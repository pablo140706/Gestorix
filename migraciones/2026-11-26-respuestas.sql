-- =====================================================================
--  Respuestas a los comentarios: solo texto, sin calificaciones.
-- =====================================================================
--  Pedido del usuario (2026-11-26): "una versión de respuesta a un
--  comentario donde no incluya nada de calificaciones, solo una
--  respuesta". Sirve para matizar ("conmigo no fue así", "ya cambió la
--  rúbrica") sin meter otra calificación al promedio del profesor.
--
--  Por qué tabla aparte y no un `padre` en comentario: ahí calidad,
--  dificultad y recomienda son NOT NULL —y así deben seguir, porque son
--  lo que alimenta las métricas—. Una respuesta no tiene nada de eso.
--
--  Reglas (decididas con el usuario):
--   · un solo nivel: se responde al comentario, nunca a otra respuesta;
--   · cualquiera con cuenta activa; anónimo opcional, con el mismo
--     nombre al azar que los comentarios;
--   · 300 caracteres (el comentario son 500: esto es una respuesta);
--   · se edita o borra en las primeras 24 h, como el comentario;
--   · hereda la materia del padre: no se pregunta;
--   · se ocultan con su comentario (lo hace api/moderacion/accion.php);
--   · no entran a ninguna métrica ni al conteo de comentarios.
--
--  Los reportes ahora pueden ser de un comentario O de una respuesta:
--  `reporte.comentario` deja de ser NOT NULL y entra `reporte.respuesta`,
--  con un CHECK de que siempre haya exactamente uno de los dos.
--
--  Se aplica con el usuario administrador:
--    docker compose exec -T db sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < migraciones/2026-11-26-respuestas.sql
-- =====================================================================

BEGIN;

CREATE TABLE respuesta (
    id          SERIAL        PRIMARY KEY,
    comentario  INT           NOT NULL REFERENCES comentario ON DELETE CASCADE,
    -- Si el autor borra su cuenta, sus respuestas se van con ella, igual
    -- que sus comentarios (migraciones/2026-11-21).
    usuario     INT           REFERENCES usuario ON DELETE CASCADE,
    texto       VARCHAR(300)  NOT NULL,
    anonimo     VARCHAR(15)   CHECK (anonimo ~ '^[A-Za-z0-9]{6,15}$'),
    creado      TIMESTAMPTZ   NOT NULL DEFAULT now(),   -- editar o borrar: solo en 24 h
    editado     TIMESTAMPTZ,
    estado      VARCHAR(7)    NOT NULL DEFAULT 'visible'
                CHECK (estado IN ('visible', 'oculto')),
    -- Se ocultó porque ocultaron su comentario, no por sí misma: así, al
    -- volver a mostrar el comentario, regresan estas y NO las que un
    -- moderador ocultó aparte.
    oculta_con_padre  BOOLEAN NOT NULL DEFAULT false
);

-- Se leen siempre por comentario, de la más vieja a la más nueva.
CREATE INDEX respuesta_comentario ON respuesta (comentario, creado);

ALTER TABLE reporte
    ALTER COLUMN comentario DROP NOT NULL,
    ADD COLUMN respuesta INT REFERENCES respuesta ON DELETE CASCADE,
    ADD CONSTRAINT reporte_comentario_o_respuesta CHECK ((comentario IS NULL) <> (respuesta IS NULL));

COMMIT;

-- Nota: el índice parcial de reportes pendientes era solo por comentario.
-- Las respuestas necesitan el suyo (lo usa api/moderacion/reportes.php).
BEGIN;
CREATE INDEX reporte_pendiente_respuesta ON reporte (respuesta) WHERE estado = 'pendiente';
COMMIT;
