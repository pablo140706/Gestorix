<?php
// GET api/cuenta/verificar.php?t=…   (el enlace del correo)
// Activa la cuenta, abre la sesión y regresa a la app con un aviso.
require __DIR__ . '/../../lib/cuenta.php';

$id = usarToken((string)($_GET['t'] ?? ''), 'verificar');
if ($id === null) {
    header('Location: ' . urlApp('?cuenta=enlace-vencido'));
    exit;
}
db()->prepare('UPDATE usuario SET verificado = true WHERE id = ?')->execute([$id]);
entrarComo($id);
header('Location: ' . urlApp('?cuenta=activada'));
