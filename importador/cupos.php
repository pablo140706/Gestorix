<?php
// =====================================================================
//  cupos.php: carga los cupos de SAES a la base.
// =====================================================================
//  Lee data/{isc,ia,lcd}/cupos.html: la tabla "Ocupabilidad" de SAES
//  pegada tal cual, con 7 columnas:
//    grupo · clave · nombre · semestre · cupo · inscritos · disponibles
//
//  Uso (desde la carpeta del proyecto):
//      docker compose run --rm web php importador/cupos.php 27/1
//
//  A diferencia de horarios.php, aquí SAES SÍ pisa lo que haya: los
//  inscritos cambian todo el tiempo, así que cada corrida deja la tabla
//  cupo igual que el HTML. Pega el HTML nuevo y vuelve a correrlo.
// =====================================================================

require __DIR__ . '/comun.php';
require __DIR__ . '/../html/lib/db.php';

const DATA = __DIR__ . '/../data';
const CARRERAS = ['ISC' => ['isc', 'C'], 'IA' => ['ia', 'B'], 'LCD' => ['lcd', 'A']];

$periodo = $argv[1] ?? '';
if (!preg_match('#^\d{2}/[12]$#', $periodo)) {
    fwrite(STDERR, "Uso: php importador/cupos.php 27/1\n");
    exit(1);
}

$pdo = db();
$st = $pdo->prepare('SELECT 1 FROM periodo WHERE codigo = ?');
$st->execute([$periodo]);
if (!$st->fetch()) {
    fwrite(STDERR, "El periodo $periodo no existe en la tabla periodo.\n");
    exit(1);
}

$avisos = [];
$materias = [];
foreach ($pdo->query('SELECT clave, carrera FROM materia') as $m) {
    $materias[$m['clave']] = $m['carrera'];
}


// ---------------------------------------------------------------------
//  1. Leer el HTML
// ---------------------------------------------------------------------

$filas = [];
$leidas = [];
$EXCLUIR = excluidas($periodo);   // data/excluir.csv
$saltadas = [];
foreach (CARRERAS as $car => [$dir, $letra]) {
    $leidas[$car] = 0;
    $archivo = DATA . "/$dir/cupos.html";
    if (!is_file($archivo)) { $avisos[] = "no existe data/$dir/cupos.html"; continue; }
    foreach (explode('</tr>', file_get_contents($archivo)) as $tr) {
        preg_match_all('#<td[^>]*>(.*?)</td>#s', $tr, $m);
        $t = array_map(fn($c) => trim(html_entity_decode(strip_tags($c), ENT_QUOTES | ENT_HTML5, 'UTF-8')), $m[1]);
        if (count($t) < 7 || !preg_match('/^[1-8][ABC][MVX][1-9]\d?$/', $t[0])) { continue; }
        $leidas[$car]++;
        [$grupo, $clave, $nombre, , $cupo, $inscritos, $disponibles] = $t;

        if ($grupo[1] !== $letra)                 { $avisos[] = "$car: el grupo $grupo no es de esta carrera"; }
        if (($materias[$clave] ?? null) !== $car) { $avisos[] = "$grupo $clave «{$nombre}»: esa clave no es de $car; no se carga"; continue; }
        if (isset($EXCLUIR["$grupo|$clave"])) { $saltadas[] = "$grupo $clave"; continue; }
        if ((int)$cupo - (int)$inscritos !== (int)$disponibles) {
            $avisos[] = "$grupo $clave: cupo $cupo − inscritos $inscritos no da los $disponibles disponibles";
        }
        $k = "$grupo|$clave";
        if (isset($filas[$k])) { $avisos[] = "$grupo $clave viene dos veces; se queda la última"; }
        $filas[$k] = [$grupo, $clave, (int)$cupo, (int)$inscritos];
    }
}


// ---------------------------------------------------------------------
//  2. Guardar (todo o nada)
// ---------------------------------------------------------------------

$antes = [];
$st = $pdo->prepare('SELECT grupo, materia, cupo, inscritos FROM cupo WHERE periodo = ?');
$st->execute([$periodo]);
foreach ($st as $r) {
    $antes["{$r['grupo']}|{$r['materia']}"] = [(int)$r['cupo'], (int)$r['inscritos']];
}

$guardar = $pdo->prepare(
    'INSERT INTO cupo (periodo, grupo, materia, cupo, inscritos) VALUES (?, ?, ?, ?, ?)
     ON CONFLICT (periodo, grupo, materia) DO UPDATE SET cupo = EXCLUDED.cupo, inscritos = EXCLUDED.inscritos');

$nuevos = $cambiaron = $iguales = 0;
$pdo->beginTransaction();
foreach ($filas as $k => [$grupo, $clave, $cupo, $inscritos]) {
    if (!isset($antes[$k]))                         { $nuevos++; }
    elseif ($antes[$k] !== [$cupo, $inscritos])     { $cambiaron++; }
    else                                            { $iguales++; continue; }
    $guardar->execute([$periodo, $grupo, $clave, $cupo, $inscritos]);
}
$pdo->commit();


// ---------------------------------------------------------------------
//  3. Resumen
// ---------------------------------------------------------------------

$lista = function (string $sql) use ($pdo, $periodo): array {
    $st = $pdo->prepare($sql);
    $st->execute([$periodo, $periodo]);
    return $st->fetchAll(PDO::FETCH_COLUMN);
};
$sinOferta = $lista(
    "SELECT c.grupo || ' ' || c.materia || ' (cupo ' || c.cupo || ')' FROM cupo c
     WHERE c.periodo = ? AND NOT EXISTS (SELECT 1 FROM oferta o
           WHERE o.periodo = ? AND o.grupo = c.grupo AND o.materia = c.materia) ORDER BY 1");
$sinCupo = $lista(
    "SELECT DISTINCT o.grupo || ' ' || o.materia FROM oferta o
     WHERE o.periodo = ? AND NOT EXISTS (SELECT 1 FROM cupo c
           WHERE c.periodo = ? AND c.grupo = o.grupo AND c.materia = o.materia) ORDER BY 1");

echo "\n=== cupos de SAES → periodo $periodo ===\n";
foreach ($leidas as $car => $n) { printf("  %-4s %4d filas leídas\n", $car, $n); }
echo "  nuevos: $nuevos, cambiaron: $cambiaron, sin cambio: $iguales\n";
foreach ($saltadas as $x) { echo "  no se cargó $x (data/excluir.csv)\n"; }
$st = $pdo->prepare('SELECT count(*), count(*) FILTER (WHERE inscritos > cupo) FROM cupo WHERE periodo = ?');
$st->execute([$periodo]);
[$total, $sobre] = $st->fetch(PDO::FETCH_NUM);
echo "  en la base: $total cupos, $sobre con más inscritos que cupo (sobrecupo)\n";
echo "\n=== cupos sin oferta (" . count($sinOferta) . "): grupo + materia que no vienen en los horarios ===\n";
foreach ($sinOferta as $x) { echo "  $x\n"; }
echo "\n=== ofertas sin cupo (" . count($sinCupo) . ") ===\n";
foreach ($sinCupo as $x) { echo "  $x\n"; }
if ($avisos) {
    echo "\n=== avisos (" . count($avisos) . ") ===\n";
    foreach ($avisos as $a) { echo "  $a\n"; }
}
