<?php
// POST api/cuenta/alias.php   { alias }  → { usuario }
// El alias es único sin importar mayúsculas ("Pablo" = "pablo").
// Se puede cambiar como máximo 2 veces en la vida de la cuenta (usuario,
// 2026-11-21): el alias sale en tus reseñas, y cambiarlo sin límite dejaría
// que alguien "se escondiera" detrás de otro nombre.
require __DIR__ . '/../../lib/cuenta.php';

const MAX_CAMBIOS_ALIAS = 2;

$u = exigirUsuario();
$alias = validarAlias(leerJson()['alias'] ?? '');

if ($alias === $u['alias']) { responder(['usuario' => perfil($u)]); exit; }   // no es un cambio
if ((int)$u['alias_cambios'] >= MAX_CAMBIOS_ALIAS) {
    fallar(403, 'Ya cambiaste tu alias ' . MAX_CAMBIOS_ALIAS . ' veces: ya no se puede cambiar.');
}

$st = db()->prepare('SELECT 1 FROM usuario WHERE lower(alias) = lower(?) AND id <> ?');
$st->execute([$alias, $u['id']]);
if ($st->fetch()) { fallar(409, 'Ese alias ya lo tiene alguien más.'); }

db()->prepare('UPDATE usuario SET alias = ?, alias_cambios = alias_cambios + 1 WHERE id = ?')->execute([$alias, $u['id']]);
$u['alias'] = $alias;
$u['alias_cambios'] = (int)$u['alias_cambios'] + 1;
responder(['usuario' => perfil($u)]);
