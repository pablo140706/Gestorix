<?php
// =====================================================================
//  horarios.php: carga los horarios de SAES a la base, desde la terminal.
// =====================================================================
//  Lee data/{isc,ia,lcd}/horario-m.html y horario-v.html (el HTML de la
//  tabla de horarios de SAES, pegado tal cual) y crea las ofertas, sus
//  sesiones y los profes que todavía no existan.
//
//  Uso (desde la carpeta del proyecto):
//      docker compose run --rm web php importador/horarios.php 27/1
//
//  Se puede correr las veces que quieras: lo que ya está en la base no se
//  duplica ni se pisa (así no se pierden las correcciones hechas en
//  pgAdmin). Solo agrega lo nuevo y te dice qué no pudo cruzar.
//
//  El trabajo lo hace cargarHorarios() de carga.php, el mismo que usa el
//  panel de Admin (src/api/admin/horarios.php): aquí solo se leen los
//  archivos y se imprime el reporte.
// =====================================================================

require __DIR__ . '/carga.php';
require __DIR__ . '/../html/lib/db.php';

const DATA = __DIR__ . '/../data';
const CARPETA = ['ISC' => 'isc', 'IA' => 'ia', 'LCD' => 'lcd'];

$periodo = $argv[1] ?? '';
if (!periodoValido($periodo)) {
    fwrite(STDERR, "Uso: php importador/horarios.php 27/1\n");
    exit(1);
}

$faltantes = [];
$html = [];
foreach (CARPETA as $car => $dir) {
    foreach (['m', 'v'] as $turno) {
        $archivo = DATA . "/$dir/horario-$turno.html";
        if (!is_file($archivo)) { $faltantes[] = "no existe data/$dir/horario-$turno.html"; continue; }
        $html[$car][$turno] = file_get_contents($archivo);
    }
}

try {
    $r = cargarHorarios(db(), $periodo, $html);
} catch (InvalidArgumentException | RuntimeException $e) {
    fwrite(STDERR, $e->getMessage() . "\n");
    exit(1);
}

echo "\n=== horarios de SAES → periodo {$r['periodo']} ===\n";
foreach ($r['leidas'] as $car => $n) {
    printf("  %-4s %4d filas leídas, %4d ofertas nuevas\n", $car, $n, $r['nuevas'][$car]);
}
echo "  ya estaban en la base: {$r['yaEstaban']}\n";
foreach ($r['saltadas'] as $x => $motivo) { echo "  no se cargó $x (data/excluir.csv): $motivo\n"; }
echo "  sesiones nuevas: {$r['sesiones']}\n";
echo '  profes nuevos: ' . count($r['profesNuevos']) . "\n";
echo "\n=== en la base, periodo {$r['periodo']} ===\n";
echo "  ofertas:  {$r['base']['ofertas']}\n";
echo "  sesiones: {$r['base']['sesiones']}\n";
echo "  profes con clase: {$r['base']['profesConClase']}\n";
echo "  ofertas sin profesor: {$r['base']['sinProfesor']}\n";
echo "  profesores en total (todos los periodos): {$r['base']['profesores']}\n";

if ($r['sinCruzar']) {
    echo "\n=== filas que NO se cargaron: la materia no cruza (" . count($r['sinCruzar']) . ") ===\n";
    foreach ($r['sinCruzar'] as $x) { echo "  $x\n"; }
}
if ($r['parecidos']) {
    echo "\n=== ¿mismo profe? revisa en pgAdmin (" . count($r['parecidos']) . ") ===\n";
    foreach ($r['parecidos'] as $x) { echo "  $x\n"; }
}
$avisos = array_merge($faltantes, $r['avisos']);
if ($avisos) {
    echo "\n=== avisos (" . count($avisos) . ") ===\n";
    foreach ($avisos as $a) { echo "  $a\n"; }
}
