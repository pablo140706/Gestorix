<?php
// POST api/comentarios/reportar.php   { id, motivo, detalle }  → { ok }
// motivo es uno de MOTIVOS_REPORTE; detalle, texto opcional. No se reporta
// un comentario propio, ni dos veces el mismo mientras siga pendiente.
require __DIR__ . '/../../lib/comentarios.php';
require __DIR__ . '/../../lib/correo.php';
require __DIR__ . '/../../lib/limite.php';

$u = exigirQuePuedaComentar();
// Máximo 10 reportes por hora por cuenta: que nadie llene de correos a los moderadores.
exigirBajoLimite('reportar', (string)$u['id'], 10, 3600);
$d = leerJson();
$pdo = db();

$st = $pdo->prepare("SELECT c.id, c.usuario, c.texto, m.carrera, m.nombre AS materia, p.nombre AS profesor
                       FROM comentario c JOIN materia m ON m.clave = c.materia JOIN profesor p ON p.id = c.profesor
                       WHERE c.id = ? AND c.estado = 'visible'");
$st->execute([(int)($d['id'] ?? 0)]);
$c = $st->fetch() ?: fallar(404, 'Ese comentario ya no está.');
if ((int)$c['usuario'] === (int)$u['id']) { fallar(400, 'No puedes reportar tu propio comentario.'); }

$motivo = (string)($d['motivo'] ?? '');
if (!in_array($motivo, MOTIVOS_REPORTE, true)) { fallar(400, 'Elige el motivo del reporte.'); }
$detalle = preg_replace('/\s+/u', ' ', limpiarTexto($d['detalle'] ?? ''));
$texto = $detalle === '' ? $motivo : "$motivo: $detalle";
if (mb_strlen($texto) > 500) { fallar(400, 'El detalle es demasiado largo.'); }

$st = $pdo->prepare("SELECT 1 FROM reporte WHERE comentario = ? AND reportante = ? AND estado = 'pendiente'");
$st->execute([$c['id'], $u['id']]);
if ($st->fetch()) { fallar(409, 'Ya reportaste este comentario; un moderador lo va a revisar.'); }

$pdo->prepare('INSERT INTO reporte (comentario, reportante, motivo) VALUES (?, ?, ?)')
    ->execute([$c['id'], $u['id'], $texto]);
anotarIntento('reportar', (string)$u['id'], 3600);

// Aviso por correo (usuario, 2026-11-22) al admin y a los moderadores de esa
// carrera, solo con el PRIMER reporte pendiente de ese comentario (los demás
// se ven en la pestaña Admin). No lleva el correo ni el alias de nadie.
$st = $pdo->prepare("SELECT count(*) FROM reporte WHERE comentario = ? AND estado = 'pendiente'");
$st->execute([$c['id']]);
if ((int)$st->fetchColumn() === 1) {
    $st = $pdo->prepare("SELECT correo FROM usuario u WHERE verificado AND NOT baneado
                           AND (rol = 'admin' OR (rol = 'moderador' AND EXISTS (
                                SELECT 1 FROM moderador_carrera mc WHERE mc.usuario = u.id AND mc.carrera = ?)))");
    $st->execute([$c['carrera']]);
    $extracto = mb_strlen($c['texto']) > 200 ? mb_substr($c['texto'], 0, 200) . '…' : $c['texto'];
    foreach ($st->fetchAll(PDO::FETCH_COLUMN) as $para) {
        enviarCorreo($para, "Nuevo reporte en Gestorix ({$c['carrera']})",
            "Reportaron un comentario sobre {$c['profesor']} ({$c['materia']}).\n\n"
          . "Motivo: $texto\n\nComentario:\n$extracto\n\n"
          . 'Revísalo en la pestaña Admin: ' . urlApp('?admin=reportes'));
    }
}
responder(['ok' => true]);
