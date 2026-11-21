<?php
// POST api/comentarios/reportar.php   { id, motivo, detalle }  → { ok }
// motivo es uno de MOTIVOS_REPORTE; detalle, texto opcional. No se reporta
// un comentario propio, ni dos veces el mismo mientras siga pendiente.
require __DIR__ . '/../../lib/comentarios.php';

$u = exigirQuePuedaComentar();
$d = leerJson();
$pdo = db();

$st = $pdo->prepare("SELECT id, usuario FROM comentario WHERE id = ? AND estado = 'visible'");
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
responder(['ok' => true]);
