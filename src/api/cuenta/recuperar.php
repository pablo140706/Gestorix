<?php
// POST api/cuenta/recuperar.php   { token, contrasena }  → { usuario }
// Pone la contraseña nueva con el enlace del correo y abre la sesión.
require __DIR__ . '/../../lib/cuenta.php';
require __DIR__ . '/../../lib/limite.php';

$d = leerJson();
limitar('recuperar', ipCliente(), 10, 900);          // 10 por IP cada 15 min
$pass = validarContrasena($d['contrasena'] ?? '');
$id = usarToken((string)($d['token'] ?? ''), 'recuperar');
if ($id === null) { fallar(400, 'Ese enlace ya no sirve. Pide otro desde "Olvidé mi contraseña".'); }

$pdo = db();
$pdo->prepare('UPDATE usuario SET hash = ? WHERE id = ?')->execute([password_hash($pass, PASSWORD_DEFAULT), $id]);
entrarComo($id);

$u = usuarioActual() ?? fallar(403, 'Esta cuenta no puede entrar ahora.');
responder(['usuario' => perfil($u)]);
