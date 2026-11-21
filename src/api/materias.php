<?php
// GET api/materias.php → MATERIAS_INFO (Fase 5)
//   { "C306": { desc, fuente, pdf }, … }
// desc   = propósito, línea en blanco y una línea por unidad ("I. …"),
//          tal cual el programa sintético (importador/materias.php).
// fuente = null si salió del programa oficial; si no, de dónde se
//          investigó (el PDF es un escaneo sin texto).
// pdf    = ruta relativa al PDF del programa ("materias/C306.pdf") o null.
// Lo pide lazy.js la primera vez que abres la ventana de una materia.
require __DIR__ . '/../lib/api.php';

$res = [];
foreach (db()->query('SELECT clave, descripcion, descripcion_fuente, pdf FROM materia
                      WHERE descripcion IS NOT NULL OR pdf IS NOT NULL ORDER BY clave') as $m) {
    $res[$m['clave']] = ['desc' => $m['descripcion'], 'fuente' => $m['descripcion_fuente'], 'pdf' => $m['pdf']];
}
responder((object)$res);
