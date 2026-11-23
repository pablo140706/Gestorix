<?php
// POST api/cuenta/alias.php   { alias }  → { usuario }
// El alias es único sin importar mayúsculas ("Pablo" = "pablo") y no puede
// llevar groserías. Se puede cambiar 3 veces al año (usuario, 2026-11-22): el
// alias sale en tus reseñas, y cambiarlo sin límite dejaría que alguien "se
// escondiera". Cada cambio queda en la tabla alias_cambio.
require __DIR__ . '/../../lib/cuenta.php';

$u = exigirUsuario();
$alias = validarAlias(leerJson()['alias'] ?? '');

if ($alias === $u['alias']) { responder(['usuario' => perfil($u)]); exit; }   // no es un cambio
if (aliasCambiosRestantes((int)$u['id']) <= 0) {
    fallar(403, 'Ya cambiaste tu alias ' . MAX_CAMBIOS_ALIAS_ANIO . ' veces en el último año: espera para volver a cambiarlo.');
}
cambiarAlias((int)$u['id'], $u['alias'], $alias, (int)$u['id']);
$u['alias'] = $alias;
responder(['usuario' => perfil($u)]);
