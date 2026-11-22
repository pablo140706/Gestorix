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

// ¿Publicar como anónimo? Se muestra un nombre de letras y números al azar
// (10 caracteres; la columna acepta hasta 15) en vez de tu alias. Al editar
// se conserva el que ya tenía; si lo quitas, vuelve a salir tu alias.
$quiereAnonimo = !empty($d['anonimo']);
$anonimoActual = isset($c) ? ($c['anonimo'] ?? null) : null;
$anonimo = $quiereAnonimo ? ($anonimoActual ?: substr(str_replace(['+', '/', '='], '', base64_encode(random_bytes(12))), 0, 10)) : null;

$pdo->beginTransaction();
if (isset($c)) {
    $id = (int)$c['id'];
    $pdo->prepare('UPDATE comentario SET materia = ?, calidad = ?, recomienda = ?, dificultad = ?, texto = ?, anonimo = ?, editado = now()
                   WHERE id = ?')->execute([...$campos, $anonimo, $id]);
} else {
    $st = $pdo->prepare('INSERT INTO comentario (usuario, profesor, materia, calidad, recomienda, dificultad, texto, anonimo)
                         VALUES (?, ?, ?, ?, ?, ?, ?, ?) RETURNING id');
    $st->execute([$u['id'], $profesor, ...$campos, $anonimo]);
    $id = (int)$st->fetchColumn();
}
guardarRubrica($id, $v['rubrica']);
$pdo->commit();

responder(['ok' => true, 'id' => $id]);
