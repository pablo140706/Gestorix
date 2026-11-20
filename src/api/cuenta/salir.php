<?php
// POST api/cuenta/salir.php   {}  → cierra la sesión
require __DIR__ . '/../../lib/cuenta.php';

leerJson();
iniciarSesion();
$_SESSION = [];
session_destroy();
setcookie(session_name(), '', ['expires' => time() - 3600, 'path' => '/', 'httponly' => true, 'samesite' => 'Lax']);
responder(['ok' => true]);
