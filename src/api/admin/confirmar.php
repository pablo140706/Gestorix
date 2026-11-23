<?php
// POST api/admin/confirmar.php   { contrasena }  → { ok, minutos }
// Escribir otra vez tu contraseña abre 10 minutos para lo delicado (ver
// correos, cambiar roles o alias ajenos, bajar el respaldo). Solo admin y
// moderadores; 5 intentos fallidos y a esperar 15 minutos.
require __DIR__ . '/../../lib/admin.php';
require __DIR__ . '/../../lib/limite.php';

$u = exigirModerador();
$pass = (string)(leerJson()['contrasena'] ?? '');

exigirBajoLimite('confirmar', (string)$u['id'], 5, 900);
$st = db()->prepare('SELECT hash FROM usuario WHERE id = ?');
$st->execute([$u['id']]);
if (!password_verify($pass, (string)$st->fetchColumn())) {
    anotarIntento('confirmar', (string)$u['id'], 900);
    usleep(400000);
    fallar(401, 'Esa no es tu contraseña.');
}
$_SESSION['confirmado_hasta'] = time() + MINUTOS_CONFIRMADO * 60;
responder(['ok' => true, 'minutos' => MINUTOS_CONFIRMADO]);
