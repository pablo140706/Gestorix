-- =====================================================================
--  Gestorix · 08-ofertas-extra.sql · carga inicial (initdb)
-- =====================================================================
--  Ofertas de 27/1 que NO vienen en el HTML de SAES, pero que iscweb
--  conservaba a mano (lista $EXTRA de build-data.ps1, commit 2419470) y que
--  el usuario confirmó el 2026-11-08. Eran 5 y quedan 3: las dos de Trabajo
--  terminal I se quitaron el 2026-11-25, porque TT no es una clase. Con las
--  tres, 27/1 cuadra en 663 ofertas; sin ellas, el HTML de SAES da 660.
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

-- 7CM1 y 7CM2 · Trabajo terminal I: YA NO SE CARGAN (usuario, 2026-11-25).
-- TT I no es una clase sino un proyecto, así que no tiene oferta ni grupo ni
-- maestro que elegir: `materia.sin_clase` lo marca y el alumno solo dice que lo
-- está llevando (migraciones/2026-11-25-proyectos-sin-clase.sql). Las dos
-- profesoras sí se quedan arriba: son reales y pueden tener comentarios.

-- 8CM3 · Gestión empresarial · lun 10:30, mar 08:30, jue 10:30
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM3', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'SOSA ADAN FANNY'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
