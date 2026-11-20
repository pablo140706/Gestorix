-- =====================================================================
--  Gestorix · 08-ofertas-extra.sql · carga inicial (initdb)
-- =====================================================================
--  5 ofertas de 27/1 que NO vienen en el HTML de SAES, pero que iscweb
--  conservaba a mano (lista $EXTRA de build-data.ps1, commit 2419470) y que
--  el usuario confirmó el 2026-11-08. Con ellas, 27/1 cuadra en 665 ofertas
--  y 2,024 sesiones; sin ellas, el HTML de SAES da 660 y 2,015.
--
--  Corre antes que importador/horarios.php, así que primero se aseguran
--  los profes (si el importador los vuelve a ver, ya existen y no duplica).
-- =====================================================================

INSERT INTO profesor (nombre, nombre_norm) VALUES
    ('CRUZ LAZARO ING. APOLINAR FRANCISCO', 'CRUZ LAZARO ING. APOLINAR FRANCISCO'),
    ('AGUILAR SANCHEZ FERNANDO',            'AGUILAR SANCHEZ FERNANDO'),
    ('SANCHEZ MORENO ADRIANA DE LA P',      'SANCHEZ MORENO ADRIANA DE LA P'),
    ('RIVERA DE LA ROSA MONICA',            'RIVERA DE LA ROSA MONICA'),
    ('SOSA ADAN FANNY',                     'SOSA ADAN FANNY')
ON CONFLICT (nombre_norm) DO NOTHING;

-- 2CV1 · Ingeniería, ética y sociedad · mar, mié y vie 18:30–20:00
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV1', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ LAZARO ING. APOLINAR FRANCISCO'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);

-- 6CM5 · Sistemas en chip · lun 10:30, mar 08:30, jue 10:30 (salón por definir)
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM5', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'AGUILAR SANCHEZ FERNANDO'), NULL, NULL)
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);

-- 7CM1 y 7CM2 · Trabajo terminal I · sin horario fijo
INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM1', 'C701', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ MORENO ADRIANA DE LA P'), NULL, NULL);
INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM2', 'C701', (SELECT id FROM profesor WHERE nombre_norm = 'RIVERA DE LA ROSA MONICA'), NULL, NULL);

-- 8CM3 · Gestión empresarial · lun 10:30, mar 08:30, jue 10:30
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM3', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'SOSA ADAN FANNY'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
