<?php
// POST api/comentarios/borrar.php   { id }  → { ok }
// Solo el autor, en las primeras 24 h, y si un moderador no lo ocultó.
// La rúbrica y los reportes se van con él (ON DELETE CASCADE).
require __DIR__ . '/../../lib/comentarios.php';

$u = exigirUsuario();
$c = exigirComentarioPropio((int)(leerJson()['id'] ?? 0), $u);
db()->prepare('DELETE FROM comentario WHERE id = ?')->execute([$c['id']]);
responder(['ok' => true]);
