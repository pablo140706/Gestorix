<?php
// GET api/admin/comentarios.php?estado=&carrera=&reportados=1&q=&pagina=1
//   → { total, por_pagina, comentarios: [{ id, carrera, profesor, materia, texto, estado, creado,
//        autor (alias real), anonimo (nombre al azar o null), autor_id, autor_rol,
//        calidad, recomienda, dificultad, reportes }] }
// Todos los comentarios, con filtros, para moderadores y admin; un
// moderador solo ve los de sus carreras. q busca en el texto, el profesor
// y el alias (real o anónimo).
require __DIR__ . '/../../lib/admin.php';

$u = exigirModerador();
$carreras = carrerasQueModera($u);
$porPagina = 30;

$donde = ['m.carrera = ANY (CAST(:carreras AS text[]))'];
$p = ['carreras' => arregloPg($carreras)];

$carrera = (string)($_GET['carrera'] ?? '');
if ($carrera !== '') {
    if (!in_array($carrera, $carreras, true)) { fallar(403, "No moderas $carrera."); }
    $donde[] = 'm.carrera = :carrera';
    $p['carrera'] = $carrera;
}
$estado = (string)($_GET['estado'] ?? '');
if (in_array($estado, ['visible', 'oculto'], true)) {
    $donde[] = 'c.estado = :estado';
    $p['estado'] = $estado;
}
if (!empty($_GET['reportados'])) {
    $donde[] = "EXISTS (SELECT 1 FROM reporte r WHERE r.comentario = c.id AND r.estado = 'pendiente')";
}
$q = trim((string)($_GET['q'] ?? ''));
if ($q !== '') {
    if (mb_strlen($q) > 60) { fallar(400, 'La búsqueda es muy larga.'); }
    // unaccent no está instalado: se compara en minúsculas. El % y el _ del usuario se escapan.
    $donde[] = '(lower(c.texto) LIKE :q OR lower(p.nombre) LIKE :q2 OR lower(us.alias) LIKE :q3 OR lower(c.anonimo) LIKE :q4)';
    $like = '%' . addcslashes(mb_strtolower($q), '%_\\') . '%';
    $p += ['q' => $like, 'q2' => $like, 'q3' => $like, 'q4' => $like];
}
$where = implode(' AND ', $donde);
$desde = "FROM comentario c
          JOIN materia m  ON m.clave = c.materia
          JOIN profesor p ON p.id = c.profesor
          LEFT JOIN usuario us ON us.id = c.usuario
          WHERE $where";

$st = db()->prepare("SELECT count(*) $desde");
$st->execute($p);
$total = (int)$st->fetchColumn();

$st = db()->prepare(
    "SELECT c.id, m.carrera, p.nombre AS profesor, m.nombre AS materia, c.texto, c.estado, c.anonimo,
            to_char(c.creado AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') AS creado,
            us.alias AS autor, c.usuario AS autor_id, us.rol AS autor_rol,
            c.calidad, c.recomienda, c.dificultad,
            (SELECT count(*) FROM reporte r WHERE r.comentario = c.id AND r.estado = 'pendiente') AS reportes
     $desde
     ORDER BY c.creado DESC, c.id DESC
     LIMIT $porPagina OFFSET " . ((paginaPedida() - 1) * $porPagina));
$st->execute($p);

$lista = array_map(fn($c) => [
    'id' => (int)$c['id'], 'carrera' => $c['carrera'], 'profesor' => $c['profesor'], 'materia' => $c['materia'],
    'texto' => $c['texto'], 'estado' => $c['estado'], 'creado' => $c['creado'],
    'autor' => $c['autor'], 'anonimo' => $c['anonimo'],
    'autor_id' => $c['autor_id'] === null ? null : (int)$c['autor_id'], 'autor_rol' => $c['autor_rol'],
    'calidad' => (int)$c['calidad'], 'recomienda' => (bool)$c['recomienda'], 'dificultad' => (int)$c['dificultad'],
    'reportes' => (int)$c['reportes'],
], $st->fetchAll());

responder(['total' => $total, 'por_pagina' => $porPagina, 'comentarios' => $lista]);
