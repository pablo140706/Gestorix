<?php
// GET api/optativas.php → ESPECIALIZACIONES (reemplaza optativas.js)
//   [{ nombre, icono, materias: [{ sem, clave, nombre, en }] }, …]
// Las 14 ramas de ISC (el front solo dibuja rutas para ISC; IA y LCD
// muestran su catálogo de optativas desde api/planes.php).
require __DIR__ . '/../lib/api.php';

$ramas = [];
$st = db()->query(
    "SELECT r.id, r.nombre, r.icono, m.semestre, m.clave, m.nombre AS materia, m.nombre_en
     FROM ruta_optativa r
     JOIN ruta_materia rm ON rm.ruta = r.id
     JOIN materia m ON m.clave = rm.materia
     WHERE r.carrera = 'ISC'
     ORDER BY r.id, m.semestre");
foreach ($st as $r) {
    $ramas[$r['id']] ??= ['nombre' => $r['nombre'], 'icono' => $r['icono'] ?? '', 'materias' => []];
    $ramas[$r['id']]['materias'][] = [
        'sem' => (int)$r['semestre'], 'clave' => $r['clave'],
        'nombre' => $r['materia'], 'en' => $r['nombre_en'] ?? '',
    ];
}
responder(array_values($ramas));
