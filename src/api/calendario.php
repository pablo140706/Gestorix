<?php
// GET api/calendario.php → CALENDARIO (reemplaza calendario.js)
//   { periodos: [{ id, inicio, fin, reinsIni, reinsFin }],
//     eventos:  [{ ini, fin, tipo, periodo }] }
// Fechas "AAAA-MM-DD"; "" = sin dato. Un evento de un día trae fin = ini.
require __DIR__ . '/../lib/api.php';
$pdo = db();

$reins = [];
foreach ($pdo->query(
    "SELECT periodo, min(inicio) AS ini, max(coalesce(fin, inicio)) AS fin
     FROM evento_calendario WHERE tipo = 'reinscripcion' AND periodo IS NOT NULL GROUP BY periodo") as $r) {
    $reins[$r['periodo']] = [$r['ini'], $r['fin']];
}

// Solo los periodos del calendario (26/2 existe por su historial, pero sin fechas).
$periodos = [];
foreach ($pdo->query('SELECT codigo, inicio, fin FROM periodo WHERE inicio IS NOT NULL ORDER BY inicio') as $p) {
    $periodos[] = [
        'id'       => $p['codigo'],
        'inicio'   => $p['inicio'],
        'fin'      => $p['fin'] ?? '',
        'reinsIni' => $reins[$p['codigo']][0] ?? '',
        'reinsFin' => $reins[$p['codigo']][1] ?? '',
    ];
}

$eventos = [];
foreach ($pdo->query(
    "SELECT inicio, coalesce(fin, inicio) AS fin, tipo, coalesce(periodo, '') AS periodo
     FROM evento_calendario ORDER BY inicio, tipo") as $e) {
    $eventos[] = ['ini' => $e['inicio'], 'fin' => $e['fin'], 'tipo' => $e['tipo'], 'periodo' => $e['periodo']];
}

responder(['periodos' => $periodos, 'eventos' => $eventos]);
