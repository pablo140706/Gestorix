<?php
// POST api/admin/probar-correo.php   {}  → { ok, enviado, configurado, para }
// Manda un correo de prueba a TU correo (el del admin) para saber si Gmail
// sigue funcionando. Si no sale, el texto queda en docker compose logs web.
require __DIR__ . '/../../lib/admin.php';
require __DIR__ . '/../../lib/limite.php';

$u = exigirAdmin();
leerJson();
exigirBajoLimite('probar-correo', (string)$u['id'], 5, 3600);
anotarIntento('probar-correo', (string)$u['id'], 3600);

$enviado = enviarCorreo($u['correo'], 'Prueba de correo de Gestorix',
    "Si lees esto, el correo de Gestorix funciona.\n\nEnviado desde la pestaña Admin el "
    . (new DateTime('now', new DateTimeZone('America/Mexico_City')))->format('d/m/Y H:i') . '.');
anotarBitacora((int)$u['id'], 'probar_correo', null, null, $enviado ? 'Enviado' : 'No salió (ver docker compose logs web)');
responder(['ok' => true, 'enviado' => $enviado, 'configurado' => correoConfigurado(), 'para' => $u['correo']]);
