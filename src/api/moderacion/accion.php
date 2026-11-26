<?php
// =====================================================================
//  POST api/moderacion/accion.php  → { ok, mensaje }
// =====================================================================
//  { accion: "ocultar" | "mostrar" | "descartar",  comentario | respuesta, motivo }
//  { accion: "suspender", comentario | respuesta | usuario, dias: 1 | 7 | 30, motivo }
//  { accion: "banear" | "desbanear", comentario | respuesta | usuario, motivo }
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
//  · Las RESPUESTAS (2026-11-26) se moderan igual, y además **se ocultan
//    y se muestran junto con el comentario que contestan**: una respuesta
//    suelta se lee fuera de contexto. En la bitácora quedan con el id de
//    su comentario y el número de respuesta en el motivo, porque
//    bitacora.objetivo_comentario apunta a comentario.
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

// La respuesta (si viene) trae consigo a su comentario: de ahí salen la
// carrera que manda para moderar y el id que va a la bitácora.
$respuesta = null;
if (isset($d['respuesta'])) {
    $st = $pdo->prepare('SELECT r.id, r.usuario, r.estado, r.comentario FROM respuesta r WHERE r.id = ?');
    $st->execute([(int)$d['respuesta']]);
    $respuesta = $st->fetch() ?: fallar(404, 'Esa respuesta ya no existe.');
    $d['comentario'] = $respuesta['comentario'];
}

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
    // Con comentario o respuesta se actúa sobre SU autor (no sobre otra
    // cuenta que venga en la petición).
    $uid = $respuesta !== null ? (int)($respuesta['usuario'] ?? 0)
         : ($comentario !== null ? (int)($comentario['usuario'] ?? 0) : (int)($d['usuario'] ?? 0));
    $st = $pdo->prepare('SELECT id, alias, rol, carrera, baneado FROM usuario WHERE id = ?');
    $st->execute([$uid]);
    $objetivo = $st->fetch() ?: fallar(404, 'Esa cuenta ya no existe.');
    // Sin comentario de por medio, la cuenta tiene que ser de una carrera que moderas.
    if ($comentario === null && !in_array($objetivo['carrera'], $carreras, true)) {
        fallar(403, "No moderas cuentas de {$objetivo['carrera']}.");
    }
} elseif ($comentario === null) {
    fallar(400, 'Falta el comentario.');
} else {
    $autor = $respuesta !== null ? $respuesta['usuario'] : $comentario['usuario'];
    if ($autor !== null) {
        $st = $pdo->prepare('SELECT id, alias, rol, baneado FROM usuario WHERE id = ?');
        $st->execute([$autor]);
        $objetivo = $st->fetch() ?: null;
    }
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
// Cierra los reportes del comentario Y los de sus respuestas: si se ocultó
// el hilo, no queda nada pendiente de revisar ahí.
$cerrarReportes = $pdo->prepare(
    "UPDATE reporte SET estado = ?, resuelto_por = ?
      WHERE estado = 'pendiente'
        AND (comentario = ? OR respuesta IN (SELECT id FROM respuesta WHERE comentario = ?))");
$cerrarReportesResp = $pdo->prepare("UPDATE reporte SET estado = ?, resuelto_por = ? WHERE respuesta = ? AND estado = 'pendiente'");
$objId = $objetivo ? (int)$objetivo['id'] : null;
$comId = $comentario ? (int)$comentario['id'] : null;
$respId = $respuesta ? (int)$respuesta['id'] : null;
// Lo que se anota en la bitácora: el id del comentario siempre, y de qué
// respuesta se trata dentro del motivo.
$motivoBitacora = $respId ? "Respuesta #$respId: $motivo" : $motivo;

$pdo->beginTransaction();
switch ($accion) {
    case 'ocultar':
    case 'mostrar':
        $nuevo = $accion === 'ocultar' ? 'oculto' : 'visible';
        $cierre = $accion === 'ocultar' ? 'atendido' : 'descartado';
        if ($respId !== null) {
            // Solo esa respuesta. oculta_con_padre = false: la ocultó un
            // moderador aparte, así que no regresa sola al mostrar el hilo.
            $pdo->prepare('UPDATE respuesta SET estado = ?, oculta_con_padre = false WHERE id = ?')
                ->execute([$nuevo, $respId]);
            $bitacora->execute([$mod['id'], $accion, $objId, $comId, $motivoBitacora]);
            $cerrarReportesResp->execute([$cierre, $mod['id'], $respId]);
            $mensaje = $accion === 'ocultar' ? 'Respuesta oculta.' : 'Respuesta visible otra vez.';
            break;
        }
        $pdo->prepare('UPDATE comentario SET estado = ? WHERE id = ?')->execute([$nuevo, $comId]);
        // Las respuestas van con su comentario (usuario, 2026-11-26).
        $st = $accion === 'ocultar'
            ? $pdo->prepare("UPDATE respuesta SET estado = 'oculto', oculta_con_padre = true
                              WHERE comentario = ? AND estado = 'visible' RETURNING id")
            : $pdo->prepare("UPDATE respuesta SET estado = 'visible', oculta_con_padre = false
                              WHERE comentario = ? AND oculta_con_padre RETURNING id");
        $st->execute([$comId]);
        $nResp = count($st->fetchAll(PDO::FETCH_COLUMN));
        $bitacora->execute([$mod['id'], $accion, $objId, $comId, $motivo]);
        $cerrarReportes->execute([$cierre, $mod['id'], $comId, $comId]);
        $conResp = $nResp === 0 ? '' : ($nResp === 1 ? ' y su respuesta' : " y sus $nResp respuestas");
        $mensaje = ($accion === 'ocultar' ? "Comentario$conResp oculto" : "Comentario$conResp visible otra vez") . '.';
        break;

    case 'descartar':
        if ($respId !== null) {
            $cerrarReportesResp->execute(['descartado', $mod['id'], $respId]);
            $mensaje = 'Reportes descartados: la respuesta se queda.';
            break;
        }
        $cerrarReportes->execute(['descartado', $mod['id'], $comId, $comId]);
        $mensaje = 'Reportes descartados: el comentario se queda.';
        break;

    case 'suspender':
        $pdo->prepare('UPDATE usuario SET suspendido_hasta = now() + make_interval(days => ?) WHERE id = ?')
            ->execute([$dias, $objId]);
        $bitacora->execute([$mod['id'], 'suspender', $objId, $comId, "$motivoBitacora ($dias " . ($dias === 1 ? 'día' : 'días') . ')']);
        if ($respId) { $cerrarReportesResp->execute(['atendido', $mod['id'], $respId]); }
        elseif ($comId) { $cerrarReportes->execute(['atendido', $mod['id'], $comId, $comId]); }
        $mensaje = "«{$objetivo['alias']}» no podrá comentar durante $dias " . ($dias === 1 ? 'día' : 'días') . '.';
        break;

    case 'banear':
        $pdo->prepare('UPDATE usuario SET baneado = true, suspendido_hasta = NULL WHERE id = ?')->execute([$objId]);
        $bitacora->execute([$mod['id'], 'banear', $objId, $comId, $motivoBitacora]);
        // Se ocultan todos sus comentarios visibles, cada uno con su línea en la bitácora.
        $st = $pdo->prepare("UPDATE comentario SET estado = 'oculto' WHERE usuario = ? AND estado = 'visible' RETURNING id");
        $st->execute([$objId]);
        $ocultos = $st->fetchAll(PDO::FETCH_COLUMN);
        foreach ($ocultos as $cid) {
            $bitacora->execute([$mod['id'], 'ocultar', $objId, $cid, "Baneo: $motivo"]);
            // Las respuestas de otros a ese comentario se van con él, y
            // regresan si algún día se vuelve a mostrar.
            $pdo->prepare("UPDATE respuesta SET estado = 'oculto', oculta_con_padre = true
                            WHERE comentario = ? AND estado = 'visible'")->execute([$cid]);
        }
        // Y sus propias respuestas en los comentarios de cualquiera.
        $st = $pdo->prepare("UPDATE respuesta SET estado = 'oculto', oculta_con_padre = false
                              WHERE usuario = ? AND estado = 'visible' RETURNING comentario");
        $st->execute([$objId]);
        $resp = $st->fetchAll(PDO::FETCH_COLUMN);
        foreach (array_unique($resp) as $cid) {
            $bitacora->execute([$mod['id'], 'ocultar', $objId, $cid, "Baneo (respuestas): $motivo"]);
        }
        // PDO no deja repetir un parámetro con nombre: por eso :u1 y :u2.
        $pdo->prepare("UPDATE reporte SET estado = 'atendido', resuelto_por = :mod
                       WHERE estado = 'pendiente'
                         AND (comentario IN (SELECT id FROM comentario WHERE usuario = :u1)
                              OR respuesta IN (SELECT id FROM respuesta WHERE usuario = :u2))")
            ->execute(['mod' => $mod['id'], 'u1' => $objId, 'u2' => $objId]);
        $n = count($ocultos);
        $nr = count($resp);
        $mensaje = "«{$objetivo['alias']}» quedó baneada" . ($n === 0 ? '; no tenía comentarios visibles.'
                 : ($n === 1 ? ' y se ocultó su único comentario visible.' : " y se ocultaron sus $n comentarios visibles."))
                 . ($nr === 0 ? '' : ($nr === 1 ? ' También su respuesta.' : " También sus $nr respuestas."));
        break;

    case 'desbanear':
        $pdo->prepare('UPDATE usuario SET baneado = false WHERE id = ?')->execute([$objId]);
        $bitacora->execute([$mod['id'], 'desbanear', $objId, $comId, $motivo]);
        $mensaje = "«{$objetivo['alias']}» puede volver a entrar. Sus comentarios siguen ocultos: muéstralos uno por uno si procede.";
        break;
}
$pdo->commit();

responder(['ok' => true, 'mensaje' => $mensaje]);
