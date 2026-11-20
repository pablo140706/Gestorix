<?php
// POST api/cuenta/entrar.php   { correo, contrasena }  → { usuario }
require __DIR__ . '/../../lib/cuenta.php';

$d = leerJson();
$correo = strtolower(trim((string)($d['correo'] ?? '')));
$pass = (string)($d['contrasena'] ?? '');

$st = db()->prepare(
    "SELECT id, correo, alias, rol, carrera, hash, verificado, baneado,
            CASE WHEN suspendido_hasta > now()
                 THEN to_char(suspendido_hasta AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') END AS suspendido_hasta
     FROM usuario WHERE correo = ?");
$st->execute([$correo]);
$u = $st->fetch();

if (!$u || !password_verify($pass, $u['hash'])) {
    usleep(400000);   // frena a quien pruebe contraseñas al por mayor
    fallar(401, 'Correo o contraseña incorrectos.');
}
if (!$u['verificado']) {
    fallar(403, 'Primero activa tu cuenta con el enlace que te mandamos por correo.');
}
if ($u['baneado']) {
    fallar(403, 'Esta cuenta fue dada de baja por romper las reglas para comentar.');
}
if ($u['suspendido_hasta']) {
    fallar(403, "Tu cuenta está suspendida hasta el {$u['suspendido_hasta']}.");
}
if (password_needs_rehash($u['hash'], PASSWORD_DEFAULT)) {
    db()->prepare('UPDATE usuario SET hash = ? WHERE id = ?')->execute([password_hash($pass, PASSWORD_DEFAULT), $u['id']]);
}

entrarComo((int)$u['id']);
responder(['usuario' => perfil($u)]);
