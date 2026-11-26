<?php
// =====================================================================
//  carga.php: el HTML de SAES → la base.
// =====================================================================
//  Lo usan los dos caminos, para que la regla viva en un solo lugar:
//   · la terminal: importador/horarios.php y importador/cupos.php, que
//     leen los archivos de data/{isc,ia,lcd}/;
//   · el panel de Admin: src/api/admin/horarios.php, con los archivos
//     que el admin sube desde el navegador (usuario, 2026-11-25). Esos
//     NO se guardan en disco: se parsean y se cargan.
//
//  Por eso las funciones reciben el HTML **ya leído** (texto), no rutas,
//  y devuelven un reporte (arreglo) con lo mismo que imprimía la
//  terminal: quien llama decide si lo pinta como texto o lo manda como
//  JSON. Lanzan InvalidArgumentException (datos mal) o RuntimeException
//  (el periodo no existe); el resto de los problemas van en 'avisos'.
//
//  Cada función abre y cierra su propia transacción (todo o nada), así
//  que no se pueden anidar: el panel corre horarios y luego cupos, igual
//  que si corrieras los dos comandos.
// =====================================================================

require_once __DIR__ . '/comun.php';

//  Carrera → letra que SAES usa en el código de grupo (6CV3 = ISC).
const CARRERAS_SAES = ['ISC' => 'C', 'IA' => 'B', 'LCD' => 'A'];

function periodoValido(string $periodo): bool
{
    return (bool)preg_match('#^\d{2}/[12]$#', $periodo);
}

function exigirPeriodo(PDO $pdo, string $periodo): void
{
    if (!periodoValido($periodo)) {
        throw new InvalidArgumentException('El periodo se escribe como 27/1.');
    }
    $st = $pdo->prepare('SELECT 1 FROM periodo WHERE codigo = ?');
    $st->execute([$periodo]);
    if (!$st->fetch()) {
        throw new RuntimeException("El periodo $periodo no existe todavía: créalo primero.");
    }
}

// Las filas de la tabla de horarios de SAES. Cada una trae 11 celdas:
//   grupo · materia · profesor · edificio · salón · lun · mar · mié · jue · vie · sáb
// y cada día puede traer uno o varios rangos "10:30-12:00".
function filasDeHorario(string $html): array
{
    $filas = [];
    foreach (explode('</tr>', $html) as $tr) {
        preg_match_all('#<td[^>]*>(.*?)</td>#s', $tr, $m);
        $tds = array_map(function ($celda) {
            $t = html_entity_decode(strip_tags($celda), ENT_QUOTES | ENT_HTML5, 'UTF-8');
            return trim(str_replace("\u{00A0}", ' ', $t));
        }, $m[1]);
        if (count($tds) >= 11 && preg_match('/^[1-8][ABC][MVX][1-9]\d?$/', $tds[0])) {
            $filas[] = $tds;
        }
    }
    return $filas;
}

// Las filas de la tabla "Ocupabilidad" de SAES, con 7 columnas:
//   grupo · clave · nombre · semestre · cupo · inscritos · disponibles
function filasDeCupos(string $html): array
{
    $filas = [];
    foreach (explode('</tr>', $html) as $tr) {
        preg_match_all('#<td[^>]*>(.*?)</td>#s', $tr, $m);
        $t = array_map(fn($c) => trim(html_entity_decode(strip_tags($c), ENT_QUOTES | ENT_HTML5, 'UTF-8')), $m[1]);
        if (count($t) >= 7 && preg_match('/^[1-8][ABC][MVX][1-9]\d?$/', $t[0])) {
            $filas[] = $t;
        }
    }
    return $filas;
}

// ---------------------------------------------------------------------
//  Horarios: ofertas, sesiones y profes nuevos.
// ---------------------------------------------------------------------
//  $html = ['ISC' => ['m' => '<tr>…', 'v' => '…'], 'IA' => […], …]
//  Lo que no venga en el arreglo no se toca.
//
//  Se puede correr las veces que quieras: lo que ya está en la base no
//  se duplica ni se pisa (así no se pierden las correcciones hechas en
//  pgAdmin). Solo agrega lo nuevo y avisa qué no pudo cruzar.
function cargarHorarios(PDO $pdo, string $periodo, array $html): array
{
    exigirPeriodo($pdo, $periodo);
    $avisos = [];
    $aviso = function (string $s) use (&$avisos): void { $avisos[] = $s; };

    // 1. Lo que ya hay en la base.
    $porSaes = [];      // "CARRERA|semestre|NOMBRE" → clave (ver buscarClave en comun.php)
    $seOfrece = [];
    foreach ($pdo->query('SELECT clave, carrera, semestre, nombre_saes, se_ofrece FROM materia') as $m) {
        $porSaes["{$m['carrera']}|{$m['semestre']}|" . norm($m['nombre_saes'])] = $m['clave'];
        $seOfrece[$m['clave']] = $m['se_ofrece'];
    }
    $profes = [];       // nombre_norm → id
    foreach ($pdo->query('SELECT id, nombre_norm FROM profesor') as $p) {
        $profes[$p['nombre_norm']] = $p['id'];
    }

    // 2. Leer el HTML.
    $ofertas = [];      // "grupo|clave|profe" → oferta (las filas repetidas se juntan)
    $leidas = [];
    $sinCruzar = [];
    $EXCLUIR = excluidas($periodo);   // data/excluir.csv
    $saltadas = [];
    foreach (CARRERAS_SAES as $car => $letra) {
        $leidas[$car] = 0;
        foreach (['m', 'v'] as $turno) {
            $contenido = $html[$car][$turno] ?? '';
            if (trim($contenido) === '') { continue; }        // no se mandó: esa carrera y turno no se tocan
            foreach (filasDeHorario($contenido) as $f) {
                $leidas[$car]++;
                [$grupo, $materia, $profe, $edificio, $salon] = $f;
                if ($grupo[1] !== $letra) { $aviso("$car: el grupo $grupo no es de esta carrera"); }

                [$clave, $como] = buscarClave($porSaes, $car, $grupo, $materia);
                if ($clave === null) { $sinCruzar[] = "$car $grupo «{$materia}»"; continue; }
                if (isset($EXCLUIR["$grupo|$clave"])) { $saltadas["$grupo $clave"] = $EXCLUIR["$grupo|$clave"]; continue; }
                if ($como !== 'exacto') { $aviso("$grupo «{$materia}» → $clave ($como)"); }
                if (!$seOfrece[$clave]) { $aviso("$grupo ofrece $clave, la clave que NO marca el PDF de optativas"); }

                $pn = norm($profe);
                if ($pn === '' || $pn === 'SIN ASIGNAR') { $pn = null; }

                $k = "$grupo|$clave|$pn";
                $ofertas[$k] ??= [
                    'car' => $car, 'grupo' => $grupo, 'clave' => $clave,
                    'profe' => $pn, 'nombre' => preg_replace('/\s+/u', ' ', trim($profe)),
                    'edificio' => lugar($edificio), 'salon' => lugar($salon), 'ses' => [],
                ];
                for ($d = 0; $d < 6; $d++) {
                    foreach (preg_split('/\s+/', $f[5 + $d], -1, PREG_SPLIT_NO_EMPTY) as $rango) {
                        if (!preg_match('/^\d{2}:\d{2}-\d{2}:\d{2}$/', $rango)) { continue; }
                        $bs = bloquesDe($rango);
                        if (!$bs) { $aviso("$grupo $clave día " . ($d + 1) . " $rango: no cabe en ningún bloque"); }
                        if (count($bs) > 1) { $aviso("$grupo $clave día " . ($d + 1) . " $rango: partido en bloques " . implode(' + ', $bs)); }
                        foreach ($bs as $b) { $ofertas[$k]['ses'][($d + 1) . "|$b"] = [$d + 1, $b]; }
                    }
                }
            }
        }
    }

    // 3. Guardar (todo o nada).
    $insProfe  = $pdo->prepare('INSERT INTO profesor (nombre, nombre_norm) VALUES (?, ?) RETURNING id');
    $hayGrupo  = $pdo->prepare('SELECT 1 FROM oferta WHERE periodo = ? AND grupo = ? AND materia = ?');
    $insOferta = $pdo->prepare(
        'INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon) VALUES (?, ?, ?, ?, ?, ?)
         ON CONFLICT (periodo, grupo, materia, profesor) DO NOTHING RETURNING id');
    $insSesion = $pdo->prepare('INSERT INTO sesion (oferta, dia, bloque) VALUES (?, ?, ?)');

    $nuevas = array_fill_keys(array_keys(CARRERAS_SAES), 0);
    $yaEstaban = 0;
    $profesNuevos = [];
    $nSesiones = 0;

    $pdo->beginTransaction();
    foreach ($ofertas as $o) {
        $idProfe = null;
        if ($o['profe'] !== null) {
            if (!isset($profes[$o['profe']])) {
                $insProfe->execute([$o['nombre'], $o['profe']]);
                $profes[$o['profe']] = $insProfe->fetchColumn();
                $profesNuevos[] = $o['profe'];
            }
            $idProfe = $profes[$o['profe']];
        } else {
            // Sin profesor: si ese grupo ya tiene esa materia (quizá ya le pusiste
            // profe a mano en pgAdmin), no se agrega otra vez.
            $hayGrupo->execute([$periodo, $o['grupo'], $o['clave']]);
            if ($hayGrupo->fetch()) { $yaEstaban++; continue; }
        }

        $insOferta->execute([$periodo, $o['grupo'], $o['clave'], $idProfe, $o['edificio'], $o['salon']]);
        $id = $insOferta->fetchColumn();
        if ($id === false) { $yaEstaban++; continue; }

        $nuevas[$o['car']]++;
        foreach ($o['ses'] as [$dia, $bloque]) {
            $insSesion->execute([$id, $dia, $bloque]);
            $nSesiones++;
        }
    }
    $pdo->commit();

    // 4. Reporte. Profes nuevos que se parecen a uno que ya estaba: mismo
    // inicio, o iguales quitando títulos como "ING." o "M. EN A.P.". NO se
    // juntan solos: hay que revisarlos.
    $sinTitulos = fn($n) => trim(preg_replace('/\s+/', ' ', preg_replace('/(^|\s)(M\. EN [A-Z.]+|[A-Z]{1,4}\.)(?=\s|$)/', ' ', $n)));
    $parecidos = [];
    foreach ($profesNuevos as $nuevo) {
        foreach (array_keys($profes) as $viejo) {
            if ($viejo === $nuevo) { continue; }
            if (str_starts_with($viejo, "$nuevo ") || str_starts_with($nuevo, "$viejo ")
                || $sinTitulos($viejo) === $sinTitulos($nuevo)) {
                $parecidos[] = "«{$nuevo}» (nuevo)  ≈  «{$viejo}»";
            }
        }
    }

    $cuenta = function (string $sql) use ($pdo, $periodo) {
        $st = $pdo->prepare($sql);
        $st->execute([$periodo]);
        return (int)$st->fetchColumn();
    };

    return [
        'periodo'       => $periodo,
        'leidas'        => $leidas,
        'nuevas'        => $nuevas,
        'yaEstaban'     => $yaEstaban,
        'sesiones'      => $nSesiones,
        'profesNuevos'  => $profesNuevos,
        'saltadas'      => $saltadas,
        'sinCruzar'     => $sinCruzar,
        'parecidos'     => $parecidos,
        'avisos'        => $avisos,
        'base'          => [
            'ofertas'        => $cuenta('SELECT count(*) FROM oferta WHERE periodo = ?'),
            'sesiones'       => $cuenta('SELECT count(*) FROM sesion s JOIN oferta o ON o.id = s.oferta WHERE o.periodo = ?'),
            'profesConClase' => $cuenta('SELECT count(DISTINCT profesor) FROM oferta WHERE periodo = ?'),
            'sinProfesor'    => $cuenta('SELECT count(*) FROM oferta WHERE periodo = ? AND profesor IS NULL'),
            'profesores'     => (int)$pdo->query('SELECT count(*) FROM profesor')->fetchColumn(),
        ],
    ];
}

// ---------------------------------------------------------------------
//  Cupos: la tabla "Ocupabilidad" de SAES, con 7 columnas:
//    grupo · clave · nombre · semestre · cupo · inscritos · disponibles
// ---------------------------------------------------------------------
//  $html = ['ISC' => '<tr>…', 'IA' => '…', …]; lo que no venga no se toca.
//
//  A diferencia de los horarios, aquí SAES SÍ pisa lo que haya: los
//  inscritos cambian todo el tiempo, así que cada corrida deja la tabla
//  cupo igual que el HTML.
function cargarCupos(PDO $pdo, string $periodo, array $html): array
{
    exigirPeriodo($pdo, $periodo);
    $avisos = [];

    $materias = [];
    foreach ($pdo->query('SELECT clave, carrera FROM materia') as $m) {
        $materias[$m['clave']] = $m['carrera'];
    }

    // 1. Leer el HTML.
    $filas = [];
    $leidas = [];
    $EXCLUIR = excluidas($periodo);   // data/excluir.csv
    $saltadas = [];
    foreach (CARRERAS_SAES as $car => $letra) {
        $leidas[$car] = 0;
        $contenido = $html[$car] ?? '';
        if (trim($contenido) === '') { continue; }
        foreach (filasDeCupos($contenido) as $t) {
            $leidas[$car]++;
            [$grupo, $clave, $nombre, , $cupo, $inscritos, $disponibles] = $t;

            if ($grupo[1] !== $letra)                 { $avisos[] = "$car: el grupo $grupo no es de esta carrera"; }
            if (($materias[$clave] ?? null) !== $car) { $avisos[] = "$grupo $clave «{$nombre}»: esa clave no es de $car; no se carga"; continue; }
            if (isset($EXCLUIR["$grupo|$clave"])) { $saltadas[] = "$grupo $clave"; continue; }
            if ((int)$cupo - (int)$inscritos !== (int)$disponibles) {
                $avisos[] = "$grupo $clave: cupo $cupo − inscritos $inscritos no da los $disponibles disponibles";
            }
            $k = "$grupo|$clave";
            if (isset($filas[$k])) { $avisos[] = "$grupo $clave viene dos veces; se queda la última"; }
            $filas[$k] = [$grupo, $clave, (int)$cupo, (int)$inscritos];
        }
    }

    // 2. Guardar (todo o nada).
    $antes = [];
    $st = $pdo->prepare('SELECT grupo, materia, cupo, inscritos FROM cupo WHERE periodo = ?');
    $st->execute([$periodo]);
    foreach ($st as $r) {
        $antes["{$r['grupo']}|{$r['materia']}"] = [(int)$r['cupo'], (int)$r['inscritos']];
    }

    $guardar = $pdo->prepare(
        'INSERT INTO cupo (periodo, grupo, materia, cupo, inscritos) VALUES (?, ?, ?, ?, ?)
         ON CONFLICT (periodo, grupo, materia) DO UPDATE SET cupo = EXCLUDED.cupo, inscritos = EXCLUDED.inscritos');

    $nuevos = $cambiaron = $iguales = 0;
    $pdo->beginTransaction();
    foreach ($filas as $k => [$grupo, $clave, $cupo, $inscritos]) {
        if (!isset($antes[$k]))                     { $nuevos++; }
        elseif ($antes[$k] !== [$cupo, $inscritos]) { $cambiaron++; }
        else                                        { $iguales++; continue; }
        $guardar->execute([$periodo, $grupo, $clave, $cupo, $inscritos]);
    }
    $pdo->commit();

    // 3. Reporte.
    $lista = function (string $sql) use ($pdo, $periodo): array {
        $st = $pdo->prepare($sql);
        $st->execute([$periodo, $periodo]);
        return $st->fetchAll(PDO::FETCH_COLUMN);
    };
    $sinOferta = $lista(
        "SELECT c.grupo || ' ' || c.materia || ' (cupo ' || c.cupo || ')' FROM cupo c
         WHERE c.periodo = ? AND NOT EXISTS (SELECT 1 FROM oferta o
               WHERE o.periodo = ? AND o.grupo = c.grupo AND o.materia = c.materia) ORDER BY 1");
    $sinCupo = $lista(
        "SELECT DISTINCT o.grupo || ' ' || o.materia FROM oferta o
         WHERE o.periodo = ? AND NOT EXISTS (SELECT 1 FROM cupo c
               WHERE c.periodo = ? AND c.grupo = o.grupo AND c.materia = o.materia) ORDER BY 1");

    $st = $pdo->prepare('SELECT count(*), count(*) FILTER (WHERE inscritos > cupo) FROM cupo WHERE periodo = ?');
    $st->execute([$periodo]);
    [$total, $sobre] = $st->fetch(PDO::FETCH_NUM);

    return [
        'periodo'   => $periodo,
        'leidas'    => $leidas,
        'nuevos'    => $nuevos,
        'cambiaron' => $cambiaron,
        'iguales'   => $iguales,
        'saltadas'  => $saltadas,
        'sinOferta' => $sinOferta,
        'sinCupo'   => $sinCupo,
        'avisos'    => $avisos,
        'base'      => ['cupos' => (int)$total, 'sobrecupo' => (int)$sobre],
    ];
}
