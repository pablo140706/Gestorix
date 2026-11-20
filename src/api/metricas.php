<?php
// GET api/metricas.php → TEACHER_METRICS (reemplaza metrics.js)
//   { "NOMBRE": { calidad, recomiendan, dificultad }, … }   "" = sin dato
// Escalas de MisProfesores: calidad 0–10, recomiendan 0–100 %, dificultad 0–10.
require __DIR__ . '/../lib/api.php';

$dato = fn($v) => $v === null ? '' : (float)$v;
$res = [];
$st = db()->query(
    'SELECT nombre, mp_calidad, mp_recomiendan, mp_dificultad FROM profesor
     WHERE coalesce(mp_calidad, mp_recomiendan, mp_dificultad) IS NOT NULL
     ORDER BY nombre_norm');
foreach ($st as $p) {
    $res[$p['nombre']] = [
        'calidad'     => $dato($p['mp_calidad']),
        'recomiendan' => $dato($p['mp_recomiendan']),
        'dificultad'  => $dato($p['mp_dificultad']),
    ];
}
responder((object)$res);
