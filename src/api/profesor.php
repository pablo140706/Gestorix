<?php
// =====================================================================
//  GET api/profesor.php?nombre=…  → la ficha del profesor (Fase 4)
// =====================================================================
//  { profesor:    { id, nombre, cedulas: [{ numero, nivel }] },
//    materias:    [{ clave, nombre, carrera }]   ← las que ha dado: etiquetas para comentar
//    resumen:     { comentarios, calidad, recomienda, dificultad }  ← solo los visibles
//    comentarios: [ ver comentariosDe() ],
//    yo:          { sesion, puede_comentar, suspendido_hasta, moderador } }
//
//  El nombre es el que usa el front (sale de la misma tabla profesor). Las
//  métricas de MisProfesores NO vienen aquí: el front ya las tiene, y van
//  lado a lado con el resumen de los comentarios, nunca promediadas.
//  No se guarda en caché: trae datos de quien la pide (sus comentarios
//  ocultos, si ya reportó…).
// =====================================================================

require __DIR__ . '/../lib/comentarios.php';

header('Cache-Control: no-store');
$pdo = db();
$u = usuarioActual();

$nombre = trim((string)($_GET['nombre'] ?? ''));
$st = $pdo->prepare('SELECT id, nombre FROM profesor WHERE nombre = ?');
$st->execute([$nombre]);
$p = $st->fetch() ?: fallar(404, 'No encontramos a ese profesor.');
$id = (int)$p['id'];

// Cédulas (tabla cedula), del grado más alto al más bajo.
$st = $pdo->prepare(
    "SELECT numero, nivel FROM cedula WHERE profesor = ?
     ORDER BY array_position(ARRAY['doctorado','especialidad','maestria','ingenieria','licenciatura'], nivel::text), numero");
$st->execute([$id]);
$cedulas = $st->fetchAll();

$st = $pdo->prepare(
    'SELECT DISTINCT m.clave, m.nombre, m.carrera, m.semestre
     FROM oferta o JOIN materia m ON m.clave = o.materia
     WHERE o.profesor = ?
     ORDER BY m.carrera, m.semestre, m.nombre');
$st->execute([$id]);
$materias = array_map(fn($m) => ['clave' => $m['clave'], 'nombre' => $m['nombre'], 'carrera' => $m['carrera']],
                      $st->fetchAll());

// Promedios de los comentarios propios (no los de MisProfesores).
$st = $pdo->prepare(
    "SELECT count(*) AS n, round(avg(calidad), 1) AS calidad, round(100.0 * avg(recomienda::int)) AS recomienda,
            round(avg(dificultad), 1) AS dificultad
     FROM comentario WHERE profesor = ? AND estado = 'visible'");
$st->execute([$id]);
$r = $st->fetch();
$num = fn($v) => $v === null ? null : (float)$v;

responder([
    'profesor' => ['id' => $id, 'nombre' => $p['nombre'], 'cedulas' => $cedulas],
    'materias' => $materias,
    'resumen' => [
        'comentarios' => (int)$r['n'],
        'calidad'     => $num($r['calidad']),
        'recomienda'  => $num($r['recomienda']),       // % de "sí"
        'dificultad'  => $num($r['dificultad']),
    ],
    'comentarios' => comentariosDe($id, $u),
    'yo' => [
        'sesion'           => $u !== null,
        'puede_comentar'   => $u !== null && !$u['suspendido_hasta'],
        'suspendido_hasta' => $u['suspendido_hasta'] ?? null,
        'moderador'        => esModerador($u),
    ],
]);
