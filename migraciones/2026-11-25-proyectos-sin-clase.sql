-- =====================================================================
--  Trabajo Terminal I y II y la Estancia profesional no llevan clase.
-- =====================================================================
--  Usuario, 2026-11-25: "TT I y II como tal no son materias, son
--  proyectos, así que no llevan como tal una clase, solo tienen
--  calificaciones. Lo mismo la Estancia profesional". Es consistente con
--  lo que hace SAES: sus grupos X (7CX1, 8CX2…) traen cupo 250/255 —sin
--  límite— y nunca traen horario.
--
--  Qué cambia:
--   1. `materia.sin_clase` marca cuáles son. Son 9: TT I, TT II y
--      Estancia de las tres carreras.
--   2. `avance.proyecto_en_curso`: el alumno marca que lo está llevando,
--      para que ocupe su carga (TT I y TT II valen 2 UA; Estancia, 1).
--      No va en la tabla `horario` porque ahí cada renglón es una oferta,
--      y un proyecto no tiene oferta ni grupo ni hora. Se apaga solo al
--      capturar la calificación: ya aprobada, deja de contar.
--   3. Se van las dos ofertas de TT I que estaban puestas a mano
--      (`7CM1` y `7CM2`, de sql/08-ofertas-extra.sql), que hacían que
--      TT I se viera como una clase donde eliges maestra. Las dos
--      profesoras se quedan en la tabla `profesor`: son reales y pueden
--      tener comentarios y métricas.
--
--  Al 2026-11-25 nadie tenía esas ofertas en su horario (0 renglones),
--  así que el DELETE no le quita nada a ningún alumno; si alguien las
--  tuviera, la llave foránea de `horario` haría fallar la migración.
--
--  Se aplica con el usuario administrador:
--    docker compose exec -T db sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < migraciones/2026-11-25-proyectos-sin-clase.sql
-- =====================================================================

BEGIN;

ALTER TABLE materia ADD COLUMN sin_clase BOOLEAN NOT NULL DEFAULT false;

UPDATE materia SET sin_clase = true WHERE clave IN (
    'C701', 'C801', 'C804',     -- ISC: TT I, TT II, Estancia profesional
    'B701', 'B801', 'B803',     -- IA
    'A703', 'A803', 'A804');    -- LCD

ALTER TABLE avance ADD COLUMN proyecto_en_curso BOOLEAN NOT NULL DEFAULT false;

DELETE FROM oferta WHERE materia = 'C701' AND grupo IN ('7CM1', '7CM2');

COMMIT;
