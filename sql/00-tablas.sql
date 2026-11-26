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
    nombre_en    TEXT,                                 -- nombre oficial en inglés (optativas de ISC)
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
    -- TT I, TT II y la Estancia profesional NO llevan clase: son proyectos y
    -- solo tienen calificación (usuario, 2026-11-25). No tienen oferta ni
    -- grupo ni horario; en SAES son los grupos X, con cupo sin límite.
    sin_clase    BOOLEAN       NOT NULL DEFAULT false,
    -- Propósito y temas del programa sintético, tal cual el PDF: el
    -- propósito, una línea en blanco y una línea por unidad ("I. …").
    -- Lo llena importador/materias.php.
    descripcion  TEXT,
    -- NULL = salió del programa oficial (el PDF). Si no, de dónde se
    -- investigó (el PDF es un escaneo sin texto): data/programas/investigadas.csv.
    descripcion_fuente TEXT,
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

-- Equivalencias entre carreras, de SAES (migraciones/2026-11-21; datos en
-- sql/10-equivalencias.sql). Cada par una vez; se usa en los dos sentidos.
CREATE TABLE equivalencia (
    materia      VARCHAR(5)  REFERENCES materia,
    equivalente  VARCHAR(5)  REFERENCES materia,
    PRIMARY KEY (materia, equivalente),
    CHECK (materia <> equivalente)
);

-- ISC: las 14 ramas. IA y LCD: solo las parejas obvias (CLAUDE.md §4.3).
CREATE TABLE ruta_optativa (
    id       SERIAL      PRIMARY KEY,
    carrera  VARCHAR(3)  NOT NULL REFERENCES carrera,
    nombre   TEXT        NOT NULL,
    icono    VARCHAR(4),                 -- siglas para la tarjeta: BD, IoT, PLN…
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
    -- MisProfesores. NULL = sin dato. Nunca se promedian con los comentarios propios.
    mp_link             TEXT,
    mp_calidad          NUMERIC(3,1)  CHECK (mp_calidad     BETWEEN 0 AND 10),
    mp_recomiendan      NUMERIC(4,1)  CHECK (mp_recomiendan BETWEEN 0 AND 100),  -- %
    mp_dificultad       NUMERIC(3,1)  CHECK (mp_dificultad  BETWEEN 0 AND 10)    -- bajo = bueno
);

-- Cédulas profesionales (Registro Nacional de Profesionistas, SEP). Un
-- profesor tiene varias: licenciatura o ingeniería, una o dos maestrías,
-- doctorado, especialidad. Antes era un solo campo profesor.cedula; un
-- atributo con varios valores va en su propia tabla (1FN). La carga
-- importador/profesores.php desde la lista que captura el usuario.
CREATE TABLE cedula (
    profesor  INT          NOT NULL REFERENCES profesor ON DELETE CASCADE,
    numero    VARCHAR(10)  NOT NULL CHECK (numero ~ '^[0-9]{5,9}$'),
    nivel     VARCHAR(12)  NOT NULL CHECK (nivel IN
                  ('licenciatura', 'ingenieria', 'especialidad', 'maestria', 'doctorado')),
    PRIMARY KEY (profesor, numero)
);

-- Una oferta = grupo + materia + profesor en un periodo. Un mismo grupo
-- tiene varias ofertas, y en TT el mismo grupo + materia se repite con
-- varios asesores. El historial son las ofertas de periodos pasados.
CREATE TABLE oferta (
    id         SERIAL      PRIMARY KEY,
    periodo    VARCHAR(4)  NOT NULL REFERENCES periodo,
    -- El número puede tener dos dígitos: en 26/2 existió 1CM10.
    grupo      VARCHAR(5)  NOT NULL CHECK (grupo ~ '^[1-8][ABC][MVX][1-9][0-9]?$'),
    materia    VARCHAR(5)  NOT NULL REFERENCES materia,
    profesor   INT         REFERENCES profesor,         -- NULL = sin asignar; se corrige a mano
    turno      CHAR(1)     GENERATED ALWAYS AS (substr(grupo, 3, 1)) STORED,  -- M, V o X (TT)
    -- Edificio y salón: los del HTML de SAES, corregidos con el PDF oficial
    -- de distribución de salones (importador/salones.php), que manda.
    -- NULL si no hay dato (SAES trae X o POR DEFINIR; el PDF, SA).
    edificio   TEXT,
    salon      TEXT,
    -- NULLS NOT DISTINCT: dos ofertas "sin profesor" del mismo grupo y
    -- materia también cuentan como repetidas.
    UNIQUE NULLS NOT DISTINCT (periodo, grupo, materia, profesor)
);

-- Postgres no indexa solo las llaves foráneas. La ficha del maestro busca
-- sus ofertas por profesor.
CREATE INDEX oferta_profesor ON oferta (profesor);

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

-- Cupo de SAES (importador/cupos.php). Es de grupo + materia, no de cada
-- oferta: en TT varios asesores comparten un cupo, y los grupos X de TT
-- tienen cupo aunque no tengan oferta. Se cruza con oferta por
-- periodo + grupo + materia. Disponibles = cupo − inscritos (sale negativo
-- con sobrecupo). El +4 de sobrecupo de 2.º en adelante lo suma la app.
CREATE TABLE cupo (
    periodo    VARCHAR(4)  REFERENCES periodo,
    grupo      VARCHAR(5)  CHECK (grupo ~ '^[1-8][ABC][MVX][1-9][0-9]?$'),
    materia    VARCHAR(5)  REFERENCES materia,
    cupo       SMALLINT    NOT NULL CHECK (cupo >= 0),       -- tal cual SAES; 250/255 en TT = sin límite
    inscritos  SMALLINT    NOT NULL CHECK (inscritos >= 0),
    PRIMARY KEY (periodo, grupo, materia)
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
    ingreso           VARCHAR(4)   CHECK (ingreso ~ '^[0-9]{2}/[12]$'),  -- periodo en que entró ("25/1"); NULL = no lo dijo
    baneado           BOOLEAN      NOT NULL DEFAULT false,
    alias_cambios     SMALLINT     NOT NULL DEFAULT 0 CHECK (alias_cambios BETWEEN 0 AND 2)  -- máximo 2 cambios de alias (migraciones/2026-11-21)
);

-- "Pablo" y "pablo" son el mismo alias.
CREATE UNIQUE INDEX usuario_alias_unico ON usuario (lower(alias));

-- Cambios de alias (migraciones/2026-11-22): el alumno puede cambiarlo 3 veces
-- al año; los que hace un admin (por alias ofensivo) no cuentan.
CREATE TABLE alias_cambio (
    id               SERIAL        PRIMARY KEY,
    usuario          INT           NOT NULL REFERENCES usuario ON DELETE CASCADE,
    alias_anterior   VARCHAR(30)   NOT NULL,
    alias_nuevo      VARCHAR(30)   NOT NULL,
    por              INT           REFERENCES usuario ON DELETE SET NULL,
    cuando           TIMESTAMPTZ   NOT NULL DEFAULT now()
);
CREATE INDEX alias_cambio_usuario ON alias_cambio (usuario, cuando);

-- Qué carreras modera cada moderador (migraciones/2026-11-22). La carrera de
-- un comentario es la de su materia. El admin modera todas sin estar aquí.
CREATE TABLE moderador_carrera (
    usuario  INT         NOT NULL REFERENCES usuario ON DELETE CASCADE,
    carrera  VARCHAR(3)  NOT NULL REFERENCES carrera,
    PRIMARY KEY (usuario, carrera)
);

-- Enlaces de verificación y de "olvidé mi contraseña". Se guarda el hash
-- del token, no el token. Al usarlo, se borra la fila.
CREATE TABLE token (
    hash     CHAR(64)     PRIMARY KEY,                -- sha256 en hexadecimal
    usuario  INT          NOT NULL REFERENCES usuario ON DELETE CASCADE,
    tipo     VARCHAR(10)  NOT NULL CHECK (tipo IN ('verificar', 'recuperar')),
    expira   TIMESTAMPTZ  NOT NULL
);

-- Correos de cuentas borradas hace poco: no se pueden volver a registrar
-- hasta "hasta" (7 días). Solo el sha256 del correo, no el correo.
CREATE TABLE correo_borrado (
    hash   CHAR(64)     PRIMARY KEY,
    hasta  TIMESTAMPTZ  NOT NULL
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
    -- Resultado SIN número, para quien no quiere dar sus calificaciones
    -- (migraciones/2026-11-21). Solo vale si no hay número. No entra al promedio.
    resultado      VARCHAR(9)  CHECK (resultado     IN ('aprobada', 'reprobada')),
    resultado_ets  VARCHAR(9)  CHECK (resultado_ets IN ('aprobado', 'reprobado')),
    -- Periodo en que la reprobaste ("26/1"), para el aviso de desfase (migraciones/2026-11-21).
    periodo_reprobada  VARCHAR(4)  CHECK (periodo_reprobada ~ '^[0-9]{2}/[12]$'),
    -- Solo para las materias sin clase (TT I, TT II, Estancia): el alumno marcó
    -- que lo está llevando, para que ocupe su carga (migraciones/2026-11-25).
    -- No va en `horario` porque ahí cada renglón es una oferta y un proyecto no
    -- tiene. Deja de contar solo, al capturar la calificación.
    proyecto_en_curso  BOOLEAN     NOT NULL DEFAULT false,
    PRIMARY KEY (usuario, materia),
    CONSTRAINT avance_periodo_solo_si_reprobo CHECK (
        periodo_reprobada IS NULL OR calif < 6 OR resultado = 'reprobada'),
    CONSTRAINT avance_resultado_sin_calif     CHECK (resultado     IS NULL OR calif     IS NULL),
    CONSTRAINT avance_resultado_ets_sin_calif CHECK (resultado_ets IS NULL OR calif_ets IS NULL),
    -- Solo hay ETS si reprobaste el curso (con número o sin él).
    CONSTRAINT avance_ets_solo_si_reprobo CHECK (
        (calif_ets IS NULL AND resultado_ets IS NULL) OR calif < 6 OR resultado = 'reprobada')
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
    fecha       DATE          NOT NULL,
    hora        TIME,                       -- hora de la Ciudad de México; NULL = todo el día
    titulo      VARCHAR(100)  NOT NULL CHECK (btrim(titulo) <> ''),
    materia     VARCHAR(5)    REFERENCES materia,   -- opcional
    nota        VARCHAR(500)
);

CREATE INDEX recordatorio_usuario ON recordatorio (usuario, fecha);


-- ---------------------------------------------------------------------
--  6. Comentarios y moderación
-- ---------------------------------------------------------------------

-- Sin UNIQUE: cada usuario comenta las veces que quiera.
CREATE TABLE comentario (
    id          SERIAL        PRIMARY KEY,
    -- Si el autor borra su cuenta, sus comentarios se borran con ella
    -- (migraciones/2026-11-21). Los NULL que haya son de antes de ese cambio.
    usuario     INT           REFERENCES usuario ON DELETE CASCADE,
    profesor    INT           NOT NULL REFERENCES profesor,
    materia     VARCHAR(5)    NOT NULL REFERENCES materia,  -- etiqueta: una de las que da ese profesor
    -- Escalas de MisProfesores, por comentario: enteros de 0 a 10 y sí/no.
    calidad     SMALLINT      NOT NULL CHECK (calidad    BETWEEN 0 AND 10),
    recomienda  BOOLEAN       NOT NULL,     -- la ficha muestra el % de "sí"
    dificultad  SMALLINT      NOT NULL CHECK (dificultad BETWEEN 0 AND 10),
    texto       VARCHAR(500)  NOT NULL,
    anonimo     VARCHAR(15)   CHECK (anonimo ~ '^[A-Za-z0-9]{6,15}$'),  -- publicado como anónimo: nombre al azar; NULL = con el alias
    creado      TIMESTAMPTZ   NOT NULL DEFAULT now(),  -- editar o borrar: solo en 24 h
    editado     TIMESTAMPTZ,
    estado      VARCHAR(7)    NOT NULL DEFAULT 'visible'
                CHECK (estado IN ('visible', 'oculto'))
);

-- La ficha del maestro lista sus comentarios, del más nuevo al más viejo.
CREATE INDEX comentario_profesor ON comentario (profesor, creado DESC);

-- Cómo evalúa: examen 60 %, proyecto 40 %…
CREATE TABLE rubrica (
    comentario  INT          REFERENCES comentario ON DELETE CASCADE,
    concepto    VARCHAR(40),
    porcentaje  SMALLINT     NOT NULL CHECK (porcentaje BETWEEN 1 AND 100),
    PRIMARY KEY (comentario, concepto)
);

-- Respuestas a un comentario: solo texto, sin calificaciones, un solo nivel
-- (usuario, 2026-11-26; migraciones/2026-11-26-respuestas.sql). No entran a
-- ninguna métrica. Se ocultan junto con el comentario que contestan.
CREATE TABLE respuesta (
    id          SERIAL        PRIMARY KEY,
    comentario  INT           NOT NULL REFERENCES comentario ON DELETE CASCADE,
    usuario     INT           REFERENCES usuario ON DELETE CASCADE,
    texto       VARCHAR(300)  NOT NULL,
    anonimo     VARCHAR(15)   CHECK (anonimo ~ '^[A-Za-z0-9]{6,15}$'),
    creado      TIMESTAMPTZ   NOT NULL DEFAULT now(),   -- editar o borrar: solo en 24 h
    editado     TIMESTAMPTZ,
    estado      VARCHAR(7)    NOT NULL DEFAULT 'visible'
                CHECK (estado IN ('visible', 'oculto')),
    -- Se ocultó con su comentario, no por sí misma: al mostrar el comentario
    -- regresan estas y no las que un moderador ocultó aparte.
    oculta_con_padre  BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX respuesta_comentario ON respuesta (comentario, creado);

-- Un reporte es de un comentario O de una respuesta, nunca de los dos.
CREATE TABLE reporte (
    id            SERIAL        PRIMARY KEY,
    comentario    INT           REFERENCES comentario ON DELETE CASCADE,
    respuesta     INT           REFERENCES respuesta  ON DELETE CASCADE,
    CONSTRAINT reporte_comentario_o_respuesta CHECK ((comentario IS NULL) <> (respuesta IS NULL)),
    reportante    INT           REFERENCES usuario ON DELETE SET NULL,
    motivo        VARCHAR(500)  NOT NULL,
    creado        TIMESTAMPTZ   NOT NULL DEFAULT now(),
    estado        VARCHAR(10)   NOT NULL DEFAULT 'pendiente'
                  CHECK (estado IN ('pendiente', 'atendido', 'descartado')),
    resuelto_por  INT           REFERENCES usuario ON DELETE SET NULL
);

-- La ventana de moderación solo pide los pendientes.
CREATE INDEX reporte_pendiente ON reporte (comentario) WHERE estado = 'pendiente';
CREATE INDEX reporte_pendiente_respuesta ON reporte (respuesta) WHERE estado = 'pendiente';

-- Todo lo que hacen moderadores y admins queda aquí.
CREATE TABLE bitacora (
    id                   SERIAL        PRIMARY KEY,
    actor                INT           REFERENCES usuario ON DELETE SET NULL,
    accion               VARCHAR(20)   NOT NULL CHECK (accion IN (
                             'ocultar', 'mostrar', 'suspender', 'banear', 'desbanear',
                             'nombrar_moderador', 'quitar_moderador', 'ver_correo',
                             'carreras_moderador', 'cambiar_alias', 'respaldo', 'probar_correo')),
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
           WHEN a.calif_ets >= 6 OR a.resultado_ets = 'aprobado'        THEN 'aprobada por ETS'
           WHEN a.calif >= 6 OR a.resultado = 'aprobada'                THEN 'aprobada'
           WHEN a.calif IS NULL AND a.resultado IS NULL AND a.veces = 1 THEN 'pendiente'
           WHEN a.calif IS NULL AND a.resultado IS NULL                 THEN 'en recurse'
           WHEN a.veces = 1                                             THEN 'reprobada'
           ELSE                                                              'solo por ETS'
       END AS status,
       -- Al promedio solo entra la calificación con NÚMERO con que se aprobó.
       CASE
           WHEN a.calif_ets >= 6 THEN a.calif_ets
           WHEN a.calif >= 6     THEN a.calif
       END AS calif_final,
       a.resultado,
       a.resultado_ets
FROM avance a;
