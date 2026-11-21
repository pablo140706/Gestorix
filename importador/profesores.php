<?php
// =====================================================================
//  profesores.php: links de MisProfesores y cédulas profesionales.
// =====================================================================
//  Lee data/profesores/links-cedulas.csv, la lista que captura el usuario:
//
//      nombre,link,numC-LoI,numC-M,numC-D,numC-T,calidad,recomiendan,dificultad
//
//  · calidad (0–10), recomiendan (0–100, sin %), dificultad (0–10): las de
//    MisProfesores. Vacías = no se tocan; si traen número, pisan las de la base.
//
//  · link: la dirección de MisProfesores; "SI" = ya estaba en la base;
//    "NO" = no tiene perfil en MisProfesores.
//  · numC-LoI: cédula de licenciatura ("…-L") o ingeniería ("…-I").
//  · numC-M: maestría (puede traer dos, separadas por coma).
//  · numC-D: doctorado.  · numC-T: especialidad (usuario, 2026-11-20).
//
//  Uso:  docker compose run --rm web php importador/profesores.php
//        (con --prueba solo reporta, no guarda nada)
//
//  Se puede repetir: el link solo se llena si la base no tiene uno (si es
//  distinto al de la base, lo reporta y no lo pisa); las cédulas de cada
//  profesor que trae el CSV se reemplazan por las del CSV.
//
//  Los nombres se cruzan normalizados. SAES escribe algunos con título o
//  cortados ("ENRIQUEZ ZARATE Dr. JOSE ASUNCION", "SANCHEZ MORENO ADRIANA
//  DE LA P", "SERRANO TALAMANTES J. FELIX"): esos se cruzan quitando el
//  título y aceptando iniciales y la última palabra cortada.
// =====================================================================

require __DIR__ . '/comun.php';
require __DIR__ . '/../html/lib/db.php';

$prueba = in_array('--prueba', $argv, true);
$archivo = __DIR__ . '/../data/profesores/links-cedulas.csv';
if (!is_file($archivo)) { fwrite(STDERR, "No existe data/profesores/links-cedulas.csv\n"); exit(1); }
$pdo = db();

// --- profesores de la base, con su nombre en palabras sin títulos ---
function palabras(string $nombre): array
{
    $n = norm($nombre);
    $n = preg_replace('/\bM\. EN [A-Z.]+\s*/u', '', $n);            // M. EN C., M. EN A.P.
    $sin = array_filter(explode(' ', $n), fn($t) => !in_array($t, ['DR.', 'DRA.', 'ING.', 'LIC.', 'MTRO.', 'MTRA.'], true));
    return array_values($sin);
}

// ¿El nombre de la base (quizá con iniciales o cortado al final) es el del CSV?
function mismoNombre(array $base, array $csv): bool
{
    if (count($base) !== count($csv)) { return false; }
    foreach ($base as $i => $t) {
        if ($t === $csv[$i]) { continue; }
        if (preg_match('/^([A-Z]+)\.$/', $t, $m) && str_starts_with($csv[$i], $m[1])) { continue; }   // J. = JOSE
        if ($i === count($base) - 1 && str_starts_with($csv[$i], $t)) { continue; }                    // DE LA P = DE LA PAZ
        return false;
    }
    return true;
}

$profes = $pdo->query('SELECT id, nombre, nombre_norm, mp_link FROM profesor')->fetchAll();
$porNorm = [];
foreach ($profes as $p) { $porNorm[$p['nombre_norm']] = $p; }

function buscar(string $nombre, array $porNorm, array $profes): ?array
{
    if (isset($porNorm[norm($nombre)])) { return $porNorm[norm($nombre)]; }
    $csv = palabras($nombre);
    $hits = array_values(array_filter($profes, fn($p) => mismoNombre(palabras($p['nombre']), $csv)));
    return count($hits) === 1 ? $hits[0] : null;
}

// "4865425-I" → [4865425, ingenieria]; "13299957, 14504250" → dos.
function cedulas(string $valor, string $nivel): array
{
    $res = [];
    foreach (preg_split('/\s*,\s*/', trim($valor), -1, PREG_SPLIT_NO_EMPTY) as $v) {
        $niv = $nivel;
        if ($nivel === 'licenciatura') {
            if (preg_match('/-I$/i', $v)) { $niv = 'ingenieria'; }
            $v = preg_replace('/-[LI]$/i', '', $v);
        }
        $res[] = [$v, $niv];
    }
    return $res;
}

$f = fopen($archivo, 'r');
fgetcsv($f);
$conMetricas = 0; $linksNuevos = 0; $sinPerfil = 0; $conCedula = 0; $totalCed = 0;
$noEncontrados = []; $linksDistintos = []; $raras = []; $repetidas = []; $porTitulo = [];
$cambios = [];       // [profesor, link|null, cédulas[]|null]
while (($r = fgetcsv($f)) !== false) {
    if (!$r || trim($r[0]) === '') { continue; }
    [$nombre, $link, $cLI, $cM, $cD, $cT, $mCal, $mRec, $mDif] = array_pad(array_map('trim', $r), 9, '');
    $p = buscar($nombre, $porNorm, $profes);
    if (!$p) { $noEncontrados[] = $nombre; continue; }
    if ($p['nombre_norm'] !== norm($nombre)) { $porTitulo[] = "$nombre = {$p['nombre']}"; }

    $nuevoLink = null;
    if (str_starts_with($link, 'http')) {
        if (!$p['mp_link']) { $nuevoLink = $link; $linksNuevos++; }
        elseif (rtrim($p['mp_link'], '/') !== rtrim($link, '/')) { $linksDistintos[] = "$nombre: base {$p['mp_link']} · CSV $link"; }
    } elseif ($link === 'NO') { $sinPerfil++; }

    $lista = null;
    if ("$cLI$cM$cD$cT" !== '') {
        $lista = [];
        foreach ([[$cLI, 'licenciatura'], [$cM, 'maestria'], [$cD, 'doctorado'], [$cT, 'especialidad']] as [$v, $niv]) {
            foreach (cedulas($v, $niv) as [$num, $nivel]) {
                if (preg_match('/^L(\d+)$/', $num, $m)) { $raras[] = "$nombre: «{$num}» → $m[1] (sobraba la L)"; $num = $m[1]; }
                if (!preg_match('/^\d{5,9}$/', $num)) { $raras[] = "$nombre: «{$num}» no es un número de cédula; no se guarda"; continue; }
                if (isset($lista[$num])) { $repetidas[] = "$nombre: $num viene como {$lista[$num]} y como $nivel; se guarda como {$lista[$num]}"; continue; }
                $lista[$num] = $nivel;
            }
        }
        if ($lista) { $conCedula++; $totalCed += count($lista); }
    }
    // Métricas de MisProfesores: solo las que traen número.
    $metr = [];
    foreach ([['mp_calidad', $mCal, 10], ['mp_recomiendan', rtrim($mRec, '%'), 100], ['mp_dificultad', $mDif, 10]] as [$col, $v, $max]) {
        if ($v === '') { continue; }
        $v = str_replace(',', '.', $v);
        if (!is_numeric($v) || $v < 0 || $v > $max) { $raras[] = "$nombre: $col = «{$v}» fuera de 0–$max; no se guarda"; continue; }
        $metr[$col] = (float)$v;
    }
    if ($metr) { $conMetricas++; }
    if ($nuevoLink !== null || $lista !== null || $metr) { $cambios[] = [(int)$p['id'], $nuevoLink, $lista, $metr]; }
}
fclose($f);

if (!$prueba) {
    $pdo->beginTransaction();
    $upLink = $pdo->prepare('UPDATE profesor SET mp_link = ? WHERE id = ? AND mp_link IS NULL');
    $delCed = $pdo->prepare('DELETE FROM cedula WHERE profesor = ?');
    $insCed = $pdo->prepare('INSERT INTO cedula (profesor, numero, nivel) VALUES (?, ?, ?)');
    foreach ($cambios as [$id, $link, $lista, $metr]) {
        foreach ($metr as $col => $v) { $pdo->prepare("UPDATE profesor SET $col = ? WHERE id = ?")->execute([$v, $id]); }
        if ($link !== null) { $upLink->execute([$link, $id]); }
        if ($lista !== null) {
            $delCed->execute([$id]);
            foreach ($lista as $num => $nivel) { $insCed->execute([$id, (string)$num, $nivel]); }
        }
    }
    $pdo->commit();
}

$out = fn($t, $a) => print("$t (" . count($a) . ")" . ($a ? ":\n  " . implode("\n  ", $a) : '') . "\n");
echo ($prueba ? "PRUEBA: no se guardó nada.\n" : "Guardado.\n");
echo "Links nuevos: $linksNuevos · sin perfil en MisProfesores: $sinPerfil\n";
echo "Cédulas: $totalCed de $conCedula profesores · métricas de $conMetricas profesores\n";
$out('Cruzados quitando título o iniciales', $porTitulo);
$out('No encontrados en la base', $noEncontrados);
$out('Link distinto al de la base (no se pisó)', $linksDistintos);
$out('Cédulas raras', $raras);
$out('Cédula repetida en dos columnas', $repetidas);
