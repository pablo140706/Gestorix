<?php
// POST api/cuenta/alias.php   { alias }  → { usuario }
// El alias es único sin importar mayúsculas ("Pablo" = "pablo").
require __DIR__ . '/../../lib/cuenta.php';

$u = exigirUsuario();
$alias = validarAlias(leerJson()['alias'] ?? '');

$st = db()->prepare('SELECT 1 FROM usuario WHERE lower(alias) = lower(?) AND id <> ?');
$st->execute([$alias, $u['id']]);
if ($st->fetch()) { fallar(409, 'Ese alias ya lo tiene alguien más.'); }

db()->prepare('UPDATE usuario SET alias = ? WHERE id = ?')->execute([$alias, $u['id']]);
$u['alias'] = $alias;
responder(['usuario' => perfil($u)]);
