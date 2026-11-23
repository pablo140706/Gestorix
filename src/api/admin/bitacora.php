<?php
// GET api/admin/bitacora.php?accion=&pagina=1
//   → { total, por_pagina, acciones: [...], filas: [{ cuando, actor, accion, usuario, comentario, motivo }] }
// Lo que han hecho moderadores y admin, del más nuevo al más viejo.
// El admin ve todo. Un moderador ve lo que toca a sus carreras (por el
// comentario o, si no hay, por la carrera de la cuenta), nunca las
// acciones de admin sin objetivo (respaldo, probar correo).
require __DIR__ . '/../../lib/admin.php';

$u = exigirModerador();
$porPagina = 50;
$ACCIONES = ['ocultar', 'mostrar', 'suspender', 'banear', 'desbanear', 'nombrar_moderador', 'quitar_moderador',
             'carreras_moderador', 'cambiar_alias', 'ver_correo', 'respaldo', 'probar_correo'];

$donde = ['true'];
$p = [];
if ($u['rol'] !== 'admin') {
    $donde[] = 'coalesce(mc.carrera, ou.carrera) = ANY (CAST(:carreras AS text[]))';
    $p['carreras'] = arregloPg(carrerasQueModera($u));
}
$accion = (string)($_GET['accion'] ?? '');
if ($accion !== '') {
    if (!in_array($accion, $ACCIONES, true)) { fallar(400, 'Acción desconocida.'); }
    $donde[] = 'b.accion = :accion';
    $p['accion'] = $accion;
}
$desde = 'FROM bitacora b
          LEFT JOIN usuario a     ON a.id = b.actor
          LEFT JOIN usuario ou    ON ou.id = b.objetivo_usuario
          LEFT JOIN comentario oc ON oc.id = b.objetivo_comentario
          LEFT JOIN materia mc    ON mc.clave = oc.materia
          LEFT JOIN profesor pc   ON pc.id = oc.profesor
          WHERE ' . implode(' AND ', $donde);

$st = db()->prepare("SELECT count(*) $desde");
$st->execute($p);
$total = (int)$st->fetchColumn();

$st = db()->prepare(
    "SELECT to_char(b.cuando AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') AS cuando,
            a.alias AS actor, b.accion, ou.alias AS usuario, b.objetivo_comentario AS comentario,
            left(oc.texto, 80) AS comentario_texto, pc.nombre AS profesor, b.motivo
     $desde
     ORDER BY b.cuando DESC, b.id DESC
     LIMIT $porPagina OFFSET " . ((paginaPedida() - 1) * $porPagina));
$st->execute($p);

responder(['total' => $total, 'por_pagina' => $porPagina, 'acciones' => $ACCIONES, 'filas' => $st->fetchAll()]);
