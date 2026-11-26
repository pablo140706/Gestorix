<?php
// =====================================================================
//  Lo que comparten los endpoints de src/api/.
// =====================================================================
//  Cada endpoint hace:   require __DIR__ . '/../lib/api.php';
//  arma un arreglo con los datos y termina con responder($datos).
//
//  La API reemplaza los .js de datos de iscweb (planes.js, schedule.js…)
//  y regresa los datos CON LA MISMA FORMA que tenían, para que el front
//  casi no cambie. src/arranque.js es quien los pide.
// =====================================================================

require_once __DIR__ . '/db.php';

// Si algo truena, el navegador recibe un error en JSON sin detalles; el
// detalle va al log de Apache (docker compose logs web).
set_exception_handler(function (Throwable $e): void {
    error_log('API ' . ($_SERVER['SCRIPT_NAME'] ?? '') . ': ' . $e->getMessage());
    if (!headers_sent()) {
        http_response_code(500);
        header('Content-Type: application/json; charset=utf-8');
    }
    echo json_encode(['error' => 'No se pudieron leer los datos.']);
});

// Manda el JSON con ETag, para que una visita repetida no vuelva a bajar lo
// mismo (medido el 2026-11-26: eran ~267 KB en cada carga solo para pintar).
// Apache manda Cache-Control: no-cache para todo src/, así que el navegador
// SIEMPRE pregunta; con ETag esa pregunta se contesta con un 304 vacío cuando
// los datos no cambiaron, y con el JSON completo cuando sí.
//
// Ojo con mod_deflate: al comprimir le pega "-gzip" al ETag, y el navegador
// devuelve esa versión. Por eso se compara sin el sufijo; si no, nunca
// coincidiría y siempre se mandaría todo.
function responder($datos): void
{
    $cuerpo = json_encode($datos, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_THROW_ON_ERROR);
    $etag = '"' . md5($cuerpo) . '"';

    header('Content-Type: application/json; charset=utf-8');
    header('ETag: ' . $etag);

    $recibido = $_SERVER['HTTP_IF_NONE_MATCH'] ?? '';
    foreach (explode(',', $recibido) as $candidato) {
        $candidato = trim($candidato);
        $candidato = preg_replace('/^W\//', '', $candidato);          // ETag débil
        $candidato = preg_replace('/-(gzip|br)"$/', '"', $candidato); // el sufijo de mod_deflate
        if ($candidato === $etag) {
            http_response_code(304);
            return;
        }
    }
    echo $cuerpo;
}

// El periodo vigente es el más reciente que tiene ofertas. Los códigos
// "AA/N" se ordenan bien como texto: "27/1" > "26/2".
function periodoVigente(): string
{
    return (string)db()->query('SELECT max(periodo) FROM oferta')->fetchColumn();
}

// El front de iscweb usa "2026/2" y "2027/1" como llaves del historial y de
// los cupos viejos (maestros.js las tiene escritas así), y la base "26/2".
function periodoLargo(string $periodo): string
{
    return '20' . $periodo;
}

// Orden de las carreras en todas las listas: el de iscweb.
const ORDEN_CARRERAS = "array_position(ARRAY['ISC','IA','LCD'], %s::text)";

// Ofertas con sus sesiones, agrupadas por periodo, con la forma de los
// registros de schedule.js / historial.js:
//   { id, carrera, grupo, clave, materia, profesor, edificio, salon,
//     sesiones: [{ dia: "Lun", ini: "07:00", fin: "08:30" }, …] }
// materia es el nombre tal cual SAES (así cruza el front con el plan).
function ofertasPorPeriodo(?string $soloPeriodo = null): array
{
    $pdo = db();
    $filtro = $soloPeriodo === null ? '' : 'WHERE o.periodo = :p';
    $params = $soloPeriodo === null ? [] : ['p' => $soloPeriodo];

    $dias = [1 => 'Lun', 2 => 'Mar', 3 => 'Mie', 4 => 'Jue', 5 => 'Vie', 6 => 'Sab'];
    $sesiones = [];
    $st = $pdo->prepare(
        "SELECT s.oferta, s.dia, to_char(b.inicio, 'HH24:MI') AS ini, to_char(b.fin, 'HH24:MI') AS fin
         FROM sesion s JOIN bloque b ON b.numero = s.bloque JOIN oferta o ON o.id = s.oferta
         $filtro ORDER BY s.oferta, s.dia, s.bloque");
    $st->execute($params);
    foreach ($st as $s) {
        $sesiones[$s['oferta']][] = ['dia' => $dias[$s['dia']], 'ini' => $s['ini'], 'fin' => $s['fin']];
    }

    $res = [];
    $st = $pdo->prepare(
        "SELECT o.id, o.periodo, m.carrera, o.grupo, m.clave, m.nombre_saes AS materia,
                coalesce(p.nombre, '') AS profesor, coalesce(o.edificio, '') AS edificio, coalesce(o.salon, '') AS salon
         FROM oferta o
         JOIN materia m ON m.clave = o.materia
         LEFT JOIN profesor p ON p.id = o.profesor
         $filtro
         ORDER BY o.periodo, " . sprintf(ORDEN_CARRERAS, 'm.carrera') . ", o.grupo, m.semestre, m.tipo, m.orden, p.nombre");
    $st->execute($params);
    foreach ($st as $o) {
        $res[$o['periodo']][] = [
            'id'       => (int)$o['id'],      // el horario guardado de cada usuario apunta a este id
            'carrera'  => $o['carrera'],
            'grupo'    => $o['grupo'],
            'clave'    => $o['clave'],
            'materia'  => $o['materia'],
            'profesor' => $o['profesor'],
            'edificio' => $o['edificio'],
            'salon'    => $o['salon'],
            'sesiones' => $sesiones[$o['id']] ?? [],
        ];
    }
    return $res;
}
