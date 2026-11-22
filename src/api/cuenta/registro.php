<?php
// POST api/cuenta/registro.php   { correo, contrasena, carrera }
// Crea la cuenta (sin activar) y manda el enlace de verificación.
//
// La respuesta es la misma exista o no el correo: así nadie puede usar
// este formulario para averiguar quién tiene cuenta.
require __DIR__ . '/../../lib/cuenta.php';
require __DIR__ . '/../../lib/limite.php';

$d = leerJson();
limitar('registro', ipCliente(), 5, 3600);          // 5 registros por hora por IP
$correo = validarCorreo($d['correo'] ?? '');
$pass = validarContrasena($d['contrasena'] ?? '');
$carrera = (string)($d['carrera'] ?? '');

$pdo = db();
$st = $pdo->prepare('SELECT 1 FROM carrera WHERE codigo = ?');
$st->execute([$carrera]);
if (!$st->fetch()) { fallar(400, 'Elige tu carrera.'); }

$st = $pdo->prepare('SELECT id, verificado FROM usuario WHERE correo = ?');
$st->execute([$correo]);
$u = $st->fetch();

// ¿Ese correo borró su cuenta hace poco? (api/cuenta/borrar.php)
$st = $pdo->prepare("SELECT to_char(hasta AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI')
                     FROM correo_borrado WHERE hash = ? AND hasta > now()");
$st->execute([hash('sha256', $correo)]);
$bloqueadoHasta = $st->fetchColumn();

if ($bloqueadoHasta !== false) {
    // Se avisa por correo y no en pantalla, como los demás casos: así el
    // formulario no revela qué correos tuvieron cuenta.
    enviarCorreo($correo, 'No se pudo crear tu cuenta de Gestorix',
        "¡Hola!\n\nAlguien intentó crear una cuenta con este correo, pero una cuenta con él se borró hace poco.\n"
      . "Podrás registrarlo otra vez a partir del $bloqueadoHasta.\n\n"
      . "Si no fuiste tú, ignora este correo.");
} elseif (!$u) {
    $st = $pdo->prepare('INSERT INTO usuario (correo, hash, alias, carrera) VALUES (?, ?, ?, ?) RETURNING id');
    $st->execute([$correo, password_hash($pass, PASSWORD_DEFAULT), aliasAlAzar(), $carrera]);
    mandarVerificacion((int)$st->fetchColumn(), $correo);
} elseif (!$u['verificado']) {
    // Se registró antes y nunca activó: se toman la contraseña y la carrera
    // nuevas y se manda otro enlace.
    $pdo->prepare('UPDATE usuario SET hash = ?, carrera = ? WHERE id = ?')
        ->execute([password_hash($pass, PASSWORD_DEFAULT), $carrera, $u['id']]);
    mandarVerificacion((int)$u['id'], $correo);
} else {
    enviarCorreo($correo, 'Ya tienes cuenta en Gestorix',
        "¡Hola!\n\nAlguien intentó crear una cuenta con este correo, pero ya tienes una.\n"
      . "Si olvidaste tu contraseña, pide una nueva desde \"Olvidé mi contraseña\" en " . urlApp() . "\n\n"
      . "Si no fuiste tú, ignora este correo.");
}

responder(['ok' => true, 'mensaje' => "Listo. Te mandamos un correo a $correo con el enlace para activar tu cuenta."]);
