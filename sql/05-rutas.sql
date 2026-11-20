-- =====================================================================
--  Gestorix · 05-rutas.sql · carga inicial (initdb)
-- =====================================================================
--  Generado UNA VEZ el 2026-11-08 por importador/iscweb/convertir.php
--  desde iscweb 2419470 (optativas.js). No se vuelve a generar:
--  desde aquí la base manda y se corrige en pgAdmin.
--
--  ISC: las 14 ramas de mapaCurricularISC2020_optativas.pdf (una materia de
--  6.º y una de 7.º cada una). IA y LCD: solo las parejas obvias; las demás
--  optativas se eligen libres dentro de su semestre.
-- =====================================================================

INSERT INTO ruta_optativa (carrera, nombre, icono) VALUES
    ('ISC', 'Big Data', 'BD'),
    ('ISC', 'Desarrollo de aplicaciones', 'DA'),
    ('ISC', 'Minería de datos', 'MD'),
    ('ISC', 'Instrumentación virtual', 'IV'),
    ('ISC', 'Internet de las cosas', 'IoT'),
    ('ISC', 'Gobierno de TI', 'TI'),
    ('ISC', 'Criptografía', 'CR'),
    ('ISC', 'Procesamiento de lenguaje natural', 'PLN'),
    ('ISC', 'Algoritmos bioinspirados', 'AB'),
    ('ISC', 'Computación gráfica', 'CG'),
    ('ISC', 'Visión por computadora', 'VC'),
    ('ISC', 'Sistemas complejos', 'SC'),
    ('ISC', 'Gestión de empresas de alta tecnología', 'GE'),
    ('ISC', 'Tópicos selectos de computación', 'TS'),
    ('IA', 'Sistemas Multiagentes → Aplicaciones de Sistemas Multiagentes', NULL),
    ('IA', 'Propiedad Intelectual → Innovación y Emprendimiento Tecnológico', NULL),
    ('IA', 'Minería de Datos → Big Data', NULL),
    ('LCD', 'Bioinformática Básica → Bioinformática Avanzada', NULL),
    ('LCD', 'Simulación Básica → Simulación Avanzada', NULL),
    ('LCD', 'Ciberseguridad → Protección de Datos', NULL),
    ('LCD', 'Propiedad Intelectual → Innovación y Emprendimiento Tecnológico', NULL);

INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C604'), ('C703')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Big Data';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C605'), ('C704')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Desarrollo de aplicaciones';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C606'), ('C705')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Minería de datos';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C607'), ('C706')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Instrumentación virtual';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C608'), ('C707')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Internet de las cosas';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C609'), ('C708')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Gobierno de TI';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C610'), ('C709')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Criptografía';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C611'), ('C710')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Procesamiento de lenguaje natural';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C612'), ('C711')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Algoritmos bioinspirados';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C613'), ('C712')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Computación gráfica';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C614'), ('C713')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Visión por computadora';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C615'), ('C714')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Sistemas complejos';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C616'), ('C715')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Gestión de empresas de alta tecnología';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('C617'), ('C716')) AS m(clave)
WHERE r.carrera = 'ISC' AND r.nombre = 'Tópicos selectos de computación';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('B643'), ('B744')) AS m(clave)
WHERE r.carrera = 'IA' AND r.nombre = 'Sistemas Multiagentes → Aplicaciones de Sistemas Multiagentes';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('B641'), ('B740')) AS m(clave)
WHERE r.carrera = 'IA' AND r.nombre = 'Propiedad Intelectual → Innovación y Emprendimiento Tecnológico';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('B645'), ('B746')) AS m(clave)
WHERE r.carrera = 'IA' AND r.nombre = 'Minería de Datos → Big Data';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('A624'), ('A725')) AS m(clave)
WHERE r.carrera = 'LCD' AND r.nombre = 'Bioinformática Básica → Bioinformática Avanzada';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('A631'), ('A732')) AS m(clave)
WHERE r.carrera = 'LCD' AND r.nombre = 'Simulación Básica → Simulación Avanzada';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('A627'), ('A728')) AS m(clave)
WHERE r.carrera = 'LCD' AND r.nombre = 'Ciberseguridad → Protección de Datos';
INSERT INTO ruta_materia (ruta, materia)
SELECT r.id, m.clave FROM ruta_optativa r, (VALUES ('A630'), ('A729')) AS m(clave)
WHERE r.carrera = 'LCD' AND r.nombre = 'Propiedad Intelectual → Innovación y Emprendimiento Tecnológico';
