<?php
// POST api/cuenta/entrar.php   { correo, contrasena }  → { usuario }
require __DIR__ . '/../../lib/cuenta.php';
require __DIR__ . '/../../lib/limite.php';

$d = leerJson();
$correo = strtolower(trim((string)($d['correo'] ?? '')));
$pass = (string)($d['contrasena'] ?? '');

// Solo cuentan los intentos FALLIDOS: 5 por correo (usuario, 2026-11-22) y 20 por IP,
// y luego hay que esperar 15 minutos.
const VENTANA_ENTRAR = 900;
$ip = ipCliente();
exigirBajoLimite('entrar-ip', $ip, 20, VENTANA_ENTRAR);
exigirBajoLimite('entrar-correo', $correo, 5, VENTANA_ENTRAR);

$st = db()->prepare(
    'SELECT id, correo, alias, alias_cambios, rol, carrera, hash, verificado, baneado, ' . SQL_SUSPENDIDO_HASTA . ' AS suspendido_hasta
     FROM usuario WHERE correo = ?');
$st->execute([$correo]);
$u = $st->fetch();

if (!$u || !password_verify($pass, $u['hash'])) {
    anotarIntento('entrar-ip', $ip, VENTANA_ENTRAR);
    anotarIntento('entrar-correo', $correo, VENTANA_ENTRAR);
    usleep(400000);   // frena a quien pruebe contraseñas al por mayor
    fallar(401, 'Correo o contraseña incorrectos.');
}
if (!$u['verificado']) {
    fallar(403, 'Primero activa tu cuenta con el enlace que te mandamos por correo.');
}
if ($u['baneado']) {
    fallar(403, 'Esta cuenta fue dada de baja por romper las reglas para comentar.');
}
// Suspendido sí entra (ve y guarda su avance); solo no puede comentar.
if (password_needs_rehash($u['hash'], PASSWORD_DEFAULT)) {
    db()->prepare('UPDATE usuario SET hash = ? WHERE id = ?')->execute([password_hash($pass, PASSWORD_DEFAULT), $u['id']]);
}

entrarComo((int)$u['id']);
responder(['usuario' => perfil($u)]);
