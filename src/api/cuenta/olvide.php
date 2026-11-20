<?php
// POST api/cuenta/olvide.php   { correo }
// Manda un enlace para poner otra contraseña. Misma respuesta exista o no
// la cuenta, para no revelar quién está registrado.
require __DIR__ . '/../../lib/cuenta.php';

$correo = validarCorreo(leerJson()['correo'] ?? '');

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
