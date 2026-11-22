-- =====================================================================
--  Aprobada / reprobada SIN calificación, y periodo de ingreso.
-- =====================================================================
--  Pedido del usuario (2026-11-21), para la ventana de bienvenida:
--   · quien no quiere dar sus calificaciones (privacidad) marca la materia
--     como "aprobada" o "reprobada" sin número, y el ETS como "aprobado" o
--     "reprobado" sin número. Cuentan para créditos y avance, NO para el
--     promedio (calif_final sigue siendo solo de las que tienen número);
--   · el periodo en que entraste (p. ej. 25/1), para calcular el egreso.
--
--  Se aplica con el usuario administrador:
--    docker compose exec -T db sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < migraciones/2026-11-21-resultado-sin-calificacion-e-ingreso.sql
-- =====================================================================

BEGIN;

-- 1. Resultado sin número. Solo vale cuando NO hay calificación: si hay
--    número, el número manda y el resultado se deja vacío.
ALTER TABLE avance
    ADD COLUMN resultado      VARCHAR(9) CHECK (resultado     IN ('aprobada', 'reprobada')),
    ADD COLUMN resultado_ets  VARCHAR(9) CHECK (resultado_ets IN ('aprobado', 'reprobado')),
    ADD CONSTRAINT avance_resultado_sin_calif     CHECK (resultado     IS NULL OR calif     IS NULL),
    ADD CONSTRAINT avance_resultado_ets_sin_calif CHECK (resultado_ets IS NULL OR calif_ets IS NULL);

-- 2. "Solo hay ETS si reprobaste el curso", ahora también sin número.
ALTER TABLE avance
    DROP CONSTRAINT avance_check,
    ADD CONSTRAINT avance_ets_solo_si_reprobo CHECK (
        (calif_ets IS NULL AND resultado_ets IS NULL) OR calif < 6 OR resultado = 'reprobada');

-- 3. La vista toma en cuenta el resultado sin número. Las columnas nuevas
--    van al final (CREATE OR REPLACE VIEW no deja cambiar las de antes).
CREATE OR REPLACE VIEW avance_status AS
SELECT a.usuario,
       a.materia,
       a.veces,
       a.calif,
       a.calif_ets,
       CASE
           WHEN a.calif_ets >= 6 OR a.resultado_ets = 'aprobado'      THEN 'aprobada por ETS'
           WHEN a.calif >= 6 OR a.resultado = 'aprobada'              THEN 'aprobada'
           WHEN a.calif IS NULL AND a.resultado IS NULL AND a.veces = 1 THEN 'pendiente'
           WHEN a.calif IS NULL AND a.resultado IS NULL               THEN 'en recurse'
           WHEN a.veces = 1                                           THEN 'reprobada'
           ELSE                                                            'solo por ETS'
       END AS status,
       -- Al promedio solo entra la calificación con NÚMERO con que se aprobó.
       CASE
           WHEN a.calif_ets >= 6 THEN a.calif_ets
           WHEN a.calif >= 6     THEN a.calif
       END AS calif_final,
       a.resultado,
       a.resultado_ets
FROM avance a;

-- 4. Periodo de ingreso del usuario ("25/1"). NULL = no lo ha dicho.
ALTER TABLE usuario
    ADD COLUMN ingreso VARCHAR(4) CHECK (ingreso ~ '^[0-9]{2}/[12]$');

COMMIT;
