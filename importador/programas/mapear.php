<?php
// =====================================================================
//  programas/mapear.php: a qué materia corresponde cada PDF de programa.
// =====================================================================
//  Se usó UNA vez (2026-11-20) para armar data/programas/mapa.csv a
//  partir de la carpeta de PDFs del usuario. Lee por la entrada estándar
//  una lista separada por tabuladores:
//      carrera (ia|isc|lcd) · archivo · nombre de la UA (de la 1.ª hoja)
//  y escribe el CSV: clave,carrera,archivo. Cruza por el nombre de la UA
//  que trae el PDF, o por el nombre del archivo ("algebraLineal_ISC2020"),
//  y en ISC también contra el nombre en inglés de las optativas.
//  Lo que no cruza va a la salida de errores para revisarlo a mano.
//
//  Si llegan PDFs nuevos, es más fácil agregar la línea a mano en mapa.csv.
// =====================================================================

require __DIR__ . '/../comun.php';
require __DIR__ . '/../../html/lib/db.php';

$mats = db()->query("SELECT clave, carrera, nombre, coalesce(nombre_en, '') AS en, se_ofrece FROM materia")->fetchAll();
$car = ['ia' => 'IA', 'isc' => 'ISC', 'lcd' => 'LCD'];

// Archivos cuyo nombre abrevia "IA" y no cruzan solos.
const A_MANO = [
    'aplicacionesIASistemasEmbebidos_IIA2020.pdf' => 'Aplicaciones de inteligencia artificial en sistemas embebidos',
    'temasSelectosIA_IIA2020.pdf'                 => 'Temas selectos de inteligencia artificial',
    'temaSelectosIA_LCD2020.pdf'                  => 'Temas selectos de inteligencia artificial',
];

// "algoritmosEstructurasDatos_IIA2020.pdf" → "ALGORITMOS ESTRUCTURAS DATOS"
function deArchivo(string $f): string
{
    $b = preg_replace('/(_[A-Z]+20\d*|_\d+)?\.pdf$/i', '', $f);
    $b = preg_replace('/_(I+)$/', ' $1', $b);
    return norm(preg_replace('/([a-z])([A-Z])/', '$1 $2', str_replace('_', ' ', $b)));
}

const VACIAS = ['DE', 'DEL', 'LA', 'LAS', 'LOS', 'EL', 'Y', 'E', 'PARA', 'EN', 'A', 'AND', 'FOR', 'OF', 'TO', 'THE', 'CON'];

// Parecido entre dos nombres: fracción de palabras que coinciden (por sus 5 primeras letras).
function parecido(string $a, string $b): float
{
    $x = array_values(array_diff(explode(' ', $a), VACIAS));
    $y = array_values(array_diff(explode(' ', $b), VACIAS));
    if (!$x || !$y) { return 0; }
    $hits = 0;
    foreach ($x as $w) {
        foreach ($y as $v) {
            if ($w === $v || (strlen($w) >= 4 && strlen($v) >= 4 && substr($w, 0, 5) === substr($v, 0, 5))) { $hits++; break; }
        }
    }
    return $hits / max(count($x), count($y));
}

echo "clave,carrera,archivo\n";
foreach (file('php://stdin', FILE_IGNORE_NEW_LINES) as $linea) {
    [$c, $ruta, $ua] = array_pad(explode("\t", $linea), 3, '');
    $f = basename($ruta);
    $buscar = isset(A_MANO[$f]) ? [norm(A_MANO[$f])] : [norm($ua), deArchivo($f)];
    $mejor = null; $nota = 0.0;
    foreach ($mats as $m) {
        if ($m['carrera'] !== $car[$c]) { continue; }
        foreach (array_filter($buscar) as $q) {
            foreach (array_filter([norm($m['nombre']), norm($m['en'])]) as $n) {
                $s = $q === $n ? 2.0 : parecido($q, $n);
                // Empate: gana la clave que se ofrece (en IA y LCD, la del semestre del PDF).
                if ($s > $nota || ($s == $nota && $mejor && !$mejor['se_ofrece'] && $m['se_ofrece'])) { $nota = $s; $mejor = $m; }
            }
        }
    }
    if ($nota >= 0.6) { echo "{$mejor['clave']},{$mejor['carrera']},$c/$f\n"; }
    else { fwrite(STDERR, "SIN MATERIA: $c/$f (lo más parecido: " . ($mejor['nombre'] ?? '-') . ")\n"); }
}
