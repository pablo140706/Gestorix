<?php
// POST api/cuenta/borrar.php   { contrasena }  → borra tu cuenta para siempre
//
// Lo que pasa (aviso de privacidad §5, y las llaves foráneas del esquema):
//   · se borran tu correo, tu contraseña, tu avance, tu horario, tu agenda
//     y tus enlaces pendientes (ON DELETE CASCADE);
//   · tus comentarios se quedan publicados como "usuario eliminado"
//     (comentario.usuario = NULL), sin forma de ligarlos a ti;
//   · en reportes y bitácora tu nombre se vuelve NULL.
//
// Pide la contraseña otra vez: así nadie la borra desde una sesión que
// dejaste abierta.
require __DIR__ . '/../../lib/cuenta.php';

$u = exigirUsuario();
$pass = (string)(leerJson()['contrasena'] ?? '');

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

$pdo->prepare('DELETE FROM usuario WHERE id = ?')->execute([$u['id']]);

$_SESSION = [];
session_destroy();
setcookie(session_name(), '', ['expires' => time() - 3600, 'path' => '/', 'httponly' => true, 'samesite' => 'Lax']);
responder(['ok' => true]);
