<?php
// POST api/cuenta/olvide.php   { correo }
// Manda un enlace para poner otra contraseña. Misma respuesta exista o no
// la cuenta, para no revelar quién está registrado.
require __DIR__ . '/../../lib/cuenta.php';
require __DIR__ . '/../../lib/limite.php';

$d = leerJson();
limitar('olvide-ip', ipCliente(), 5, 3600);          // 5 por hora por IP
$correo = validarCorreo($d['correo'] ?? '');
limitar('olvide-correo', $correo, 3, 3600);         // 3 correos por hora a la misma cuenta

$st = db()->prepare('SELECT id FROM usuario WHERE correo = ? AND verificado AND NOT baneado');
$st->execute([$correo]);
$id = $st->fetchColumn();
if ($id !== false) {
    $enlace = urlApp('?recuperar=' . crearToken((int)$id, 'recuperar', '1 hour'));
    enviarCorreo($correo, 'Nueva contraseña para Gestorix',
        "¡Hola!\n\nPara poner una contraseña nueva abre este enlace (sirve 1 hora):\n\n$enlace\n\n"
      . "Si tú no lo pediste, ignora este correo: tu contraseña no cambia.");
}

responder(['ok' => true, 'mensaje' => "Si $correo tiene cuenta, le llegará un enlace para poner una contraseña nueva."]);
