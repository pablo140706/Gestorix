<?php
// =====================================================================
//  cupos.php: carga los cupos de SAES a la base, desde la terminal.
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
//
//  El trabajo lo hace cargarCupos() de carga.php, el mismo que usa el
//  panel de Admin (src/api/admin/horarios.php): aquí solo se leen los
//  archivos y se imprime el reporte.
// =====================================================================

require __DIR__ . '/carga.php';
require __DIR__ . '/../html/lib/db.php';

const DATA = __DIR__ . '/../data';
const CARPETA = ['ISC' => 'isc', 'IA' => 'ia', 'LCD' => 'lcd'];

$periodo = $argv[1] ?? '';
if (!periodoValido($periodo)) {
    fwrite(STDERR, "Uso: php importador/cupos.php 27/1\n");
    exit(1);
}

$faltantes = [];
$html = [];
foreach (CARPETA as $car => $dir) {
    $archivo = DATA . "/$dir/cupos.html";
    if (!is_file($archivo)) { $faltantes[] = "no existe data/$dir/cupos.html"; continue; }
    $html[$car] = file_get_contents($archivo);
}

try {
    $r = cargarCupos(db(), $periodo, $html);
} catch (InvalidArgumentException | RuntimeException $e) {
    fwrite(STDERR, $e->getMessage() . "\n");
    exit(1);
}

echo "\n=== cupos de SAES → periodo {$r['periodo']} ===\n";
foreach ($r['leidas'] as $car => $n) { printf("  %-4s %4d filas leídas\n", $car, $n); }
echo "  nuevos: {$r['nuevos']}, cambiaron: {$r['cambiaron']}, sin cambio: {$r['iguales']}\n";
foreach ($r['saltadas'] as $x) { echo "  no se cargó $x (data/excluir.csv)\n"; }
echo "  en la base: {$r['base']['cupos']} cupos, {$r['base']['sobrecupo']} con más inscritos que cupo (sobrecupo)\n";
echo "\n=== cupos sin oferta (" . count($r['sinOferta']) . "): grupo + materia que no vienen en los horarios ===\n";
foreach ($r['sinOferta'] as $x) { echo "  $x\n"; }
echo "\n=== ofertas sin cupo (" . count($r['sinCupo']) . ") ===\n";
foreach ($r['sinCupo'] as $x) { echo "  $x\n"; }
$avisos = array_merge($faltantes, $r['avisos']);
if ($avisos) {
    echo "\n=== avisos (" . count($avisos) . ") ===\n";
    foreach ($avisos as $a) { echo "  $a\n"; }
}
