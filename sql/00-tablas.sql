-- =====================================================================
--  Gestorix · 00-tablas.sql · esquema de la base (Postgres 17)
-- =====================================================================
--  Lo corre Postgres solo la primera vez, cuando el volumen de la base
--  está vacío (docker-entrypoint-initdb.d). Para cambiar el esquema con
--  la base ya en uso se escribe un archivo nuevo en migraciones/.
--
--  Reglas de negocio: CLAUDE.md §4–§7. Esquema cerrado el 2026-11-08.
--
--  Convenciones:
--   · Las tablas del catálogo (carrera, materia, profesor, oferta…) NO
--     borran en cascada: pgAdmin se niega a borrar una materia o un
--     profesor que se está usando.
--   · Lo que es de un usuario (avance, horario, agenda) sí se borra
--     cuando el usuario borra su cuenta.
-- =====================================================================


-- ---------------------------------------------------------------------
--  1. Plan de estudios
-- ---------------------------------------------------------------------

CREATE TABLE carrera (
    codigo          VARCHAR(3)  PRIMARY KEY,           -- ISC, IA, LCD
    letra           CHAR(1)     NOT NULL UNIQUE        -- la de la clave y el grupo
                    CHECK (letra IN ('A', 'B', 'C')),  -- C = ISC, B = IA, A = LCD
    nombre          TEXT        NOT NULL,
    plan            SMALLINT    NOT NULL,              -- 2020
    carga_min_ua    SMALLINT    NOT NULL,              -- 4
    carga_media_ua  SMALLINT    NOT NULL,              -- 7 en ISC, 6 en IA y LCD
    carga_max_ua    SMALLINT    NOT NULL,              -- 9
    CHECK (0 < carga_min_ua
           AND carga_min_ua   <= carga_media_ua
           AND carga_media_ua <= carga_max_ua)
);

CREATE TABLE materia (
    clave        VARCHAR(5)    PRIMARY KEY,            -- clave oficial: C101, B643…
    carrera      VARCHAR(3)    NOT NULL REFERENCES carrera,
    nombre       TEXT          NOT NULL,               -- como se ve en la app, con acentos
    nombre_saes  TEXT          NOT NULL,               -- tal cual lo escribe SAES (para cruzar)
    tipo         CHAR(3)       NOT NULL CHECK (tipo IN ('OBL', 'OPT')),
    semestre     SMALLINT      NOT NULL CHECK (semestre BETWEEN 1 AND 8),
    creditos     NUMERIC(4,1)  NOT NULL CHECK (creditos > 0),   -- solo informativo
    ua           SMALLINT      NOT NULL DEFAULT 1 CHECK (ua IN (1, 2)),  -- TT I y TT II = 2
    horas_t      NUMERIC(3,1),
    horas_p      NUMERIC(3,1),
    orden        SMALLINT,                             -- posición dentro de su semestre
    -- En IA y LCD cada optativa tiene clave de 6.º y de 7.º en SAES, pero
    -- solo vale la del semestre que marca su PDF. Se guardan las dos; la
    -- otra lleva se_ofrece = false y la app no la muestra.
    se_ofrece    BOOLEAN       NOT NULL DEFAULT true,
    descripcion  TEXT,                                 -- resumen generado a partir del PDF
    pdf          TEXT,                                 -- ruta relativa: materias/C101.pdf
    -- El importador encuentra la materia por carrera + semestre + nombre de
    -- SAES (en IA y LCD el nombre se repite entre 6.º y 7.º).
    UNIQUE (carrera, semestre, nombre_saes)
);

-- Solo avisa, nunca bloquea.
CREATE TABLE seriacion (
    materia    VARCHAR(5)  REFERENCES materia,
    requisito  VARCHAR(5)  REFERENCES materia,
    oficial    BOOLEAN     NOT NULL,   -- ISC: mapa oficial. IA y LCD: propuesta aprobada
    PRIMARY KEY (materia, requisito),
    CHECK (materia <> requisito)
);

-- ISC: las 14 ramas. IA y LCD: solo las parejas obvias (CLAUDE.md §4.3).
CREATE TABLE ruta_optativa (
    id       SERIAL      PRIMARY KEY,
    carrera  VARCHAR(3)  NOT NULL REFERENCES carrera,
    nombre   TEXT        NOT NULL,
    UNIQUE (carrera, nombre)
);

-- El semestre ya viene en materia.semestre.
CREATE TABLE ruta_materia (
    ruta     INT         REFERENCES ruta_optativa,
    materia  VARCHAR(5)  REFERENCES materia,
    PRIMARY KEY (ruta, materia)
);


-- ---------------------------------------------------------------------
--  2. Periodos y calendario del IPN
-- ---------------------------------------------------------------------

CREATE TABLE periodo (
    codigo  VARCHAR(4)  PRIMARY KEY CHECK (codigo ~ '^[0-9]{2}/[12]$'),  -- 26/2, 27/1
    inicio  DATE,                       -- NULL si todavía no se sabe
    fin     DATE,
    CHECK (fin IS NULL OR inicio IS NULL OR fin >= inicio)
);

-- La prioridad para pintar cada tipo vive en el front (calendario-ui.js).
CREATE TABLE evento_calendario (
    id       SERIAL      PRIMARY KEY,
    periodo  VARCHAR(4)  REFERENCES periodo,   -- NULL = no es de un periodo (vacaciones, descansos)
    inicio   DATE        NOT NULL,
    fin      DATE,                             -- NULL = un solo día
    tipo     TEXT        NOT NULL CHECK (tipo IN (
                 'reinscripcion', 'inicio', 'fin', 'ordinaria', 'extraordinaria',
                 'inscripcion_ets', 'ets', 'vacaciones', 'descanso', 'sindical',
                 'politecnico', 'limite_saberes', 'planeacion')),
    CHECK (fin IS NULL OR fin >= inicio)
);


-- ---------------------------------------------------------------------
--  3. Profesores, ofertas y horario de clases
-- ---------------------------------------------------------------------

CREATE TABLE profesor (
    id                  SERIAL        PRIMARY KEY,
    nombre              TEXT          NOT NULL,         -- como se muestra, con acentos
    nombre_norm         TEXT          NOT NULL UNIQUE,  -- MAYÚSCULAS sin acentos: llave para cruzar
    cedula              VARCHAR(10),                    -- Registro Nacional de Profesionistas
    titulo_profesional  TEXT,
    -- MisProfesores. NULL = sin dato. Nunca se promedian con los comentarios propios.
    mp_link             TEXT,
    mp_calidad          NUMERIC(3,1)  CHECK (mp_calidad     BETWEEN 0 AND 10),
    mp_recomiendan      NUMERIC(4,1)  CHECK (mp_recomiendan BETWEEN 0 AND 100),  -- %
    mp_dificultad       NUMERIC(3,1)  CHECK (mp_dificultad  BETWEEN 0 AND 10)    -- bajo = bueno
);

-- Una oferta = grupo + materia + profesor en un periodo. Un mismo grupo
-- tiene varias ofertas, y en TT el mismo grupo + materia se repite con
-- varios asesores. El historial son las ofertas de periodos pasados.
CREATE TABLE oferta (
    id         SERIAL      PRIMARY KEY,
    periodo    VARCHAR(4)  NOT NULL REFERENCES periodo,
    grupo      CHAR(4)     NOT NULL CHECK (grupo ~ '^[1-8][ABC][MVX][1-9]$'),
    materia    VARCHAR(5)  NOT NULL REFERENCES materia,
    profesor   INT         REFERENCES profesor,         -- NULL = sin asignar; se corrige a mano
    turno      CHAR(1)     GENERATED ALWAYS AS (substr(grupo, 3, 1)) STORED,  -- M, V o X (TT)
    edificio   TEXT,                                    -- NULL si SAES trae X o POR DEFINIR
    salon      TEXT,
    -- Cupo tal cual lo da SAES (NULL = sin dato). El sobrecupo (+4 de 2.º
    -- en adelante) lo suma la app; no se guarda.
    cupo       SMALLINT    CHECK (cupo >= 0),
    inscritos  SMALLINT    CHECK (inscritos >= 0),
    -- NULLS NOT DISTINCT: dos ofertas "sin profesor" del mismo grupo y
    -- materia también cuentan como repetidas.
    UNIQUE NULLS NOT DISTINCT (periodo, grupo, materia, profesor)
);

-- Rejilla fija: 9 bloques de 1:30, con recesos de 10:00–10:30 y 18:00–18:30.
CREATE TABLE bloque (
    numero  SMALLINT  PRIMARY KEY CHECK (numero BETWEEN 1 AND 9),
    inicio  TIME      NOT NULL UNIQUE,
    fin     TIME      NOT NULL UNIQUE,
    CHECK (fin > inicio)
);

INSERT INTO bloque (numero, inicio, fin) VALUES
    (1, '07:00', '08:30'),
    (2, '08:30', '10:00'),
    (3, '10:30', '12:00'),
    (4, '12:00', '13:30'),
    (5, '13:30', '15:00'),
    (6, '15:00', '16:30'),
    (7, '16:30', '18:00'),
    (8, '18:30', '20:00'),
    (9, '20:00', '21:30');

-- Cada fila es un bloque de clase de una oferta. TT no tiene sesiones.
CREATE TABLE sesion (
    oferta  INT       REFERENCES oferta ON DELETE CASCADE,
    dia     SMALLINT  CHECK (dia BETWEEN 1 AND 6),     -- 1 = lunes … 6 = sábado
    bloque  SMALLINT  REFERENCES bloque,
    PRIMARY KEY (oferta, dia, bloque)
);


-- ---------------------------------------------------------------------
--  4. Usuarios
-- ---------------------------------------------------------------------
--  No se guarda boleta, teléfono ni nombre real. El inicio de sesión usa
--  la sesión normal de PHP (una cookie), así que no necesita tabla.

CREATE TABLE usuario (
    id                SERIAL       PRIMARY KEY,
    correo            TEXT         NOT NULL UNIQUE
                      CHECK (correo = lower(correo)),  -- se guarda en minúsculas
    hash              TEXT         NOT NULL,           -- password_hash() de PHP
    verificado        BOOLEAN      NOT NULL DEFAULT false,
    alias             VARCHAR(30)  NOT NULL,           -- generado al azar, cambiable
    rol               VARCHAR(10)  NOT NULL DEFAULT 'alumno'
                      CHECK (rol IN ('alumno', 'moderador', 'admin')),
    carrera           VARCHAR(3)   NOT NULL REFERENCES carrera,  -- fija desde el registro
    creado            TIMESTAMPTZ  NOT NULL DEFAULT now(),
    suspendido_hasta  TIMESTAMPTZ,                     -- NULL = no está suspendido
    baneado           BOOLEAN      NOT NULL DEFAULT false
);

-- "Pablo" y "pablo" son el mismo alias.
CREATE UNIQUE INDEX usuario_alias_unico ON usuario (lower(alias));

-- Enlaces de verificación y de "olvidé mi contraseña". Se guarda el hash
-- del token, no el token. Al usarlo, se borra la fila.
CREATE TABLE token (
    hash     CHAR(64)     PRIMARY KEY,                -- sha256 en hexadecimal
    usuario  INT          NOT NULL REFERENCES usuario ON DELETE CASCADE,
    tipo     VARCHAR(10)  NOT NULL CHECK (tipo IN ('verificar', 'recuperar')),
    expira   TIMESTAMPTZ  NOT NULL
);


-- ---------------------------------------------------------------------
--  5. Avance, horario y agenda (solo los ve su dueño)
-- ---------------------------------------------------------------------

-- Una fila por materia cursada. Sin fila = no la has cursado.
-- calif es la del último curso; calif_ets, la del ETS que presentaste
-- después de ese curso. Status y calificación final: vista avance_status.
CREATE TABLE avance (
    usuario    INT         REFERENCES usuario ON DELETE CASCADE,
    materia    VARCHAR(5)  REFERENCES materia,
    veces      SMALLINT    NOT NULL DEFAULT 1 CHECK (veces IN (1, 2)),  -- 1 ordinario, 2 recurse
    calif      SMALLINT    CHECK (calif     BETWEEN 0 AND 10),  -- NULL = la estás cursando
    calif_ets  SMALLINT    CHECK (calif_ets BETWEEN 0 AND 10),  -- NULL = sin ETS
    PRIMARY KEY (usuario, materia),
    -- Solo hay ETS si reprobaste el curso.
    CHECK (calif_ets IS NULL OR (calif IS NOT NULL AND calif < 6))
);

CREATE TABLE horario (
    usuario  INT  REFERENCES usuario ON DELETE CASCADE,
    oferta   INT  REFERENCES oferta,
    PRIMARY KEY (usuario, oferta)
);

-- Solo se muestran en el calendario. No mandan avisos.
CREATE TABLE recordatorio (
    id          SERIAL        PRIMARY KEY,
    usuario     INT           NOT NULL REFERENCES usuario ON DELETE CASCADE,
    fecha_hora  TIMESTAMP     NOT NULL,     -- hora de la Ciudad de México
    titulo      VARCHAR(100)  NOT NULL,
    materia     VARCHAR(5)    REFERENCES materia,   -- opcional
    nota        VARCHAR(500)
);


-- ---------------------------------------------------------------------
--  6. Comentarios y moderación
-- ---------------------------------------------------------------------

-- Sin UNIQUE: cada usuario comenta las veces que quiera.
CREATE TABLE comentario (
    id          SERIAL        PRIMARY KEY,
    -- Si el autor borra su cuenta, el comentario se queda como
    -- "usuario eliminado" (usuario = NULL).
    usuario     INT           REFERENCES usuario ON DELETE SET NULL,
    profesor    INT           NOT NULL REFERENCES profesor,
    materia     VARCHAR(5)    NOT NULL REFERENCES materia,  -- etiqueta: una de las que da ese profesor
    -- Escalas de MisProfesores, por comentario: enteros de 0 a 10 y sí/no.
    calidad     SMALLINT      NOT NULL CHECK (calidad    BETWEEN 0 AND 10),
    recomienda  BOOLEAN       NOT NULL,     -- la ficha muestra el % de "sí"
    dificultad  SMALLINT      NOT NULL CHECK (dificultad BETWEEN 0 AND 10),
    texto       VARCHAR(500)  NOT NULL,
    creado      TIMESTAMPTZ   NOT NULL DEFAULT now(),  -- editar o borrar: solo en 24 h
    editado     TIMESTAMPTZ,
    estado      VARCHAR(7)    NOT NULL DEFAULT 'visible'
                CHECK (estado IN ('visible', 'oculto'))
);

-- Cómo evalúa: examen 60 %, proyecto 40 %…
CREATE TABLE rubrica (
    comentario  INT          REFERENCES comentario ON DELETE CASCADE,
    concepto    VARCHAR(40),
    porcentaje  SMALLINT     NOT NULL CHECK (porcentaje BETWEEN 1 AND 100),
    PRIMARY KEY (comentario, concepto)
);

CREATE TABLE reporte (
    id            SERIAL        PRIMARY KEY,
    comentario    INT           NOT NULL REFERENCES comentario ON DELETE CASCADE,
    reportante    INT           REFERENCES usuario ON DELETE SET NULL,
    motivo        VARCHAR(500)  NOT NULL,
    creado        TIMESTAMPTZ   NOT NULL DEFAULT now(),
    estado        VARCHAR(10)   NOT NULL DEFAULT 'pendiente'
                  CHECK (estado IN ('pendiente', 'atendido', 'descartado')),
    resuelto_por  INT           REFERENCES usuario ON DELETE SET NULL
);

-- Todo lo que hacen moderadores y admins queda aquí.
CREATE TABLE bitacora (
    id                   SERIAL        PRIMARY KEY,
    actor                INT           REFERENCES usuario ON DELETE SET NULL,
    accion               VARCHAR(20)   NOT NULL CHECK (accion IN (
                             'ocultar', 'mostrar', 'suspender', 'banear', 'desbanear',
                             'nombrar_moderador', 'quitar_moderador', 'ver_correo')),
    objetivo_usuario     INT           REFERENCES usuario    ON DELETE SET NULL,
    objetivo_comentario  INT           REFERENCES comentario ON DELETE SET NULL,
    motivo               VARCHAR(500),
    cuando               TIMESTAMPTZ   NOT NULL DEFAULT now()
);


-- ---------------------------------------------------------------------
--  7. Vistas
-- ---------------------------------------------------------------------

-- Status derivado de cada materia (CLAUDE.md §4.2). La calificación final
-- es la que entra al promedio: la aprobatoria del curso o la del ETS.
CREATE VIEW avance_status AS
SELECT a.usuario,
       a.materia,
       a.veces,
       a.calif,
       a.calif_ets,
       CASE
           WHEN a.calif_ets >= 6                 THEN 'aprobada por ETS'
           WHEN a.calif >= 6                     THEN 'aprobada'
           WHEN a.calif IS NULL AND a.veces = 1  THEN 'pendiente'
           WHEN a.calif IS NULL                  THEN 'en recurse'
           WHEN a.veces = 1                      THEN 'reprobada'
           ELSE                                       'solo por ETS'
       END AS status,
       CASE
           WHEN a.calif_ets >= 6 THEN a.calif_ets
           WHEN a.calif >= 6     THEN a.calif
       END AS calif_final
FROM avance a;
