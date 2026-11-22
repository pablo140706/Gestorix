-- =====================================================================
--  Periodo en que reprobaste una materia, para avisar del desfase.
-- =====================================================================
--  Pedido del usuario (2026-11-21; reglas en docs/reglas-escolares.md):
--  una materia se desfasa si la repruebas y no la regularizas (recurse o
--  ETS) en los dos semestres siguientes. Para saberlo hace falta CUÁNDO la
--  reprobaste: lo pregunta la ventana de "Reprobaste…" o sale del Estado
--  General de SAES.
--
--  Se aplica con el usuario administrador:
--    docker compose exec -T db sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < migraciones/2026-11-21-periodo-reprobada.sql
-- =====================================================================

BEGIN;

ALTER TABLE avance
    ADD COLUMN periodo_reprobada VARCHAR(4) CHECK (periodo_reprobada ~ '^[0-9]{2}/[12]$'),
    -- Solo tiene sentido si reprobaste el curso.
    ADD CONSTRAINT avance_periodo_solo_si_reprobo CHECK (
        periodo_reprobada IS NULL OR calif < 6 OR resultado = 'reprobada');

COMMIT;
