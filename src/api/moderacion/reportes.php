<?php
// GET api/moderacion/reportes.php  → reportes pendientes, agrupados por comentario
//   [{ comentario: { id, texto, estado, creado, carrera, autor (alias real), anonimo (nombre al azar o null),
//                    autor_id, autor_rol, profesor, materia },
//      reportes:   [{ motivo, reportante, creado }] }]
// Solo moderadores y administradores, y solo de las carreras que moderan.
require __DIR__ . '/../../lib/comentarios.php';

header('Cache-Control: no-store');
$carreras = arregloPg(carrerasQueModera(exigirModerador()));   // solo las carreras que moderas

$st = db()->prepare(
    "SELECT c.id, c.texto, c.estado, c.anonimo, m.carrera, us.alias AS autor, c.usuario AS autor_id, us.rol AS autor_rol,
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
     WHERE r.estado = 'pendiente' AND m.carrera = ANY (?::text[])
     ORDER BY min(r.creado) OVER (PARTITION BY c.id), c.id, r.creado");
$st->execute([$carreras]);

$res = [];
foreach ($st as $f) {
    $k = (int)$f['id'];
    if (!isset($res[$k])) {
        $res[$k] = ['comentario' => [
            'id' => $k, 'texto' => $f['texto'], 'estado' => $f['estado'], 'creado' => $f['creado'],
            'anonimo' => $f['anonimo'], 'carrera' => $f['carrera'],
            'autor' => $f['autor'], 'autor_id' => $f['autor_id'] === null ? null : (int)$f['autor_id'],
            'autor_rol' => $f['autor_rol'], 'autor_baneado' => (bool)$f['autor_baneado'],
            'autor_suspendido' => $f['autor_suspendido'],
            'profesor' => $f['profesor'], 'materia' => $f['materia'],
        ], 'reportes' => []];
    }
    $res[$k]['reportes'][] = ['motivo' => $f['motivo'], 'reportante' => $f['reportante'], 'creado' => $f['reportado']];
}
responder(array_values($res));
