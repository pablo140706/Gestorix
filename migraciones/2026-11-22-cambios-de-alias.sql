-- =====================================================================
--  Historial de cambios de alias: 3 por año, y el admin puede cambiarlo.
-- =====================================================================
--  Pedido del usuario (2026-11-22): el alumno cambia su alias máximo 3 veces
--  al año (antes: 2 en toda la vida, con usuario.alias_cambios, que ya no se
--  usa). Si un alias es ofensivo, el admin lo cambia; esos cambios no cuentan
--  para el alumno. Cada cambio queda aquí, con el alias anterior.
--
--  Se aplica con el usuario administrador:
--    docker compose exec -T db sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < migraciones/2026-11-22-cambios-de-alias.sql
-- =====================================================================

BEGIN;

CREATE TABLE alias_cambio (
    id               SERIAL        PRIMARY KEY,
    usuario          INT           NOT NULL REFERENCES usuario ON DELETE CASCADE,
    alias_anterior   VARCHAR(30)   NOT NULL,
    alias_nuevo      VARCHAR(30)   NOT NULL,
    por              INT           REFERENCES usuario ON DELETE SET NULL,  -- quién lo cambió (él mismo o un admin)
    cuando           TIMESTAMPTZ   NOT NULL DEFAULT now()
);
CREATE INDEX alias_cambio_usuario ON alias_cambio (usuario, cuando);

COMMIT;
