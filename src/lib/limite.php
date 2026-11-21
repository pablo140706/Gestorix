<?php
// =====================================================================
//  Límite de intentos: que nadie pruebe contraseñas al por mayor ni
//  mande cientos de registros o correos.
// =====================================================================
//  Cada intento se anota en un archivito dentro de /tmp del contenedor
//  (uno por acción + IP o correo). Si en la ventana de tiempo ya hubo
//  demasiados, se contesta 429 "Demasiados intentos".
//
//  Se reinicia solo al reconstruir el contenedor; para esto basta.
// =====================================================================

require_once __DIR__ . '/sesion.php';

// La IP de quien hace la petición. Con ngrok, Apache ve la IP interna de
// Docker y la real viene en X-Forwarded-For. Se toma la ÚLTIMA de esa
// lista, la que pone ngrok: las anteriores las puede inventar cualquiera.
function ipCliente(): string
{
    $ip = $_SERVER['REMOTE_ADDR'] ?? '';
    $esInterna = !filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE);
    $xff = $_SERVER['HTTP_X_FORWARDED_FOR'] ?? '';
    if ($esInterna && $xff !== '') {
        $lista = array_map('trim', explode(',', $xff));
        $ultima = end($lista);
        if (filter_var($ultima, FILTER_VALIDATE_IP)) { return $ultima; }
    }
    return $ip;
}

// Abre el archivo de una llave y regresa [manejador, intentos vigentes].
function abrirLimite(string $accion, string $llave, int $segundos): array
{
    $dir = sys_get_temp_dir() . '/gestorix-limites';
    if (!is_dir($dir)) { @mkdir($dir, 0700, true); }
    $f = fopen($dir . '/' . hash('sha256', "$accion|$llave"), 'c+');
    flock($f, LOCK_EX);
    $intentos = json_decode(stream_get_contents($f) ?: '[]', true) ?: [];
    $desde = time() - $segundos;
    $intentos = array_values(array_filter($intentos, fn($t) => $t > $desde));
    return [$f, $intentos];
}

function guardarLimite($f, array $intentos): void
{
    ftruncate($f, 0);
    rewind($f);
    fwrite($f, json_encode($intentos));
    flock($f, LOCK_UN);
    fclose($f);
}

// Si ya hubo $max intentos en los últimos $segundos, corta con 429.
function exigirBajoLimite(string $accion, string $llave, int $max, int $segundos): void
{
    [$f, $intentos] = abrirLimite($accion, $llave, $segundos);
    guardarLimite($f, $intentos);
    if (count($intentos) >= $max) {
        $min = max(1, (int)ceil(($intentos[0] + $segundos - time()) / 60));
        header('Retry-After: ' . ($min * 60));
        fallar(429, "Demasiados intentos. Espera $min " . ($min === 1 ? 'minuto' : 'minutos') . ' y vuelve a intentar.');
    }
}

function anotarIntento(string $accion, string $llave, int $segundos): void
{
    [$f, $intentos] = abrirLimite($accion, $llave, $segundos);
    $intentos[] = time();
    guardarLimite($f, $intentos);
}

// Lo normal: revisar y anotar de una vez.
function limitar(string $accion, string $llave, int $max, int $segundos): void
{
    exigirBajoLimite($accion, $llave, $max, $segundos);
    anotarIntento($accion, $llave, $segundos);
}
