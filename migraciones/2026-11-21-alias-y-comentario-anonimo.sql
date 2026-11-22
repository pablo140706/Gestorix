-- =====================================================================
--  Alias: máximo 2 cambios. Comentarios: se pueden publicar como anónimos.
-- =====================================================================
--  Pedido del usuario (2026-11-21), por un reporte de un compañero: si el
--  alias se cambia sin límite, cambia también en todas las reseñas viejas.
--   · usuario.alias_cambios: cuántas veces cambió su alias (máximo 2).
--   · comentario.anonimo: si la reseña se publicó como anónima, el nombre al
--     azar con que se muestra (hasta 15 caracteres). NULL = con el alias.
--     El dueño sigue siendo comentario.usuario (para moderar y borrar).
--
--  Se aplica con el usuario administrador:
--    docker compose exec -T db sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < migraciones/2026-11-21-alias-y-comentario-anonimo.sql
-- =====================================================================

BEGIN;

ALTER TABLE usuario
    ADD COLUMN alias_cambios SMALLINT NOT NULL DEFAULT 0 CHECK (alias_cambios BETWEEN 0 AND 2);

ALTER TABLE comentario
    ADD COLUMN anonimo VARCHAR(15) CHECK (anonimo ~ '^[A-Za-z0-9]{6,15}$');

COMMIT;
