<?php
// POST api/admin/usuario.php   → { ok, mensaje }
//   { accion: "rol",   usuario, rol: "alumno" | "moderador", carreras: ["ISC", …], motivo }
//   { accion: "alias", usuario, alias, motivo }
// SOLO EL ADMIN, con la contraseña confirmada. Todo queda en la bitácora.
//  · rol: nombra o quita moderadores y elige qué carreras moderan. Desde
//    aquí no se nombran admins (eso, en pgAdmin) ni se toca a otro admin.
//  · alias: cambia un alias ofensivo. No cuenta para los 3 cambios al año
//    del alumno, y respeta las mismas reglas (único, sin groserías).
require __DIR__ . '/../../lib/admin.php';

$admin = exigirAdmin();
exigirConfirmado();
$d = leerJson();
$pdo = db();
$accion = (string)($d['accion'] ?? '');
if (!in_array($accion, ['rol', 'alias'], true)) { fallar(400, 'Acción desconocida.'); }
$motivo = leerMotivo($d);

$st = $pdo->prepare('SELECT id, alias, rol, carrera, verificado FROM usuario WHERE id = ?');
$st->execute([(int)($d['usuario'] ?? 0)]);
$obj = $st->fetch() ?: fallar(404, 'Esa cuenta ya no existe.');
$oid = (int)$obj['id'];
if ($obj['rol'] === 'admin') { fallar(403, 'A un administrador no se le cambia nada desde aquí.'); }

if ($accion === 'alias') {
    $nuevo = validarAlias($d['alias'] ?? '');
    if ($nuevo === $obj['alias']) { fallar(400, 'Es el mismo alias.'); }
    cambiarAlias($oid, $obj['alias'], $nuevo, (int)$admin['id']);
    anotarBitacora((int)$admin['id'], 'cambiar_alias', $oid, null, "«{$obj['alias']}» → «{$nuevo}»: $motivo");
    responder(['ok' => true, 'mensaje' => "Listo: «{$obj['alias']}» ahora es «{$nuevo}»."]);
    exit;
}

// ---------- rol y carreras ----------
$rol = (string)($d['rol'] ?? '');
if (!in_array($rol, ['alumno', 'moderador'], true)) { fallar(400, 'El rol es alumno o moderador.'); }
$validas = $pdo->query('SELECT codigo FROM carrera')->fetchAll(PDO::FETCH_COLUMN);
$carreras = array_values(array_unique(array_filter((array)($d['carreras'] ?? []), fn($c) => in_array($c, $validas, true))));
if ($rol === 'moderador') {
    if (!$obj['verificado']) { fallar(400, 'Esa cuenta no está activada.'); }
    if (!$carreras) { fallar(400, 'Elige al menos una carrera para que modere.'); }
}

$pdo->beginTransaction();
$pdo->prepare('UPDATE usuario SET rol = ? WHERE id = ?')->execute([$rol, $oid]);
$pdo->prepare('DELETE FROM moderador_carrera WHERE usuario = ?')->execute([$oid]);
$ins = $pdo->prepare('INSERT INTO moderador_carrera (usuario, carrera) VALUES (?, ?)');
foreach ($rol === 'moderador' ? $carreras : [] as $c) { $ins->execute([$oid, $c]); }
$lista = implode(', ', $carreras);
if ($rol === 'moderador' && $obj['rol'] !== 'moderador') {
    anotarBitacora((int)$admin['id'], 'nombrar_moderador', $oid, null, "$motivo (modera: $lista)");
    $mensaje = "«{$obj['alias']}» ahora es moderador de $lista.";
} elseif ($rol === 'moderador') {
    anotarBitacora((int)$admin['id'], 'carreras_moderador', $oid, null, "$motivo (modera: $lista)");
    $mensaje = "«{$obj['alias']}» ahora modera $lista.";
} elseif ($obj['rol'] === 'moderador') {
    anotarBitacora((int)$admin['id'], 'quitar_moderador', $oid, null, $motivo);
    $mensaje = "«{$obj['alias']}» ya no es moderador.";
} else {
    $mensaje = "«{$obj['alias']}» ya era alumno.";
}
$pdo->commit();
responder(['ok' => true, 'mensaje' => $mensaje]);
