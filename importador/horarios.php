<?php
// =====================================================================
//  horarios.php: carga los horarios de SAES a la base.
// =====================================================================
//  Lee data/{isc,ia,lcd}/horario-m.html y horario-v.html (el HTML de la
//  tabla de horarios de SAES, pegado tal cual) y crea las ofertas, sus
//  sesiones y los profes que todavía no existan.
//
//  Uso (desde la carpeta del proyecto):
//      docker compose run --rm web php importador/horarios.php 27/1
//
//  Se puede correr las veces que quieras: lo que ya está en la base no se
//  duplica ni se pisa (así no se pierden las correcciones hechas en
//  pgAdmin). Solo agrega lo nuevo y te dice qué no pudo cruzar.
// =====================================================================

require __DIR__ . '/comun.php';
require __DIR__ . '/../html/lib/db.php';

const DATA = __DIR__ . '/../data';
const CARRERAS = ['ISC' => ['isc', 'C'], 'IA' => ['ia', 'B'], 'LCD' => ['lcd', 'A']];

$periodo = $argv[1] ?? '';
if (!preg_match('#^\d{2}/[12]$#', $periodo)) {
    fwrite(STDERR, "Uso: php importador/horarios.php 27/1\n");
    exit(1);
}

$pdo = db();
$st = $pdo->prepare('SELECT 1 FROM periodo WHERE codigo = ?');
$st->execute([$periodo]);
if (!$st->fetch()) {
    fwrite(STDERR, "El periodo $periodo no existe en la tabla periodo.\n");
    exit(1);
}

$avisos = [];
function aviso(string $s): void { global $avisos; $avisos[] = $s; }


// ---------------------------------------------------------------------
//  1. Lo que ya hay en la base
// ---------------------------------------------------------------------

$porSaes = [];      // "CARRERA|semestre|NOMBRE" → clave (ver buscarClave en comun.php)
$seOfrece = [];
foreach ($pdo->query('SELECT clave, carrera, semestre, nombre_saes, se_ofrece FROM materia') as $m) {
    $porSaes["{$m['carrera']}|{$m['semestre']}|" . norm($m['nombre_saes'])] = $m['clave'];
    $seOfrece[$m['clave']] = $m['se_ofrece'];
}
$profes = [];       // nombre_norm → id
foreach ($pdo->query('SELECT id, nombre_norm FROM profesor') as $p) {
    $profes[$p['nombre_norm']] = $p['id'];
}


// ---------------------------------------------------------------------
//  2. Leer el HTML de SAES
// ---------------------------------------------------------------------
//  Cada fila de la tabla trae 11 celdas:
//    grupo · materia · profesor · edificio · salón · lun · mar · mié · jue · vie · sáb
//  y cada día puede traer uno o varios rangos "10:30-12:00".

function filasDe(string $archivo): array
{
    $filas = [];
    foreach (explode('</tr>', file_get_contents($archivo)) as $tr) {
        preg_match_all('#<td[^>]*>(.*?)</td>#s', $tr, $m);
        $tds = array_map(function ($celda) {
            $t = html_entity_decode(strip_tags($celda), ENT_QUOTES | ENT_HTML5, 'UTF-8');
            return trim(str_replace("\u{00A0}", ' ', $t));
        }, $m[1]);
        if (count($tds) >= 11 && preg_match('/^[1-8][ABC][MVX][1-9]\d?$/', $tds[0])) {
            $filas[] = $tds;
        }
    }
    return $filas;
}

$ofertas = [];      // "grupo|clave|profe" → oferta (las filas repetidas se juntan)
$leidas = [];
$sinCruzar = [];
$EXCLUIR = excluidas($periodo);   // data/excluir.csv
$saltadas = [];
foreach (CARRERAS as $car => [$dir, $letra]) {
    $leidas[$car] = 0;
    foreach (['m', 'v'] as $turno) {
        $archivo = DATA . "/$dir/horario-$turno.html";
        if (!is_file($archivo)) { aviso("no existe data/$dir/horario-$turno.html"); continue; }
        foreach (filasDe($archivo) as $f) {
            $leidas[$car]++;
            [$grupo, $materia, $profe, $edificio, $salon] = $f;
            if ($grupo[1] !== $letra) { aviso("$car: el grupo $grupo no es de esta carrera"); }

            [$clave, $como] = buscarClave($porSaes, $car, $grupo, $materia);
            if ($clave === null) { $sinCruzar[] = "$car $grupo «{$materia}»"; continue; }
            if (isset($EXCLUIR["$grupo|$clave"])) { $saltadas["$grupo $clave"] = $EXCLUIR["$grupo|$clave"]; continue; }
            if ($como !== 'exacto') { aviso("$grupo «{$materia}» → $clave ($como)"); }
            if (!$seOfrece[$clave]) { aviso("$grupo ofrece $clave, la clave que NO marca el PDF de optativas"); }

            $pn = norm($profe);
            if ($pn === '' || $pn === 'SIN ASIGNAR') { $pn = null; }

            $k = "$grupo|$clave|$pn";
            $ofertas[$k] ??= [
                'car' => $car, 'grupo' => $grupo, 'clave' => $clave,
                'profe' => $pn, 'nombre' => preg_replace('/\s+/u', ' ', trim($profe)),
                'edificio' => lugar($edificio), 'salon' => lugar($salon), 'ses' => [],
            ];
            for ($d = 0; $d < 6; $d++) {
                foreach (preg_split('/\s+/', $f[5 + $d], -1, PREG_SPLIT_NO_EMPTY) as $rango) {
                    if (!preg_match('/^\d{2}:\d{2}-\d{2}:\d{2}$/', $rango)) { continue; }
                    $bs = bloquesDe($rango);
                    if (!$bs) { aviso("$grupo $clave día " . ($d + 1) . " $rango: no cabe en ningún bloque"); }
                    if (count($bs) > 1) { aviso("$grupo $clave día " . ($d + 1) . " $rango: partido en bloques " . implode(' + ', $bs)); }
                    foreach ($bs as $b) { $ofertas[$k]['ses'][($d + 1) . "|$b"] = [$d + 1, $b]; }
                }
            }
        }
    }
}


// ---------------------------------------------------------------------
//  3. Guardar (todo o nada)
// ---------------------------------------------------------------------

$insProfe  = $pdo->prepare('INSERT INTO profesor (nombre, nombre_norm) VALUES (?, ?) RETURNING id');
$hayGrupo  = $pdo->prepare('SELECT 1 FROM oferta WHERE periodo = ? AND grupo = ? AND materia = ?');
$insOferta = $pdo->prepare(
    'INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon) VALUES (?, ?, ?, ?, ?, ?)
     ON CONFLICT (periodo, grupo, materia, profesor) DO NOTHING RETURNING id');
$insSesion = $pdo->prepare('INSERT INTO sesion (oferta, dia, bloque) VALUES (?, ?, ?)');

$nuevas = array_fill_keys(array_keys(CARRERAS), 0);
$yaEstaban = 0;
$profesNuevos = [];
$nSesiones = 0;

$pdo->beginTransaction();
foreach ($ofertas as $o) {
    $idProfe = null;
    if ($o['profe'] !== null) {
        if (!isset($profes[$o['profe']])) {
            $insProfe->execute([$o['nombre'], $o['profe']]);
            $profes[$o['profe']] = $insProfe->fetchColumn();
            $profesNuevos[] = $o['profe'];
        }
        $idProfe = $profes[$o['profe']];
    } else {
        // Sin profesor: si ese grupo ya tiene esa materia (quizá ya le pusiste
        // profe a mano en pgAdmin), no se agrega otra vez.
        $hayGrupo->execute([$periodo, $o['grupo'], $o['clave']]);
        if ($hayGrupo->fetch()) { $yaEstaban++; continue; }
    }

    $insOferta->execute([$periodo, $o['grupo'], $o['clave'], $idProfe, $o['edificio'], $o['salon']]);
    $id = $insOferta->fetchColumn();
    if ($id === false) { $yaEstaban++; continue; }

    $nuevas[$o['car']]++;
    foreach ($o['ses'] as [$dia, $bloque]) {
        $insSesion->execute([$id, $dia, $bloque]);
        $nSesiones++;
    }
}
$pdo->commit();


// ---------------------------------------------------------------------
//  4. Resumen
// ---------------------------------------------------------------------

// Profes nuevos que se parecen a uno que ya estaba: mismo inicio, o iguales
// quitando títulos como "ING." o "M. EN A.P.". NO se juntan solos: revísalos.
$sinTitulos = fn($n) => trim(preg_replace('/\s+/', ' ', preg_replace('/(^|\s)(M\. EN [A-Z.]+|[A-Z]{1,4}\.)(?=\s|$)/', ' ', $n)));
$parecidos = [];
foreach ($profesNuevos as $nuevo) {
    foreach (array_keys($profes) as $viejo) {
        if ($viejo === $nuevo) { continue; }
        if (str_starts_with($viejo, "$nuevo ") || str_starts_with($nuevo, "$viejo ")
            || $sinTitulos($viejo) === $sinTitulos($nuevo)) {
            $parecidos[] = "«{$nuevo}» (nuevo)  ≈  «{$viejo}»";
        }
    }
}

$cuenta = fn($sql) => (function () use ($pdo, $sql, $periodo) {
    $st = $pdo->prepare($sql);
    $st->execute([$periodo]);
    return $st->fetchColumn();
})();

echo "\n=== horarios de SAES → periodo $periodo ===\n";
foreach (CARRERAS as $car => $_) {
    printf("  %-4s %4d filas leídas, %4d ofertas nuevas\n", $car, $leidas[$car], $nuevas[$car]);
}
echo "  ya estaban en la base: $yaEstaban\n";
foreach ($saltadas as $x => $motivo) { echo "  no se cargó $x (data/excluir.csv): $motivo\n"; }
echo "  sesiones nuevas: $nSesiones\n";
echo '  profes nuevos: ' . count($profesNuevos) . "\n";
echo "\n=== en la base, periodo $periodo ===\n";
echo '  ofertas:  ' . $cuenta('SELECT count(*) FROM oferta WHERE periodo = ?') . "\n";
echo '  sesiones: ' . $cuenta('SELECT count(*) FROM sesion s JOIN oferta o ON o.id = s.oferta WHERE o.periodo = ?') . "\n";
echo '  profes con clase: ' . $cuenta('SELECT count(DISTINCT profesor) FROM oferta WHERE periodo = ?') . "\n";
echo '  ofertas sin profesor: ' . $cuenta('SELECT count(*) FROM oferta WHERE periodo = ? AND profesor IS NULL') . "\n";
echo '  profesores en total (todos los periodos): ' . $pdo->query('SELECT count(*) FROM profesor')->fetchColumn() . "\n";

if ($sinCruzar) {
    echo "\n=== filas que NO se cargaron: la materia no cruza (" . count($sinCruzar) . ") ===\n";
    foreach ($sinCruzar as $x) { echo "  $x\n"; }
}
if ($parecidos) {
    echo "\n=== ¿mismo profe? revisa en pgAdmin (" . count($parecidos) . ") ===\n";
    foreach ($parecidos as $x) { echo "  $x\n"; }
}
if ($avisos) {
    echo "\n=== avisos (" . count($avisos) . ") ===\n";
    foreach ($avisos as $a) { echo "  $a\n"; }
}
