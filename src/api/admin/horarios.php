<?php
// POST api/admin/horarios.php
//   { periodo: "27/2",
//     horarios: { ISC: { m: "<html>", v: "<html>" }, IA: {…}, LCD: {…} },   opcional
//     cupos:    { ISC: "<html>", IA: "…", LCD: "…" } }                      opcional
//   → { periodo, horarios: <reporte>|null, cupos: <reporte>|null, resumen }
// =====================================================================
//  Subir el HTML de SAES desde la app, sin terminal (usuario, 2026-11-25).
// =====================================================================
//  SOLO EL ADMIN, con la contraseña confirmada: cambia los datos que ve
//  todo el mundo (ofertas, sesiones, profes y cupos del periodo).
//
//  El HTML **no se guarda en disco** (decisión del usuario): llega, se
//  parsea y se cargan las filas. Por eso `data/` sigue montada de solo
//  lectura y no hay archivos subidos que cuidar. Si quieres el respaldo
//  del HTML original, guárdalo tú en data/<carrera>/ como siempre.
//
//  El trabajo lo hace importador/carga.php, el mismo código que corre
//  `docker compose run --rm web php importador/horarios.php 27/1`: así la
//  regla vive en un solo lugar y los dos caminos cargan igual.
//
//  Qué carrera y turno mandes es lo que se toca: lo que no venga, no se
//  toca. Los horarios solo AGREGAN (no pisan lo corregido en pgAdmin);
//  los cupos SÍ pisan, porque los inscritos cambian todo el tiempo.
// =====================================================================
require __DIR__ . '/../../lib/admin.php';
require __DIR__ . '/../../../importador/carga.php';

const MAX_ARCHIVO = 4 * 1024 * 1024;    // 4 MB por archivo (el más grande de SAES ronda 250 KB)
const MAX_TOTAL   = 16 * 1024 * 1024;   // 16 MB entre todos

$u = exigirAdmin();
exigirConfirmado();
$d = leerJson();
$pdo = db();

$periodo = (string)($d['periodo'] ?? '');
if (!periodoValido($periodo)) { fallar(400, 'El periodo se escribe como 27/1.'); }

// ---------- leer y revisar lo que llegó ----------
$total = 0;
$pedir = function ($v, string $que) use (&$total): string {
    if ($v === null || $v === '') { return ''; }
    if (!is_string($v)) { fallar(400, "El archivo de $que no llegó como texto."); }
    if (strlen($v) > MAX_ARCHIVO) { fallar(413, "El archivo de $que pasa de 4 MB: ¿es la página de SAES?"); }
    $total += strlen($v);
    if ($total > MAX_TOTAL) { fallar(413, 'Entre todos los archivos pasan de 16 MB.'); }
    return $v;
};

$horarios = [];
$cupos = [];
$cuales = [];                            // para el resumen de la bitácora
foreach (array_keys(CARRERAS_SAES) as $car) {
    foreach (['m', 'v'] as $turno) {
        $html = $pedir($d['horarios'][$car][$turno] ?? null, "$car horario-$turno");
        if ($html === '') { continue; }
        // Si el archivo no trae filas de horario, es otra página: mejor
        // decirlo antes de escribir nada.
        if (!filasDeHorario($html)) {
            fallar(400, "El archivo de $car horario-$turno no trae filas de horario de SAES (grupo, materia, profesor, horas).");
        }
        $horarios[$car][$turno] = $html;
        $cuales[] = "$car $turno";
    }
    $html = $pedir($d['cupos'][$car] ?? null, "$car cupos");
    if ($html === '') { continue; }
    if (!filasDeCupos($html)) {
        fallar(400, "El archivo de $car cupos no trae la tabla de ocupabilidad de SAES (grupo, clave, cupo, inscritos).");
    }
    $cupos[$car] = $html;
    $cuales[] = "$car cupos";
}
if (!$horarios && !$cupos) { fallar(400, 'No mandaste ningún archivo.'); }

// ---------- cargar ----------
//  Cada función abre su propia transacción (todo o nada), así que los
//  horarios se guardan aunque los cupos fallen; el reporte lo dice.
try {
    $rHorarios = $horarios ? cargarHorarios($pdo, $periodo, $horarios) : null;
    $rCupos    = $cupos    ? cargarCupos($pdo, $periodo, $cupos)       : null;
} catch (InvalidArgumentException | RuntimeException $e) {
    fallar(400, $e->getMessage());
}

$resumen = "$periodo: " . implode(', ', $cuales);
if ($rHorarios) { $resumen .= ' → ' . array_sum($rHorarios['nuevas']) . ' ofertas nuevas'; }
if ($rCupos)    { $resumen .= ', ' . ($rCupos['nuevos'] + $rCupos['cambiaron']) . ' cupos al día'; }
anotarBitacora($u['id'], 'importar_horarios', null, null, mb_substr($resumen, 0, 500));

responder(['periodo' => $periodo, 'horarios' => $rHorarios, 'cupos' => $rCupos, 'resumen' => $resumen]);
