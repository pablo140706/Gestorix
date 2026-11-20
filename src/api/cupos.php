<?php
// GET api/cupos.php → CUPOS y CUPOS_HIST (reemplaza cupos.js)
//   { actual:    [{ g, m, cupo, ins, disp }],            ← periodo vigente
//     historial: { "2026/2": [{ g, m, cupo, ins, disp }] } ← los demás }
// m es el nombre de la materia tal cual SAES, igual que en api/horarios.php:
// el front cruza cupo y oferta por grupo + nombre.
require __DIR__ . '/../lib/api.php';

$vigente = periodoVigente();
$actual = [];
$historial = [];
$st = db()->query(
    'SELECT c.periodo, c.grupo, m.nombre_saes, c.cupo, c.inscritos
     FROM cupo c JOIN materia m ON m.clave = c.materia
     ORDER BY c.periodo, c.grupo, m.semestre, m.orden');
foreach ($st as $c) {
    $fila = ['g' => $c['grupo'], 'm' => $c['nombre_saes'], 'cupo' => (int)$c['cupo'],
             'ins' => (int)$c['inscritos'], 'disp' => (int)$c['cupo'] - (int)$c['inscritos']];
    if ($c['periodo'] === $vigente) { $actual[] = $fila; }
    else { $historial[periodoLargo($c['periodo'])][] = $fila; }
}
responder(['actual' => $actual, 'historial' => (object)$historial]);
