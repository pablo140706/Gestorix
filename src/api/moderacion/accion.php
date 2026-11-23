<?php
// =====================================================================
//  POST api/moderacion/accion.php  → { ok, mensaje }
// =====================================================================
//  { accion: "ocultar" | "mostrar" | "descartar",  comentario, motivo }
//  { accion: "suspender", comentario | usuario, dias: 1 | 7 | 30, motivo }
//  { accion: "banear" | "desbanear", comentario | usuario, motivo }
//
//  Reglas (CLAUDE.md §6):
//  · Solo moderadores y administradores. Todo, salvo descartar un
//    reporte, lleva motivo y queda en la bitácora.
//  · Nadie se modera a sí mismo ni a un administrador; a un moderador
//    solo lo modera un administrador.
//  · Banear oculta de una vez todos los comentarios visibles de la
//    cuenta. Desbanear NO los vuelve a mostrar: se revisan uno por uno.
//  · Una acción sobre un comentario cierra sus reportes pendientes:
//    "atendido" si se ocultó o se sancionó al autor, "descartado" si no.
// =====================================================================

require __DIR__ . '/../../lib/comentarios.php';

const DIAS_SUSPENSION = [1, 7, 30];

$mod = exigirModerador();
$d = leerJson();
$pdo = db();
$accion = (string)($d['accion'] ?? '');
$carreras = carrerasQueModera($mod);    // un moderador solo modera sus carreras (usuario, 2026-11-22)

if (!in_array($accion, ['ocultar', 'mostrar', 'descartar', 'suspender', 'banear', 'desbanear'], true)) {
    fallar(400, 'Acción desconocida.');
}

$motivo = preg_replace('/\s+/u', ' ', limpiarTexto($d['motivo'] ?? ''));
if ($accion !== 'descartar' && mb_strlen($motivo) < 3) { fallar(400, 'Escribe el motivo: queda en la bitácora.'); }
if (mb_strlen($motivo) > 500) { fallar(400, 'El motivo es de máximo 500 caracteres.'); }

// El comentario (si viene) y la cuenta sobre la que se actúa.
$comentario = null;
if (isset($d['comentario'])) {
    $st = $pdo->prepare('SELECT c.id, c.usuario, c.estado, m.carrera FROM comentario c JOIN materia m ON m.clave = c.materia WHERE c.id = ?');
    $st->execute([(int)$d['comentario']]);
    $comentario = $st->fetch() ?: fallar(404, 'Ese comentario ya no existe.');
    if (!in_array($comentario['carrera'], $carreras, true)) {
        fallar(403, "No moderas los comentarios de {$comentario['carrera']}: pídeselo al administrador.");
    }
}
$objetivo = null;
if (in_array($accion, ['suspender', 'banear', 'desbanear'], true)) {
    // Con comentario se actúa sobre SU autor (no sobre otra cuenta que venga en la petición).
    $uid = $comentario !== null ? (int)($comentario['usuario'] ?? 0) : (int)($d['usuario'] ?? 0);
    $st = $pdo->prepare('SELECT id, alias, rol, carrera, baneado FROM usuario WHERE id = ?');
    $st->execute([$uid]);
    $objetivo = $st->fetch() ?: fallar(404, 'Esa cuenta ya no existe.');
    // Sin comentario de por medio, la cuenta tiene que ser de una carrera que moderas.
    if ($comentario === null && !in_array($objetivo['carrera'], $carreras, true)) {
        fallar(403, "No moderas cuentas de {$objetivo['carrera']}.");
    }
} elseif ($comentario === null) {
    fallar(400, 'Falta el comentario.');
} elseif ($comentario['usuario'] !== null) {
    $st = $pdo->prepare('SELECT id, alias, rol, baneado FROM usuario WHERE id = ?');
    $st->execute([$comentario['usuario']]);
    $objetivo = $st->fetch() ?: null;
}

if ($objetivo) {
    if ((int)$objetivo['id'] === (int)$mod['id']) { fallar(403, 'No puedes moderarte a ti mismo.'); }
    if ($objetivo['rol'] === 'admin') { fallar(403, 'A un administrador no se le modera.'); }
    if ($objetivo['rol'] === 'moderador' && $mod['rol'] !== 'admin') {
        fallar(403, 'A un moderador solo lo modera un administrador.');
    }
}

// Validar todo antes de abrir la transacción.
$dias = (int)($d['dias'] ?? 0);
if ($accion === 'suspender' && !in_array($dias, DIAS_SUSPENSION, true)) { fallar(400, 'La suspensión es de 1, 7 o 30 días.'); }
if ($accion === 'banear' && $objetivo['baneado']) { fallar(409, 'Esa cuenta ya está baneada.'); }
if ($accion === 'desbanear' && !$objetivo['baneado']) { fallar(409, 'Esa cuenta no está baneada.'); }

$bitacora = $pdo->prepare('INSERT INTO bitacora (actor, accion, objetivo_usuario, objetivo_comentario, motivo) VALUES (?, ?, ?, ?, ?)');
$cerrarReportes = $pdo->prepare("UPDATE reporte SET estado = ?, resuelto_por = ? WHERE comentario = ? AND estado = 'pendiente'");
$objId = $objetivo ? (int)$objetivo['id'] : null;
$comId = $comentario ? (int)$comentario['id'] : null;

$pdo->beginTransaction();
switch ($accion) {
    case 'ocultar':
    case 'mostrar':
        $nuevo = $accion === 'ocultar' ? 'oculto' : 'visible';
        $pdo->prepare('UPDATE comentario SET estado = ? WHERE id = ?')->execute([$nuevo, $comId]);
        $bitacora->execute([$mod['id'], $accion, $objId, $comId, $motivo]);
        $cerrarReportes->execute([$accion === 'ocultar' ? 'atendido' : 'descartado', $mod['id'], $comId]);
        $mensaje = $accion === 'ocultar' ? 'Comentario oculto.' : 'Comentario visible otra vez.';
        break;

    case 'descartar':
        $cerrarReportes->execute(['descartado', $mod['id'], $comId]);
        $mensaje = 'Reportes descartados: el comentario se queda.';
        break;

    case 'suspender':
        $pdo->prepare('UPDATE usuario SET suspendido_hasta = now() + make_interval(days => ?) WHERE id = ?')
            ->execute([$dias, $objId]);
        $bitacora->execute([$mod['id'], 'suspender', $objId, $comId, "$motivo ($dias " . ($dias === 1 ? 'día' : 'días') . ')']);
        if ($comId) { $cerrarReportes->execute(['atendido', $mod['id'], $comId]); }
        $mensaje = "«{$objetivo['alias']}» no podrá comentar durante $dias " . ($dias === 1 ? 'día' : 'días') . '.';
        break;

    case 'banear':
        $pdo->prepare('UPDATE usuario SET baneado = true, suspendido_hasta = NULL WHERE id = ?')->execute([$objId]);
        $bitacora->execute([$mod['id'], 'banear', $objId, $comId, $motivo]);
        // Se ocultan todos sus comentarios visibles, cada uno con su línea en la bitácora.
        $st = $pdo->prepare("UPDATE comentario SET estado = 'oculto' WHERE usuario = ? AND estado = 'visible' RETURNING id");
        $st->execute([$objId]);
        $ocultos = $st->fetchAll(PDO::FETCH_COLUMN);
        foreach ($ocultos as $cid) {
            $bitacora->execute([$mod['id'], 'ocultar', $objId, $cid, "Baneo: $motivo"]);
        }
        $pdo->prepare("UPDATE reporte SET estado = 'atendido', resuelto_por = ?
                       WHERE estado = 'pendiente' AND comentario IN (SELECT id FROM comentario WHERE usuario = ?)")
            ->execute([$mod['id'], $objId]);
        $n = count($ocultos);
        $mensaje = "«{$objetivo['alias']}» quedó baneada" . ($n === 0 ? '; no tenía comentarios visibles.'
                 : ($n === 1 ? ' y se ocultó su único comentario visible.' : " y se ocultaron sus $n comentarios visibles."));
        break;

    case 'desbanear':
        $pdo->prepare('UPDATE usuario SET baneado = false WHERE id = ?')->execute([$objId]);
        $bitacora->execute([$mod['id'], 'desbanear', $objId, $comId, $motivo]);
        $mensaje = "«{$objetivo['alias']}» puede volver a entrar. Sus comentarios siguen ocultos: muéstralos uno por uno si procede.";
        break;
}
$pdo->commit();

responder(['ok' => true, 'mensaje' => $mensaje]);
