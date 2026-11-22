-- =====================================================================
--  Al borrar una cuenta, sus comentarios se borran con ella, y el mismo
--  correo no puede volver a registrarse durante 7 días.
-- =====================================================================
--  Antes (decisión del 2026-11-08) los comentarios se quedaban como
--  "usuario eliminado". Un reporte de errores (2026-11-21) mostró el abuso:
--  comentas, borras tu cuenta (el comentario sigue ahí, ya sin dueño que
--  moderar) y te vuelves a registrar con el mismo correo, por ejemplo para
--  salirte de una suspensión.
--
--  Se aplica con el usuario administrador (el de pgAdmin):
--    docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < migraciones/2026-11-21-comentarios-se-borran-con-la-cuenta.sql
--  Al crear la tabla con ese usuario, los privilegios por omisión de
--  sql/99-rol-app.sh le dan acceso a la app.
-- =====================================================================

BEGIN;

-- 1. Comentarios: de SET NULL a CASCADE.
ALTER TABLE comentario
    DROP CONSTRAINT comentario_usuario_fkey,
    ADD CONSTRAINT comentario_usuario_fkey
        FOREIGN KEY (usuario) REFERENCES usuario ON DELETE CASCADE;

-- 2. Correos de cuentas borradas hace poco. Solo el sha256 del correo, no
--    el correo: sirve para reconocerlo si vuelve, no para saber quién era.
CREATE TABLE correo_borrado (
    hash   CHAR(64)     PRIMARY KEY,          -- sha256 del correo en minúsculas
    hasta  TIMESTAMPTZ  NOT NULL              -- antes de esta fecha no se puede registrar
);

COMMIT;
