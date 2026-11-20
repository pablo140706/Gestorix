<?php
// =====================================================================
//  api/mis-datos.php: el avance y el horario del usuario con sesión.
// =====================================================================
//  GET  → { carrera, avance: [{ materia, veces, calif, calif_ets }], horario: [id de oferta…] }
//  POST   { avance: [...], horario: [...] }  → guarda TODO (reemplaza lo anterior)
//
//  El front manda el estado completo cada vez que cambia algo (unos pocos
//  KB), así no hay que llevar la cuenta de qué cambió. El horario es solo
//  del periodo vigente. Las reglas de la tabla avance (veces 1–2, ETS solo
//  si reprobaste) las vuelve a revisar la base con sus CHECK.
// =====================================================================

require __DIR__ . '/../lib/sesion.php';

header('Cache-Control: no-store');
$u = exigirUsuario();
$pdo = db();
$vigente = periodoVigente();

if (($_SERVER['REQUEST_METHOD'] ?? '') === 'GET') {
    $st = $pdo->prepare('SELECT materia, veces, calif, calif_ets FROM avance WHERE usuario = ? ORDER BY materia');
    $st->execute([$u['id']]);
    $avance = array_map(fn($r) => [
        'materia' => $r['materia'], 'veces' => (int)$r['veces'],
        'calif' => $r['calif'] === null ? null : (int)$r['calif'],
        'calif_ets' => $r['calif_ets'] === null ? null : (int)$r['calif_ets'],
    ], $st->fetchAll());

    $st = $pdo->prepare('SELECT h.oferta FROM horario h JOIN oferta o ON o.id = h.oferta WHERE h.usuario = ? AND o.periodo = ? ORDER BY h.oferta');
    $st->execute([$u['id'], $vigente]);
    responder(['carrera' => $u['carrera'], 'avance' => $avance, 'horario' => array_map('intval', $st->fetchAll(PDO::FETCH_COLUMN))]);
    exit;
}

$d = leerJson();
$avance = $d['avance'] ?? null;
$horario = $d['horario'] ?? null;
if (!is_array($avance) || !is_array($horario) || count($avance) > 300 || count($horario) > 40) {
    fallar(400, 'Datos incompletos.');
}

// Solo materias de la carrera del usuario (la carrera queda fija al registrarse).
$st = $pdo->prepare('SELECT clave FROM materia WHERE carrera = ?');
$st->execute([$u['carrera']]);
$suyas = array_flip($st->fetchAll(PDO::FETCH_COLUMN));

$entero = function ($v): ?int {
    if ($v === null || $v === '') { return null; }
    if (!is_numeric($v) || (int)$v != $v || $v < 0 || $v > 10) { fallar(400, 'Las calificaciones son enteros de 0 a 10.'); }
    return (int)$v;
};
$filas = [];
foreach ($avance as $a) {
    $clave = (string)($a['materia'] ?? '');
    if (!isset($suyas[$clave])) { fallar(400, "La materia $clave no es de tu carrera."); }
    $veces = (int)($a['veces'] ?? 1);
    if ($veces !== 1 && $veces !== 2) { fallar(400, 'Una materia se cursa 1 o 2 veces.'); }
    $calif = $entero($a['calif'] ?? null);
    $ets = $entero($a['calif_ets'] ?? null);
    if ($ets !== null && ($calif === null || $calif >= 6)) { $ets = null; }   // solo hay ETS si reprobaste
    $filas[$clave] = [$u['id'], $clave, $veces, $calif, $ets];
}

$ids = array_values(array_unique(array_map('intval', $horario)));
if ($ids) {
    $st = $pdo->prepare('SELECT count(*) FROM oferta WHERE periodo = ? AND id = ANY (?::int[])');
    $st->execute([$vigente, '{' . implode(',', $ids) . '}']);
    if ((int)$st->fetchColumn() !== count($ids)) { fallar(400, 'Tu horario trae ofertas que ya no existen. Recarga la página.'); }
}

$pdo->beginTransaction();
$pdo->prepare('DELETE FROM avance WHERE usuario = ?')->execute([$u['id']]);
$ins = $pdo->prepare('INSERT INTO avance (usuario, materia, veces, calif, calif_ets) VALUES (?, ?, ?, ?, ?)');
foreach ($filas as $f) { $ins->execute($f); }
$pdo->prepare('DELETE FROM horario WHERE usuario = ? AND oferta IN (SELECT id FROM oferta WHERE periodo = ?)')->execute([$u['id'], $vigente]);
$ins = $pdo->prepare('INSERT INTO horario (usuario, oferta) VALUES (?, ?)');
foreach ($ids as $id) { $ins->execute([$u['id'], $id]); }
$pdo->commit();

responder(['ok' => true, 'avance' => count($filas), 'horario' => count($ids)]);
