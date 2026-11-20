<?php
// GET api/horarios.php → SCHEDULE (reemplaza schedule.js)
// Las ofertas del periodo vigente de las tres carreras, con sus sesiones.
require __DIR__ . '/../lib/api.php';

$vigente = periodoVigente();
responder(ofertasPorPeriodo($vigente)[$vigente] ?? []);
