<?php
// =====================================================================
//  Lo común de la pestaña Admin (src/api/admin/*.php).
// =====================================================================
//  Quién ve qué (usuario, 2026-11-22):
//   · Moderadores y admin: tablero, comentarios, reportes y bitácora,
//     pero un moderador SOLO de las carreras que modera.
//   · Solo el admin: estado del sistema, usuarios (con su correo),
//     nombrar moderadores, cambiar alias ofensivos, probar el correo y
//     bajar el respaldo. Lo más delicado pide otra vez la contraseña
//     (exigirConfirmado(), en lib/sesion.php).
//  Todo se revisa AQUÍ, en el servidor: esconder la pestaña en el front
//  no protege nada, porque cualquiera puede mandar la petición a mano.
// =====================================================================

require_once __DIR__ . '/comentarios.php';
require_once __DIR__ . '/cuenta.php';

header('Cache-Control: no-store');

function anotarBitacora(int $actor, string $accion, ?int $usuario, ?int $comentario, ?string $motivo): void
{
    db()->prepare('INSERT INTO bitacora (actor, accion, objetivo_usuario, objetivo_comentario, motivo) VALUES (?, ?, ?, ?, ?)')
        ->execute([$actor, $accion, $usuario, $comentario, $motivo]);
}

// Motivo obligatorio (queda en la bitácora).
function leerMotivo(array $d): string
{
    $m = preg_replace('/\s+/u', ' ', limpiarTexto($d['motivo'] ?? ''));
    if (mb_strlen($m) < 3) { fallar(400, 'Escribe el motivo: queda en la bitácora.'); }
    if (mb_strlen($m) > 500) { fallar(400, 'El motivo es de máximo 500 caracteres.'); }
    return $m;
}

// Página de una lista: ?pagina=1, 2… de $porPagina en $porPagina.
function paginaPedida(): int
{
    return max(1, min(1000, (int)($_GET['pagina'] ?? 1)));
}
