<?php
// =====================================================================
//  convertir.php: pasa los datos de iscweb a SQL de carga inicial.
// =====================================================================
//  Se corre UNA VEZ. Lee los .js y el CSV de iscweb (commit 2419470) y
//  escribe sql/02 … sql/07 y sql/09. Después de eso la base manda: lo que haya que
//  corregir se corrige en pgAdmin o con una migración, no volviendo a
//  correr esto (borraría las correcciones de los .sql).
//
//  Cómo se corre, desde la carpeta del proyecto en Git Bash:
//
//    MSYS_NO_PATHCONV=1 docker compose run --rm --no-deps \
//      -v C:/db/repos/iscweb-inicio:/iscweb:ro -v ./sql:/var/www/sql \
//      web php importador/iscweb/convertir.php
//
//  Lo que sale de cada archivo de iscweb:
//    calendario.csv        → 02-calendario.sql   periodos y eventos del IPN
//    planes.js             → 03-materias.sql     claves, nombres con acentos y orden
//    + optativas.js                              (+ nombre en inglés de las optativas de ISC)
//                          → 04-seriacion.sql    ISC oficial, IA y LCD aprobada
//    optativas.js          → 05-rutas.sql        14 ramas de ISC con su ícono (+ parejas IA/LCD)
//    metrics.js
//    + maestros_manual.js  → 06-profesores.sql   métricas y links de MisProfesores
//    historial.js          → 07-historial.sql    ofertas de 26/2 (solo ISC)
//    cupos_2026_2.csv      → 09-cupos-26-2.sql   cupos de 26/2 (solo ISC), para el historial
//  (08-ofertas-extra.sql está escrito a mano.)
// =====================================================================

require __DIR__ . '/../comun.php';

const ISCWEB = '/iscweb';
const SALIDA = '/var/www/sql';
const FECHA  = '2026-11-08';
const COMMIT = '2419470';

$avisos = [];
function aviso(string $s): void { global $avisos; $avisos[] = $s; }


require __DIR__ . '/leer-js.php';     // leerJs(): saltarCadena, literal, jsAJson

// ---------------------------------------------------------------------
//  Escribir SQL
// ---------------------------------------------------------------------

function q($v): string
{
    if ($v === null)  { return 'NULL'; }
    if (is_bool($v))  { return $v ? 'true' : 'false'; }
    if (is_int($v) || is_float($v)) {
        return rtrim(rtrim(number_format($v, 2, '.', ''), '0'), '.');
    }
    return "'" . str_replace("'", "''", $v) . "'";
}

function fila(array $valores): string
{
    return '(' . implode(', ', array_map('q', $valores)) . ')';
}

function escribir(string $archivo, string $fuente, string $explicacion, array $sql): void
{
    $enc = "-- =====================================================================\n"
         . "--  Gestorix · $archivo · carga inicial (initdb)\n"
         . "-- =====================================================================\n"
         . "--  Generado UNA VEZ el " . FECHA . " por importador/iscweb/convertir.php\n"
         . "--  desde iscweb " . COMMIT . " ($fuente). No se vuelve a generar:\n"
         . "--  desde aquí la base manda y se corrige en pgAdmin.\n"
         . ($explicacion !== '' ? "--\n" . preg_replace('/^/m', '--  ', $explicacion) . "\n" : '')
         . "-- =====================================================================\n\n";
    file_put_contents(SALIDA . "/$archivo", $enc . implode("\n", $sql) . "\n");
    echo "  escrito sql/$archivo\n";
}

// INSERT de varias filas, una por línea.
function insertar(string $tabla, array $columnas, array $filas): string
{
    if (!$filas) { return "-- (sin filas para $tabla)\n"; }
    return "INSERT INTO $tabla (" . implode(', ', $columnas) . ") VALUES\n    "
         . implode(",\n    ", array_map('fila', $filas)) . ";\n";
}


// =====================================================================
//  02 · calendario
// =====================================================================

$eventos = [];
foreach (file(ISCWEB . '/calendario.csv', FILE_IGNORE_NEW_LINES) as $ln) {
    $ln = trim(preg_replace('/^\xEF\xBB\xBF/', '', $ln));
    if ($ln === '' || $ln[0] === '#' || str_starts_with($ln, 'inicio,')) { continue; }
    $c = array_map('trim', str_getcsv($ln));
    if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $c[0])) { aviso("calendario.csv: fila rara «{$ln}»"); continue; }
    $eventos[] = [
        'periodo' => ($c[3] ?? '') !== '' ? $c[3] : null,
        'inicio'  => $c[0],
        'fin'     => ($c[1] ?? '') !== '' ? $c[1] : null,
        'tipo'    => $c[2],
    ];
}
usort($eventos, fn($a, $b) => [$a['inicio'], $a['tipo']] <=> [$b['inicio'], $b['tipo']]);

// Un periodo se arma con sus marcas de inicio y fin. 26/2 no está en este
// calendario (es del ciclo anterior), pero hace falta para su historial.
$periodos = ['26/2' => [null, null]];
foreach ($eventos as $e) {
    if ($e['periodo'] === null) { continue; }
    $periodos[$e['periodo']] ??= [null, null];
    if ($e['tipo'] === 'inicio') { $periodos[$e['periodo']][0] = $e['inicio']; }
    if ($e['tipo'] === 'fin')    { $periodos[$e['periodo']][1] = $e['inicio']; }
}
$filasPer = [];
foreach ($periodos as $cod => [$ini, $fin]) { $filasPer[] = [$cod, $ini, $fin]; }

escribir('02-calendario.sql', 'calendario.csv',
    "Calendario del IPN 2026-2027 (escolarizada), transcrito a mano del PDF:\n"
  . "ahí las fechas son colores, no texto. fin NULL = un solo día.",
    [
        insertar('periodo', ['codigo', 'inicio', 'fin'], $filasPer),
        insertar('evento_calendario', ['periodo', 'inicio', 'fin', 'tipo'],
            array_map(fn($e) => [$e['periodo'], $e['inicio'], $e['fin'], $e['tipo']], $eventos)),
    ]);


// =====================================================================
//  03 · materias
// =====================================================================

$PLANES = leerJs('planes.js', 'PLANES');

// Las 14 ramas de ISC: de aquí salen el nombre en inglés de cada optativa
// (bien escrito; SAES trae "COMPUTTING", "QUALLITY"…) y el ícono de la rama.
$ESPECIALIZACIONES = leerJs('optativas.js', 'ESPECIALIZACIONES');
$EN = [];
foreach ($ESPECIALIZACIONES as $r) {
    foreach ($r['materias'] as $m) { $EN[$m['clave']] = $m['en']; }
}

// Optativas de IA y LCD según su PDF (mapaCurricular{IIA,LCD}2020_optativas.pdf).
// Solo vale la clave del semestre que marca el PDF; la otra va con se_ofrece = false.
$PDF_OPTATIVAS = [
    'IA' => [
        6 => ['Aplicaciones de Lenguaje Natural', 'Cómputo en la Nube', 'Interacción Humano-Máquina',
              'Minería de Datos', 'Programación de Dispositivos Móviles', 'Propiedad Intelectual',
              'Sistemas Multiagentes'],
        7 => ['Temas Selectos de Inteligencia Artificial', 'Técnicas de Programación para Robots Móviles',
              'Tópicos Selectos de Algoritmos Bioinspirados', 'Big Data',
              'Aplicaciones de Inteligencia Artificial en Sistemas Embebidos',
              'Innovación y Emprendimiento Tecnológico', 'Aplicaciones de Sistemas Multiagentes'],
    ],
    'LCD' => [
        6 => ['Bioinformática Básica', 'Ciberseguridad', 'Estadística Avanzada', 'Propiedad Intelectual',
              'Simulación Básica', 'Sistemas de Información Geográfica'],
        7 => ['Bioinformática Avanzada', 'Protección de Datos', 'Temas Selectos de Aprendizaje Profundo',
              'Innovación y Emprendimiento Tecnológico', 'Simulación Avanzada',
              'Temas Selectos de Inteligencia Artificial',
              'Temas Selectos de Procesamiento de Lenguaje Natural'],
    ],
];

$materias = [];        // clave → datos
$porSaes  = [];        // carrera|semestre|norm(nombre_saes) → clave
$filasMat = [];
foreach ($PLANES as $car => $plan) {
    foreach (['OBL' => $plan['materias'], 'OPT' => $plan['optativas']] as $tipo => $lista) {
        $orden = [];
        foreach ($lista as $m) {
            $sem = (int)$m['sem'];
            $orden[$sem] = ($orden[$sem] ?? 0) + 1;
            $seOfrece = true;
            if ($tipo === 'OPT' && isset($PDF_OPTATIVAS[$car])) {
                $seOfrece = in_array(norm($m['nom']), array_map('norm', $PDF_OPTATIVAS[$car][$sem] ?? []), true);
            }
            $ua = str_starts_with(norm($m['saes']), 'TRABAJO TERMINAL') ? 2 : 1;
            $k = "$car|$sem|" . norm($m['saes']);
            if (isset($porSaes[$k])) { aviso("nombre SAES repetido en $car $sem.º: {$m['saes']}"); }
            $porSaes[$k] = $m['clave'];
            $materias[$m['clave']] = ['car' => $car, 'sem' => $sem, 'tipo' => $tipo, 'nom' => $m['nom'], 'saes' => $m['saes']];
            $filasMat[] = [$m['clave'], $car, $m['nom'], $m['saes'], $tipo, $sem, (float)$m['cr'], $ua,
                           isset($m['ht']) ? (float)$m['ht'] : null, isset($m['hp']) ? (float)$m['hp'] : null,
                           $orden[$sem], $seOfrece, $EN[$m['clave']] ?? null];
        }
    }
}
// Cada nombre del PDF debe corresponder a exactamente una optativa de su semestre.
foreach ($PDF_OPTATIVAS as $car => $sems) {
    foreach ($sems as $sem => $nombres) {
        foreach ($nombres as $nom) {
            $hay = array_filter($materias, fn($m) => $m['car'] === $car && $m['sem'] === $sem
                                                  && $m['tipo'] === 'OPT' && norm($m['nom']) === norm($nom));
            if (count($hay) !== 1) { aviso("PDF de $car, $sem.º: «{$nom}» cruza con " . count($hay) . " claves"); }
        }
    }
}

escribir('03-materias.sql', 'planes.js',
    "planes.js salió del mapa curricular de SAES (data/*/mp.html) más el nombre\n"
  . "con acentos y el orden de nombres.csv. ua = 2 en Trabajo Terminal I y II.\n"
  . "se_ofrece = false en la clave de IA/LCD que no corresponde al semestre\n"
  . "que marca el PDF de optativas. nombre_en: optativas de ISC (optativas.js).",
    [insertar('materia',
        ['clave', 'carrera', 'nombre', 'nombre_saes', 'tipo', 'semestre', 'creditos', 'ua',
         'horas_t', 'horas_p', 'orden', 'se_ofrece', 'nombre_en'],
        $filasMat)]);


// =====================================================================
//  04 · seriación
// =====================================================================

$filasSer = [];
foreach ($PLANES as $car => $plan) {
    foreach ($plan['seriacion'] as $dep => $reqs) {
        foreach ($reqs as $req) {
            if (!isset($materias[$dep], $materias[$req])) { aviso("seriación $car: $req → $dep no existe"); continue; }
            $filasSer[] = [$dep, $req, $car === 'ISC'];
        }
    }
}
escribir('04-seriacion.sql', 'planes.js',
    "ISC: los pares del mapa oficial (oficial = true). IA y LCD: la propuesta\n"
  . "por nombres que aprobó el usuario el 2026-11-02 (oficial = false).\n"
  . "Solo avisa, nunca bloquea.",
    [insertar('seriacion', ['materia', 'requisito', 'oficial'], $filasSer)]);


// =====================================================================
//  05 · rutas de optativas
// =====================================================================

$rutas = [];   // [carrera, nombre, [claves]]
foreach ($ESPECIALIZACIONES as $r) {
    $claves = array_column($r['materias'], 'clave');
    foreach ($r['materias'] as $m) {
        $x = $materias[$m['clave']] ?? null;
        if (!$x || $x['car'] !== 'ISC' || $x['tipo'] !== 'OPT' || $x['sem'] !== (int)$m['sem']) {
            aviso("rama ISC «{$r['nombre']}»: {$m['clave']} no es optativa de {$m['sem']}.º");
        }
    }
    $rutas[] = ['ISC', $r['nombre'], $claves, $r['icono'] ?? null];
}

// IA y LCD: solo las parejas obvias (CLAUDE.md §4.3).
$PAREJAS = [
    'IA'  => [['Sistemas Multiagentes', 'Aplicaciones de Sistemas Multiagentes'],
              ['Propiedad Intelectual', 'Innovación y Emprendimiento Tecnológico'],
              ['Minería de Datos', 'Big Data']],
    'LCD' => [['Bioinformática Básica', 'Bioinformática Avanzada'],
              ['Simulación Básica', 'Simulación Avanzada'],
              ['Ciberseguridad', 'Protección de Datos'],
              ['Propiedad Intelectual', 'Innovación y Emprendimiento Tecnológico']],
];
$optDe = function (string $car, int $sem, string $nom) use ($materias): ?string {
    foreach ($materias as $clave => $m) {
        if ($m['car'] === $car && $m['sem'] === $sem && $m['tipo'] === 'OPT' && norm($m['nom']) === norm($nom)) {
            return $clave;
        }
    }
    aviso("pareja $car: no encontré «{$nom}» en {$sem}.º");
    return null;
};
foreach ($PAREJAS as $car => $lista) {
    foreach ($lista as [$a, $b]) {
        $rutas[] = [$car, "$a → $b", array_filter([$optDe($car, 6, $a), $optDe($car, 7, $b)]), null];
    }
}

$sqlRutas = [insertar('ruta_optativa', ['carrera', 'nombre', 'icono'], array_map(fn($r) => [$r[0], $r[1], $r[3]], $rutas))];
foreach ($rutas as [$car, $nom, $claves]) {
    $sqlRutas[] = "INSERT INTO ruta_materia (ruta, materia)\n"
                . "SELECT r.id, m.clave FROM ruta_optativa r, (VALUES " . implode(', ', array_map(fn($c) => '(' . q($c) . ')', $claves)) . ") AS m(clave)\n"
                . "WHERE r.carrera = " . q($car) . " AND r.nombre = " . q($nom) . ";";
}
escribir('05-rutas.sql', 'optativas.js',
    "ISC: las 14 ramas de mapaCurricularISC2020_optativas.pdf (una materia de\n"
  . "6.º y una de 7.º cada una). IA y LCD: solo las parejas obvias; las demás\n"
  . "optativas se eligen libres dentro de su semestre.",
    $sqlRutas);


// =====================================================================
//  06 · profesores
// =====================================================================

$profes = [];   // norm → [nombre, calidad, recomiendan, dificultad, link]
$sinDato = fn($v) => ($v === '' || $v === null) ? null : (float)$v;
foreach (leerJs('metrics.js', 'TEACHER_METRICS') as $nombre => $m) {
    $profes[norm($nombre)] = [
        'nombre' => trim($nombre),
        'calidad' => $sinDato($m['calidad'] ?? null),
        'recomiendan' => $sinDato($m['recomiendan'] ?? null),
        'dificultad' => $sinDato($m['dificultad'] ?? null),
        'link' => null,
    ];
}
$nMetricas = count($profes);

// Correcciones de captura confirmadas por el usuario (CLAUDE.md §4.6).
// BARRALES (recomiendan 1.4 → 14) y TELLEZ BARRERA (rec/dif invertidos) ya
// venían corregidos en metrics.js. Se revisa el valor viejo antes de cambiarlo.
$CORRECCIONES = [
    ['LUNA BENOSO',      'dificultad', 44,  4.4],
    ['MARQUEZ ARREGUIN', 'dificultad', 33,  3.3],
    ['OLALDE MOGOLLAN',  'calidad',    83,  8.3],
    ['LEVARIO MEDINA',   'dificultad', 6.4, 3.5],
];
$hechas = [];
foreach ($CORRECCIONES as [$pref, $campo, $viejo, $nuevo]) {
    $hay = array_filter(array_keys($profes), fn($k) => str_starts_with($k, $pref));
    if (count($hay) !== 1) { aviso("corrección $pref: cruza con " . count($hay) . " profes"); continue; }
    $k = reset($hay);
    if (abs($profes[$k][$campo] - $viejo) > 0.001) { aviso("corrección $pref: $campo vale {$profes[$k][$campo]}, no $viejo"); continue; }
    $profes[$k][$campo] = $nuevo;
    $hechas[] = "$k: $campo $viejo → $nuevo";
}

$nLinks = 0;
foreach (leerJs('maestros_manual.js', 'MANUAL_LINKS') as $nombre => $v) {
    $link = is_array($v) ? ($v['link'] ?? '') : (string)$v;
    if ($link === '') { continue; }
    $nLinks++;
    $k = norm($nombre);
    $profes[$k] ??= ['nombre' => trim($nombre), 'calidad' => null, 'recomiendan' => null, 'dificultad' => null, 'link' => null];
    $profes[$k]['link'] = $link;
}

// Métricas fuera de escala: el CHECK de la tabla las rechazaría.
foreach ($profes as $k => $p) {
    foreach (['calidad' => 10, 'recomiendan' => 100, 'dificultad' => 10] as $campo => $max) {
        if ($p[$campo] !== null && ($p[$campo] < 0 || $p[$campo] > $max)) { aviso("$k: $campo = {$p[$campo]} fuera de 0–$max"); }
    }
}

// Nombres que parecen el mismo profe escrito distinto (uno empieza igual que el otro).
$llaves = array_keys($profes);
sort($llaves);
foreach ($llaves as $i => $a) {
    foreach (array_slice($llaves, $i + 1) as $b) {
        if (str_starts_with($b, "$a ") || str_starts_with($a, "$b ")) { aviso("¿mismo profe?: «{$a}» y «{$b}»"); }
    }
}

ksort($profes);
$filasProf = [];
foreach ($profes as $k => $p) {
    $filasProf[] = [$p['nombre'], $k, $p['link'], $p['calidad'], $p['recomiendan'], $p['dificultad']];
}
escribir('06-profesores.sql', 'metrics.js + maestros_manual.js',
    "Métricas de MisProfesores (calidad 0–10, recomiendan 0–100 %, dificultad\n"
  . "0–10) y links. NULL = sin dato. Correcciones de captura aplicadas:\n  "
  . implode("\n  ", $hechas ?: ['(ninguna)']),
    [insertar('profesor', ['nombre', 'nombre_norm', 'mp_link', 'mp_calidad', 'mp_recomiendan', 'mp_dificultad'], $filasProf)]);


// =====================================================================
//  07 · historial
// =====================================================================

$HISTORIAL = leerJs('historial.js', 'HISTORIAL');
$DIAS = ['Lun' => 1, 'Mar' => 2, 'Mie' => 3, 'Jue' => 4, 'Vie' => 5, 'Sab' => 6];

$ofertasHist = [];      // grupo|clave|profe → datos (se juntan filas repetidas)
$profesNuevos = [];
$sinCruzar = [];
foreach ($HISTORIAL['2026/2'] as $e) {
    [$clave, $como] = buscarClave($porSaes, $e['carrera'], $e['grupo'], $e['materia']);
    if ($clave === null) { $sinCruzar["{$e['grupo']} {$e['materia']}"] = true; continue; }
    if ($como !== 'exacto') { aviso("historial {$e['grupo']} «{$e['materia']}» → $clave ($como)"); }
    $pn = norm($e['profesor']);
    if ($pn === '' || $pn === 'SIN ASIGNAR') { $pn = null; }
    if ($pn !== null && !isset($profes[$pn])) { $profesNuevos[$pn] = trim($e['profesor']); }
    $k = "{$e['grupo']}|$clave|$pn";
    $ofertasHist[$k] ??= ['grupo' => $e['grupo'], 'clave' => $clave, 'profe' => $pn,
                          'edificio' => lugar($e['edificio']), 'salon' => lugar($e['salon']), 'ses' => []];
    foreach ($e['sesiones'] as $s) {
        $rango = "{$s['ini']}-{$s['fin']}";
        $bs = bloquesDe($rango);
        if (!$bs) { aviso("historial {$e['grupo']} {$s['dia']} $rango: no cabe en ningún bloque"); continue; }
        if (count($bs) > 1) { aviso("historial {$e['grupo']} {$s['dia']} $rango: partido en bloques " . implode(' + ', $bs)); }
        foreach ($bs as $b) {
            $ofertasHist[$k]['ses']["{$DIAS[$s['dia']]}|$b"] = [$DIAS[$s['dia']], $b];
        }
    }
}
foreach (array_keys($sinCruzar) as $x) { aviso("historial 26/2 sin materia: $x"); }

ksort($profesNuevos);
$sqlHist = [];
$sqlHist[] = "-- Profes que dieron clase en 26/2 y no están en las métricas ni en los links.";
$sqlHist[] = $profesNuevos
    ? "INSERT INTO profesor (nombre, nombre_norm) VALUES\n    "
      . implode(",\n    ", array_map(fn($k, $n) => fila([$n, $k]), array_keys($profesNuevos), $profesNuevos))
      . "\nON CONFLICT (nombre_norm) DO NOTHING;\n"
    : "-- (ninguno)\n";
$sqlHist[] = "-- Una oferta por sentencia, con sus sesiones (día 1–6, bloque 1–9).";
foreach ($ofertasHist as $o) {
    $prof = $o['profe'] === null ? 'NULL' : '(SELECT id FROM profesor WHERE nombre_norm = ' . q($o['profe']) . ')';
    $ins = "INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)\n"
         . "VALUES ('26/2', " . q($o['grupo']) . ', ' . q($o['clave']) . ", $prof, " . q($o['edificio']) . ', ' . q($o['salon']) . ')';
    if (!$o['ses']) { $sqlHist[] = "$ins;"; continue; }
    $ses = implode(', ', array_map(fn($s) => "({$s[0]}, {$s[1]})", array_values($o['ses'])));
    $sqlHist[] = "WITH o AS ($ins\n  RETURNING id)\n"
               . "INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES $ses) AS s(dia, bloque);";
}
$nHist27 = count($HISTORIAL['2027/1'] ?? []);
escribir('07-historial.sql', 'historial.js',
    "Ofertas de 26/2 de ISC (no hay historial de IA ni de LCD). El 27/1 que\n"
  . "también traía historial.js ($nHist27 filas) NO se carga: el 27/1 sale del\n"
  . "HTML de SAES con importador/horarios.php.",
    $sqlHist);


// =====================================================================
//  09 · cupos de 26/2
// =====================================================================

$filasCupo26 = [];
foreach (file(ISCWEB . '/cupos_2026_2.csv', FILE_IGNORE_NEW_LINES) as $ln) {
    $ln = trim(preg_replace('/^\xEF\xBB\xBF/', '', $ln));
    if ($ln === '' || $ln[0] === '#' || str_starts_with($ln, 'grupo,')) { continue; }
    [$grupo, $clave, $nombre, , $cupo, $ins, $disp] = array_map('trim', str_getcsv($ln));
    if (!preg_match('/^[1-8][ABC][MVX][1-9]\d?$/', $grupo) || !isset($materias[$clave])) {
        aviso("cupos 26/2: «{$ln}» no tiene grupo o clave válidos");
        continue;
    }
    if ((int)$cupo - (int)$ins !== (int)$disp) { aviso("cupos 26/2 $grupo $clave: cupo − inscritos ≠ disponibles"); }
    $filasCupo26["$grupo|$clave"] = ['26/2', $grupo, $clave, (int)$cupo, (int)$ins];
}
escribir('09-cupos-26-2.sql', 'cupos_2026_2.csv',
    "Cupos de 26/2 (solo ISC). La ficha del maestro los usa para mostrar\n"
  . "cuántos inscritos tuvo cada grupo el periodo pasado.",
    [insertar('cupo', ['periodo', 'grupo', 'materia', 'cupo', 'inscritos'], array_values($filasCupo26))]);


// =====================================================================
//  Resumen
// =====================================================================

$porCar = array_count_values(array_column($materias, 'car'));
echo "\n=== resumen ===\n";
echo '  periodos: ' . count($filasPer) . ', eventos: ' . count($eventos) . "\n";
echo '  materias: ' . count($materias) . ' (' . implode(', ', array_map(fn($c, $n) => "$c $n", array_keys($porCar), $porCar)) . ")\n";
echo '    con se_ofrece = false: ' . count(array_filter($filasMat, fn($f) => $f[11] === false)) . "\n";
echo '  seriación: ' . count($filasSer) . " pares\n";
echo '  rutas: ' . count($rutas) . "\n";
echo "  profesores: " . count($profes) . " ($nMetricas con métricas, $nLinks links) + " . count($profesNuevos) . " solo del historial\n";
echo '  correcciones aplicadas: ' . count($hechas) . "\n";
echo '  historial 26/2: ' . count($ofertasHist) . ' ofertas, ' . array_sum(array_map(fn($o) => count($o['ses']), $ofertasHist)) . " sesiones\n";
echo '  cupos 26/2: ' . count($filasCupo26) . "\n";
echo '  optativas con nombre en inglés: ' . count(array_filter($filasMat, fn($f) => $f[12] !== null)) . "\n";
echo "\n=== avisos (" . count($avisos) . ") ===\n";
foreach ($avisos as $a) { echo "  $a\n"; }
