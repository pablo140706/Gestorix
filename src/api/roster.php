<?php
// GET api/roster.php → ROSTER (reemplaza roster.js)
//   [{ t: profesor, m: materia, g: "", p: "26/2" }, …]
//
// Las materias que cada profesor dio en periodos pasados y que en el
// periodo vigente YA NO da (p = el último periodo en que la dio). Sirve
// para la pestaña Maestros:
//   · lo que da este periodo sale de api/horarios.php → etiqueta verde
//     "Imparte";
//   · lo de aquí → etiqueta roja "Ya no (26/2)";
//   · y así también salen en la lista los profes que este periodo no dan
//     ninguna clase.
// Todo se calcula de las ofertas de la base; nadie lo edita a mano.
// Sin grupos, para no mezclar grupos viejos con los de ahora.
//
// Se compara por NOMBRE de la materia, no por clave: si alguien dio
// Matemáticas discretas de ISC (C102) en 26/2 y este periodo da la de IA
// (B102), sigue dando "Matemáticas discretas" (así la junta el front).
require __DIR__ . '/../lib/api.php';

$st = db()->prepare(
    "SELECT p.nombre AS t, m.nombre_saes AS m, max(o.periodo) AS p
     FROM oferta o
     JOIN profesor p ON p.id = o.profesor
     JOIN materia m ON m.clave = o.materia
     WHERE o.periodo <> :v1
       AND NOT EXISTS (SELECT 1 FROM oferta x JOIN materia mx ON mx.clave = x.materia
                       WHERE x.periodo = :v2 AND x.profesor = o.profesor AND mx.nombre_saes = m.nombre_saes)
     GROUP BY p.nombre, m.nombre_saes
     ORDER BY t, m");
$v = periodoVigente();
$st->execute(['v1' => $v, 'v2' => $v]);

responder(array_map(fn($r) => ['t' => $r['t'], 'm' => $r['m'], 'g' => '', 'p' => $r['p']], $st->fetchAll()));
