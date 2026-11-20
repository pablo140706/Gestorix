<?php
// GET api/links.php → MANUAL_LINKS (reemplaza maestros_manual.js)
//   { "NOMBRE": { link: "https://www.misprofesores.com/…" }, … }
require __DIR__ . '/../lib/api.php';

$res = [];
foreach (db()->query('SELECT nombre, mp_link FROM profesor WHERE mp_link IS NOT NULL ORDER BY nombre_norm') as $p) {
    $res[$p['nombre']] = ['link' => $p['mp_link']];
}
responder((object)$res);
