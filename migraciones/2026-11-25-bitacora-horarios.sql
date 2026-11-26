-- =====================================================================
--  Dos acciones nuevas en la bitácora: cargar horarios y crear periodo.
-- =====================================================================
--  Pedido del usuario (2026-11-25): el admin ya puede subir el HTML de
--  SAES y crear el periodo desde la pestaña Admin, sin terminal. Como
--  toda acción de admin, queda anotada en la bitácora, y para eso su
--  nombre tiene que estar en el CHECK de bitacora.accion.
--
--  El motivo guarda el resumen de la carga ("27/2: ISC m+v, cupos ISC →
--  412 ofertas nuevas"), para saber de un periodo a otro qué se subió.
--
--  Se aplica con el usuario administrador:
--    docker compose exec -T db sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < migraciones/2026-11-25-bitacora-horarios.sql
-- =====================================================================

BEGIN;

ALTER TABLE bitacora
    DROP CONSTRAINT bitacora_accion_check,
    ADD  CONSTRAINT bitacora_accion_check CHECK (accion IN (
             'ocultar', 'mostrar', 'suspender', 'banear', 'desbanear',
             'nombrar_moderador', 'quitar_moderador', 'ver_correo',
             'carreras_moderador', 'cambiar_alias', 'respaldo', 'probar_correo',
             'importar_horarios', 'periodo_nuevo'));

COMMIT;
