<?php
// GET api/planes.php → PLANES (reemplaza planes.js)
//   { ISC: { nombre, letra, creditos, maxCred, slots, materias, optativas, seriacion }, IA: …, LCD: … }
require __DIR__ . '/../lib/api.php';
$pdo = db();

// Lugares para optativa en el plan: 2 en 6.º y 2 en 7.º. Los nombres son los
// de iscweb; el avance guardado en el navegador depende de ellos.
const SLOTS = [
    'ISC' => [['A1', 6], ['B1', 6], ['A2', 7], ['B2', 7]],
    'IA'  => [['A', 6], ['B', 6], ['C', 7], ['D', 7]],
    'LCD' => [['A', 6], ['B', 6], ['C', 7], ['D', 7]],
];

$planes = [];
foreach ($pdo->query('SELECT codigo, letra, nombre, carga_min_ua, carga_media_ua, carga_max_ua FROM carrera ORDER BY ' . sprintf(ORDEN_CARRERAS, 'codigo')) as $c) {
    $planes[$c['codigo']] = [
        'nombre'    => $c['nombre'],
        'letra'     => $c['letra'],
        'creditos'  => 0,
        // Carga académica en UA (CLAUDE.md §4.1): hasta la media sin aviso;
        // entre la media y la máxima, con trámite; más de la máxima, no.
        'carga'     => ['min' => (int)$c['carga_min_ua'], 'media' => (int)$c['carga_media_ua'], 'max' => (int)$c['carga_max_ua']],
        'slots'     => array_map(fn($s) => ['label' => $s[0], 'sem' => $s[1]], SLOTS[$c['codigo']] ?? []),
        'materias'  => [],
        'optativas' => [],
        'seriacion' => [],
    ];
}

// Obligatorias, y de las optativas solo las que se ofrecen (en IA y LCD, la
// clave del semestre que marca el PDF). El orden importa: el front numera
// las materias por su posición dentro del semestre.
$st = $pdo->query(
    "SELECT clave, carrera, nombre, nombre_saes, tipo, semestre, creditos, ua, horas_t, horas_p
     FROM materia WHERE tipo = 'OBL' OR se_ofrece
     ORDER BY carrera, semestre, orden");
foreach ($st as $m) {
    $base = ['clave' => $m['clave'], 'nom' => $m['nombre'], 'saes' => $m['nombre_saes'],
             'sem' => (int)$m['semestre'], 'cr' => (float)$m['creditos'], 'ua' => (int)$m['ua']];
    if ($m['tipo'] === 'OBL') {
        $planes[$m['carrera']]['materias'][] = $base + [
            'ht' => $m['horas_t'] === null ? null : (float)$m['horas_t'],
            'hp' => $m['horas_p'] === null ? null : (float)$m['horas_p'],
        ];
    } else {
        $planes[$m['carrera']]['optativas'][] = $base;
    }
}

// Créditos del plan: obligatorias + los lugares de optativa.
foreach ($planes as $cod => &$p) {
    $crOpt = $p['optativas'] ? max(array_column($p['optativas'], 'cr')) : 0;
    $p['creditos'] = array_sum(array_column($p['materias'], 'cr')) + count($p['slots']) * $crOpt;
}
unset($p);

$st = $pdo->query(
    'SELECT m.carrera, s.materia, s.requisito FROM seriacion s JOIN materia m ON m.clave = s.materia
     ORDER BY m.carrera, s.materia, s.requisito');
foreach ($st as $s) {
    $planes[$s['carrera']]['seriacion'][$s['materia']][] = $s['requisito'];
}
foreach ($planes as &$p) {
    $p['seriacion'] = (object)$p['seriacion'];   // siempre objeto en JSON, aunque esté vacío
}
unset($p);

responder($planes);
