<?php
// =====================================================================
//  Cuentas: validaciones, alias al azar y enlaces de un solo uso.
// =====================================================================

require_once __DIR__ . '/sesion.php';
require_once __DIR__ . '/correo.php';
require_once __DIR__ . '/groserias.php';

const CONTRASENA_MIN = 8;
const CONTRASENA_MAX = 72;          // password_hash (bcrypt) ignora lo que pase de 72 bytes

function validarCorreo($correo): string
{
    $c = strtolower(trim((string)$correo));
    if ($c === '' || strlen($c) > 254 || !filter_var($c, FILTER_VALIDATE_EMAIL)) {
        fallar(400, 'Escribe un correo válido.');
    }
    return $c;
}

function validarContrasena($pass): string
{
    $p = (string)$pass;
    if (strlen($p) < CONTRASENA_MIN) { fallar(400, 'La contraseña debe tener al menos ' . CONTRASENA_MIN . ' caracteres.'); }
    if (strlen($p) > CONTRASENA_MAX) { fallar(400, 'La contraseña es demasiado larga (máximo ' . CONTRASENA_MAX . ').'); }
    return $p;
}

// ---------------------------------------------------------------------
//  Alias: la identidad pública. Se genera al azar y el usuario lo cambia.
// ---------------------------------------------------------------------

const ANIMALES = ['Ajolote', 'Axolotl', 'Búho', 'Colibrí', 'Coyote', 'Jaguar', 'Quetzal', 'Tlacuache',
                  'Venado', 'Zorro', 'Tejón', 'Lince', 'Halcón', 'Tucán', 'Mapache', 'Iguana',
                  'Delfín', 'Puma', 'Gato', 'Burro'];
const ADJETIVOS = ['Veloz', 'Sabio', 'Curioso', 'Valiente', 'Tranquilo', 'Astuto', 'Nocturno', 'Feliz',
                   'Atento', 'Paciente', 'Brillante', 'Discreto', 'Tenaz', 'Amable', 'Sereno', 'Audaz'];

function aliasAlAzar(): string
{
    $st = db()->prepare('SELECT 1 FROM usuario WHERE lower(alias) = lower(?)');
    for ($i = 0; $i < 30; $i++) {
        $alias = ANIMALES[array_rand(ANIMALES)] . ' ' . ADJETIVOS[array_rand(ADJETIVOS)] . ' ' . random_int(10, 99);
        $st->execute([$alias]);
        if (!$st->fetch()) { return $alias; }
    }
    return 'Alumno ' . bin2hex(random_bytes(4));
}

function validarAlias($alias): string
{
    $a = trim(preg_replace('/\s+/u', ' ', (string)$alias));
    if (mb_strlen($a) < 3 || mb_strlen($a) > 30) { fallar(400, 'El alias debe tener de 3 a 30 caracteres.'); }
    if (!preg_match('/^[\p{L}\p{N} ._-]+$/u', $a)) { fallar(400, 'El alias solo puede llevar letras, números, espacios, punto, guion y guion bajo.'); }
    exigirSinGroserias($a, 'Tu alias');
    return $a;
}

// ---------------------------------------------------------------------
//  Enlaces de un solo uso (verificar la cuenta, recuperar la contraseña).
//  En la base solo se guarda el sha256 del enlace: si alguien leyera la
//  tabla token, no podría usarlos.
// ---------------------------------------------------------------------

function crearToken(int $usuario, string $tipo, string $vigencia): string
{
    $pdo = db();
    $pdo->exec('DELETE FROM token WHERE expira < now()');                     // limpieza de vencidos
    $pdo->prepare('DELETE FROM token WHERE usuario = ? AND tipo = ?')->execute([$usuario, $tipo]);
    $plano = bin2hex(random_bytes(32));
    $pdo->prepare("INSERT INTO token (hash, usuario, tipo, expira) VALUES (?, ?, ?, now() + ?::interval)")
        ->execute([hash('sha256', $plano), $usuario, $tipo, $vigencia]);
    return $plano;
}

// Gasta el enlace: si sirve, lo borra y regresa el id del usuario.
function usarToken(string $plano, string $tipo): ?int
{
    if (!preg_match('/^[0-9a-f]{64}$/', $plano)) { return null; }
    $st = db()->prepare('DELETE FROM token WHERE hash = ? AND tipo = ? AND expira > now() RETURNING usuario');
    $st->execute([hash('sha256', $plano), $tipo]);
    $id = $st->fetchColumn();
    return $id === false ? null : (int)$id;
}

function mandarVerificacion(int $usuario, string $correo): void
{
    $enlace = urlApp('api/cuenta/verificar.php?t=' . crearToken($usuario, 'verificar', '48 hours'));
    enviarCorreo($correo, 'Activa tu cuenta de Gestorix',
        "¡Hola!\n\nPara activar tu cuenta de Gestorix abre este enlace (sirve 48 horas):\n\n$enlace\n\n"
      . "Si tú no creaste la cuenta, ignora este correo.");
}

// Cambia el alias de $usuario y lo anota en alias_cambio. $por es quién lo
// cambió: el mismo usuario (cuenta para su límite de 3 al año) o un admin.
function cambiarAlias(int $usuario, string $anterior, string $nuevo, int $por): void
{
    $pdo = db();
    $st = $pdo->prepare('SELECT 1 FROM usuario WHERE lower(alias) = lower(?) AND id <> ?');
    $st->execute([$nuevo, $usuario]);
    if ($st->fetch()) { fallar(409, 'Ese alias ya lo tiene alguien más.'); }
    $pdo->beginTransaction();
    $pdo->prepare('UPDATE usuario SET alias = ? WHERE id = ?')->execute([$nuevo, $usuario]);
    $pdo->prepare('INSERT INTO alias_cambio (usuario, alias_anterior, alias_nuevo, por) VALUES (?, ?, ?, ?)')
        ->execute([$usuario, $anterior, $nuevo, $por]);
    $pdo->commit();
}
