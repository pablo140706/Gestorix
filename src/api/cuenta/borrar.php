<?php
// POST api/cuenta/borrar.php   { contrasena }  → borra tu cuenta para siempre
//
// Lo que pasa (aviso de privacidad §5, y las llaves foráneas del esquema):
//   · se borran tu correo, tu contraseña, tu avance, tu horario, tu agenda,
//     tus comentarios y tus enlaces pendientes (ON DELETE CASCADE);
//   · en reportes y bitácora tu nombre se vuelve NULL;
//   · ese correo no se puede volver a registrar en DIAS_SIN_REGISTRO días
//     (tabla correo_borrado, solo con el sha256 del correo).
//
// Pide la contraseña otra vez: así nadie la borra desde una sesión que
// dejaste abierta. Con una suspensión vigente no se puede: si no, bastaría
// con borrar la cuenta y volver a registrarse para salirse de ella.
require __DIR__ . '/../../lib/cuenta.php';

const DIAS_SIN_REGISTRO = 7;

$u = exigirUsuario();
$pass = (string)(leerJson()['contrasena'] ?? '');
if ($u['suspendido_hasta']) {
    fallar(403, "Tu cuenta está suspendida hasta el {$u['suspendido_hasta']}: no puedes borrarla mientras tanto.");
}

$pdo = db();
$st = $pdo->prepare('SELECT hash FROM usuario WHERE id = ?');
$st->execute([$u['id']]);
if (!password_verify($pass, (string)$st->fetchColumn())) {
    usleep(400000);
    fallar(401, 'La contraseña no es correcta.');
}

// Que no se quede la app sin administrador.
if ($u['rol'] === 'admin') {
    $otros = $pdo->prepare("SELECT count(*) FROM usuario WHERE rol = 'admin' AND id <> ?");
    $otros->execute([$u['id']]);
    if ((int)$otros->fetchColumn() === 0) {
        fallar(409, 'Eres el único administrador: nombra a otro antes de borrar tu cuenta.');
    }
}

// Las dos cosas juntas o ninguna.
$pdo->beginTransaction();
$pdo->prepare("INSERT INTO correo_borrado (hash, hasta) VALUES (?, now() + make_interval(days => ?))
               ON CONFLICT (hash) DO UPDATE SET hasta = EXCLUDED.hasta")
    ->execute([hash('sha256', strtolower($u['correo'])), DIAS_SIN_REGISTRO]);
$pdo->prepare('DELETE FROM usuario WHERE id = ?')->execute([$u['id']]);
$pdo->commit();

$_SESSION = [];
session_destroy();
setcookie(session_name(), '', ['expires' => time() - 3600, 'path' => '/', 'httponly' => true, 'samesite' => 'Lax']);
responder(['ok' => true]);
