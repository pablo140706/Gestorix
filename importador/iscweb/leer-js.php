<?php
// =====================================================================
//  leer-js.php: lee los .js de datos de iscweb desde PHP.
// =====================================================================
//  Los usan convertir.php (carga inicial) y las pruebas que comparan la
//  API contra los datos originales de iscweb. Quien lo incluya define
//  antes la constante ISCWEB (carpeta de iscweb).
// =====================================================================


function saltarCadena(string $s, int $i): int
{
    $q = $s[$i];
    $n = strlen($s);
    $i++;
    while ($i < $n && $s[$i] !== $q) {
        $i += ($s[$i] === '\\') ? 2 : 1;
    }
    return $i + 1;
}

// Regresa el texto del objeto o arreglo que empieza en $i, completo.
function literal(string $s, int $i): string
{
    $n = strlen($s);
    while ($i < $n && $s[$i] !== '{' && $s[$i] !== '[') {
        $i++;
    }
    $ini = $i;
    $prof = 0;
    while ($i < $n) {
        $c = $s[$i];
        if ($c === '"' || $c === "'") { $i = saltarCadena($s, $i); continue; }
        if ($c === '/' && ($s[$i + 1] ?? '') === '/') { $i = strpos($s, "\n", $i) ?: $n; continue; }
        if ($c === '{' || $c === '[') { $prof++; }
        if ($c === '}' || $c === ']') {
            $prof--;
            if ($prof === 0) { return substr($s, $ini, $i - $ini + 1); }
        }
        $i++;
    }
    throw new RuntimeException('objeto sin cerrar');
}

function jsAJson(string $js): string
{
    $out = '';
    $n = strlen($js);
    $i = 0;
    while ($i < $n) {
        $c = $js[$i];
        if ($c === '"' || $c === "'") {                         // cadena
            $fin = saltarCadena($js, $i);
            $txt = substr($js, $i + 1, $fin - $i - 2);
            if ($c === "'") { $txt = str_replace(["\\'", '"'], ["'", '\\"'], $txt); }
            $out .= '"' . $txt . '"';
            $i = $fin;
            continue;
        }
        if ($c === '/' && ($js[$i + 1] ?? '') === '/') {         // comentario
            $i = strpos($js, "\n", $i) ?: $n;
            continue;
        }
        if (ctype_alpha($c) || $c === '_') {                     // llave sin comillas
            preg_match('/[A-Za-z_][A-Za-z0-9_]*/A', $js, $m, 0, $i);
            $i += strlen($m[0]);
            $out .= preg_match('/\G\s*:/', $js, $x, 0, $i) ? '"' . $m[0] . '"' : $m[0];
            continue;
        }
        if ($c === ',' && preg_match('/\G,(\s|\/\/[^\n]*)*[}\]]/', $js, $x, 0, $i)) {
            $i++;                                                // coma al final
            continue;
        }
        $out .= $c;
        $i++;
    }
    return $out;
}

function leerJs(string $archivo, string $const): array
{
    $src = file_get_contents(ISCWEB . "/$archivo");
    $p = strpos($src, "const $const");
    if ($p === false) {
        throw new RuntimeException("no encontré «const $const» en $archivo");
    }
    return json_decode(jsAJson(literal($src, strpos($src, '=', $p))), true, 512, JSON_THROW_ON_ERROR);
}
