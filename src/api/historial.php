<?php
// GET api/historial.php → HISTORIAL (reemplaza historial.js)
//   { "2026/2": [ofertas…], "2027/1": [ofertas…] }
// Todos los periodos con ofertas, el vigente incluido (como en iscweb).
require __DIR__ . '/../lib/api.php';

$res = [];
foreach (ofertasPorPeriodo() as $periodo => $ofertas) {
    $res[periodoLargo($periodo)] = $ofertas;
}
responder((object)$res);
