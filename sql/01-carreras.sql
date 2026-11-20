-- =====================================================================
--  Gestorix · 01-carreras.sql · carga inicial (initdb)
-- =====================================================================
--  Carga académica en UA (CLAUDE.md §4.1): mínima 4, media 7 en ISC y 6
--  en IA y LCD, máxima 9.
-- =====================================================================

INSERT INTO carrera (codigo, letra, nombre, plan, carga_min_ua, carga_media_ua, carga_max_ua) VALUES
    ('ISC', 'C', 'Ingeniería en Sistemas Computacionales', 2020, 4, 7, 9),
    ('IA',  'B', 'Ingeniería en Inteligencia Artificial',  2020, 4, 6, 9),
    ('LCD', 'A', 'Licenciatura en Ciencia de Datos',       2020, 4, 6, 9);
