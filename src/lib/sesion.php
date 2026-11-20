<?php
// =====================================================================
//  Sesión del usuario y entrada de datos para los endpoints con cuenta.
// =====================================================================
//  La sesión es la normal de PHP: una cookie ("gestorix") con un id al
//  azar; los datos viven en el servidor. Sin cookies de rastreo.
//
//  Los endpoints que cambian algo solo aceptan POST con cuerpo JSON. Un
//  formulario de otro sitio no puede mandar JSON sin permiso del navegador,
//  y además se revisa que el Origin sea este mismo sitio: así nadie puede
//  hacer que tu navegador cambie tu cuenta desde otra página (CSRF).
// =====================================================================

require_once __DIR__ . '/api.php';

const DURACION_SESION = 60 * 60 * 24 * 30;   // 30 días

function iniciarSesion(): void
{
    if (session_status() === PHP_SESSION_ACTIVE) { return; }
    $https = ($_SERVER['HTTPS'] ?? '') === 'on' || ($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https';
    ini_set('session.gc_maxlifetime', (string)DURACION_SESION);
    ini_set('session.use_strict_mode', '1');
    session_name('gestorix');
    session_set_cookie_params([
        'lifetime' => DURACION_SESION,
        'path'     => '/',
        'secure'   => $https,       // en producción (HTTPS) la cookie solo viaja cifrada
        'httponly' => true,         // JavaScript no puede leerla
        'samesite' => 'Lax',
    ]);
    session_start();
}

// Termina la petición con un error en JSON.
function fallar(int $codigo, string $mensaje): never
{
    http_response_code($codigo);
    responder(['error' => $mensaje]);
    exit;
}

// Cuerpo JSON de un POST, con las protecciones de arriba.
function leerJson(): array
{
    if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
        fallar(405, 'Usa POST.');
    }
    if (!str_contains(strtolower($_SERVER['CONTENT_TYPE'] ?? ''), 'application/json')) {
        fallar(415, 'Se espera JSON.');
    }
    $origen = $_SERVER['HTTP_ORIGIN'] ?? '';
    if ($origen !== '') {
        $o = parse_url($origen);
        $hostOrigen = ($o['host'] ?? '') . (isset($o['port']) ? ':' . $o['port'] : '');
        if ($hostOrigen !== ($_SERVER['HTTP_HOST'] ?? '')) {
            fallar(403, 'Origen no permitido.');
        }
    }
    $datos = json_decode(file_get_contents('php://input'), true);
    if (!is_array($datos)) {
        fallar(400, 'JSON inválido.');
    }
    return $datos;
}

// Lo que el usuario puede saber de sí mismo. El correo solo se le muestra
// a él (y a moderadores y admins, en casos graves).
function perfil(array $u): array
{
    return ['alias' => $u['alias'], 'correo' => $u['correo'], 'carrera' => $u['carrera'], 'rol' => $u['rol']];
}

// El usuario de la sesión, o null. Si lo banearon o suspendieron mientras
// tenía la sesión abierta, se le cierra.
function usuarioActual(): ?array
{
    iniciarSesion();
    $id = $_SESSION['usuario'] ?? null;
    if ($id === null) { return null; }
    $st = db()->prepare(
        'SELECT id, correo, alias, rol, carrera, baneado, suspendido_hasta > now() AS suspendido
         FROM usuario WHERE id = ? AND verificado');
    $st->execute([$id]);
    $u = $st->fetch();
    if (!$u || $u['baneado'] || $u['suspendido']) {
        unset($_SESSION['usuario']);
        return null;
    }
    return $u;
}

function exigirUsuario(): array
{
    return usuarioActual() ?? fallar(401, 'Inicia sesión para guardar.');
}

// Abre la sesión de un usuario. Cambiar el id de sesión al entrar evita
// que alguien que conociera el id anterior se cuele (session fixation).
function entrarComo(int $id): void
{
    iniciarSesion();
    session_regenerate_id(true);
    $_SESSION['usuario'] = $id;
}
