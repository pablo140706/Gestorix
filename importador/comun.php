<?php
// =====================================================================
//  Funciones que comparten el importador y el convertidor de iscweb.
// =====================================================================

// Nombre normalizado para cruzar: MAYÚSCULAS, sin acentos ni diéresis,
// Ñ → N y un solo espacio entre palabras. "Resendiz  Muñoz" → "RESENDIZ MUNOZ".
// Es la misma regla que usaba iscweb (build-data.ps1 y core.js).
function norm(?string $s): string
{
    if ($s === null) {
        return '';
    }
    $s = html_entity_decode($s, ENT_QUOTES | ENT_HTML5, 'UTF-8');
    $s = str_replace("\u{00A0}", ' ', $s);  // &nbsp;
    $s = mb_strtoupper($s, 'UTF-8');
    $s = strtr($s, [
        'Á' => 'A', 'À' => 'A', 'Ä' => 'A', 'Â' => 'A',
        'É' => 'E', 'È' => 'E', 'Ë' => 'E', 'Ê' => 'E',
        'Í' => 'I', 'Ì' => 'I', 'Ï' => 'I', 'Î' => 'I',
        'Ó' => 'O', 'Ò' => 'O', 'Ö' => 'O', 'Ô' => 'O',
        'Ú' => 'U', 'Ù' => 'U', 'Ü' => 'U', 'Û' => 'U',
        'Ñ' => 'N', 'Ç' => 'C',
    ]);
    return trim(preg_replace('/\s+/u', ' ', $s));
}

// Los 9 bloques de la rejilla (igual que la tabla bloque de sql/00-tablas.sql).
const BLOQUES = [
    1 => ['07:00', '08:30'], 2 => ['08:30', '10:00'], 3 => ['10:30', '12:00'],
    4 => ['12:00', '13:30'], 5 => ['13:30', '15:00'], 6 => ['15:00', '16:30'],
    7 => ['16:30', '18:00'], 8 => ['18:30', '20:00'], 9 => ['20:00', '21:30'],
];

function minutos(string $hhmm): int
{
    [$h, $m] = explode(':', $hhmm);
    return (int)$h * 60 + (int)$m;
}

// Un rango "13:30-16:30" se traduce a TODOS los bloques que caben completos
// dentro: [5, 6]. "10:00-12:00" → [3] (brinca el receso). Misma regla que iscweb.
function bloquesDe(string $rango): array
{
    if (!preg_match('/^(\d{2}:\d{2})-(\d{2}:\d{2})$/', $rango, $m)) {
        return [];
    }
    $ini = minutos($m[1]);
    $fin = minutos($m[2]);
    $res = [];
    foreach (BLOQUES as $n => [$bi, $bf]) {
        if (minutos($bi) >= $ini && minutos($bf) <= $fin) {
            $res[] = $n;
        }
    }
    return $res;
}

// Encuentra la clave de una materia a partir de como la escribe SAES.
// $porSaes es un mapa "CARRERA|semestre|NOMBRE NORMALIZADO" → clave.
// Regresa [clave, cómo cruzó] o [null, null]. Tres intentos, en orden:
//   1. carrera + semestre del grupo + nombre completo;
//   2. carrera + nombre completo, si solo hay una materia con ese nombre;
//   3. carrera + semestre + lo que va antes del "|" (la rama de ISC), si es
//      único. Así cruza "TOPICOS SEL. DE COM|COMPUTING…" aunque el mapa
//      curricular de SAES lo escriba "COMPUTTING".
function buscarClave(array $porSaes, string $car, string $grupo, string $materia): array
{
    $sem = $grupo[0];
    $nm = norm($materia);
    if (isset($porSaes["$car|$sem|$nm"])) {
        return [$porSaes["$car|$sem|$nm"], 'exacto'];
    }
    $hay = [];
    foreach ($porSaes as $k => $clave) {
        if (str_starts_with($k, "$car|") && str_ends_with($k, "|$nm")) { $hay[] = $clave; }
    }
    if (count($hay) === 1) {
        return [$hay[0], 'por nombre, en otro semestre'];
    }
    if (str_contains($nm, '|')) {
        $rama = explode('|', $nm)[0];
        $hay = [];
        foreach ($porSaes as $k => $clave) {
            if (str_starts_with($k, "$car|$sem|$rama|")) { $hay[] = $clave; }
        }
        if (count($hay) === 1) {
            return [$hay[0], 'por rama'];
        }
    }
    return [null, null];
}

// Ofertas que el usuario decidió no cargar (data/excluir.csv), como un mapa
// "grupo|clave" → motivo, solo del periodo pedido.
function excluidas(string $periodo): array
{
    $res = [];
    $archivo = __DIR__ . '/../data/excluir.csv';
    if (!is_file($archivo)) { return $res; }
    foreach (file($archivo, FILE_IGNORE_NEW_LINES) as $ln) {
        if (trim($ln) === '' || $ln[0] === '#') { continue; }
        $c = str_getcsv($ln);
        if (count($c) >= 3 && trim($c[0]) === $periodo) {
            $res[trim($c[1]) . '|' . trim($c[2])] = trim($c[3] ?? '');
        }
    }
    return $res;
}

// Edificio o salón: SAES rellena con "X" o "POR DEFINIR" cuando no hay dato.
function lugar(?string $s): ?string
{
    $s = trim((string)$s);
    return ($s === '' || $s === 'X' || norm($s) === 'POR DEFINIR') ? null : $s;
}
