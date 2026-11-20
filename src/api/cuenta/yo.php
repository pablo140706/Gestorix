<?php
// GET api/cuenta/yo.php  → { usuario: { alias, correo, carrera, rol } | null }
require __DIR__ . '/../../lib/cuenta.php';

header('Cache-Control: no-store');   // que el service worker ni el navegador guarden quién eres
$u = usuarioActual();
responder(['usuario' => $u ? perfil($u) : null]);
