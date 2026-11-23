<?php
// GET api/admin/usuarios.php?q=&rol=&pagina=1
//   → { total, por_pagina, usuarios: [{ id, correo, alias, rol, carrera, modera: [..], verificado,
//        creado, suspendido_hasta, baneado, comentarios, ocultos, alias_cambios_restantes }] }
// SOLO EL ADMIN y con la contraseña confirmada hace menos de 10 minutos:
// aquí sale el correo de cada cuenta. Ver la lista queda en la bitácora
// ("ver_correo"), una vez por cada confirmación.
require __DIR__ . '/../../lib/admin.php';

$u = exigirAdmin();
exigirConfirmado();
$porPagina = 30;

$donde = ['true'];
$p = [];
$q = trim((string)($_GET['q'] ?? ''));
if ($q !== '') {
    if (mb_strlen($q) > 60) { fallar(400, 'La búsqueda es muy larga.'); }
    $like = '%' . addcslashes(mb_strtolower($q), '%_\\') . '%';
    $donde[] = '(u.correo LIKE :q OR lower(u.alias) LIKE :q2)';
    $p += ['q' => $like, 'q2' => $like];
}
$rol = (string)($_GET['rol'] ?? '');
if (in_array($rol, ['alumno', 'moderador', 'admin'], true)) {
    $donde[] = 'u.rol = :rol';
    $p['rol'] = $rol;
}
$where = implode(' AND ', $donde);

$st = db()->prepare("SELECT count(*) FROM usuario u WHERE $where");
$st->execute($p);
$total = (int)$st->fetchColumn();

$st = db()->prepare(
    "SELECT u.id, u.correo, u.alias, u.rol, u.carrera, u.verificado, u.baneado,
            to_char(u.creado AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY') AS creado,
            " . SQL_SUSPENDIDO_HASTA . " AS suspendido_hasta,
            (SELECT count(*) FROM comentario c WHERE c.usuario = u.id) AS comentarios,
            (SELECT count(*) FROM comentario c WHERE c.usuario = u.id AND c.estado = 'oculto') AS ocultos,
            (SELECT string_agg(carrera, ',' ORDER BY " . sprintf(ORDEN_CARRERAS, 'carrera') . ")
               FROM moderador_carrera mc WHERE mc.usuario = u.id) AS modera
     FROM usuario u WHERE $where
     ORDER BY array_position(ARRAY['admin','moderador','alumno'], u.rol::text), u.creado DESC, u.id DESC
     LIMIT $porPagina OFFSET " . ((paginaPedida() - 1) * $porPagina));
$st->execute($p);
$lista = array_map(fn($f) => [
    'id' => (int)$f['id'], 'correo' => $f['correo'], 'alias' => $f['alias'], 'rol' => $f['rol'],
    'carrera' => $f['carrera'], 'modera' => $f['modera'] ? explode(',', $f['modera']) : [],
    'verificado' => (bool)$f['verificado'], 'baneado' => (bool)$f['baneado'], 'creado' => $f['creado'],
    'suspendido_hasta' => $f['suspendido_hasta'],
    'comentarios' => (int)$f['comentarios'], 'ocultos' => (int)$f['ocultos'],
    'alias_cambios_restantes' => aliasCambiosRestantes((int)$f['id']),
], $st->fetchAll());

// Una línea de bitácora por cada vez que confirmaste la contraseña y viste correos.
if (($_SESSION['correos_vistos'] ?? 0) !== $_SESSION['confirmado_hasta']) {
    $_SESSION['correos_vistos'] = $_SESSION['confirmado_hasta'];
    anotarBitacora((int)$u['id'], 'ver_correo', null, null, 'Lista de usuarios en la pestaña Admin');
}

responder(['total' => $total, 'por_pagina' => $porPagina, 'usuarios' => $lista]);
