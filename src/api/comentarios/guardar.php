<?php
// POST api/comentarios/guardar.php
//   nuevo:   { profesor, materia, calidad, recomienda, dificultad, texto, rubrica: [{ concepto, porcentaje }] }
//   editar:  lo mismo + { id }   (solo el autor, en las primeras 24 h, y si no está oculto)
// → { ok, id }
require __DIR__ . '/../../lib/comentarios.php';

$u = exigirQuePuedaComentar();
$d = leerJson();
$pdo = db();

if (isset($d['id'])) {
    $c = exigirComentarioPropio((int)$d['id'], $u);
    $profesor = (int)$c['profesor'];
} else {
    $profesor = (int)($d['profesor'] ?? 0);
    $st = $pdo->prepare('SELECT 1 FROM profesor WHERE id = ?');
    $st->execute([$profesor]);
    if (!$st->fetch()) { fallar(400, 'No encontramos a ese profesor.'); }
}

$v = leerComentario($d, $profesor);
$campos = [$v['materia'], $v['calidad'], $v['recomienda'] ? 'true' : 'false', $v['dificultad'], $v['texto']];

$pdo->beginTransaction();
if (isset($c)) {
    $id = (int)$c['id'];
    $pdo->prepare('UPDATE comentario SET materia = ?, calidad = ?, recomienda = ?, dificultad = ?, texto = ?, editado = now()
                   WHERE id = ?')->execute([...$campos, $id]);
} else {
    $st = $pdo->prepare('INSERT INTO comentario (usuario, profesor, materia, calidad, recomienda, dificultad, texto)
                         VALUES (?, ?, ?, ?, ?, ?, ?) RETURNING id');
    $st->execute([$u['id'], $profesor, ...$campos]);
    $id = (int)$st->fetchColumn();
}
guardarRubrica($id, $v['rubrica']);
$pdo->commit();

responder(['ok' => true, 'id' => $id]);
