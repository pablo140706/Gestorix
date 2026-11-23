-- =====================================================================
--  2026-11-22 · Moderadores por carrera y más acciones en la bitácora
-- =====================================================================
--  · Cada moderador modera solo las carreras que le asigna el admin
--    (usuario, 2026-11-22). La carrera de un comentario es la de la
--    materia que lleva de etiqueta. El admin modera todas.
--  · La bitácora anota también: cambiar el alias de alguien, cambiar las
--    carreras de un moderador, descargar un respaldo y probar el correo.
--
--  Aplicar con el administrador (pgAdmin o):
--    docker compose exec -T db sh -c 'psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < migraciones/2026-11-22-moderadores-por-carrera.sql
-- =====================================================================

BEGIN;

CREATE TABLE moderador_carrera (
    usuario  INT         NOT NULL REFERENCES usuario ON DELETE CASCADE,
    carrera  VARCHAR(3)  NOT NULL REFERENCES carrera,
    PRIMARY KEY (usuario, carrera)
);

-- Los moderadores que ya existan moderan su propia carrera.
INSERT INTO moderador_carrera (usuario, carrera)
SELECT id, carrera FROM usuario WHERE rol = 'moderador'
ON CONFLICT DO NOTHING;

ALTER TABLE bitacora DROP CONSTRAINT bitacora_accion_check;
ALTER TABLE bitacora ADD CONSTRAINT bitacora_accion_check CHECK (accion IN (
    'ocultar', 'mostrar', 'suspender', 'banear', 'desbanear',
    'nombrar_moderador', 'quitar_moderador', 'ver_correo',
    'carreras_moderador', 'cambiar_alias', 'respaldo', 'probar_correo'));

COMMIT;
