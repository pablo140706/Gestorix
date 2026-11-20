-- =====================================================================
--  Gestorix · 04-seriacion.sql · carga inicial (initdb)
-- =====================================================================
--  Generado UNA VEZ el 2026-11-08 por importador/iscweb/convertir.php
--  desde iscweb 2419470 (planes.js). No se vuelve a generar:
--  desde aquí la base manda y se corrige en pgAdmin.
--
--  ISC: los pares del mapa oficial (oficial = true). IA y LCD: la propuesta
--  por nombres que aprobó el usuario el 2026-11-02 (oficial = false).
--  Solo avisa, nunca bloquea.
-- =====================================================================

INSERT INTO seriacion (materia, requisito, oficial) VALUES
    ('C201', 'C101', true),
    ('C202', 'C104', true),
    ('C203', 'C103', true),
    ('C301', 'C201', true),
    ('C302', 'C201', true),
    ('C303', 'C203', true),
    ('C305', 'C204', true),
    ('C401', 'C301', true),
    ('C403', 'C303', true),
    ('C404', 'C304', true),
    ('C405', 'C305', true),
    ('C406', 'C306', true),
    ('C501', 'C301', true),
    ('C502', 'C403', true),
    ('C503', 'C404', true),
    ('C504', 'C405', true),
    ('C602', 'C503', true),
    ('C618', 'C505', true),
    ('C619', 'C507', true),
    ('C702', 'C407', true),
    ('C718', 'C507', true),
    ('B201', 'B101', false),
    ('B204', 'B104', false),
    ('B301', 'B201', false),
    ('B302', 'B201', false),
    ('B303', 'B204', false),
    ('B305', 'B203', false),
    ('B403', 'B303', false),
    ('B404', 'B304', false),
    ('B501', 'B401', false),
    ('B503', 'B301', false),
    ('B602', 'B501', false),
    ('B801', 'B701', false),
    ('A201', 'A101', false),
    ('A204', 'A104', false),
    ('A301', 'A201', false),
    ('A302', 'A201', false),
    ('A404', 'A303', false),
    ('A405', 'A304', false),
    ('A504', 'A304', false),
    ('A505', 'A204', false),
    ('A602', 'A502', false),
    ('A603', 'A501', false),
    ('A803', 'A703', false);

