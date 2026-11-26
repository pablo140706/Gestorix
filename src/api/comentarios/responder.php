<?php
// POST api/comentarios/responder.php
//   nueva:   { comentario, texto, anonimo? }
//   editar:  { id, texto, anonimo? }   (solo la autora, en las primeras 24 h)
// → { ok, id }
// =====================================================================
//  Responder a un comentario: SOLO TEXTO (usuario, 2026-11-26).
// =====================================================================
//  No lleva calidad, dificultad ni recomienda, así que no toca ninguna
//  métrica del profesor. Un solo nivel: se responde al comentario, nunca
//  a otra respuesta. La materia se hereda del padre y no se pregunta.
//
//  Quién: cualquiera con cuenta activa y sin suspensión, igual que para
//  comentar. Se puede responder al propio comentario (sirve para
//  corregirse sin tocar lo que ya leyeron otros).
//
//  Tope: 10 respuestas al día por cuenta, para que una discusión no se
//  convierta en un muro.
require __DIR__ . '/../../lib/comentarios.php';
require __DIR__ . '/../../lib/limite.php';

const RESPUESTAS_POR_DIA = 10;

$u = exigirQuePuedaComentar();
$d = leerJson();
$pdo = db();

$texto = leerRespuesta($d);

// Editar la propia, o responder a un comentario que siga visible.
$r = null;
if (isset($d['id'])) {
    $r = exigirRespuestaPropia((int)$d['id'], $u);
} else {
    $padre = exigirComentarioAbierto((int)($d['comentario'] ?? 0));
    exigirBajoLimite('responder', (string)$u['id'], RESPUESTAS_POR_DIA, 86400);
}

// ¿Publicar como anónimo? Mismo nombre al azar que en los comentarios. Al
// editar se conserva el que ya tenía; si lo quitas, vuelve a salir tu alias.
$quiereAnonimo = !empty($d['anonimo']);
$anonimoActual = $r['anonimo'] ?? null;
$anonimo = $quiereAnonimo
    ? ($anonimoActual ?: substr(str_replace(['+', '/', '='], '', base64_encode(random_bytes(12))), 0, 10))
    : null;

if ($r !== null) {
    $pdo->prepare('UPDATE respuesta SET texto = ?, anonimo = ?, editado = now() WHERE id = ?')
        ->execute([$texto, $anonimo, $r['id']]);
    $id = (int)$r['id'];
} else {
    $st = $pdo->prepare('INSERT INTO respuesta (comentario, usuario, texto, anonimo) VALUES (?, ?, ?, ?) RETURNING id');
    $st->execute([$padre['id'], $u['id'], $texto, $anonimo]);
    $id = (int)$st->fetchColumn();
    anotarIntento('responder', (string)$u['id'], 86400);
}

responder(['ok' => true, 'id' => $id]);
