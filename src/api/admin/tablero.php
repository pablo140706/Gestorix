<?php
// GET api/admin/tablero.php  → números para la pestaña Admin
//   { carreras: ["ISC", …],            las que modera quien pregunta
//     usuarios, comentarios, reportes, datos,
//     estado: { … } }                  solo para el admin
// Moderadores y admin. Los números de comentarios y reportes son solo de
// las carreras que moderas; los de usuarios y datos, de todo el sitio
// (son conteos, no dicen quién es quién).
require __DIR__ . '/../../lib/admin.php';

$u = exigirModerador();
$pdo = db();
$carreras = carrerasQueModera($u);
$pg = arregloPg($carreras);

$uno = function (string $sql, array $p = []) use ($pdo) {
    $st = $pdo->prepare($sql);
    $st->execute($p);
    return $st->fetch();
};

$usuarios = $uno(
    "SELECT count(*) FILTER (WHERE verificado) AS activas,
            count(*) FILTER (WHERE NOT verificado) AS sin_activar,
            count(*) FILTER (WHERE verificado AND creado > now() - interval '7 days') AS nuevas_7d,
            count(*) FILTER (WHERE suspendido_hasta > now()) AS suspendidas,
            count(*) FILTER (WHERE baneado) AS baneadas,
            count(*) FILTER (WHERE rol = 'moderador') AS moderadores,
            count(*) FILTER (WHERE verificado AND carrera = 'ISC') AS isc,
            count(*) FILTER (WHERE verificado AND carrera = 'IA') AS ia,
            count(*) FILTER (WHERE verificado AND carrera = 'LCD') AS lcd,
            (SELECT count(DISTINCT usuario) FROM avance) AS con_avance,
            (SELECT count(DISTINCT usuario) FROM horario) AS con_horario,
            (SELECT count(*) FROM recordatorio) AS recordatorios
     FROM usuario");

$comentarios = $uno(
    "SELECT count(*) FILTER (WHERE c.estado = 'visible') AS visibles,
            count(*) FILTER (WHERE c.estado = 'oculto') AS ocultos,
            count(*) FILTER (WHERE c.creado > now() - interval '7 days') AS nuevos_7d,
            count(*) FILTER (WHERE c.anonimo IS NOT NULL) AS anonimos
     FROM comentario c JOIN materia m ON m.clave = c.materia
     WHERE m.carrera = ANY (?::text[])", [$pg]);

$reportes = $uno(
    "SELECT count(*) FILTER (WHERE r.estado = 'pendiente') AS pendientes,
            count(DISTINCT r.comentario) FILTER (WHERE r.estado = 'pendiente') AS comentarios_reportados,
            count(*) FILTER (WHERE r.estado <> 'pendiente' AND r.creado > now() - interval '30 days') AS resueltos_30d
     FROM reporte r JOIN comentario c ON c.id = r.comentario JOIN materia m ON m.clave = c.materia
     WHERE m.carrera = ANY (?::text[])", [$pg]);

$periodo = periodoVigente();
$datos = $uno(
    "SELECT ? AS periodo,
            (SELECT count(*) FROM oferta WHERE periodo = ?) AS ofertas,
            (SELECT count(DISTINCT profesor) FROM oferta WHERE periodo = ?) AS profes_con_clase,
            (SELECT count(*) FROM profesor) AS profesores,
            (SELECT count(*) FROM materia) AS materias,
            (SELECT count(*) FROM profesor WHERE mp_calidad IS NULL) AS profes_sin_metricas",
    [$periodo, $periodo, $periodo]);

$res = ['carreras' => $carreras, 'rol' => $u['rol'],
        'usuarios' => array_map('intval', $usuarios),
        'comentarios' => array_map('intval', $comentarios),
        'reportes' => array_map('intval', $reportes),
        'datos' => $datos];

// ---------- Estado del sistema: solo el admin ----------
if ($u['rol'] === 'admin') {
    $base = $uno("SELECT split_part(version(), ' ', 2) AS version,
                         pg_size_pretty(pg_database_size(current_database())) AS tamano,
                         to_char(now() AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') AS hora");
    $respaldo = $uno("SELECT to_char(cuando AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') AS cuando
                      FROM bitacora WHERE accion = 'respaldo' ORDER BY cuando DESC LIMIT 1");

    // ¿El sitio público (ngrok) contesta? Se pide la portada por la misma
    // dirección que usan los alumnos, con 4 segundos de paciencia.
    $url = urlApp('favicon.svg');
    $ctx = stream_context_create(['http' => ['method' => 'HEAD', 'timeout' => 4, 'ignore_errors' => true,
                                             'header' => "ngrok-skip-browser-warning: 1\r\n"]]);
    $inicio = microtime(true);
    $resp = @get_headers($url, false, $ctx);
    $codigo = $resp && preg_match('/\s(\d{3})\s/', $resp[0], $m) ? (int)$m[1] : 0;

    $res['estado'] = [
        'base'      => ['ok' => true, 'version' => $base['version'], 'tamano' => $base['tamano'], 'hora' => $base['hora']],
        'sitio'     => ['url' => urlApp(), 'ok' => $codigo >= 200 && $codigo < 400, 'codigo' => $codigo,
                        'ms' => (int)round((microtime(true) - $inicio) * 1000)],
        'correo'    => ['configurado' => correoConfigurado()],
        'respaldo'  => $respaldo['cuando'] ?? null,
        'php'       => PHP_VERSION,
    ];
}

responder($res);
