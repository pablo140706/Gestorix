<?php
// POST api/admin/respaldo.php   {}  → archivo gestorix-datos-AAAA-MM-DD-HHMM.sql
// =====================================================================
//  Respaldo de los DATOS de la base, descargable desde la pestaña Admin.
// =====================================================================
//  SOLO EL ADMIN, con la contraseña confirmada. Trae correos y hashes de
//  contraseñas: guárdalo FUERA del repositorio (docs/respaldo.md).
//
//  Por qué no pg_dump: el pg_dump que trae Debian en el contenedor es el
//  15 y no respalda un Postgres 17. Así que se hace a mano con COPY, que
//  es lo mismo que usa pg_dump por dentro:
//   · tablas en orden de llaves foráneas (primero carrera, luego materia…);
//   · por cada una, sus filas en formato COPY;
//   · al final, los contadores SERIAL donde se quedaron.
//  Es solo de datos: el esquema ya está en sql/00-tablas.sql + migraciones/.
//
//  Para restaurarlo (borra lo que haya en esas tablas y pone lo del archivo):
//    docker compose exec -T db sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < gestorix-datos-….sql
// =====================================================================
require __DIR__ . '/../../lib/admin.php';

$u = exigirAdmin();
exigirConfirmado();
leerJson();
$pdo = db();

// Tablas y sus llaves foráneas → orden en que se pueden cargar.
$tablas = $pdo->query("SELECT table_name FROM information_schema.tables
                       WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY table_name")
              ->fetchAll(PDO::FETCH_COLUMN);
$dependeDe = array_fill_keys($tablas, []);
foreach ($pdo->query("SELECT conrelid::regclass::text AS hija, confrelid::regclass::text AS madre
                      FROM pg_constraint WHERE contype = 'f' AND connamespace = 'public'::regnamespace") as $f) {
    if ($f['hija'] !== $f['madre'] && isset($dependeDe[$f['hija']])) { $dependeDe[$f['hija']][] = $f['madre']; }
}
$orden = [];
$visitar = function (string $t) use (&$visitar, &$orden, $dependeDe) {
    if (in_array($t, $orden, true)) { return; }
    foreach ($dependeDe[$t] as $madre) { $visitar($madre); }
    $orden[] = $t;
};
foreach ($tablas as $t) { $visitar($t); }

// Columnas que se guardan (las calculadas, como oferta.turno, no) y contadores SERIAL.
$columnas = [];
$seriales = [];
foreach ($pdo->query("SELECT table_name, column_name, column_default FROM information_schema.columns
                      WHERE table_schema = 'public' AND is_generated = 'NEVER'
                      ORDER BY table_name, ordinal_position") as $c) {
    $columnas[$c['table_name']][] = $c['column_name'];
    if (str_starts_with((string)$c['column_default'], 'nextval(')) { $seriales[$c['table_name']] = $c['column_name']; }
}

$q = fn(string $nombre) => '"' . str_replace('"', '""', $nombre) . '"';
$ahora = new DateTime('now', new DateTimeZone('America/Mexico_City'));

anotarBitacora((int)$u['id'], 'respaldo', null, null, 'Respaldo de datos descargado');

header('Content-Type: application/sql; charset=utf-8');
header('Content-Disposition: attachment; filename="gestorix-datos-' . $ahora->format('Y-m-d-Hi') . '.sql"');

echo "-- Respaldo de datos de Gestorix · " . $ahora->format('d/m/Y H:i') . " (hora de la CDMX)\n";
echo "-- Trae correos y hashes de contraseñas: NO lo subas al repositorio.\n";
echo "-- Restaurar: docker compose exec -T db sh -c 'psql -v ON_ERROR_STOP=1 -U \"\$POSTGRES_USER\" -d \"\$POSTGRES_DB\"' < este-archivo.sql\n\n";
echo "BEGIN;\n";
echo 'TRUNCATE ' . implode(', ', array_map($q, $orden)) . " CASCADE;\n\n";
foreach ($orden as $t) {
    $cols = $columnas[$t] ?? [];
    if (!$cols) { continue; }
    // El nulo va como \N. PDO lo mete en un E'…' que se come una diagonal: por eso son dos.
    $filas = $pdo->pgsqlCopyToArray($q($t), "\t", '\\\\N', implode(',', array_map($q, $cols))) ?: [];
    echo '-- ' . $t . ': ' . count($filas) . " filas\n";
    echo 'COPY ' . $q($t) . ' (' . implode(', ', array_map($q, $cols)) . ") FROM stdin;\n";
    echo implode('', $filas);
    echo "\\.\n\n";
}
foreach ($seriales as $t => $col) {
    printf("SELECT setval(pg_get_serial_sequence('%s', '%s'), coalesce(max(%s), 1), max(%s) IS NOT NULL) FROM %s;\n",
           $t, $col, $q($col), $q($col), $q($t));
}
echo "COMMIT;\n";
