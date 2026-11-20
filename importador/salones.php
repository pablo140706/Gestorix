<?php
// =====================================================================
//  salones.php: corrige edificio y salón con el PDF oficial de ESCOM.
// =====================================================================
//  ESCOM publica la "Distribución de salones" de cada semestre en PDF:
//  grupo · unidad de aprendizaje · salón (1206 = edificio 1, salón 206;
//  SA = sin asignar) · laboratorio. Decisión del usuario (2026-11-08):
//  ese PDF MANDA sobre el salón del HTML de SAES. El laboratorio no se
//  guarda.
//
//  PHP no lee PDF, así que primero se saca el texto, en tu Git Bash
//  (pdftotext viene con MSYS2 UCRT64; el modo -table conserva las filas):
//
//      pdftotext -table -enc UTF-8 data/salones/27-1.pdf data/salones/27-1.txt
//      docker compose run --rm web php importador/salones.php 27/1
//
//  Va después de horarios.php: solo corrige ofertas que ya existen; lo
//  que el PDF trae y SAES no, solo lo reporta. Se puede repetir.
// =====================================================================

require __DIR__ . '/comun.php';
require __DIR__ . '/../html/lib/db.php';

$periodo = $argv[1] ?? '';
if (!preg_match('#^\d{2}/[12]$#', $periodo)) {
    fwrite(STDERR, "Uso: php importador/salones.php 27/1\n");
    exit(1);
}
$archivo = __DIR__ . '/../data/salones/' . str_replace('/', '-', $periodo) . '.txt';
if (!is_file($archivo)) {
    fwrite(STDERR, "No existe data/salones/" . basename($archivo) . ". Sácalo del PDF con pdftotext (ver arriba).\n");
    exit(1);
}
$pdo = db();


// ---------------------------------------------------------------------
//  1. Leer el texto del PDF
// ---------------------------------------------------------------------
//  Cada línea trae hasta dos registros (turno matutino a la izquierda y
//  vespertino a la derecha). Un nombre largo se parte en dos renglones, y
//  el pedazo suelto puede quedar arriba O abajo del renglón del grupo:
//
//            Algoritmos                      Tecnologías para el Desarrollo de
//      3CM5  Circuitos Eléctricos  2211 LE1  4CV1  Aplicaciones Web  2003 LS4
//
//  Por eso a cada registro se le guardan los pedazos sueltos de su misma
//  columna en el renglón de arriba y en el de abajo; al cruzar se prueba
//  con y sin ellos y gana la combinación que mejor se parece a una materia.

const REGISTRO = '/([1-9][A-Z][MVX]\d{1,2})\s+(\S.*?)\s+(\d{4}|SA)\s+(NA|L[A-Z]{1,3}\d?)(?=\s|$)/u';
const ENCABEZADO = '/GRUPO|TURNO|SEMESTRE|INGENIER|LICENCIATURA|INSTITUTO|ESCUELA|EVALUACI|DISTRIBUCI/u';

$lineas = [];
foreach (file($archivo, FILE_IGNORE_NEW_LINES) as $ln) {
    if (trim($ln) === '') { continue; }
    if (preg_match(ENCABEZADO, $ln)) { $lineas[] = ['corte' => true]; continue; }   // entre tablas no se pegan pedazos
    $regs = [];
    $resto = $ln;
    if (preg_match_all(REGISTRO, $ln, $m, PREG_SET_ORDER | PREG_OFFSET_CAPTURE)) {
        foreach ($m as $x) {
            $regs[] = ['grupo' => $x[1][0], 'ua' => $x[2][0], 'salon' => $x[3][0],
                       'col' => mb_strlen(substr($ln, 0, $x[2][1]))];
            $resto = substr_replace($resto, str_repeat(' ', strlen($x[0][0])), $x[0][1], strlen($x[0][0]));
        }
    }
    $pedazos = [];
    preg_match_all('/\S(?:.*?\S)?(?=\s{3,}|\s*$)/u', $resto, $t, PREG_OFFSET_CAPTURE);
    foreach ($t[0] as [$txt, $off]) {
        if (!preg_match('/^(\d{4}|SA|NA|L[A-Z]{1,3}\d?)$/', $txt)) {
            $pedazos[] = ['txt' => $txt, 'col' => mb_strlen(substr($resto, 0, $off))];
        }
    }
    $lineas[] = ['regs' => $regs, 'pedazos' => $pedazos];
}

function pedazoEn(array $lineas, int $i, int $col): string
{
    if (!isset($lineas[$i]) || !empty($lineas[$i]['corte'])) { return ''; }
    foreach ($lineas[$i]['pedazos'] as $p) {
        if (abs($p['col'] - $col) <= 6) { return $p['txt']; }
    }
    return '';
}


// ---------------------------------------------------------------------
//  2. Qué tanto se parecen dos nombres (0 a 1)
// ---------------------------------------------------------------------
//  El PDF no escribe igual que SAES: "Estructuras" / "estructura",
//  "para la Ciencia" / "para Ciencia", "Desiciones", "Quallity"… Se
//  comparan las palabras sin acentos ni conectores, sin la S final, y
//  aceptando una letra de diferencia en palabras largas.

const CONECTORES = ['DE', 'LA', 'EL', 'Y', 'PARA', 'AND', 'EN', 'THE', 'A', 'LOS', 'LAS', 'DEL'];

function palabras(string $s): array
{
    $s = preg_replace('/[^A-Z0-9 ]/', ' ', norm($s));
    $w = array_filter(explode(' ', $s), fn($x) => $x !== '' && !in_array($x, CONECTORES, true));
    return array_values(array_map(fn($x) => strlen($x) > 3 ? rtrim($x, 'S') : $x, $w));
}

function parecido(string $a, string $b): float
{
    $A = palabras($a);
    $B = palabras($b);
    if (!$A || !$B) { return 0.0; }
    $iguales = 0;
    foreach ($A as $x) {
        foreach ($B as $y) {
            if ($x === $y || (strlen($x) > 4 && levenshtein($x, $y) <= 1)) { $iguales++; break; }
        }
    }
    return $iguales / max(count($A), count($B));
}


// ---------------------------------------------------------------------
//  3. Cruzar cada registro con las ofertas de SU grupo
// ---------------------------------------------------------------------
//  Solo se compara contra las materias que ese grupo tiene en la base
//  (unas 6), así no se confunden materias de nombre parecido de otros
//  semestres. En ISC las optativas se comparan también contra su nombre
//  en inglés, que es como las escribe el PDF ("Machine Learning").

$ofertas = [];
$st = $pdo->prepare(
    'SELECT o.id, o.grupo, o.materia, o.edificio, o.salon, m.nombre, m.nombre_saes
     FROM oferta o JOIN materia m ON m.clave = o.materia WHERE o.periodo = ?');
$st->execute([$periodo]);
foreach ($st as $o) {
    $partes = explode('|', $o['nombre_saes']);
    $o['nombres'] = array_filter([$o['nombre'], $partes[0], $partes[1] ?? null]);
    $ofertas[$o['grupo']][] = $o;
}

$delPdf = [];        // id de oferta → salones que le da el PDF (a veces trae dos filas)
$sinOferta = [];
$noOtraCarrera = 0;
$taller = 0;
foreach ($lineas as $i => $l) {
    foreach ($l['regs'] ?? [] as $r) {
        if (!in_array($r['grupo'][1], ['A', 'B', 'C'], true)) { $noOtraCarrera++; continue; }   // 7SV1: otra carrera
        if (str_contains(norm($r['ua']), 'TALLER DE NIVELACION')) { $taller++; continue; }       // no es del plan

        $arriba = pedazoEn($lineas, $i - 1, $r['col']);
        $abajo  = pedazoEn($lineas, $i + 1, $r['col']);
        $variantes = array_unique(array_filter([
            $r['ua'], "$arriba {$r['ua']}", "{$r['ua']} $abajo", "$arriba {$r['ua']} $abajo",
        ], fn($v) => trim($v) !== ''));

        $porClave = [];      // clave → mejor parecido
        foreach ($ofertas[$r['grupo']] ?? [] as $o) {
            foreach ($variantes as $v) {
                foreach ($o['nombres'] as $nom) {
                    $porClave[$o['materia']] = max($porClave[$o['materia']] ?? 0, parecido($v, $nom));
                }
            }
        }
        arsort($porClave);
        $claves = array_keys($porClave);
        $mejor = $porClave[$claves[0] ?? ''] ?? 0;
        $segundo = $porClave[$claves[1] ?? ''] ?? 0;
        if ($mejor < 0.6 || $mejor - $segundo < 0.15) {        // ninguna se parece, o dos se parecen igual
            $sinOferta[] = sprintf('%-5s %s (salón %s)', $r['grupo'], trim(preg_replace('/\s+/', ' ', $r['ua'])), $r['salon']);
            continue;
        }

        foreach ($ofertas[$r['grupo']] as $o) {
            if ($o['materia'] === $claves[0]) { $delPdf[$o['id']][] = $r['salon']; }
        }
    }
}

// Si el PDF trae dos filas para la misma materia (p. ej. "Aprendizaje de
// Máquina 4010" y otra vez "SA"), un salón real gana sobre SA. Si trae
// dos salones reales distintos, se queda el primero y se avisa.
$porId = [];
foreach ($ofertas as $os) { foreach ($os as $o) { $porId[$o['id']] = $o; } }
$cambios = [];       // id → [edificio, salón, oferta, antes]
$avisos = [];
foreach ($delPdf as $id => $salones) {
    $o = $porId[$id];
    $reales = array_values(array_unique(array_diff($salones, ['SA'])));
    if (count($reales) > 1) { $avisos[] = "{$o['grupo']} {$o['materia']}: el PDF le da " . implode(' y ', $reales) . "; se queda {$reales[0]}"; }
    [$ed, $sa] = $reales ? [$reales[0][0], substr($reales[0], 1)] : [null, null];
    if ($o['edificio'] === $ed && $o['salon'] === $sa) { continue; }
    $cambios[$id] = [$ed, $sa, $o, ($o['edificio'] ?? '') . ($o['salon'] ?? '')];
}
$tocadas = $delPdf;


// ---------------------------------------------------------------------
//  4. Guardar y resumir
// ---------------------------------------------------------------------

$upd = $pdo->prepare('UPDATE oferta SET edificio = ?, salon = ? WHERE id = ?');
$pdo->beginTransaction();
foreach ($cambios as $id => [$ed, $sa]) { $upd->execute([$ed, $sa, $id]); }
$pdo->commit();

$llenadas = array_filter($cambios, fn($c) => $c[3] === '');
$corregidas = array_filter($cambios, fn($c) => $c[3] !== '');
$sinPdf = [];
foreach ($ofertas as $os) {
    foreach ($os as $o) {
        if (!isset($tocadas[$o['id']])) { $sinPdf[] = sprintf('%-5s %-5s %s', $o['grupo'], $o['materia'], $o['nombre']); }
    }
}

echo "\n=== salones del PDF oficial → periodo $periodo ===\n";
echo '  ofertas que cruzaron con el PDF: ' . count($tocadas) . "\n";
echo '  salón llenado (SAES venía vacío): ' . count($llenadas) . "\n";
echo '  salón corregido (el PDF dice otro): ' . count($corregidas) . "\n";
echo "  sin cambio: " . (count($tocadas) - count($cambios)) . "\n";
echo "  ignorados: $taller de Taller de Nivelación (no es del plan), $noOtraCarrera de otra carrera\n";
if ($corregidas) {
    echo "\n=== corregidos: antes (SAES) → ahora (PDF) ===\n";
    foreach ($corregidas as [$ed, $sa, $o, $antes]) {
        printf("  %-5s %-5s %-40s %-5s → %s\n", $o['grupo'], $o['materia'], mb_substr($o['nombre'], 0, 40), $antes, $ed === null ? 'sin asignar' : "$ed$sa");
    }
}
echo "\n=== en el PDF pero sin oferta en la base (" . count($sinOferta) . ") ===\n";
foreach ($sinOferta as $x) { echo "  $x\n"; }
echo "\n=== ofertas que el PDF no trae (" . count($sinPdf) . "): se quedan con su salón de SAES ===\n";
foreach ($sinPdf as $x) { echo "  $x\n"; }
if ($avisos) {
    echo "\n=== avisos (" . count($avisos) . ") ===\n";
    foreach ($avisos as $a) { echo "  $a\n"; }
}
