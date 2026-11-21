<?php
// =====================================================================
//  Envío de correos (verificación de cuenta y "olvidé mi contraseña").
// =====================================================================
//  Se mandan por SMTP con una cuenta de Gmail y una "contraseña de
//  aplicación" (no la contraseña normal). Todo sale del .env:
//
//      SMTP_HOST=smtp.gmail.com      SMTP_PORT=465
//      SMTP_USER=correo-del-sitio@gmail.com
//      SMTP_PASSWORD=la contraseña de aplicación (16 letras)
//
//  Si SMTP_HOST, SMTP_USER o SMTP_PASSWORD están vacíos, el correo NO se
//  manda: su texto completo, con el enlace, sale en el log del contenedor
//  (docker compose logs web). Si Gmail falla, también sale ahí, junto con
//  el motivo, para que el admin pueda pasarle el enlace a mano.
//
//  Sin Composer ni librerías: SMTP son unas cuantas líneas de texto sobre
//  una conexión cifrada (SSL, puerto 465).
// =====================================================================

function enviarCorreo(string $para, string $asunto, string $texto): void
{
    $listo = (getenv('SMTP_HOST') ?: '') !== '' && (getenv('SMTP_USER') ?: '') !== ''
          && (getenv('SMTP_PASSWORD') ?: '') !== '';
    if ($listo) {
        try {
            enviarPorSmtp($para, $asunto, $texto);
            return;
        } catch (Throwable $e) {
            error_log('CORREO no enviado: ' . $e->getMessage());
        }
    }
    $sep = str_repeat('=', 60);
    $nota = $listo ? 'falló el envío; ver arriba' : 'no se manda; falta configurar SMTP en el .env';
    error_log("\n$sep\nCORREO ($nota)\nPara:   $para\nAsunto: $asunto\n\n$texto\n$sep");
}

function enviarPorSmtp(string $para, string $asunto, string $texto): void
{
    // $para ya viene validado, pero un salto de línea aquí permitiría
    // colar encabezados o destinatarios extra: se rechaza por si acaso.
    if (preg_match('/[\r\n<>]/', $para)) { throw new RuntimeException('Destinatario inválido.'); }

    $host   = getenv('SMTP_HOST');
    $puerto = (int)(getenv('SMTP_PORT') ?: 465);
    $usuario = getenv('SMTP_USER');
    $de     = getenv('SMTP_FROM') ?: $usuario;
    $nombre = getenv('SMTP_FROM_NAME') ?: 'Gestorix';

    $s = @stream_socket_client("ssl://$host:$puerto", $errno, $errstr, 15);
    if (!$s) { throw new RuntimeException("No se pudo conectar a $host:$puerto ($errstr)."); }
    stream_set_timeout($s, 15);

    // Lee la respuesta del servidor (puede ser de varias líneas: "250-…"
    // y la última "250 …") y revisa que el código sea el esperado.
    $leer = function (int $esperado) use ($s): void {
        $r = '';
        while (($linea = fgets($s, 1024)) !== false) {
            $r .= $linea;
            if (strlen($linea) < 4 || $linea[3] === ' ') { break; }
        }
        if ((int)substr($r, 0, 3) !== $esperado) {
            throw new RuntimeException("SMTP esperaba $esperado y contestó: " . trim($r));
        }
    };
    $orden = function (string $linea, int $esperado) use ($s, $leer): void {
        fwrite($s, $linea . "\r\n");
        $leer($esperado);
    };

    try {
        $leer(220);
        $orden('EHLO gestorix', 250);
        $orden('AUTH LOGIN', 334);
        $orden(base64_encode($usuario), 334);
        $orden(base64_encode(getenv('SMTP_PASSWORD')), 235);   // 535 = usuario o contraseña de aplicación mal
        $orden("MAIL FROM:<$de>", 250);
        $orden("RCPT TO:<$para>", 250);
        $orden('DATA', 354);

        // Asunto y remitente en UTF-8 (acentos, ¡, ñ) y el cuerpo en base64:
        // así ninguna línea del texto se confunde con el "." que cierra el correo.
        $dominio = substr(strrchr($de, '@'), 1) ?: 'gestorix';
        $correo = implode("\r\n", [
            'Date: ' . date('r'),
            'From: =?UTF-8?B?' . base64_encode($nombre) . "?= <$de>",
            "To: <$para>",
            'Subject: =?UTF-8?B?' . base64_encode($asunto) . '?=',
            'Message-ID: <' . bin2hex(random_bytes(12)) . "@$dominio>",
            'MIME-Version: 1.0',
            'Content-Type: text/plain; charset=UTF-8',
            'Content-Transfer-Encoding: base64',
            '',
            rtrim(chunk_split(base64_encode($texto), 76, "\r\n")),
        ]);
        $orden($correo . "\r\n.", 250);
        fwrite($s, "QUIT\r\n");
    } finally {
        fclose($s);
    }
}

// Dirección pública de la app, para armar los enlaces de los correos.
function urlApp(string $ruta = ''): string
{
    return rtrim(getenv('APP_URL') ?: 'http://localhost:8080', '/') . '/' . ltrim($ruta, '/');
}
