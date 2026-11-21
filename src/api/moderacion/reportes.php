<?php
// GET api/moderacion/reportes.php  → reportes pendientes, agrupados por comentario
//   [{ comentario: { id, texto, estado, creado, autor, autor_id, autor_rol, profesor, materia },
//      reportes:   [{ motivo, reportante, creado }] }]
// Solo moderadores y administradores.
require __DIR__ . '/../../lib/comentarios.php';

header('Cache-Control: no-store');
exigirModerador();

$st = db()->query(
    "SELECT c.id, c.texto, c.estado, us.alias AS autor, c.usuario AS autor_id, us.rol AS autor_rol,
            us.baneado AS autor_baneado,
            CASE WHEN us.suspendido_hasta > now() THEN to_char(us.suspendido_hasta AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') END AS autor_suspendido,
            p.nombre AS profesor, m.nombre AS materia,
            to_char(c.creado AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') AS creado,
            r.motivo, ru.alias AS reportante,
            to_char(r.creado AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') AS reportado
     FROM reporte r
     JOIN comentario c ON c.id = r.comentario
     JOIN profesor p   ON p.id = c.profesor
     JOIN materia m    ON m.clave = c.materia
     LEFT JOIN usuario us ON us.id = c.usuario
     LEFT JOIN usuario ru ON ru.id = r.reportante
     WHERE r.estado = 'pendiente'
     ORDER BY min(r.creado) OVER (PARTITION BY c.id), c.id, r.creado");

$res = [];
foreach ($st as $f) {
    $k = (int)$f['id'];
    if (!isset($res[$k])) {
        $res[$k] = ['comentario' => [
            'id' => $k, 'texto' => $f['texto'], 'estado' => $f['estado'], 'creado' => $f['creado'],
            'autor' => $f['autor'], 'autor_id' => $f['autor_id'] === null ? null : (int)$f['autor_id'],
            'autor_rol' => $f['autor_rol'], 'autor_baneado' => (bool)$f['autor_baneado'],
            'autor_suspendido' => $f['autor_suspendido'],
            'profesor' => $f['profesor'], 'materia' => $f['materia'],
        ], 'reportes' => []];
    }
    $res[$k]['reportes'][] = ['motivo' => $f['motivo'], 'reportante' => $f['reportante'], 'creado' => $f['reportado']];
}
responder(array_values($res));
