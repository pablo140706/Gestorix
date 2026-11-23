<?php
// =====================================================================
//  Comentarios: validación y lectura (CLAUDE.md §6).
// =====================================================================
//  · Cualquiera con cuenta comenta sobre un profesor, con la etiqueta de
//    una materia que ese profesor ha dado (está en sus ofertas).
//  · Escalas de MisProfesores: calidad y dificultad enteros de 0 a 10,
//    recomienda sí/no. NUNCA se promedian con las de MisProfesores.
//  · Máximo 500 caracteres. Rúbrica opcional: si se llena, hasta 6
//    conceptos que suman exactamente 100 %.
//  · El autor edita o borra solo en las primeras 24 horas.
//  · Un comentario oculto solo lo ven su autor (marcado) y los moderadores.
// =====================================================================

require_once __DIR__ . '/sesion.php';
require_once __DIR__ . '/groserias.php';

const TEXTO_MAX = 500;
const RUBRICA_MAX = 6;
const CONCEPTO_MAX = 40;
const HORAS_PARA_EDITAR = 24;

const MOTIVOS_REPORTE = [
    'Ataque personal',
    'Acusación sin sustento',
    'Datos personales',
    'Odio o amenaza',
    'Spam o no habla de la clase',
    'Otro',
];

function enteroEntre($v, int $min, int $max, string $campo): int
{
    if (!is_numeric($v) || (int)$v != $v || $v < $min || $v > $max) {
        fallar(400, "$campo debe ser un entero de $min a $max.");
    }
    return (int)$v;
}

// Texto limpio: sin caracteres de control (salvo saltos de línea), sin
// espacios de sobra al inicio y al final.
function limpiarTexto($s): string
{
    $s = str_replace("\r\n", "\n", (string)$s);
    $s = preg_replace('/[^\P{C}\n]/u', '', $s);
    return trim($s);
}

// Valida lo que manda el formulario y regresa los datos listos para la base.
function leerComentario(array $d, int $profesor): array
{
    $pdo = db();

    $materia = (string)($d['materia'] ?? '');
    $st = $pdo->prepare('SELECT 1 FROM oferta WHERE profesor = ? AND materia = ? LIMIT 1');
    $st->execute([$profesor, $materia]);
    if (!$st->fetch()) { fallar(400, 'Elige una de las materias que da este profesor.'); }

    $texto = limpiarTexto($d['texto'] ?? '');
    if ($texto === '') { fallar(400, 'Escribe tu comentario.'); }
    if (mb_strlen($texto) > TEXTO_MAX) { fallar(400, 'El comentario es de máximo ' . TEXTO_MAX . ' caracteres.'); }
    exigirSinGroserias($texto, 'Tu comentario');

    if (!is_bool($d['recomienda'] ?? null)) { fallar(400, 'Di si lo recomiendas o no.'); }

    $rubrica = $d['rubrica'] ?? [];
    if (!is_array($rubrica) || count($rubrica) > RUBRICA_MAX) {
        fallar(400, 'La rúbrica lleva máximo ' . RUBRICA_MAX . ' conceptos.');
    }
    $filas = [];
    $suma = 0;
    foreach ($rubrica as $r) {
        $concepto = limpiarTexto(is_array($r) ? ($r['concepto'] ?? '') : '');
        $concepto = preg_replace('/\s+/u', ' ', $concepto);
        if ($concepto === '' || mb_strlen($concepto) > CONCEPTO_MAX) {
            fallar(400, 'Cada concepto de la rúbrica lleva de 1 a ' . CONCEPTO_MAX . ' caracteres.');
        }
        exigirSinGroserias($concepto, 'La rúbrica');
        $llave = mb_strtolower($concepto);
        if (isset($filas[$llave])) { fallar(400, "«{$concepto}» está repetido en la rúbrica."); }
        $pct = enteroEntre($r['porcentaje'] ?? null, 1, 100, "El porcentaje de «{$concepto}»");
        $filas[$llave] = [$concepto, $pct];
        $suma += $pct;
    }
    if ($filas && $suma !== 100) { fallar(400, "La rúbrica suma $suma %: tiene que sumar 100 %."); }

    return [
        'materia'    => $materia,
        'calidad'    => enteroEntre($d['calidad'] ?? null, 0, 10, 'La calidad'),
        'recomienda' => $d['recomienda'],
        'dificultad' => enteroEntre($d['dificultad'] ?? null, 0, 10, 'La dificultad'),
        'texto'      => $texto,
        'rubrica'    => array_values($filas),
    ];
}

function guardarRubrica(int $comentario, array $rubrica): void
{
    $pdo = db();
    $pdo->prepare('DELETE FROM rubrica WHERE comentario = ?')->execute([$comentario]);
    $ins = $pdo->prepare('INSERT INTO rubrica (comentario, concepto, porcentaje) VALUES (?, ?, ?)');
    foreach ($rubrica as [$concepto, $pct]) { $ins->execute([$comentario, $concepto, $pct]); }
}

// Un comentario propio que todavía se puede editar o borrar, o un error.
function exigirComentarioPropio(int $id, array $u): array
{
    $st = db()->prepare(
        'SELECT id, profesor, estado, anonimo, creado > now() - make_interval(hours => ?) AS a_tiempo
         FROM comentario WHERE id = ? AND usuario = ?');
    $st->execute([HORAS_PARA_EDITAR, $id, $u['id']]);
    $c = $st->fetch() ?: fallar(404, 'Ese comentario no existe o no es tuyo.');
    if ($c['estado'] !== 'visible') { fallar(403, 'Un moderador ocultó este comentario: ya no se puede cambiar.'); }
    if (!$c['a_tiempo']) { fallar(403, 'Solo puedes editar o borrar tu comentario en las primeras ' . HORAS_PARA_EDITAR . ' horas.'); }
    return $c;
}

// Comentarios de un profesor que $u puede ver, del más nuevo al más viejo.
function comentariosDe(int $profesor, ?array $u): array
{
    $pdo = db();
    $yo = $u['id'] ?? 0;
    // Un moderador solo ve ocultos y datos para moderar en las carreras que modera.
    $carreras = arregloPg(carrerasQueModera($u));

    $st = $pdo->prepare(
        "SELECT c.id, c.usuario, us.alias, c.anonimo, us.rol AS autor_rol, c.materia, m.nombre AS materia_nombre,
                c.calidad, c.recomienda, c.dificultad, c.texto, c.estado,
                to_char(c.creado  AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') AS creado,
                to_char(c.editado AT TIME ZONE 'America/Mexico_City', 'DD/MM/YYYY HH24:MI') AS editado,
                c.creado > now() - make_interval(hours => :horas) AS a_tiempo,
                EXISTS (SELECT 1 FROM reporte r WHERE r.comentario = c.id AND r.reportante = :yo1
                                                  AND r.estado = 'pendiente') AS ya_reportado,
                (SELECT count(*) FROM reporte r WHERE r.comentario = c.id AND r.estado = 'pendiente') AS reportes,
                m.carrera = ANY (CAST(:carreras AS text[])) AS moderable
         FROM comentario c
         JOIN materia m ON m.clave = c.materia
         LEFT JOIN usuario us ON us.id = c.usuario
         WHERE c.profesor = :profesor
           AND (c.estado = 'visible' OR c.usuario = :yo2 OR m.carrera = ANY (CAST(:carreras2 AS text[])))
         ORDER BY c.creado DESC, c.id DESC");
    // PDO no deja repetir un parámetro con nombre: por eso :yo1 y :yo2.
    $st->execute(['horas' => HORAS_PARA_EDITAR, 'yo1' => $yo, 'yo2' => $yo,
                  'carreras' => $carreras, 'carreras2' => $carreras, 'profesor' => $profesor]);
    $filas = $st->fetchAll();

    $rub = [];
    if ($filas) {
        $ids = '{' . implode(',', array_column($filas, 'id')) . '}';
        $sr = $pdo->prepare('SELECT comentario, concepto, porcentaje FROM rubrica WHERE comentario = ANY (?::int[])
                             ORDER BY comentario, porcentaje DESC, concepto');
        $sr->execute([$ids]);
        foreach ($sr as $r) { $rub[$r['comentario']][] = ['concepto' => $r['concepto'], 'porcentaje' => (int)$r['porcentaje']]; }
    }

    return array_map(function ($c) use ($yo, $rub) {
        $mod = (bool)$c['moderable'];
        $mio = $yo && (int)$c['usuario'] === $yo;
        $fila = [
            'id'         => (int)$c['id'],
            // Anónimo: su nombre al azar en vez del alias (el dueño sigue siendo c.usuario).
            'autor'      => $c['anonimo'] ?? $c['alias'],      // null = usuario eliminado
            'anonimo'    => $c['anonimo'] !== null,
            'materia'    => ['clave' => $c['materia'], 'nombre' => $c['materia_nombre']],
            'calidad'    => (int)$c['calidad'],
            'recomienda' => (bool)$c['recomienda'],
            'dificultad' => (int)$c['dificultad'],
            'texto'      => $c['texto'],
            'rubrica'    => $rub[$c['id']] ?? [],
            'creado'     => $c['creado'],
            'editado'    => $c['editado'],
            'estado'     => $c['estado'],
            'mio'        => $mio,
            'editable'   => $mio && $c['a_tiempo'] && $c['estado'] === 'visible',
            'reportado'  => (bool)$c['ya_reportado'],
            'moderable'  => $mod,                           // ¿quién pregunta puede moderar este?
        ];
        if ($mod) {                                            // para moderar, no para mostrar
            $fila['autor_id'] = $c['usuario'] === null ? null : (int)$c['usuario'];
            $fila['autor_rol'] = $c['autor_rol'];
            if ($c['anonimo'] !== null) { $fila['autor_real'] = $c['alias']; }   // quién es el anónimo
            $fila['reportes'] = (int)$c['reportes'];
        }
        return $fila;
    }, $filas);
}
