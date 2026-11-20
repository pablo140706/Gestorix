-- =====================================================================
--  Gestorix · 02-calendario.sql · carga inicial (initdb)
-- =====================================================================
--  Generado UNA VEZ el 2026-11-08 por importador/iscweb/convertir.php
--  desde iscweb 2419470 (calendario.csv). No se vuelve a generar:
--  desde aquí la base manda y se corrige en pgAdmin.
--
--  Calendario del IPN 2026-2027 (escolarizada), transcrito a mano del PDF:
--  ahí las fechas son colores, no texto. fin NULL = un solo día.
-- =====================================================================

INSERT INTO periodo (codigo, inicio, fin) VALUES
    ('26/2', NULL, NULL),
    ('27/1', '2026-08-24', '2026-12-18'),
    ('27/2', '2027-01-25', '2027-06-22'),
    ('28/1', '2027-08-16', NULL);

INSERT INTO evento_calendario (periodo, inicio, fin, tipo) VALUES
    (NULL, '2026-08-01', '2026-08-07', 'vacaciones'),
    (NULL, '2026-08-10', '2026-08-14', 'planeacion'),
    ('27/1', '2026-08-17', '2026-08-21', 'reinscripcion'),
    ('27/1', '2026-08-24', NULL, 'inicio'),
    (NULL, '2026-09-16', NULL, 'descanso'),
    ('27/1', '2026-09-18', NULL, 'limite_saberes'),
    ('27/1', '2026-09-28', '2026-09-30', 'ordinaria'),
    (NULL, '2026-11-01', '2026-11-02', 'sindical'),
    ('27/1', '2026-11-05', '2026-11-06', 'ordinaria'),
    ('27/1', '2026-11-09', NULL, 'ordinaria'),
    (NULL, '2026-11-16', NULL, 'descanso'),
    ('27/1', '2026-12-11', NULL, 'ordinaria'),
    ('27/1', '2026-12-14', '2026-12-15', 'ordinaria'),
    ('27/1', '2026-12-16', '2026-12-18', 'extraordinaria'),
    ('27/1', '2026-12-18', NULL, 'fin'),
    (NULL, '2026-12-21', '2027-01-01', 'vacaciones'),
    (NULL, '2026-12-25', NULL, 'descanso'),
    (NULL, '2027-01-01', NULL, 'descanso'),
    (NULL, '2027-01-04', '2027-01-08', 'planeacion'),
    ('27/2', '2027-01-06', '2027-01-07', 'inscripcion_ets'),
    ('27/2', '2027-01-11', '2027-01-15', 'ets'),
    ('27/2', '2027-01-18', '2027-01-22', 'reinscripcion'),
    ('27/2', '2027-01-25', NULL, 'inicio'),
    (NULL, '2027-02-01', NULL, 'descanso'),
    ('27/2', '2027-02-19', NULL, 'limite_saberes'),
    ('27/2', '2027-03-04', '2027-03-05', 'ordinaria'),
    ('27/2', '2027-03-08', NULL, 'ordinaria'),
    (NULL, '2027-03-15', NULL, 'descanso'),
    (NULL, '2027-03-22', '2027-04-02', 'vacaciones'),
    ('27/2', '2027-04-30', NULL, 'ordinaria'),
    (NULL, '2027-05-01', NULL, 'descanso'),
    ('27/2', '2027-05-03', '2027-05-04', 'ordinaria'),
    (NULL, '2027-05-05', NULL, 'descanso'),
    (NULL, '2027-05-10', NULL, 'sindical'),
    (NULL, '2027-05-15', NULL, 'sindical'),
    (NULL, '2027-05-21', NULL, 'politecnico'),
    ('27/2', '2027-06-15', '2027-06-17', 'ordinaria'),
    ('27/2', '2027-06-18', NULL, 'extraordinaria'),
    ('27/2', '2027-06-21', '2027-06-22', 'extraordinaria'),
    ('27/2', '2027-06-22', NULL, 'fin'),
    ('28/1', '2027-06-24', NULL, 'inscripcion_ets'),
    (NULL, '2027-06-28', '2027-07-02', 'planeacion'),
    ('28/1', '2027-07-05', '2027-07-09', 'ets'),
    (NULL, '2027-07-12', '2027-07-16', 'planeacion'),
    (NULL, '2027-07-19', '2027-08-01', 'vacaciones'),
    (NULL, '2027-07-21', NULL, 'descanso'),
    ('28/1', '2027-08-09', '2027-08-13', 'reinscripcion'),
    ('28/1', '2027-08-16', NULL, 'inicio');

