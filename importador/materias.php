<?php
// =====================================================================
//  materias.php: PDF, propósito y temas de cada materia (Fase 5).
// =====================================================================
//  Decisión del usuario (2026-11-20): la descripción es el PROPÓSITO y la
//  lista de UNIDADES del programa sintético, tal cual, sin redactar nada.
//
//  Lee:
//    · src/materias/<clave>.pdf     → materia.pdf
//    · data/programas/<clave>.txt   → materia.descripcion (1.ª hoja del PDF;
//                                      la saca programas/copiar.sh)
//    · data/programas/investigadas.csv → descripción de las materias cuyo
//      PDF es un escaneo sin texto: clave,descripcion,fuente. Se marca con
//      su fuente (materia.descripcion_fuente) para que la app diga que no
//      es del programa oficial.
//
//  Uso (después de programas/copiar.sh):
//      docker compose run --rm web php importador/materias.php
//
//  En IA y LCD cada optativa tiene dos claves (6.º y 7.º): la que no tiene
//  PDF toma el de su gemela con el mismo nombre. Se puede repetir; pisa lo
//  que haya (estos datos solo salen de aquí).
// =====================================================================

require __DIR__ . '/comun.php';
require __DIR__ . '/../html/lib/db.php';

$pdo = db();
$dirPdf = __DIR__ . '/../html/materias';
$dirTxt = __DIR__ . '/../data/programas';

// Texto de la 1.ª hoja → [propósito, [unidades]]
function leerPrograma(string $txt): array
{
    $t = str_replace("\r", '', $txt);
    $prop = '';
    if (preg_match('/PROP[ÓO]SITO DE LA UNIDAD DE APRENDIZAJE:?\s*(.+?)\s*CONTENIDOS?\s*:/su', $t, $m)) {
        $prop = trim(preg_replace('/\s+/u', ' ', $m[1]));
    }
    $temas = [];
    if (preg_match('/CONTENIDOS?\s*:\s*(.*?)\s*(ORIENTACI[ÓO]N|M[ée]todos de enseñanza|EVALUACI[ÓO]N)/su', $t, $m)) {
        $bloque = ' ' . preg_replace('/\s+/u', ' ', $m[1]) . ' ';
        // "I. Introducción II. Modelo … III. …" → una entrada por número
        // romano. Algunos PDFs no ponen el punto ("I Gestión de cubos") o
        // escriben "Unidad" antes; el número va seguido de una mayúscula.
        preg_match_all('/\s([IVX]{1,4})\.?\s+(\p{Lu}.*?)(?=\s[IVX]{1,4}\.?\s+\p{Lu}|\s*$)/u', $bloque, $mm, PREG_SET_ORDER);
        foreach ($mm as [$_, $num, $tema]) {
            $tema = rtrim(trim($tema), '.;');
            if ($tema !== '') { $temas[] = "$num. $tema"; }
        }
    }
    return [$prop, $temas];
}

$materias = $pdo->query('SELECT clave, carrera, nombre FROM materia')->fetchAll();
$porNombre = [];
foreach ($materias as $m) { $porNombre[$m['carrera'] . '|' . norm($m['nombre'])][] = $m['clave']; }

// Lo investigado para los PDFs escaneados.
$investigadas = [];
$csv = "$dirTxt/investigadas.csv";
if (is_file($csv)) {
    $f = fopen($csv, 'r');
    fgetcsv($f);                                     // encabezado
    while (($r = fgetcsv($f)) !== false) {
        if (count($r) >= 3 && $r[0] !== '') { $investigadas[$r[0]] = [trim($r[1]), trim($r[2])]; }
    }
    fclose($f);
}

$datos = [];          // clave → [pdf, descripcion, fuente]
$sinTexto = [];
$raros = [];
foreach ($materias as $m) {
    $clave = $m['clave'];
    if (!is_file("$dirPdf/$clave.pdf")) { continue; }
    [$prop, $temas] = is_file("$dirTxt/$clave.txt") ? leerPrograma(file_get_contents("$dirTxt/$clave.txt")) : ['', []];
    if ($prop !== '') {
        if (count($temas) === 0 || mb_strlen($prop) > 400) { $raros[] = "$clave: " . count($temas) . ' temas, propósito de ' . mb_strlen($prop) . ' caracteres'; }
        $datos[$clave] = ["materias/$clave.pdf", $prop . ($temas ? "\n\n" . implode("\n", $temas) : ''), null];
    } elseif (isset($investigadas[$clave])) {
        $datos[$clave] = ["materias/$clave.pdf", $investigadas[$clave][0], $investigadas[$clave][1]];
    } else {
        $datos[$clave] = ["materias/$clave.pdf", null, null];
        $sinTexto[] = "$clave {$m['nombre']}";
    }
}

// La gemela sin PDF (optativas de IA y LCD) toma los datos de la que sí tiene.
foreach ($materias as $m) {
    if (isset($datos[$m['clave']])) { continue; }
    foreach ($porNombre[$m['carrera'] . '|' . norm($m['nombre'])] as $otra) {
        if (isset($datos[$otra])) { $datos[$m['clave']] = $datos[$otra]; break; }
    }
}

$pdo->beginTransaction();
$pdo->exec('UPDATE materia SET pdf = NULL, descripcion = NULL, descripcion_fuente = NULL');
$up = $pdo->prepare('UPDATE materia SET pdf = ?, descripcion = ?, descripcion_fuente = ? WHERE clave = ?');
foreach ($datos as $clave => [$pdf, $desc, $fuente]) { $up->execute([$pdf, $desc, $fuente, $clave]); }
$pdo->commit();

$conDesc = count(array_filter($datos, fn($d) => $d[1] !== null));
$deFuente = count(array_filter($datos, fn($d) => $d[2] !== null));
echo "Materias con PDF: " . count($datos) . " de " . count($materias) . "\n";
echo "Con descripción: $conDesc (del programa oficial: " . ($conDesc - $deFuente) . ", investigadas: $deFuente)\n";
if ($sinTexto) { echo "PDF escaneado y sin descripción investigada (" . count($sinTexto) . "):\n  " . implode("\n  ", $sinTexto) . "\n"; }
if ($raros) { echo "Revisar (sin temas o propósito muy largo):\n  " . implode("\n  ", $raros) . "\n"; }
$sinPdf = array_filter($materias, fn($m) => !isset($datos[$m['clave']]));
echo "Materias sin PDF (" . count($sinPdf) . "): " . implode(', ', array_map(fn($m) => "{$m['clave']} {$m['nombre']}", $sinPdf)) . "\n";
