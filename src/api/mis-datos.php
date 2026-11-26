<?php
// =====================================================================
//  api/mis-datos.php: el avance y el horario del usuario con sesión.
// =====================================================================
//  GET  → { carrera, ingreso, avance: [{ materia, veces, calif, calif_ets, resultado, resultado_ets, proyecto_en_curso }],
//           horario: [id de oferta…] }
//  POST   { avance: [...], horario: [...], ingreso? }  → guarda TODO (reemplaza lo anterior)
//
//  resultado ('aprobada'/'reprobada') y resultado_ets ('aprobado'/'reprobado')
//  son para quien no quiere dar el número: solo valen si la calificación va
//  vacía. ingreso es el periodo en que entraste ("25/1"); si no viene, no se
//  toca y se revisa contra el que ya estaba guardado: un periodo_reprobada
//  anterior al ingreso se rechaza con 400 (no estabas inscrito).
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
    $st = $pdo->prepare('SELECT materia, veces, calif, calif_ets, resultado, resultado_ets, periodo_reprobada, proyecto_en_curso FROM avance WHERE usuario = ? ORDER BY materia');
    $st->execute([$u['id']]);
    $avance = array_map(fn($r) => [
        'materia' => $r['materia'], 'veces' => (int)$r['veces'],
        'calif' => $r['calif'] === null ? null : (int)$r['calif'],
        'calif_ets' => $r['calif_ets'] === null ? null : (int)$r['calif_ets'],
        'resultado' => $r['resultado'], 'resultado_ets' => $r['resultado_ets'],
        'periodo_reprobada' => $r['periodo_reprobada'],
        'proyecto_en_curso' => (bool)$r['proyecto_en_curso'],
    ], $st->fetchAll());

    $st = $pdo->prepare('SELECT ingreso FROM usuario WHERE id = ?');
    $st->execute([$u['id']]);
    $ingreso = $st->fetchColumn() ?: null;

    $st = $pdo->prepare('SELECT h.oferta FROM horario h JOIN oferta o ON o.id = h.oferta WHERE h.usuario = ? AND o.periodo = ? ORDER BY h.oferta');
    $st->execute([$u['id'], $vigente]);
    responder(['carrera' => $u['carrera'], 'ingreso' => $ingreso, 'avance' => $avance,
               'horario' => array_map('intval', $st->fetchAll(PDO::FETCH_COLUMN))]);
    exit;
}

$d = leerJson();
$avance = $d['avance'] ?? null;
$horario = $d['horario'] ?? null;
if (!is_array($avance) || !is_array($horario) || count($avance) > 300 || count($horario) > 40) {
    fallar(400, 'Datos incompletos.');
}

// Solo materias de la carrera del usuario (la carrera queda fija al registrarse).
$st = $pdo->prepare('SELECT clave, sin_clase FROM materia WHERE carrera = ?');
$st->execute([$u['carrera']]);
$suyas = [];   // clave → ¿es proyecto sin clase? (TT I, TT II, Estancia)
foreach ($st as $m) { $suyas[$m['clave']] = (bool)$m['sin_clase']; }

// Periodo de ingreso: "AA/1" o "AA/2". Si no viene en el JSON, no se toca y
// para revisar los periodos vale el que ya esté guardado.
$cambiaIngreso = array_key_exists('ingreso', $d);
$ingreso = $d['ingreso'] ?? null;
if ($ingreso !== null && (!is_string($ingreso) || !preg_match('#^\d{2}/[12]$#', $ingreso))) {
    fallar(400, 'El periodo de ingreso se escribe como 25/1.');
}
if (!$cambiaIngreso) {
    $st = $pdo->prepare('SELECT ingreso FROM usuario WHERE id = ?');
    $st->execute([$u['id']]);
    $ingreso = $st->fetchColumn() ?: null;
}
// "26/1" → 52, para comparar periodos (igual que perANum() del navegador).
$perNum = function (?string $p): ?int {
    return $p !== null && preg_match('#^(\d{2})/([12])$#', $p, $m) ? (int)$m[1] * 2 + (int)$m[2] - 1 : null;
};
$numIngreso = $perNum($ingreso);

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
    // Resultado sin número: solo si no hay número (si lo hay, el número manda).
    $res = in_array($a['resultado'] ?? null, ['aprobada', 'reprobada'], true) && $calif === null ? $a['resultado'] : null;
    $resEts = in_array($a['resultado_ets'] ?? null, ['aprobado', 'reprobado'], true) && $ets === null ? $a['resultado_ets'] : null;
    // Solo hay ETS si reprobaste el curso.
    $reprobo = ($calif !== null && $calif < 6) || $res === 'reprobada';
    // Periodo en que la reprobaste ("26/1"), para el aviso de desfase.
    $perRep = $a['periodo_reprobada'] ?? null;
    if ($perRep !== null && (!is_string($perRep) || !preg_match('#^\d{2}/[12]$#', $perRep))) { $perRep = null; }
    if (!$reprobo) { $ets = null; $resEts = null; $perRep = null; }
    // No pudiste reprobar antes de entrar a la Escuela (usuario, 2026-11-25).
    if ($perRep !== null && $numIngreso !== null && $perNum($perRep) < $numIngreso) {
        fallar(400, "En $perRep todavía no estabas inscrito: entraste en $ingreso.");
    }
    // "Lo estoy llevando" de un proyecto (TT I, TT II, Estancia): solo vale en
    // las materias sin clase y mientras no esté acreditada (usuario, 2026-11-25).
    $aprobada = ($calif !== null && $calif >= 6) || $res === 'aprobada'
                || ($ets !== null && $ets >= 6) || $resEts === 'aprobado';
    $proy = $suyas[$clave] && !$aprobada && !empty($a['proyecto_en_curso']);
    $filas[$clave] = [$u['id'], $clave, $veces, $calif, $ets, $res, $resEts, $perRep, $proy];
}

$ids = array_values(array_unique(array_map('intval', $horario)));
if ($ids) {
    $st = $pdo->prepare('SELECT count(*) FROM oferta WHERE periodo = ? AND id = ANY (?::int[])');
    $st->execute([$vigente, '{' . implode(',', $ids) . '}']);
    if ((int)$st->fetchColumn() !== count($ids)) { fallar(400, 'Tu horario trae ofertas que ya no existen. Recarga la página.'); }
}

$pdo->beginTransaction();
$pdo->prepare('DELETE FROM avance WHERE usuario = ?')->execute([$u['id']]);
$ins = $pdo->prepare('INSERT INTO avance (usuario, materia, veces, calif, calif_ets, resultado, resultado_ets, periodo_reprobada, proyecto_en_curso)
                      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)');
foreach ($filas as $f) { $ins->execute($f); }
if ($cambiaIngreso) {
    $pdo->prepare('UPDATE usuario SET ingreso = ? WHERE id = ?')->execute([$ingreso, $u['id']]);
}
$pdo->prepare('DELETE FROM horario WHERE usuario = ? AND oferta IN (SELECT id FROM oferta WHERE periodo = ?)')->execute([$u['id'], $vigente]);
$ins = $pdo->prepare('INSERT INTO horario (usuario, oferta) VALUES (?, ?)');
foreach ($ids as $id) { $ins->execute([$u['id'], $id]); }
$pdo->commit();

responder(['ok' => true, 'avance' => count($filas), 'horario' => count($ids)]);
