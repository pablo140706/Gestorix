<?php
// GET api/roster.php → ROSTER (reemplaza roster.js)
//   [{ t: profesor, m: materia, g: "" }, …]
//
// En iscweb el roster salía de un Excel y servía para dos cosas: el filtro
// A/B de optativas de ISC (que ya no existe) y meter en la lista de
// Maestros a los profes que no dan clase este periodo. Aquí queda solo lo
// segundo: los profes de periodos pasados que no tienen oferta en el
// vigente, con las materias que dieron. Sin grupos, para no mezclar
// grupos viejos con los de ahora.
require __DIR__ . '/../lib/api.php';

$st = db()->prepare(
    "SELECT DISTINCT p.nombre AS t, m.nombre_saes AS m
     FROM oferta o
     JOIN profesor p ON p.id = o.profesor
     JOIN materia m ON m.clave = o.materia
     WHERE o.periodo <> :v
       AND NOT EXISTS (SELECT 1 FROM oferta x WHERE x.periodo = :v AND x.profesor = p.id)
     ORDER BY t, m");
$st->execute(['v' => periodoVigente()]);

responder(array_map(fn($r) => ['m' => $r['m'], 't' => $r['t'], 'g' => ''], $st->fetchAll()));
