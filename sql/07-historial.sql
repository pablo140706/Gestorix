-- =====================================================================
--  Gestorix · 07-historial.sql · carga inicial (initdb)
-- =====================================================================
--  Generado UNA VEZ el 2026-11-08 por importador/iscweb/convertir.php
--  desde iscweb 2419470 (historial.js). No se vuelve a generar:
--  desde aquí la base manda y se corrige en pgAdmin.
--
--  Ofertas de 26/2 de ISC (no hay historial de IA ni de LCD). El 27/1 que
--  también traía historial.js (350 filas) NO se carga: el 27/1 sale del
--  HTML de SAES con importador/horarios.php.
-- =====================================================================

-- Profes que dieron clase en 26/2 y no están en las métricas ni en los links.
INSERT INTO profesor (nombre, nombre_norm) VALUES
    ('ESCALANTE NOTARIO ENRIQUE', 'ESCALANTE NOTARIO ENRIQUE'),
    ('GARCIA CORTES ROCIO', 'GARCIA CORTES ROCIO'),
    ('MOLINA PÉREZ DANIEL', 'MOLINA PEREZ DANIEL'),
    ('MORAN RUIZ ROBERTO', 'MORAN RUIZ ROBERTO'),
    ('OJEDA SILVA OSCAR ALONSO', 'OJEDA SILVA OSCAR ALONSO')
ON CONFLICT (nombre_norm) DO NOTHING;

-- Una oferta por sentencia, con sus sesiones (día 1–6, bloque 1–9).
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM1', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'RESENDIZ MUNOZ ROCIO'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM1', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'HERRERA YANEZ CRISPIN'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM1', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES VILLA CLAUDIA JISELA'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM1', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'GUZMAN AGUILAR FLORENCIO'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM1', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ MORENO ADRIANA DE LA P'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM2', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'PAREDES CADENA MYRIAM NOEMI'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM2', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANCHEZ HUGO'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (3, 4), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM2', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VARGAS PERLA REBECA'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM2', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'MIGUEL PILAR ZELIN'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM2', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'SERRANO ROMERO CLAUDIA WENDY'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM3', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'FRANCO MARTINEZ EDGARDO ADRIAN'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM3', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ PALACIOS MARIA SUSANA'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (4, 4), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM3', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ RAMIREZ JAZMIN ADRIANA'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM3', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VELEZ RICARDO'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM3', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'CENTENO ARRAZOLA MARIA SOLEDAD'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM4', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'FRANCO MARTINEZ EDGARDO ADRIAN'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM4', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ PALACIOS MARIA SUSANA'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (2, 4), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM4', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ SANCHEZ JOSE MANUEL'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM4', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VELEZ RICARDO'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM4', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'TELLEZ REYES MA. DEL SOCORRO'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM5', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'RESENDIZ MUNOZ ROCIO'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM5', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VARGAS PERLA REBECA'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM5', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES VILLA CLAUDIA JISELA'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM5', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'LUCIO PENA PERLA CECILIA'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM5', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'TELLEZ REYES MA. DEL SOCORRO'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM6', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'DAVALOS LOPEZ JOSE CARLOS'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM6', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VARGAS PERLA REBECA'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM6', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES FUENTES NARIA ADRIANA'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM6', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VELEZ RICARDO'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM6', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'ARREDONDO SANCHEZ ANA LAURA'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM7', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'DAVALOS LOPEZ JOSE CARLOS'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM7', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'PACHUCA HERRERA YANIRA'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (2, 2), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM7', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES VILLA CLAUDIA JISELA'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM7', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ VILLARREAL JOSE GREGORIO'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM8', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'REYES BERMEJO TLATOANI DE JESUS'), '2', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM8', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'LEAL PACHECO CHRISTIAN RENE'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM9', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ GARCIA CESAR ROMAN'), '2', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CM10', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'SILVA GARCIA VICTOR MANUEL'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM1', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'TECLA PARRA ROBERTO'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM1', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'GUZMAN AGUILAR FLORENCIO'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM1', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'VIVEROS VELA KARINA'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM1', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'SALINAS HERNANDEZ ENCARNACION'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (2, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM1', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'ARREDONDO SANCHEZ ANA LAURA'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM1', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'CASTILLO MARRUFO JUAN ANTONIO'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM2', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'DE LUNA CABALLERO ROBERTO'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM2', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES GONZALEZ ANGEL'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM2', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'ARCOS DIAZ ELSA LETICIA'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM2', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'CORREA COYAC DAVID'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM2', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'CENTENO ARRAZOLA MARIA SOLEDAD'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM2', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'GALINANES RODRIGUEZ MARIA GABRIELA'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM3', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'DE LUNA CABALLERO ROBERTO'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM3', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'VAZQUEZ ARREGUIN ROBERTO'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM3', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'AVILA SANCHEZ CRISTHIAN ALEJANDRO'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM3', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ VASQUEZ CESAR'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 1), (3, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM3', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ ARROYO JOSE EMILIO'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM3', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ CRUZ VIRGINIA'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM4', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'ALBORTANTE MORATO CECILIA'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM4', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'CANEDO SUAREZ LETICIA'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM4', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'AVILA SANCHEZ CRISTHIAN ALEJANDRO'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM4', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'CEBALLOS SEBASTIAN RICARDO'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (2, 4), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM4', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ ARROYO JOSE EMILIO'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM4', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'TORRES GONZALEZ ENRIQUE'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM5', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'TECLA PARRA ROBERTO'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM5', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'MIGUEL PILAR ZELIN'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM5', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'RUIZ LEDESMA ELENA FABIOLA'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM5', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'CEBALLOS SEBASTIAN RICARDO'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM5', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ ACOSTA LILIAN'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM5', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'TORRES GONZALEZ ENRIQUE'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM6', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES MENDOZA YAXKIN'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM6', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'REYES BERMEJO TLATOANI DE JESUS'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM6', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'VIVEROS VELA KARINA'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM6', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'SALINAS HERNANDEZ ENCARNACION'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (4, 5), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM6', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ MORENO ADRIANA DE LA P'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CM6', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'CASTILLO MARRUFO JUAN ANTONIO'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM1', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANTIAGO RICARDO FELIPE'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM1', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'DAVALOS LOPEZ JOSE CARLOS'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM1', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'SILVA MARTINEZ JORGE JAVIER'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM1', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ TOALA IVAN'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM1', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'ALCANTARA MENDEZ ALBERTO JESUS'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM1', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'CHAVARRIA BAEZ LORENA'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM1', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'GALINANES RODRIGUEZ MARIA GABRIELA'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM2', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANTIAGO RICARDO FELIPE'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM2', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'AGUILAR GARCIA RAFAEL'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM2', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'CHAVEZ LIMA EDUARDO'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM2', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'TESTA NAVA ALEXIS'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM2', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'DURAN CAMARILLO EDMUNDO RENE'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM2', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'GALEANA CHAVEZ M. EN A.P. MARIA DEL ROSARIO'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM2', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'AGUSTIN DOMINGUEZ VERONICA'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM3', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'LUNA BENOSO BENJAMIN'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM3', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'AGUILAR GARCIA RAFAEL'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM3', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'SILVA MARTINEZ JORGE JAVIER'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM3', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ PEREZ JOSE JUAN'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM3', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'ALCANTARA MENDEZ ALBERTO JESUS'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM3', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'GALEANA CHAVEZ M. EN A.P. MARIA DEL ROSARIO'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM3', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'MENDOZA MACIAS ELBA'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM4', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ GARCIA LUZ MARIA'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM4', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ CASTILLO MIGUEL ANGEL'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM4', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'CARBALLO JIMENEZ JUAN MANUEL'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM4', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ SECUNDINO JOSE CELESTINO ELIAS'), '2', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM4', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'ALMAZAN FARFAN ROCIO'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM4', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'MELARA ABARCA REYNA ELIA'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM4', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'MENDOZA MACIAS ELBA'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM5', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'ALBORTANTE MORATO CECILIA'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM5', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ JUAREZ JOSE'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM5', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ CARRERA BENJAMIN'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM5', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ SECUNDINO JOSE CELESTINO ELIAS'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM5', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'ALMAZAN FARFAN ROCIO'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM5', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'VELEZ SALDANA ULISES'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CM5', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'GALINANES RODRIGUEZ MARIA GABRIELA'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM1', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ MARTINEZ GENARO'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM1', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'CHAVEZ LIMA EDUARDO'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM1', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'CERVANTES ESPINOSA LUIS MOCTEZUMA'), '2', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM1', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'TESTA NAVA ALEXIS'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM1', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'DURAN CAMARILLO EDMUNDO RENE'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM1', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'BAUTISTA ROSALES SANDRA IVETTE'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM1', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'CORTES GALICIA JORGE'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM2', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ MARTINEZ GENARO'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM2', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'CORREA COYAC DAVID'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM2', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'CERVANTES ESPINOSA LUIS MOCTEZUMA'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM2', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'MUJICA ASCENCIO CESAR'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM2', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ DIAZ JUAN CARLOS'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM2', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'RIVERA DE LA ROSA MONICA'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM2', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ MENDEZ ANA BELEM'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM3', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'ALBORTANTE MORATO CECILIA'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM3', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'CANEDO SUAREZ LETICIA'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM3', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'ARCOS DIAZ ELSA LETICIA'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM3', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'GALICIA MEJIA RUBEN'), '2', '009')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM3', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'CARRANZA CASTILLO OSCAR'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM3', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA CORTES ROCIO'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM3', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ MENDEZ ANA BELEM'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM4', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'HURTADO AVILES GABRIEL'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM4', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ ROJAS JORGE ALBERTO'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM4', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'LEAL PACHECO CHRISTIAN RENE'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM4', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'GALICIA MEJIA RUBEN'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM4', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'DURAN CAMARILLO EDMUNDO RENE'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM4', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'ESCAMILLA MIRANDA PATRICIA'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM4', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'CORTES GALICIA JORGE'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM5', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ GARCIA LUZ MARIA'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM5', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES FUENTES NARIA ADRIANA'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM5', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'AVILA SANCHEZ CRISTHIAN ALEJANDRO'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM5', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ DIAZ JUAN CARLOS'), '2', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CM5', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'ESCAMILLA MIRANDA PATRICIA'), '2', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM1', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIGOZA CAMPOS M. EN C. ANDRES'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM1', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'MUJICA ASCENCIO CESAR'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM1', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'GOMEZ MAYORGA MARGARITA ELIZABETH'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM1', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'ORTEGA GONZALEZ RUBEN'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM1', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'PEREDO VALDERRAMA RUBEN'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM1', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ FLORES EDUARDO'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM1', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'ALCARAZ TORRES JUAN JESUS'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM2', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'TECLA PARRA ROBERTO'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM2', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ TOALA IVAN'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM2', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'GOMEZ MAYORGA MARGARITA ELIZABETH'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM2', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'TELLEZ BARRERA JUAN CARLOS'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM2', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'ROJAS MEXICANO ISMAEL'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM2', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ FLORES EDUARDO'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM2', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ QUINTANILLA GILBERTO'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM3', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ JUAREZ JOSE'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM3', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'CASTILLO CABRERA GELACIO'), '3', '010')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM3', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'ORTEGA GONZALEZ RUBEN'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM3', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'MALDONADO CASTILLO IDALIA'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM3', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'AGUSTIN DOMINGUEZ VERONICA'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM3', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ QUINTANILLA GILBERTO'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM4', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'TECLA PARRA ROBERTO'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM4', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'LERMA MAGANA CARLOS'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM4', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES CRUZ JUAN CARLOS'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM4', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'ALCANTARA MENDEZ ALBERTO JESUS'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM4', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'MELARA ABARCA REYNA ELIA'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM4', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'CORTEZ DUARTE NIDIA ASUNCION'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM5', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ BRITO MIGUEL'), '3', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM5', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'CASTILLO CABRERA GELACIO'), '3', '010')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM5', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'PASTRANA FERNANDEZ CARLOS JESUS'), '3', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM5', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'ALCANTARA MENDEZ ALBERTO JESUS'), '3', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM5', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ ORDAZ MARISOL'), '3', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM5', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'ALCARAZ TORRES JUAN JESUS'), '3', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CM6', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'MUJICA ASCENCIO CESAR'), '3', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM1', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'ROMAN GODINEZ RODRIGO FRANCISCO'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM1', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'AGUILAR SANCHEZ FERNANDO'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM1', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'MARQUEZ ARREGUIN GUILLERMO'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM1', 'C610', (SELECT id FROM profesor WHERE nombre_norm = 'CORTEZ DUARTE NIDIA ASUNCION'), '3', '010')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM1', 'C616', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ ROJAS ARIEL'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM1', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'ROJAS MEXICANO ISMAEL'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM1', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'MORENO CERVANTES AXEL ERNESTO'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM2', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'ROMERO HERRERA RODOLFO'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM2', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ PEREZ JOSE JUAN'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM2', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'MARQUEZ ARREGUIN GUILLERMO'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM2', 'C605', (SELECT id FROM profesor WHERE nombre_norm = 'CORDERO LOPEZ MARTHA ROSA'), '4', '010')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM2', 'C607', (SELECT id FROM profesor WHERE nombre_norm = 'TELLEZ BARRERA JUAN CARLOS'), '3', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM2', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'CORDERO LOPEZ MARTHA ROSA'), '3', '009')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM2', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'MORENO CERVANTES AXEL ERNESTO'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM3', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'ROMAN GODINEZ RODRIGO FRANCISCO'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM3', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ PEREZ JOSE JUAN'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM3', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ ROJAS ARIEL'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM3', 'C604', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ SARABIA TANIA'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM3', 'C608', (SELECT id FROM profesor WHERE nombre_norm = 'ALEMAN ARCE MIGUEL ANGEL'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM3', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'ROJAS MEXICANO ISMAEL'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM3', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'BAUTISTA ROSALES SANDRA IVETTE'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM4', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'REYES VERA ABDIEL'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM4', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES CRUZ JUAN CARLOS'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM4', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ ROJAS ARIEL'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM4', 'C611', (SELECT id FROM profesor WHERE nombre_norm = 'REYES VERA ABDIEL'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM4', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'CIFUENTES ALVAREZ ALEJANDRO SIGFRIDO'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM4', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'BAUTISTA ROSALES SANDRA IVETTE'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CM6', 'C606', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ CISNEROS ALEJANDRO'), '4', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM1', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'CARRETO ARELLANO CHADWICK'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM1', 'C707', (SELECT id FROM profesor WHERE nombre_norm = 'LERMA MAGANA CARLOS'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM1', 'C709', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANTIAGO SANDRA'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM1', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'RIVERA DE LA ROSA MONICA'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM1', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ ROSALES RICARDO'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM2', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'CORONILLA CONTRERAS UKRANIO'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM2', 'C706', (SELECT id FROM profesor WHERE nombre_norm = 'TELLEZ BARRERA JUAN CARLOS'), '3', '309')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM2', 'C710', (SELECT id FROM profesor WHERE nombre_norm = 'ROSAS TRIGUEROS JORGE LUIS'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM2', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'RIVERA DE LA ROSA MONICA'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM2', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ ROSALES RICARDO'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM3', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'CORONILLA CONTRERAS UKRANIO'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM3', 'C704', (SELECT id FROM profesor WHERE nombre_norm = 'ENRIQUEZ ZARATE DR. JOSE ASUNCION'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM3', 'C713', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ MEZA MARIA ELENA'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM3', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'CIFUENTES ALVAREZ ALEJANDRO SIGFRIDO'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM3', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'TENORIO MARRON MARCO ANTONIO'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM4', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'CORONILLA CONTRERAS UKRANIO'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM4', 'C714', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ MARTINEZ GENARO'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM4', 'C715', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES GONZALEZ ANGEL'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM4', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'CIFUENTES ALVAREZ ALEJANDRO SIGFRIDO'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM4', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'TENORIO MARRON MARCO ANTONIO'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM5', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA SANTILLAN RODRIGO'), '4', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM5', 'C705', (SELECT id FROM profesor WHERE nombre_norm = 'OCAMPO BOTELLO FABIOLA'), '4', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM5', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'VELEZ SALDANA ULISES'), '4', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM5', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'ALCARAZ TORRES JUAN JESUS'), '4', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CM6', 'C708', (SELECT id FROM profesor WHERE nombre_norm = 'GUZMAN FLORES JESSIE PAULINA'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CM1', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'CENTENO ARRAZOLA MARIA SOLEDAD'), '4', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CM1', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'MALDONADO MUNOZ MIGUEL ANGEL'), '4', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CM1', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES CORDERO MARTHA MARGARITA'), '4', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CM2', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ ALBARRAN GISELA'), '4', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CM2', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'MALDONADO MUNOZ MIGUEL ANGEL'), '4', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CM2', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'SERRANO ROMERO CLAUDIA WENDY'), '4', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CM3', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'OLALDE MOGOLLAN NORMA'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CM3', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'SOSA ADAN FANNY'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CM3', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'SERRANO ROMERO CLAUDIA WENDY'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CM4', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'SALDIVAR ALMOREJO MARIA MAGDALENA'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CM4', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'SOSA ADAN FANNY'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CM4', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'LOYOLA ESPINOSA ARACELI'), '2', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV1', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ JORDAN GABRIEL DE JESUS'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV1', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'BUITRON DAMASO ISRAEL'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (2, 8), (3, 8), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV1', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'LEVARIO MEDINA SERGIO'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV1', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'ORTUNO ARAUJO JESUS'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV1', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'WINFIELD REYES ANA MARIA'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV2', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'RAMIREZ ROMERO TONAHTIU ARTURO'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV2', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'LUCIO PENA PERLA CECILIA'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (2, 5), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV2', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'SOLORZA GUZMAN MISAEL'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV2', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'ORTUNO ARAUJO JESUS'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV2', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'LAZCANO XOXOTLA LAURA'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV3', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES RODRIGUEZ URSULA SAMANTHA'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV3', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'GUTIERREZ MEJIA DARWIN'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV3', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'JURADO JIMENEZ ROBERTO'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV3', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'ORTUNO ARAUJO JESUS'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV3', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'LAZCANO XOXOTLA LAURA'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV4', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ CARLIN EFREN'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV4', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'NAVA LARA JOEL'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7), (5, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV4', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'JURADO JIMENEZ ROBERTO'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV4', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ HUERTA CLAUDIA CELIA'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV4', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'GOMEZ TRESS MARIANA'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV5', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'SANTILLAN LUNA RAUL'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV5', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'BUITRON DAMASO ISRAEL'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 9), (3, 9), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV5', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'LEVARIO MEDINA SERGIO'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV5', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ HUERTA CLAUDIA CELIA'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV5', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES CORDERO MARTHA MARGARITA'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV6', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'LEVARIO MEDINA SERGIO'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (3, 5), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV6', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ CASTILLO JESUS ROBERTO'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '1CV6', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES MERAZ YESICA SONIA'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV1', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'CARMONA GARCIA ENRIQUE ALFONSO'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV1', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES MERAZ YESICA SONIA'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV1', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ LEON CARLOS'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV1', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'ESQUIVEL CENTENO JOSE ARMANDO'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (2, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV1', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'CABRERA CHAVEZ GLORIA LOURDES'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV2', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ GARCIA DANIEL'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV2', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'TIRADO LULE JUDITH MARGARITA'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV2', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ LEON CARLOS'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV2', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'DOMINGUEZ HERNANDEZ SAMUEL'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (2, 5), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV2', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'WINFIELD REYES ANA MARIA'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV2', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'CABRERA CHAVEZ GLORIA LOURDES'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV3', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ GARCIA DANIEL'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV3', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'SANTIAGO VALENTIN ERIC'), '1', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV3', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'ZARATE CARDENAS ALEJANDRO'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV3', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'CEBALLOS SEBASTIAN RICARDO'), '2', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (4, 5), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV3', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'OLALDE MOGOLLAN NORMA'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV3', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'VILLEGAS NAVARRETE SONIA'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV4', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'MOSCOSO MALAGON YOSAFAT'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV4', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'LEAL PACHECO CHRISTIAN RENE'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV4', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'SANTIAGO VALENTIN ERIC'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV4', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'ZARATE CARDENAS ALEJANDRO'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7), (5, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV4', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA SILVA OSCAR ALONSO'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV4', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ PERALES JOSE CRUZ'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV5', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'CARMONA GARCIA ENRIQUE ALFONSO'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV5', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ VILLARREAL JOSE GREGORIO'), '1', '114')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV5', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'ZARATE CARDENAS ALEJANDRO'), '1', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV5', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'ESQUIVEL CENTENO JOSE ARMANDO'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8), (5, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV5', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'OLALDE MOGOLLAN NORMA'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV5', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ PERALES JOSE CRUZ'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '2CV6', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'NAVA LARA JOEL'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV1', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'AVILA SANCHEZ CRISTHIAN ALEJANDRO'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV1', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'SALAZAR RAMIREZ MANUEL'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV1', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ LEYVA LUIS OCTAVIO'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV1', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ GUERRERO JOSE ALFREDO'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV1', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ SARABIA TANIA'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV2', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ MENDEZ ANA BELEM'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV2', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA SALES JUAN VICENTE'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV2', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'SALAZAR RAMIREZ MANUEL'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV2', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'SANTILLAN LUNA RAUL'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV2', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'HURTADO AVILES GABRIEL'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV2', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ GALAN YASMIN IVETTE'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV3', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ BRITO MIGUEL'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV3', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'CORTES DAVALOS ANDRES'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV3', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'ZARATE CARDENAS ALEJANDRO'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV3', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'BARRON VERA JOSUE EMANUEL'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV3', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'SANTILLAN LUNA RAUL'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV3', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'SALINAS CALLEJAS MARIA DE LOURDES'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV3', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ GALAN YASMIN IVETTE'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV4', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA FLORIANO ANDRES'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV4', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'AVILA SANCHEZ CRISTHIAN ALEJANDRO'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV4', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'BARRON VERA JOSUE EMANUEL'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV4', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'VAZQUEZ ORTIZ MIJAIL'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV4', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'HURTADO AVILES GABRIEL'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV4', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES DELGADO RAQUEL'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV5', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'AVILA SANCHEZ CRISTHIAN ALEJANDRO'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '3CV5', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES DELGADO RAQUEL'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV1', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'MOSCOSO MALAGON YOSAFAT'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV1', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'MONTIEL SANCHEZ ANGEL SALVADOR'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV1', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'LEON HERNANDEZ MIGUEL ABEL'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV1', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'FERNANDEZ VAZQUEZ ALFONSO'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV1', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'VAZQUEZ ORTIZ MIJAIL'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV1', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ BENITEZ JOSE ALFREDO'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV2', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES MENDOZA YAXKIN'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV2', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'PACHUCA HERRERA YANIRA'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV2', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ RUIZ RENE BALTAZAR'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV2', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ AGUILAR JOSE LUIS'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV2', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES GUITRON SANDRA LUZ'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV2', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ BENITEZ JOSE ALFREDO'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV3', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'CAMACHO VAZQUEZ VANESSA ALEJANDRA'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV3', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'TIRADO LULE JUDITH MARGARITA'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV3', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'LEAL PACHECO CHRISTIAN RENE'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV3', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'LINARES VALLEJO ERICK EUGENIO'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV3', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ GUERRERO JOSE ALFREDO'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV3', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'SOTO RAMOS MANUEL ALEJANDRO'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV3', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ DE LOS SANTOS MONDRAGON TANIBET'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV4', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES MENDOZA YAXKIN'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV4', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ ROJAS JORGE ALBERTO'), '2', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV4', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ NUNO JESUS ALFREDO'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV4', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'BARRALES LOPEZ ANA LUZ'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV4', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ GUERRERO JOSE ALFREDO'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV4', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIZ RAMIREZ JOSE ANTONIO'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV4', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ BENITEZ JOSE ALFREDO'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '4CV5', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'MANZANILLA GRANADOS HECTOR MANUEL'), '2', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV1', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ OLVERA LUIS ENRIQUE'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV1', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'ARZATE GORDILLO JACQUELINE'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV1', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'LERMA MAGANA CARLOS'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV1', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ AGUILAR JOSE LUIS'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV1', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'BLANCO ALMAZAN IVAN EDUARDO'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV1', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'SILVA SANCHEZ CARLOS'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV1', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'ALCARAZ TORRES JUAN JESUS'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV2', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'PUEBLA LOMAS JAIME HUGO'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV2', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'BARRALES LOPEZ ANA LUZ'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV2', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'CERVANTES DE ANDA ISMAEL'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV2', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'BLANCO ALMAZAN IVAN EDUARDO'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV2', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'SILVA SANCHEZ CARLOS'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV2', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'HENESTROSA CARRASCO LETICIA'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV3', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ JORDAN GABRIEL DE JESUS'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV3', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'ARZATE GORDILLO JACQUELINE'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV3', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'CASTILLO MARTINEZ MIGUEL ANGEL'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV3', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'TELLEZ BARRERA JUAN CARLOS'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV3', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'SALINAS CALLEJAS MARIA DE LOURDES'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV3', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'CALDERON SAMBARINO MARIA JULIA'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV3', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'HENESTROSA CARRASCO LETICIA'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV4', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ JORDAN GABRIEL DE JESUS'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV4', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ TOALA IVAN'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV4', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'LINARES VALLEJO ERICK EUGENIO'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV4', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'CERVANTES DE ANDA ISMAEL'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV4', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'BLANCO ALMAZAN IVAN EDUARDO'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV4', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ ORDAZ MARISOL'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '5CV4', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'PUEBLA LOMAS JAIME HUGO'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV1', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'CAMACHO VAZQUEZ VANESSA ALEJANDRA'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV1', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ PEREZ JOSE JUAN'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV1', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'MEDINA MEJIA VIRGINIA'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV1', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ RAMIREZ MARKO ALFONSO'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV1', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ DE LOS SANTOS MONDRAGON TANIBET'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV2', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIZ CASTILLO MARCO ANTONIO'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV2', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'LINARES VALLEJO ERICK EUGENIO'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV2', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'MEDINA MEJIA VIRGINIA'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV2', 'C613', (SELECT id FROM profesor WHERE nombre_norm = 'PALMA OROZCO ROSAURA'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV2', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ RAMIREZ MARKO ALFONSO'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV2', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ DE LOS SANTOS MONDRAGON TANIBET'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV3', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'ESCALANTE NOTARIO ENRIQUE'), '3', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (3, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV3', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'CASTILLO MARTINEZ MIGUEL ANGEL'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV3', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ ROJAS ARIEL'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV3', 'C609', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA SANTILLAN RODRIGO'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV3', 'C610', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANTIAGO SANDRA'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV3', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'SALINAS CALLEJAS MARIA DE LOURDES'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (2, 9), (3, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV3', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA SANTILLAN RODRIGO'), '2', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV4', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA FLORIANO ANDRES'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV4', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ RUIZ RENE BALTAZAR'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV4', 'C612', (SELECT id FROM profesor WHERE nombre_norm = 'MOLINA PEREZ DANIEL'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV4', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA SANTILLAN RODRIGO'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '6CV5', 'C611', (SELECT id FROM profesor WHERE nombre_norm = 'ROSAS CARRILLO ARY SHARED'), '3', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV1', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'PINEDA GUERRERO CARLOS'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV1', 'C709', (SELECT id FROM profesor WHERE nombre_norm = 'CORTEZ DUARTE NIDIA ASUNCION'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV1', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIZ RAMIREZ JOSE ANTONIO'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV1', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'SOTO RAMOS MANUEL ALEJANDRO'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV2', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'PINEDA GUERRERO CARLOS'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV2', 'C712', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ CARLIN EFREN'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV2', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES GUITRON SANDRA LUZ'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV2', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'GASPAR MEDINA FABIAN'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV3', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'PINEDA GUERRERO CARLOS'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV3', 'C711', (SELECT id FROM profesor WHERE nombre_norm = 'NUNEZ PRADO CESAR JESUS'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV3', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIZ RAMIREZ JOSE ANTONIO'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV3', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'GASPAR MEDINA FABIAN'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV4', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'PINEDA GUERRERO CARLOS'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV4', 'C703', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ SARABIA TANIA'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV4', 'C708', (SELECT id FROM profesor WHERE nombre_norm = 'PALACIOS SOLANO ROCIO'), '4', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV4', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'HURTADO AVILES GABRIEL'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV4', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'SOTO RAMOS MANUEL ALEJANDRO'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV5', 'C705', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ BRITO MIGUEL'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV5', 'C715', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ ROJAS ARIEL'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '7CV7', 'C716', (SELECT id FROM profesor WHERE nombre_norm = 'MOLINA PEREZ DANIEL'), '3', '010')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CV1', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'LOYOLA ESPINOSA ARACELI'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CV1', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'SOSA ADAN FANNY'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CV1', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'MORAN RUIZ ROBERTO'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CV2', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'SALDIVAR ALMOREJO MARIA MAGDALENA'), '4', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CV2', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'VILLEGAS NAVARRETE SONIA'), '4', '010')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CV2', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ GALAN YASMIN IVETTE'), '4', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CV3', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'OLALDE MOGOLLAN NORMA'), '3', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CV3', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ GALAN YASMIN IVETTE'), '3', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('26/2', '8CV3', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES CORDERO MARTHA MARGARITA'), '3', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7)) AS s(dia, bloque);
