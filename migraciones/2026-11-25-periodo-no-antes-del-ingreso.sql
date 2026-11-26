-- =====================================================================
--  El periodo en que reprobaste no puede ser anterior a tu ingreso.
-- =====================================================================
--  Pedido del usuario (2026-11-25): si entraste en 26/2 no pudiste cursar
--  nada en 26/1, porque no estabas inscrito. De aquí en adelante lo impiden
--  el desplegable de "¿en qué periodo reprobaste?" (src/bienvenida.js) y
--  api/mis-datos.php, que rechaza la fila con 400.
--
--  Esto arregla lo que ya estaba guardado: el periodo se adelanta al del
--  ingreso del usuario. Al 2026-11-25 eran 5 filas de 55. No se pone un
--  trigger: la regla vive en el navegador y en la API (decisión del
--  usuario), porque un CHECK no puede mirar la tabla usuario.
--
--  Se aplica con el usuario administrador:
--    docker compose exec -T db sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < migraciones/2026-11-25-periodo-no-antes-del-ingreso.sql
-- =====================================================================

BEGIN;

-- "26/1" < "26/2" < "27/1" también como texto: el formato es fijo (AA/N).
UPDATE avance a
   SET periodo_reprobada = u.ingreso
  FROM usuario u
 WHERE u.id = a.usuario
   AND a.periodo_reprobada IS NOT NULL
   AND u.ingreso IS NOT NULL
   AND a.periodo_reprobada < u.ingreso;

COMMIT;
