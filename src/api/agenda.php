<?php
// =====================================================================
//  api/agenda.php: los recordatorios del usuario con sesión (Fase 5).
// =====================================================================
//  GET  → { recordatorios: [{ id, fecha: "2026-11-12", hora: "10:00" | null,
//                              titulo, materia: { clave, nombre } | null, nota }] }
//  POST { accion: "guardar", id?, fecha, hora, titulo, materia, nota } → { ok, id }
//  POST { accion: "borrar", id }                                       → { ok }
//
//  Decisiones del usuario (CLAUDE.md §7, 2026-11-20): solo con cuenta;
//  solo los ve su dueño; solo se muestran en el calendario (no mandan
//  avisos); la hora es opcional (sin hora = todo el día); los pasados se
//  quedan (la app los pinta en gris) hasta que los borres.
//  Un suspendido sí puede usar su agenda: la suspensión es solo para comentar.
// =====================================================================

require __DIR__ . '/../lib/sesion.php';

const MAX_RECORDATORIOS = 1000;

header('Cache-Control: no-store');
$u = exigirUsuario();
$pdo = db();

if (($_SERVER['REQUEST_METHOD'] ?? '') === 'GET') {
    $st = $pdo->prepare(
        "SELECT r.id, to_char(r.fecha, 'YYYY-MM-DD') AS fecha, to_char(r.hora, 'HH24:MI') AS hora,
                r.titulo, r.materia, m.nombre AS materia_nombre, r.nota
         FROM recordatorio r LEFT JOIN materia m ON m.clave = r.materia
         WHERE r.usuario = ?
         ORDER BY r.fecha, r.hora NULLS FIRST, r.id");
    $st->execute([$u['id']]);
    responder(['recordatorios' => array_map(fn($r) => [
        'id'      => (int)$r['id'],
        'fecha'   => $r['fecha'],
        'hora'    => $r['hora'],
        'titulo'  => $r['titulo'],
        'materia' => $r['materia'] === null ? null : ['clave' => $r['materia'], 'nombre' => $r['materia_nombre']],
        'nota'    => $r['nota'],
    ], $st->fetchAll())]);
    exit;
}

$d = leerJson();
$accion = (string)($d['accion'] ?? '');

if ($accion === 'borrar') {
    $st = $pdo->prepare('DELETE FROM recordatorio WHERE id = ? AND usuario = ?');
    $st->execute([(int)($d['id'] ?? 0), $u['id']]);
    if ($st->rowCount() === 0) { fallar(404, 'Ese recordatorio no existe.'); }
    responder(['ok' => true]);
    exit;
}
if ($accion !== 'guardar') { fallar(400, 'Acción desconocida.'); }

// --- validar ---
$fecha = (string)($d['fecha'] ?? '');
if (!preg_match('/^(\d{4})-(\d{2})-(\d{2})$/', $fecha, $f) || !checkdate((int)$f[2], (int)$f[3], (int)$f[1])
    || $f[1] < 2020 || $f[1] > 2040) {
    fallar(400, 'Elige una fecha válida.');
}
$hora = trim((string)($d['hora'] ?? ''));
if ($hora === '') { $hora = null; }
elseif (!preg_match('/^([01]\d|2[0-3]):[0-5]\d$/', $hora)) { fallar(400, 'La hora va como 10:00 (o déjala vacía: todo el día).'); }

$limpiar = fn($s) => trim(preg_replace('/[^\P{C}\n]/u', '', str_replace("\r\n", "\n", (string)$s)));
$titulo = preg_replace('/\s+/u', ' ', $limpiar($d['titulo'] ?? ''));
if ($titulo === '') { fallar(400, 'Escribe un título ("Examen de Bases de Datos").'); }
if (mb_strlen($titulo) > 100) { fallar(400, 'El título es de máximo 100 caracteres.'); }
$nota = $limpiar($d['nota'] ?? '');
if (mb_strlen($nota) > 500) { fallar(400, 'La nota es de máximo 500 caracteres.'); }
$nota = $nota === '' ? null : $nota;

$materia = (string)($d['materia'] ?? '');
if ($materia === '') { $materia = null; }
else {
    $st = $pdo->prepare('SELECT 1 FROM materia WHERE clave = ? AND carrera = ?');
    $st->execute([$materia, $u['carrera']]);
    if (!$st->fetch()) { fallar(400, 'Esa materia no es de tu carrera.'); }
}

// --- guardar ---
if (isset($d['id'])) {
    $st = $pdo->prepare('UPDATE recordatorio SET fecha = ?, hora = ?, titulo = ?, materia = ?, nota = ? WHERE id = ? AND usuario = ?');
    $st->execute([$fecha, $hora, $titulo, $materia, $nota, (int)$d['id'], $u['id']]);
    if ($st->rowCount() === 0) { fallar(404, 'Ese recordatorio no existe.'); }
    responder(['ok' => true, 'id' => (int)$d['id']]);
    exit;
}

$st = $pdo->prepare('SELECT count(*) FROM recordatorio WHERE usuario = ?');
$st->execute([$u['id']]);
if ((int)$st->fetchColumn() >= MAX_RECORDATORIOS) {
    fallar(400, 'Ya tienes ' . MAX_RECORDATORIOS . ' recordatorios: borra algunos viejos para agregar más.');
}
$st = $pdo->prepare('INSERT INTO recordatorio (usuario, fecha, hora, titulo, materia, nota) VALUES (?, ?, ?, ?, ?, ?) RETURNING id');
$st->execute([$u['id'], $fecha, $hora, $titulo, $materia, $nota]);
responder(['ok' => true, 'id' => (int)$st->fetchColumn()]);
