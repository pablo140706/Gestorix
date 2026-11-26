<?php
// POST api/comentarios/borrar.php
//   { id }          → borra ese comentario (con su rúbrica, sus reportes
//                     y sus respuestas: todo va con ON DELETE CASCADE)
//   { respuesta }   → borra esa respuesta
// → { ok }
// Solo quien lo escribió, en las primeras 24 h, y si un moderador no lo ocultó.
require __DIR__ . '/../../lib/comentarios.php';

$u = exigirUsuario();
$d = leerJson();

if (isset($d['respuesta'])) {
    $r = exigirRespuestaPropia((int)$d['respuesta'], $u);
    db()->prepare('DELETE FROM respuesta WHERE id = ?')->execute([$r['id']]);
} else {
    $c = exigirComentarioPropio((int)($d['id'] ?? 0), $u);
    db()->prepare('DELETE FROM comentario WHERE id = ?')->execute([$c['id']]);
}
responder(['ok' => true]);
