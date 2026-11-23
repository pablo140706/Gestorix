<?php
// =====================================================================
//  Filtro de groserías e insultos (usuario, 2026-11-22).
// =====================================================================
//  Se usa en el texto de los comentarios, en los conceptos de la rúbrica y
//  en los alias. Corre en el SERVIDOR: aunque alguien se salte el
//  formulario y mande la petición a mano desde la consola, aquí se revisa.
//
//  Cómo busca:
//   · pasa todo a minúsculas sin acentos y deshace trucos comunes
//     (p3nd3jo → pendejo, pendejoooo → pendejo, p.e.n.d.e.j.o → pendejo);
//   · busca PALABRAS completas (o raíces al inicio de una palabra), así
//     "computadora" no choca con "puta" ni "disputa".
//  Para agregar una palabra: ponla en GROSERIAS (sin acentos, minúsculas).
//  Las que terminan en * son raíces: "pendej*" atrapa pendejo, pendejada…
// =====================================================================

const GROSERIAS = [
    'pendej*', 'put*', 'ching*', 'verga', 'vergas', 'vergazo*', 'vergud*', 'verguer*', 'vergot*', 'culer*', 'culo', 'culos',
    'mamon*', 'mamad*', 'mamar', 'cabron*', 'cabrona', 'pinche*', 'joto', 'jotos',
    'marica*', 'maricon*', 'mierd*', 'idiot*', 'imbecil*', 'estupid*', 'baboso*',
    'babosa*', 'naco', 'nacos', 'naca', 'zorra*', 'perra', 'perras', 'gilipollas',
    'hdp', 'hdtpm', 'ptm', 'alv', 'nmms', 'cojer', 'coger', 'cogida', 'pito', 'pitos',
    'mongol', 'mongolo*', 'tarad*', 'mugroso*', 'ojete*',
    'chingadera*', 'malparid*', 'hijueputa', 'hijodeputa', 'carajo', 'joder', 'jodid*',
    'mames', 'pendex', 'pndj', 'vrg', 'verguiza', 'puneta*',
];

// Texto → palabras limpias, sin acentos ni trucos.
function palabrasLimpias(string $texto): array
{
    $t = mb_strtolower($texto, 'UTF-8');
    $t = strtr($t, ['á' => 'a', 'é' => 'e', 'í' => 'i', 'ó' => 'o', 'ú' => 'u', 'ü' => 'u', 'ñ' => 'n',
                    '0' => 'o', '1' => 'i', '3' => 'e', '4' => 'a', '5' => 's', '7' => 't', '@' => 'a', '$' => 's']);
    // "p.e.n.d.e.j.o" o "p e n d e j o": letras sueltas separadas se juntan.
    $t = preg_replace_callback('/\b(?:[a-z][\s._*\-]+){3,}[a-z]\b/', fn($m) => preg_replace('/[\s._*\-]+/', '', $m[0]), $t);
    $t = preg_replace('/[^a-z]+/', ' ', $t);
    $t = preg_replace('/([a-z])\1{2,}/', '$1', $t);          // "pendejoooo" → "pendejo"
    return array_values(array_filter(explode(' ', $t)));
}

// La primera grosería que encuentre, o null.
function buscarGroseria(string $texto): ?string
{
    foreach (palabrasLimpias($texto) as $p) {
        foreach (GROSERIAS as $g) {
            $raiz = rtrim($g, '*');
            if ($g !== $raiz ? str_starts_with($p, $raiz) : $p === $raiz) { return $p; }
        }
    }
    return null;
}

// Corta la petición si el texto trae una grosería.
function exigirSinGroserias(string $texto, string $que): void
{
    if (buscarGroseria($texto) !== null) {
        fallar(400, "$que tiene groserías o insultos, y no se permiten. Quítalos para continuar.");
    }
}
