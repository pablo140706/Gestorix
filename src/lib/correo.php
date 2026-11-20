<?php
// =====================================================================
//  Envío de correos (verificación de cuenta y "olvidé mi contraseña").
// =====================================================================
//  Todavía no hay servicio de correo (decisión del usuario, 2026-11-08):
//  mientras SMTP_HOST esté vacío en el .env, el correo NO se manda; su
//  texto completo, con el enlace, sale en el log del contenedor:
//
//      docker compose logs web
//
//  Cuando se elija el servicio (Brevo o una contraseña de aplicación de
//  Gmail), aquí se agrega el envío por SMTP y solo se llena el .env.
// =====================================================================

function enviarCorreo(string $para, string $asunto, string $texto): void
{
    if (getenv('SMTP_HOST') ?: '') {
        // Pendiente: envío real por SMTP (Fase 6, cuando se elija el servicio).
        error_log("CORREO sin enviar: SMTP_HOST está configurado pero el envío por SMTP aún no está escrito.");
    }
    $sep = str_repeat('=', 60);
    error_log("\n$sep\nCORREO (no se manda; servicio pendiente)\nPara:   $para\nAsunto: $asunto\n\n$texto\n$sep");
}

// Dirección pública de la app, para armar los enlaces de los correos.
function urlApp(string $ruta = ''): string
{
    return rtrim(getenv('APP_URL') ?: 'http://localhost:8080', '/') . '/' . ltrim($ruta, '/');
}
