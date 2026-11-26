<?php
// GET api/moderacion/reportes.php  → reportes pendientes, agrupados por lo reportado
//   [{ comentario: { id, tipo, respuesta_id, texto, estado, creado, carrera,
//                    autor (alias real), anonimo (nombre al azar o null),
//                    autor_id, autor_rol, profesor, materia },
//      reportes:   [{ motivo, reportante, creado }] }]
//
//  `tipo` es "comentario" o "respuesta" (2026-11-26). En los dos casos `id`
//  es el del COMENTARIO —el hilo, que es lo que abre la ficha del maestro— y
//  en las respuestas viene además `respuesta_id`, que es sobre lo que actúa
//  api/moderacion/accion.php. El texto, el estado y el autor son los de lo
//  reportado; el profesor, la materia y la carrera salen del hilo.
//
// Solo moderadores y administradores, y solo de las carreras que moderan.
require __DIR__ . '/../../lib/comentarios.php';

header('Cache-Control: no-store');
$carreras = arregloPg(carrerasQueModera(exigirModerador()));   // solo las carreras que moderas

$st = db()->prepare(
    "SELECT CASE WHEN r.respuesta IS NULL THEN 'comentario' ELSE 'respuesta' END AS tipo,
            coalesce(c.id, cp.id) AS id,
            rs.id AS respuesta_id,
            coalesce(rs.texto, c.texto)     AS texto,
            coalesce(rs.estado, c.estado)   AS estado,
            coalesce(rs.anonimo, c.anonimo) AS anonimo,
            coalesce(rs.usuario, c.usuario) AS autor_id,
            m.carrera, us.alias AS autor, us.rol AS autor_rol, us.baneado AS autor_baneado,
            CASE WHEN us.suspendido_hasta > now() THEN to_char(us.suspendido_hasta AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') END AS autor_suspendido,
            p.nombre AS profesor, m.nombre AS materia,
            to_char(coalesce(rs.creado, c.creado) AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') AS creado,
            r.motivo, ru.alias AS reportante,
            to_char(r.creado AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') AS reportado
     FROM reporte r
     LEFT JOIN comentario c  ON c.id = r.comentario
     LEFT JOIN respuesta rs  ON rs.id = r.respuesta
     LEFT JOIN comentario cp ON cp.id = rs.comentario
     JOIN profesor p   ON p.id    = coalesce(c.profesor, cp.profesor)
     JOIN materia m    ON m.clave = coalesce(c.materia, cp.materia)
     LEFT JOIN usuario us ON us.id = coalesce(rs.usuario, c.usuario)
     LEFT JOIN usuario ru ON ru.id = r.reportante
     WHERE r.estado = 'pendiente' AND m.carrera = ANY (?::text[])
     ORDER BY min(r.creado) OVER (PARTITION BY r.comentario, r.respuesta),
              coalesce(c.id, cp.id), rs.id NULLS FIRST, r.creado");
$st->execute([$carreras]);

$res = [];
foreach ($st as $f) {
    // Una respuesta reportada se agrupa aparte de su comentario.
    $k = $f['tipo'] . ':' . ($f['respuesta_id'] ?? $f['id']);
    if (!isset($res[$k])) {
        $res[$k] = ['comentario' => [
            'id' => (int)$f['id'], 'tipo' => $f['tipo'],
            'respuesta_id' => $f['respuesta_id'] === null ? null : (int)$f['respuesta_id'],
            'texto' => $f['texto'], 'estado' => $f['estado'], 'creado' => $f['creado'],
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
