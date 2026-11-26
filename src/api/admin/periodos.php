<?php
// GET  api/admin/periodos.php  → { vigente, periodos: [{ codigo, inicio, fin, ofertas, cupos }] }
// POST api/admin/periodos.php  { codigo: "27/2", inicio?: "2027-01-25", fin?: "2027-06-22" }
//                              → { creado: true|false, mensaje }
// =====================================================================
//  Crear o ajustar un periodo desde la pestaña Admin (usuario, 2026-11-25).
// =====================================================================
//  SOLO EL ADMIN, con la contraseña confirmada. Antes esto se hacía en
//  pgAdmin y era el paso que faltaba para poder subir los horarios de un
//  periodo nuevo: el importador se niega si el periodo no existe.
//
//  Las fechas pueden ir vacías (NULL = todavía no se sabe); si van las
//  dos, el fin no puede ser antes del inicio (también lo exige la base).
//  El periodo NO se borra desde aquí: si tiene ofertas, borrarlo se
//  llevaría las de los alumnos. Eso se hace a mano en pgAdmin.
// =====================================================================
require __DIR__ . '/../../lib/admin.php';
require __DIR__ . '/../../../importador/carga.php';

$u = exigirAdmin();
$pdo = db();

if (($_SERVER['REQUEST_METHOD'] ?? '') === 'GET') {
    $st = $pdo->query(
        "SELECT p.codigo,
                to_char(p.inicio, 'YYYY-MM-DD') AS inicio,
                to_char(p.fin, 'YYYY-MM-DD')    AS fin,
                (SELECT count(*) FROM oferta o WHERE o.periodo = p.codigo) AS ofertas,
                (SELECT count(*) FROM cupo c   WHERE c.periodo = p.codigo) AS cupos
           FROM periodo p ORDER BY p.codigo DESC");
    $periodos = array_map(fn($r) => [
        'codigo' => $r['codigo'], 'inicio' => $r['inicio'], 'fin' => $r['fin'],
        'ofertas' => (int)$r['ofertas'], 'cupos' => (int)$r['cupos'],
    ], $st->fetchAll());
    responder(['vigente' => periodoVigente(), 'periodos' => $periodos]);
    exit;
}

exigirConfirmado();
$d = leerJson();

$codigo = (string)($d['codigo'] ?? '');
if (!periodoValido($codigo)) { fallar(400, 'El periodo se escribe como 27/2.'); }

$fecha = function ($v, string $cual): ?string {
    if ($v === null || $v === '') { return null; }
    if (!is_string($v) || !preg_match('/^\d{4}-\d{2}-\d{2}$/', $v)) { fallar(400, "La fecha de $cual se escribe como 2027-01-25."); }
    [$a, $m, $dia] = array_map('intval', explode('-', $v));
    if (!checkdate($m, $dia, $a)) { fallar(400, "La fecha de $cual no existe en el calendario."); }
    return $v;
};
$inicio = $fecha($d['inicio'] ?? null, 'inicio');
$fin    = $fecha($d['fin'] ?? null, 'fin');
if ($inicio !== null && $fin !== null && $fin < $inicio) {
    fallar(400, 'El fin del periodo no puede ser antes de su inicio.');
}

$st = $pdo->prepare('SELECT 1 FROM periodo WHERE codigo = ?');
$st->execute([$codigo]);
$existia = (bool)$st->fetch();

$pdo->prepare('INSERT INTO periodo (codigo, inicio, fin) VALUES (?, ?, ?)
               ON CONFLICT (codigo) DO UPDATE SET inicio = EXCLUDED.inicio, fin = EXCLUDED.fin')
    ->execute([$codigo, $inicio, $fin]);

$cuando = $inicio ? " ($inicio" . ($fin ? " a $fin" : '') . ')' : ' (sin fechas todavía)';
if (!$existia) { anotarBitacora($u['id'], 'periodo_nuevo', null, null, "Creó el periodo $codigo$cuando"); }

responder(['creado' => !$existia,
           'mensaje' => $existia ? "Se ajustaron las fechas de $codigo." : "Listo: el periodo $codigo ya existe$cuando. Ahora súbele los horarios."]);
