-- =====================================================================
--  Gestorix · 11-ofertas-27-1.sql · carga inicial (initdb)
-- =====================================================================
--  Generado el 2026-11-26 desde la base ya cargada.
--
--  Por qué existe: las ofertas del periodo vigente 27/1 solo vivían
--  dentro de la base, cargadas por importador/horarios.php leyendo
--  data/<carrera>/horario-*.html. Si se borraba el volumen de Postgres,
--  el periodo actual se perdía. Ese HTML ya no se guarda en git (pesaba
--  1 MB y se vuelve a bajar de SAES); esta semilla lo reemplaza.
--
--  Trae los 260 profesores que dan clase en 27/1 (63 de ellos no están
--  en 06-profesores.sql: los creó el importador al leer el HTML), 664
--  ofertas con sus sesiones, y los 668 cupos del periodo. Las otras 3
--  ofertas de 27/1 las pone 08-ofertas-extra.sql, así que aquí se
--  omiten: 664 + 3 = 667.
--
--  Al profesor se le busca por nombre_norm y no por id, para no depender
--  del orden en que 06-profesores.sql haya insertado.
--
--  Un periodo nuevo NO se agrega aquí: se carga desde Admin → Horarios
--  o con importador/horarios.php. Desde ahí manda la base.
-- =====================================================================

-- --- Profesores que dan clase en 27/1 --------------------------------
--  ON CONFLICT: a los que ya puso 06-profesores.sql no se les toca.
INSERT INTO profesor (nombre, nombre_norm, mp_link, mp_calidad, mp_recomiendan, mp_dificultad) VALUES
    ('AGUILAR SANCHEZ FERNANDO', 'AGUILAR SANCHEZ FERNANDO', 'https://www.misprofesores.com/profesores/Fernando-Aguilar-Sanchez_36942', 8.5, 86.0, 1.8),
    ('AGUILAR VELAZQUEZ DANIEL', 'AGUILAR VELAZQUEZ DANIEL', 'https://misprofesores.com/profesores/Daniel-Aguilar-Velazquez_166850', 8.5, 100.0, 2.5),
    ('AGUSTIN DOMINGUEZ VERONICA', 'AGUSTIN DOMINGUEZ VERONICA', 'https://www.misprofesores.com/profesores/Veronica-Agustin-Dominguez_81650', 9.3, 90.0, 1.6),
    ('ALBORTANTE MORATO CECILIA', 'ALBORTANTE MORATO CECILIA', 'https://www.misprofesores.com/profesores/CECILIA-ALBORTANTE-MORATO_139095', 8.9, 92.0, 1.4),
    ('ALCANTARA MENDEZ ALBERTO JESUS', 'ALCANTARA MENDEZ ALBERTO JESUS', 'https://www.misprofesores.com/profesores/Alberto-Jesus-Alcantara-Mendez_32201', 7.9, 76.0, 2.0),
    ('ALCARAZ TORRES JUAN JESUS', 'ALCARAZ TORRES JUAN JESUS', 'https://www.misprofesores.com/profesores/Juan-Jesus-Alcaraz-Torres_54284', 7.8, 79.0, 1.4),
    ('ALEMAN ARCE MIGUEL ANGEL', 'ALEMAN ARCE MIGUEL ANGEL', 'https://www.misprofesores.com/profesores/MIGUEL-ANGEL-ALEMAN-ARCE_161476', 8.2, 100.0, 1.3),
    ('ALMAZAN FARFAN ROCIO', 'ALMAZAN FARFAN ROCIO', 'https://www.misprofesores.com/profesores/ROCIO-ALMAZAN-FARFAN_36702', 7.1, 66.0, 4.2),
    ('ARCOS DIAZ ELSA LETICIA', 'ARCOS DIAZ ELSA LETICIA', 'https://www.misprofesores.com/profesores/Elsa-Leticia-Arcos-Diaz_166842', 4.9, 31.0, 5.8),
    ('ARREDONDO SANCHEZ ANA LAURA', 'ARREDONDO SANCHEZ ANA LAURA', 'https://www.misprofesores.com/profesores/ANA-LAURA-ARREDONDO-SANCHEZ_187685', NULL, NULL, NULL),
    ('ARZATE GORDILLO JACQUELINE', 'ARZATE GORDILLO JACQUELINE', 'https://www.misprofesores.com/profesores/Jaqueline-Arzate-Gordillo_26667', 8.3, 80.0, 3.8),
    ('AVILA SANCHEZ CRISTHIAN ALEJANDRO', 'AVILA SANCHEZ CRISTHIAN ALEJANDRO', 'https://www.misprofesores.com/profesores/Cristhian-Alejandro-Avila-Sanches_108267', 7.0, 66.0, 3.9),
    ('BARRALES LOPEZ ANA LUZ', 'BARRALES LOPEZ ANA LUZ', 'https://www.misprofesores.com/profesores/Ana-Luz-Barrales-Lopez_182628', 4.2, 14.0, 5.7),
    ('BARRON VERA JOSUE EMANUEL', 'BARRON VERA JOSUE EMANUEL', 'https://www.misprofesores.com/profesores/josue-barron-vera_108138', 6.7, 46.0, 4.3),
    ('BAUTISTA ROSALES SANDRA IVETTE', 'BAUTISTA ROSALES SANDRA IVETTE', 'https://www.misprofesores.com/profesores/Sandra-Ivette-Bautista-Rosales_72205', 4.9, 35.0, 3.8),
    ('BLANCO ALMAZAN IVAN EDUARDO', 'BLANCO ALMAZAN IVAN EDUARDO', 'https://www.misprofesores.com/profesores/Ivan-Eduardo-Blanco-Almazan_134344?pag=4', 7.8, 83.0, 3.2),
    ('BOTELLO CASTILLO ALEJANDRO', 'BOTELLO CASTILLO ALEJANDRO', 'https://misprofesores.com/profesores/alejandro-botello-castillo_40923', 6.5, 59.0, 4.1),
    ('BUITRON DAMASO ISRAEL', 'BUITRON DAMASO ISRAEL', 'https://www.misprofesores.com/profesores/ISRAEL-BUITRON-DAMASO_59068', 5.6, 35.0, 5.3),
    ('CABRERA CHAVEZ GLORIA LOURDES', 'CABRERA CHAVEZ GLORIA LOURDES', 'https://www.misprofesores.com/profesores/Gloria-Lourdes-Cabrera-Chavez_75866', 8.5, 88.0, 1.5),
    ('CALDERON SAMBARINO MARIA JULIA', 'CALDERON SAMBARINO MARIA JULIA', 'https://www.misprofesores.com/profesores/Maria-Julia-Calderon-Sambarino_41226', 8.6, 81.0, 3.7),
    ('CAMACHO VAZQUEZ VANESSA ALEJANDRA', 'CAMACHO VAZQUEZ VANESSA ALEJANDRA', 'https://www.misprofesores.com/profesores/VANESSA-ALEJANDRA-CAMACHO-VAZQUEZ_172919', 7.7, 83.0, 0.2),
    ('CANCINO CALDERON SERGIO', 'CANCINO CALDERON SERGIO', 'https://misprofesores.com/profesores/Sergio-cancino-calderon_41227', 6.9, 63.0, 3.1),
    ('CAÑEDO SUAREZ LETICIA', 'CANEDO SUAREZ LETICIA', 'https://www.misprofesores.com/profesores/Leticia-Canedo-Suarez_37380', 8.0, 72.0, 4.6),
    ('CARBALLO JIMENEZ JUAN MANUEL', 'CARBALLO JIMENEZ JUAN MANUEL', 'https://www.misprofesores.com/profesores/Juan-Manuel-Carballo-Jimenez_18610', 8.6, 87.0, 4.4),
    ('CARMONA GARCIA ENRIQUE ALFONSO', 'CARMONA GARCIA ENRIQUE ALFONSO', 'https://www.misprofesores.com/profesores/Enrique-Alfonso-Carmona-Garcia_182408', NULL, NULL, NULL),
    ('CARRETO ARELLANO CHADWICK', 'CARRETO ARELLANO CHADWICK', 'https://www.misprofesores.com/profesores/Chadwick-Carreto-Arellano_27575', 8.7, 89.0, 1.8),
    ('CASTILLO CABRERA GELACIO', 'CASTILLO CABRERA GELACIO', 'https://www.misprofesores.com/profesores/GELACIO-CASTILLO-CABRERA_40736', 6.2, 56.0, 3.2),
    ('CASTILLO MARRUFO JUAN ANTONIO', 'CASTILLO MARRUFO JUAN ANTONIO', 'https://www.misprofesores.com/profesores/Juan-Antonio-Castillo-Marrufo_46409', 8.2, 86.0, 3.9),
    ('CASTILLO MARTÍNEZ MIGUEL ÁNGEL', 'CASTILLO MARTINEZ MIGUEL ANGEL', 'https://www.misprofesores.com/profesores/Miguel-Angel-Castillo-Martinez_181507', 6.5, 71.0, 4.6),
    ('CATALAN SALGADO EDGAR ARMANDO', 'CATALAN SALGADO EDGAR ARMANDO', 'https://misprofesores.com/profesores/Edgar-Armando-Catalan-Salgado_36678', 5.3, 47.0, 4.4),
    ('CEBALLOS SEBASTIAN RICARDO', 'CEBALLOS SEBASTIAN RICARDO', 'https://www.misprofesores.com/profesores/Ricardo-Ceballos-Sebastian_37147', 6.4, 62.0, 3.7),
    ('CENTENO ARRAZOLA MARIA SOLEDAD', 'CENTENO ARRAZOLA MARIA SOLEDAD', 'https://www.misprofesores.com/profesores/Maria-Soledad-Centeno-Arrazola_173169', 7.9, 80.0, 0.4),
    ('CERVANTES DE ANDA ISMAEL', 'CERVANTES DE ANDA ISMAEL', 'https://www.misprofesores.com/profesores/Ismael-Cervantes-de-Anda_27238', 8.7, 86.0, 2.9),
    ('CERVANTES ESPINOSA LUIS MOCTEZUMA', 'CERVANTES ESPINOSA LUIS MOCTEZUMA', 'https://www.misprofesores.com/profesores/Luis-Moctezuma-Cervantes-Espinoza_40667', 7.5, 77.0, 3.3),
    ('CHAVARRIA BAEZ LORENA', 'CHAVARRIA BAEZ LORENA', 'https://www.misprofesores.com/profesores/Lorena-Chavarria-Baez_25549', 6.1, 49.0, 5.3),
    ('CHAVEZ LIMA EDUARDO', 'CHAVEZ LIMA EDUARDO', 'https://www.misprofesores.com/profesores/Eduardo-Chavez-Lima_18617', 6.6, 49.0, 3.9),
    ('CIFUENTES ALVAREZ ALEJANDRO SIGFRIDO', 'CIFUENTES ALVAREZ ALEJANDRO SIGFRIDO', 'https://www.misprofesores.com/profesores/Aljeandro-Sigfrido-Cifuentes-Alvarez_41228', 5.4, 48.0, 2.8),
    ('CORDERO LOPEZ MARTHA ROSA', 'CORDERO LOPEZ MARTHA ROSA', 'https://www.misprofesores.com/profesores/MARTHA-ROSA-CORDERO-LOPEZ_41541', 6.1, 54.0, 3.0),
    ('CORONILLA CONTRERAS UKRANIO', 'CORONILLA CONTRERAS UKRANIO', 'https://www.misprofesores.com/profesores/UKRANIO-CORONILLA_26980', 6.5, 57.0, 4.2),
    ('CORREA COYAC DAVID', 'CORREA COYAC DAVID', 'https://www.misprofesores.com/profesores/David-Correa-Coyac_177040', 7.9, 70.0, 2.0),
    ('CORTÉS DÁVALOS ANDRÉS', 'CORTES DAVALOS ANDRES', 'https://www.misprofesores.com/profesores/Andres-Cortes-Davalos_182249', 7.5, 50.0, 3.0),
    ('CORTEZ DUARTE NIDIA ASUNCIÓN', 'CORTEZ DUARTE NIDIA ASUNCION', 'https://www.misprofesores.com/profesores/Nidia-Asuncion-Cortes-Duarte_35872', 7.1, 66.0, 3.1),
    ('CRUZ CARLIN EFREN', 'CRUZ CARLIN EFREN', 'https://www.misprofesores.com/profesores/Efren-Cruz-Carlin_166851', 8.9, 89.0, 2.0),
    ('CRUZ LAZARO ING. APOLINAR FRANCISCO', 'CRUZ LAZARO ING. APOLINAR FRANCISCO', 'https://misprofesores.com/profesores/Apolinar-Francisco-Cruz-Lazaro_81603', 8.6, 89.0, 0.4),
    ('CRUZ MEZA MARIA ELENA', 'CRUZ MEZA MARIA ELENA', 'https://www.misprofesores.com/profesores/Maria-Elena-Cruz-Meza_41789', 5.9, 43.0, 3.4),
    ('CRUZ ROJAS JORGE ALBERTO', 'CRUZ ROJAS JORGE ALBERTO', 'https://www.misprofesores.com/profesores/Jorger-Alberto-Cruz-Rojas_148153', 6.5, 56.0, 1.1),
    ('CRUZ TORRES BENJAMIN', 'CRUZ TORRES BENJAMIN', 'https://misprofesores.com/profesores/Benjamin-Cruz-Torres_86105', 7.0, 69.0, 3.3),
    ('DAVALOS LOPEZ JOSE CARLOS', 'DAVALOS LOPEZ JOSE CARLOS', 'https://www.misprofesores.com/profesores/Juan-Jose-Davalos-Lopez_100680', 8.3, 86.0, 3.0),
    ('DE LA O TORRES SAUL', 'DE LA O TORRES SAUL', 'https://misprofesores.com/profesores/Saul-De-la-O-Torres_36965', 7.4, 68.0, 4.3),
    ('DIAZ HUERTA CLAUDIA CELIA', 'DIAZ HUERTA CLAUDIA CELIA', 'https://www.misprofesores.com/profesores/claudia-celia-DIAZ-HUERTA_51280', 8.1, 66.0, 4.1),
    ('DIAZ SANCHEZ HUGO', 'DIAZ SANCHEZ HUGO', 'https://www.misprofesores.com/profesores/Hugo-Diaz-Sanchez_181488', 7.0, 60.0, 3.6),
    ('DIAZ SANTIAGO RICARDO FELIPE', 'DIAZ SANTIAGO RICARDO FELIPE', 'https://www.misprofesores.com/profesores/Ricardo-Felipe-Diaz-de-Santiago_22498', 7.2, 72.0, 2.1),
    ('DIAZ SANTIAGO SANDRA', 'DIAZ SANTIAGO SANDRA', 'https://www.misprofesores.com/profesores/Sandra-Diaz_72290', 8.6, 88.0, 3.6),
    ('DIAZ TOALA IVAN', 'DIAZ TOALA IVAN', 'https://www.misprofesores.com/profesores/IVAN-DIAZ-TOALA_40755', 8.7, 85.0, 3.3),
    ('DOMINGUEZ HERNANDEZ SAMUEL', 'DOMINGUEZ HERNANDEZ SAMUEL', 'https://www.misprofesores.com/profesores/Samuel-Dominguez-Hernandez_179045', 7.4, 78.0, 2.2),
    ('DONG _ SHIHAI', 'DONG _ SHIHAI', NULL, NULL, NULL, NULL),
    ('DORANTES CORDERO MARTHA MARGARITA', 'DORANTES CORDERO MARTHA MARGARITA', 'https://www.misprofesores.com/profesores/MARTHA-MARGARITA-DORANTES-CORDERO_182002', 9.8, 100.0, 0.0),
    ('DORANTES VILLA CLAUDIA JISELA', 'DORANTES VILLA CLAUDIA JISELA', 'https://www.misprofesores.com/profesores/Claudia-Jisela-Dorantes-Villa_36840', 6.7, 57.0, 3.1),
    ('DURÀN CAMARILLO EDMUNDO RENÈ', 'DURAN CAMARILLO EDMUNDO RENE', 'https://www.misprofesores.com/profesores/Edmundo-Rene-Duran-Camarillo_38205', 6.4, 61.0, 3.8),
    ('ENRIQUEZ ZARATE Dr. JOSE ASUNCION', 'ENRIQUEZ ZARATE DR. JOSE ASUNCION', 'https://www.misprofesores.com/profesores/Jose-Asuncion-Enriquez-Zarate_46663', 8.3, 84.0, 1.6),
    ('ESCALANTE NOTARIO ENRIQUE', 'ESCALANTE NOTARIO ENRIQUE', NULL, NULL, NULL, NULL),
    ('ESCAMILLA MIRANDA PATRICIA', 'ESCAMILLA MIRANDA PATRICIA', 'https://www.misprofesores.com/profesores/Patricia-Escamilla-Miranda_120943', 7.4, 65.0, 2.2),
    ('ESPARZA SALINAS ROCÍO', 'ESPARZA SALINAS ROCIO', 'https://misprofesores.com/profesores/Rocio-Esparza-Salinas_176738', 5.7, 33.0, 2.7),
    ('ESQUIVEL CENTENO JOSE ARMANDO', 'ESQUIVEL CENTENO JOSE ARMANDO', 'https://www.misprofesores.com/profesores/Armando-Esquivel-Centeno_18613', 8.3, 85.0, 1.4),
    ('ESTRADA ELIZALDE SERAFIN', 'ESTRADA ELIZALDE SERAFIN', 'https://misprofesores.com/profesores/SERAFIN-ESTRADA-ELIZALDE_32069', 6.7, 69.0, 2.5),
    ('FERNANDEZ VAZQUEZ ALFONSO', 'FERNANDEZ VAZQUEZ ALFONSO', 'https://www.misprofesores.com/profesores/ALFONSO-FERNANDEZ-VAZQUEZ_82880', 7.2, 67.0, 5.3),
    ('FERRER TENORIO JORGE', 'FERRER TENORIO JORGE', 'https://misprofesores.com/profesores/Jorge-Ferrer-Tenorio_38620', 7.6, 68.0, 2.0),
    ('FIGUEROA DEL PRADO FELIPE DE JESUS', 'FIGUEROA DEL PRADO FELIPE DE JESUS', 'https://misprofesores.com/profesores/Felipe-de-Jesus-Figueroa-del-Prado_36947', 7.0, 63.0, 3.6),
    ('FLORES DELGADO RAQUEL', 'FLORES DELGADO RAQUEL', 'https://www.misprofesores.com/profesores/Raquel-FLORES-DELGADO_75786', 6.5, 66.0, 0.7),
    ('FLORES ESTRADA ITURIEL ENRIQUE', 'FLORES ESTRADA ITURIEL ENRIQUE', 'https://misprofesores.com/profesores/ITURIEL-ENRIQUE-FLORES-ESTRADA_154327', 9.0, 75.0, 1.0),
    ('FLORES FUENTES NARIA ADRIANA', 'FLORES FUENTES NARIA ADRIANA', 'https://www.misprofesores.com/profesores/NARIA-ADRIANA-FLORES-FUENTES_38310', 9.2, 94.0, 4.2),
    ('FLORES MERAZ YESICA SONIA', 'FLORES MERAZ YESICA SONIA', 'https://www.misprofesores.com/profesores/YESICA-SONIA-FLORES-MERAZ_161606', 6.9, 58.0, 5.2),
    ('FRANCO MARTINEZ EDGARDO ADRIAN', 'FRANCO MARTINEZ EDGARDO ADRIAN', 'https://www.misprofesores.com/profesores/Edgardo-Adrian-Franco-Martinez_25963', 8.6, 88.0, 3.6),
    ('GALEANA CHAVEZ M. en A.P. MARIA DEL ROSARIO', 'GALEANA CHAVEZ M. EN A.P. MARIA DEL ROSARIO', 'https://www.misprofesores.com/profesores/Maria-del-Rosario-Galenana-Chavez_148068', 9.3, 100.0, 1.6),
    ('GALICIA MEJIA RUBEN', 'GALICIA MEJIA RUBEN', 'https://www.misprofesores.com/profesores/Ruben-Galicia-Mejia_46751', 6.2, 51.0, 2.4),
    ('GALIÑANES RODRIGUEZ MARIA GABRIELA', 'GALINANES RODRIGUEZ MARIA GABRIELA', 'https://www.misprofesores.com/profesores/Maria-Gabriela-Galinanes-Rodriguez_45929', 6.9, 60.0, 3.0),
    ('GARCIA BLANQUEL CLAUDIA', 'GARCIA BLANQUEL CLAUDIA', 'https://misprofesores.com/profesores/Claudia-Garcia-Blanquel_166906', 6.1, 45.0, 4.1),
    ('GARCIA CORTES ROCIO', 'GARCIA CORTES ROCIO', NULL, NULL, NULL, NULL),
    ('GARCIA FLORIANO ANDRES', 'GARCIA FLORIANO ANDRES', 'https://www.misprofesores.com/profesores/Andres-Garcia-Floriano_172614', 9.9, 100.0, 0.4),
    ('GARCIA MENDOZA CONSUELO VARINIA', 'GARCIA MENDOZA CONSUELO VARINIA', 'https://misprofesores.com/profesores/Garcia-Mendoza-Consuelo-Varinia_45930', 7.8, 78.0, 2.4),
    ('GARCIA SALAS HORACIO ALBERTO', 'GARCIA SALAS HORACIO ALBERTO', 'https://misprofesores.com/profesores/Horacio-Garcia-Salas_169337', 3.5, 17.0, 3.7),
    ('GASPAR MEDINA FABIAN', 'GASPAR MEDINA FABIAN', 'https://www.misprofesores.com/profesores/Fabian-Gaspar_114932', 8.7, 79.0, 1.7),
    ('GOMEZ MAYORGA MARGARITA ELIZABETH', 'GOMEZ MAYORGA MARGARITA ELIZABETH', 'https://www.misprofesores.com/profesores/Margarita-Elizabeth-Gomez-Mayorga_35949', 4.3, 32.0, 5.0),
    ('GOMEZ TRESS MARIANA', 'GOMEZ TRESS MARIANA', 'https://www.misprofesores.com/profesores/Mariana-Gomez-Tress_161428', 10.0, 100.0, 0.2),
    ('GONZALEZ ALBARRAN GISELA', 'GONZALEZ ALBARRAN GISELA', 'https://www.misprofesores.com/profesores/GISELA-GONZALEZ-ALBARRAN_38379', 7.9, 84.0, 0.3),
    ('GONZALEZ CASTILLO JESUS ROBERTO', 'GONZALEZ CASTILLO JESUS ROBERTO', 'https://www.misprofesores.com/profesores/Jesus-Roberto-Gonzalez-Castillo_166635', 9.0, 83.0, 2.5),
    ('GONZALEZ CISNEROS ALEJANDRO', 'GONZALEZ CISNEROS ALEJANDRO', 'https://www.misprofesores.com/profesores/Alejandro-Gonzalez-Cisneros_47846', 6.0, 45.0, 3.3),
    ('GONZALEZ RAMIREZ MARKO ALFONSO', 'GONZALEZ RAMIREZ MARKO ALFONSO', 'https://www.misprofesores.com/profesores/MARKO-ALFONSO-GONZALEZ-RAMIREZ_127605', 7.3, 44.0, 2.4),
    ('GONZALEZ TRUJILLO MIGUEL ANGEL', 'GONZALEZ TRUJILLO MIGUEL ANGEL', 'https://misprofesores.com/profesores/Miguel-Gonzales-Trujillo_36809', 6.9, 54.0, 4.9),
    ('GUTIERREZ ALDANA ALFONSO', 'GUTIERREZ ALDANA ALFONSO', 'https://misprofesores.com/profesores/Alfonso-Gutierrez-Aldana_100138', 8.4, 100.0, 4.0),
    ('GUTIERREZ ALDANA EDUARDO', 'GUTIERREZ ALDANA EDUARDO', 'https://misprofesores.com/profesores/Eduardo-Gutierrez-Aldana_40752', 6.7, 60.0, 5.6),
    ('GUTIERREZ GARCIA JUAN JESUS', 'GUTIERREZ GARCIA JUAN JESUS', 'https://misprofesores.com/profesores/JUAN-JESUS-GUTIERREZ-GARCIA_72575', 6.9, 73.0, 3.7),
    ('GUTIERREZ LUQUE DIANA', 'GUTIERREZ LUQUE DIANA', NULL, NULL, NULL, NULL),
    ('GUTIERREZ MEJIA DARWIN', 'GUTIERREZ MEJIA DARWIN', 'https://www.misprofesores.com/profesores/Darwin-Gutierrez-Mejia_32199', 9.1, 95.0, 3.6),
    ('GUZMAN AGUILAR FLORENCIO', 'GUZMAN AGUILAR FLORENCIO', 'https://www.misprofesores.com/profesores/FLORENCIO-GUZMAN-AGUILAR_35905', 7.9, 85.0, 1.6),
    ('GUZMAN FLORES JESSIE PAULINA', 'GUZMAN FLORES JESSIE PAULINA', 'https://www.misprofesores.com/profesores/JESSIE-PAULINA-GUZMAN-FLORES_59069', 6.2, 61.0, 4.3),
    ('HENESTROSA CARRASCO LETICIA', 'HENESTROSA CARRASCO LETICIA', 'https://www.misprofesores.com/profesores/Leticia-Henestrosa-Carrasco_64190', 8.4, 84.0, 3.5),
    ('HERNANDEZ AGUILAR JOSE LUIS', 'HERNANDEZ AGUILAR JOSE LUIS', 'https://www.misprofesores.com/profesores/JOSE-LUIS-HERNANDEZ-AGUILAR_40740', 7.4, 74.0, 4.0),
    ('HERNÀNDEZ CRUZ MACARIO', 'HERNANDEZ CRUZ MACARIO', 'https://misprofesores.com/profesores/Macario-Hernandez_36677', 7.4, 72.0, 1.8),
    ('HERNANDEZ JAIME JOSEFINA', 'HERNANDEZ JAIME JOSEFINA', 'https://misprofesores.com/profesores/josefina-hernandez-jaime_37026', 8.9, 84.0, 2.4),
    ('HERNANDEZ OLVERA LUIS ENRIQUE', 'HERNANDEZ OLVERA LUIS ENRIQUE', 'https://www.misprofesores.com/profesores/Luis-Enrique-Hernandez-Olvera_64460', 6.9, 50.0, 3.9),
    ('HERNANDEZ RUBIO ERIKA', 'HERNANDEZ RUBIO ERIKA', 'https://misprofesores.com/profesores/Ericka-Hernandez-Rubio_36454', 6.8, 66.0, 1.4),
    ('HERNANDEZ SECUNDINO JOSE CELESTINO ELIAS', 'HERNANDEZ SECUNDINO JOSE CELESTINO ELIAS', 'https://www.misprofesores.com/profesores/Jose-Celestino-Elias-Hernandez-Secundino_108386', 7.4, 67.0, 1.3),
    ('HERNANDEZ VASQUEZ CESAR', 'HERNANDEZ VASQUEZ CESAR', 'https://www.misprofesores.com/profesores/CESAR-HERNANDEZ-VASQUEZ_133402', 8.2, 80.0, 4.1),
    ('HERRERA YAÑEZ CRISPIN', 'HERRERA YANEZ CRISPIN', 'https://www.misprofesores.com/profesores/CRISPIN-HERRERA-YANEZ_52816', 5.9, 45.0, 4.1),
    ('HURTADO AVILÉS GABRIEL', 'HURTADO AVILES GABRIEL', 'https://www.misprofesores.com/profesores/Gabriel-Hurtado-Aviles_181032', 7.1, 69.0, 2.6),
    ('IBAÑEZ ZAMORA LUIS ALBERTO', 'IBANEZ ZAMORA LUIS ALBERTO', 'https://misprofesores.com/profesores/Luis-Alberto-Ibanez-Zamora_198906', 9.5, 100.0, 0.0),
    ('JIMENEZ BENITEZ JOSE ALFREDO', 'JIMENEZ BENITEZ JOSE ALFREDO', 'https://www.misprofesores.com/profesores/Jose-Alfredo-Jimenez-Benitez_27484', 8.2, 78.0, 1.7),
    ('JIMENEZ GALAN YASMIN IVETTE', 'JIMENEZ GALAN YASMIN IVETTE', 'https://www.misprofesores.com/profesores/Yasmin-Ivette-Jimenez-Galan_22560', 7.9, 81.0, 2.6),
    ('JIMENEZ RUIZ RENE BALTAZAR', 'JIMENEZ RUIZ RENE BALTAZAR', 'https://www.misprofesores.com/profesores/Rene-Baltazar-Jimenez-Ruiz_80611', 7.2, 67.0, 5.3),
    ('JIMENEZ VILLANUEVA MARTHA PATRICIA', 'JIMENEZ VILLANUEVA MARTHA PATRICIA', 'https://misprofesores.com/profesores/Martha-Patricia-Jimenez-Villanueva_18616', 6.1, 53.0, 3.9),
    ('JUAREZ GAMBINO JOEL OMAR', 'JUAREZ GAMBINO JOEL OMAR', 'https://misprofesores.com/profesores/Joel-Omar-Juarez-Gambino_35906', 8.7, 88.0, 2.6),
    ('JUAREZ LEON CARLOS', 'JUAREZ LEON CARLOS', 'https://www.misprofesores.com/profesores/Carlos-Juarez-Leon_30233', 4.4, 24.0, 6.1),
    ('JUAREZ MARTINEZ GENARO', 'JUAREZ MARTINEZ GENARO', 'https://www.misprofesores.com/profesores/Genaro-Juarez-Martinez_51074', 6.9, 59.0, 3.4),
    ('JUÁREZ MÉNDEZ ANA BELEM', 'JUAREZ MENDEZ ANA BELEM', 'https://www.misprofesores.com/profesores/Ana-Belem-Juarez-Mendez_112059', 8.5, 81.0, 3.2),
    ('JUAREZ RAMIREZ JAZMIN ADRIANA', 'JUAREZ RAMIREZ JAZMIN ADRIANA', 'https://www.misprofesores.com/profesores/Jazmin-Adriana-Juarez-Ramirez_36277', 8.9, 86.0, 2.9),
    ('JURADO JIMENEZ ROBERTO', 'JURADO JIMENEZ ROBERTO', 'https://www.misprofesores.com/profesores/ROBERTO-JURADO-JIMENEZ_25341', 6.1, 47.0, 6.4),
    ('LAZCANO XOXOTLA LAURA', 'LAZCANO XOXOTLA LAURA', 'https://www.misprofesores.com/profesores/Laura-Lazcano-Xoxotla_60404', 6.7, 68.0, 1.6),
    ('LEAL PACHECO CHRISTIAN RENE', 'LEAL PACHECO CHRISTIAN RENE', 'https://www.misprofesores.com/profesores/Cristian-Pacheco_172939', 8.7, 100.0, 2.7),
    ('LEON HERNANDEZ MIGUEL ABEL', 'LEON HERNANDEZ MIGUEL ABEL', 'https://www.misprofesores.com/profesores/Miguel-Abel-Leon-Hernandez_36411', 7.0, 54.0, 4.5),
    ('LERMA MAGAÑA CARLOS', 'LERMA MAGANA CARLOS', 'https://www.misprofesores.com/profesores/Carlos-Lerma-Magana_182102', 7.2, 50.0, 0.7),
    ('LEVARIO MEDINA SERGIO', 'LEVARIO MEDINA SERGIO', 'https://www.misprofesores.com/profesores/Sergio-Levario-Medina_154603', 6.1, 47.0, 3.5),
    ('LINARES VALLEJO ERICK EUGENIO', 'LINARES VALLEJO ERICK EUGENIO', 'https://www.misprofesores.com/profesores/Erick-Eugenio-Linares-Vallejo_35112', 6.4, 51.0, 4.1),
    ('LOPEZ CARRERA BENJAMIN', 'LOPEZ CARRERA BENJAMIN', 'https://www.misprofesores.com/profesores/Benjamin-Lopez-Carrera_41460', 6.6, 64.0, 5.3),
    ('LÓPEZ GÓMEZ ALEJANDRO', 'LOPEZ GOMEZ ALEJANDRO', 'https://misprofesores.com/profesores/Alejandro-Lopez-Gomez_176941', 5.2, 44.0, 6.4),
    ('LOPEZ LEYVA LUIS OCTAVIO', 'LOPEZ LEYVA LUIS OCTAVIO', 'https://www.misprofesores.com/profesores/lUIS-OCTAVIO-LOPEZ-LEIVA_37434', 6.8, 60.0, 4.6),
    ('LOPEZ RODRIGUEZ CLAUDIA ALEJANDRA', 'LOPEZ RODRIGUEZ CLAUDIA ALEJANDRA', 'https://misprofesores.com/profesores/Claudia-Alejandra-Lopez-Rodriguez_23216', 7.9, 83.0, 2.3),
    ('LOPEZ ROJAS ARIEL', 'LOPEZ ROJAS ARIEL', 'https://www.misprofesores.com/profesores/ariel-lopez-rojas_23217', 9.5, 92.0, 1.5),
    ('LOPEZ RUIZ GABRIELA DE JESUS', 'LOPEZ RUIZ GABRIELA DE JESUS', 'https://misprofesores.com/profesores/Gabriela-de%20Jesus-Lopez-Ruiz_47516', 3.7, 11.0, 5.1),
    ('LOPEZ SANCHEZ JOSE MANUEL', 'LOPEZ SANCHEZ JOSE MANUEL', 'https://www.misprofesores.com/profesores/Jose-Manuel-Lopez-Sanchez_161740', 9.0, 93.0, 4.1),
    ('LOYOLA ESPINOSA ARACELI', 'LOYOLA ESPINOSA ARACELI', 'https://www.misprofesores.com/profesores/Araceli-Loyola-Espinoza_134228', 9.3, 100.0, 0.7),
    ('LUCIO PEÑA PERLA CECILIA', 'LUCIO PENA PERLA CECILIA', 'https://www.misprofesores.com/profesores/Perla-Cecilia-Lucio-Pena_178581', 8.4, 80.0, 3.6),
    ('LUNA BENOSO BENJAMIN', 'LUNA BENOSO BENJAMIN', 'https://www.misprofesores.com/profesores/Benjamin-Luna-Benoso_21841', 8.3, 83.0, 4.4),
    ('MALDONADO CASTILLO IDALIA', 'MALDONADO CASTILLO IDALIA', 'https://www.misprofesores.com/profesores/Idalia-Maldonado-Castillo_36341', 7.9, 83.0, 3.9),
    ('MALDONADO MUÑOZ MIGUEL ANGEL', 'MALDONADO MUNOZ MIGUEL ANGEL', 'https://www.misprofesores.com/profesores/Miguel-Angel-Maldonado-Munoz_28269', 8.4, 89.0, 0.6),
    ('MANZANILLA GRANADOS HECTOR MANUEL', 'MANZANILLA GRANADOS HECTOR MANUEL', 'https://www.misprofesores.com/profesores/Hector-Manuel-Manzanilla-Granados_36232', 5.8, 48.0, 3.8),
    ('MARQUEZ ARREGUIN GUILLERMO', 'MARQUEZ ARREGUIN GUILLERMO', 'https://www.misprofesores.com/profesores/Guillermo-Marquez-Arreguin_51117', 7.6, 61.0, 3.3),
    ('MARTINEZ DIAZ JUAN CARLOS', 'MARTINEZ DIAZ JUAN CARLOS', 'https://www.misprofesores.com/profesores/Juan-Carlos-Martinez-Diaz_18615', 7.2, 66.0, 4.6),
    ('MARTÍNEZ GARCÍA CÉSAR RÓMAN', 'MARTINEZ GARCIA CESAR ROMAN', 'https://www.misprofesores.com/profesores/Cesar-Roman-Martinez-Garcia_36418', 9.0, 93.0, 1.1),
    ('MARTINEZ GUERRERO JOSE ALFREDO', 'MARTINEZ GUERRERO JOSE ALFREDO', 'https://www.misprofesores.com/profesores/Jose-Alfredo-Martinez-Guerrero_37501', 6.1, 61.0, 3.5),
    ('MARTÍNEZ HERNÁNDEZ GUADALUPE ANA GABRIELA', 'MARTINEZ HERNANDEZ GUADALUPE ANA GABRIELA', NULL, NULL, NULL, NULL),
    ('MARTINEZ NUÑO JESUS ALFREDO', 'MARTINEZ NUNO JESUS ALFREDO', 'https://www.misprofesores.com/profesores/JESUS-ALFREDO-MARTINEZ-NUNO_30730', 6.1, 61.0, 4.7),
    ('MARTINEZ PERALES JOSE CRUZ', 'MARTINEZ PERALES JOSE CRUZ', 'https://www.misprofesores.com/profesores/Jose-Cruz-Martinez-Perales_46506', 7.4, 73.0, 1.6),
    ('MARTINEZ ROSALES RICARDO', 'MARTINEZ ROSALES RICARDO', 'https://www.misprofesores.com/profesores/Ricardo-Martines-Rosales_69051', 8.1, 89.0, 2.9),
    ('MEDINA MEJIA VIRGINIA', 'MEDINA MEJIA VIRGINIA', 'https://www.misprofesores.com/profesores/Vijinia-Mejia-Medina_24794', 9.4, 96.0, 0.5),
    ('MELARA ABARCA REYNA ELIA', 'MELARA ABARCA REYNA ELIA', 'https://www.misprofesores.com/profesores/Reyna-Elia-Melara-Abarca_46396', 6.9, 53.0, 2.2),
    ('MENDEZ SEGUNDO LAURA', 'MENDEZ SEGUNDO LAURA', 'https://misprofesores.com/profesores/Laura-Mendez-Segundo_46406', 6.6, 55.0, 2.2),
    ('MENDOZA MACIAS ELBA', 'MENDOZA MACIAS ELBA', 'https://www.misprofesores.com/profesores/ELBA-MENDOZA-MACIAS_25993', 8.8, 88.0, 3.5),
    ('MIGUEL PILAR ZELIN', 'MIGUEL PILAR ZELIN', 'https://www.misprofesores.com/profesores/Zelin-Miguel-Pilar_24528', 6.3, 64.0, 3.3),
    ('MOLINA PÉREZ DANIEL', 'MOLINA PEREZ DANIEL', NULL, NULL, NULL, NULL),
    ('MONTIEL SANCHEZ ANGEL SALVADOR', 'MONTIEL SANCHEZ ANGEL SALVADOR', 'https://www.misprofesores.com/profesores/ANGEL-SALVADOR-MONTIEL-SANCHEZ_30899', 7.4, 68.0, 4.1),
    ('MORALES CRUZ JUAN CARLOS', 'MORALES CRUZ JUAN CARLOS', 'https://www.misprofesores.com/profesores/Juan-Carlos-Morales-Cruz_27305', 7.5, 62.0, 3.2),
    ('MORALES GONZALEZ ANGEL', 'MORALES GONZALEZ ANGEL', 'https://www.misprofesores.com/profesores/Angel-Morales_27860', 6.7, 57.0, 4.6),
    ('MORALES GUITRON SANDRA LUZ', 'MORALES GUITRON SANDRA LUZ', 'https://www.misprofesores.com/profesores/SANDRA-LUZ-MORALES-GUITRON_36708', 5.0, 40.0, 2.7),
    ('MORALES RODRIGUEZ URSULA SAMANTHA', 'MORALES RODRIGUEZ URSULA SAMANTHA', 'https://www.misprofesores.com/profesores/URSULA-SAMANTHA-MORALES-RODRIGUEZ_154604', 4.0, 23.0, 5.0),
    ('MORAN RUIZ ROBERTO', 'MORAN RUIZ ROBERTO', NULL, NULL, NULL, NULL),
    ('MORENO CERVANTES AXEL ERNESTO', 'MORENO CERVANTES AXEL ERNESTO', 'https://www.misprofesores.com/profesores/Axel-Ernesto-Moreno-Cervantes_40753', 9.3, 92.0, 1.4),
    ('MORENO GALVAN ELIZABETH', 'MORENO GALVAN ELIZABETH', 'https://misprofesores.com/profesores/ELIZABETH-MORENO-GALVAN_134660', 8.4, 71.0, 1.7),
    ('MOSCOSO MALAGON YOSAFAT', 'MOSCOSO MALAGON YOSAFAT', 'https://www.misprofesores.com/profesores/YOSAFAT-MOSCOSO-MALAGON_32413', 6.9, 54.0, 2.3),
    ('MOSSO GARCIA M. EN C. IVAN GIOVANNY', 'MOSSO GARCIA M. EN C. IVAN GIOVANNY', 'https://misprofesores.com/profesores/Ivan-Giovanny-Mosso-Garcia_30436', 8.2, 82.0, 2.9),
    ('MUJICA ASCENCIO CESAR', 'MUJICA ASCENCIO CESAR', 'https://www.misprofesores.com/profesores/Cesar-Mujica-Ascencio_32134', 5.7, 47.0, 4.6),
    ('MUÑOZ SALAZAR LAURA', 'MUNOZ SALAZAR LAURA', 'https://misprofesores.com/profesores/Laura-Munoz-Salazar_36419', 7.7, 79.0, 2.5),
    ('NAVA LARA JOEL', 'NAVA LARA JOEL', 'https://www.misprofesores.com/profesores/Joel-Nava-Lara_90290', 8.3, 86.0, 3.2),
    ('NÚÑEZ PRADO CÉSAR JESÚS', 'NUNEZ PRADO CESAR JESUS', 'https://www.misprofesores.com/profesores/CESAR-JESUS-NUNEZ-PRADO_173659', 9.5, 100.0, 3.8),
    ('OCOTITLA ROJAS NANCY', 'OCOTITLA ROJAS NANCY', 'https://misprofesores.com/profesores/Nancy-Ocotitla-Rojas_20666', 5.1, 42.0, 3.7),
    ('OJEDA GUILLEN DIDIER', 'OJEDA GUILLEN DIDIER', 'https://misprofesores.com/profesores/DIDIER-OJEDA-GUILLEN_49839', 9.2, 98.0, 3.1),
    ('OJEDA SANTILLAN RODRIGO', 'OJEDA SANTILLAN RODRIGO', 'https://www.misprofesores.com/profesores/Rodrigo-Ojeda-Santillan_172613', 3.2, 23.0, 2.8),
    ('OJEDA SILVA OSCAR ALONSO', 'OJEDA SILVA OSCAR ALONSO', 'https://misprofesores.com/profesores/Oscar-Alonso-Ojeda-Silva_194767', 10.0, 100.0, 0.0),
    ('OLALDE MOGOLLAN NORMA', 'OLALDE MOGOLLAN NORMA', 'https://www.misprofesores.com/profesores/Norma-Olalde-Mogollan_166503', 8.3, 88.0, 0.2),
    ('OLMEDO AGUIRRE JOSE OSCAR', 'OLMEDO AGUIRRE JOSE OSCAR', 'https://misprofesores.com/profesores/Jose-Oscar-Olmedo-Aguirre_191561', 5.0, 100.0, 0.0),
    ('ORTEGA GONZALEZ JEAN MIA', 'ORTEGA GONZALEZ JEAN MIA', 'https://misprofesores.com/profesores/Jean-Ortega-Gonzalez_176691', 7.2, 63.0, 1.7),
    ('ORTEGA GONZALEZ RUBEN', 'ORTEGA GONZALEZ RUBEN', 'https://www.misprofesores.com/profesores/Ruben-Ortega-Gonzalez_51229', 8.1, 73.0, 5.4),
    ('ORTIGOZA CAMPOS M. en C. ANDRES', 'ORTIGOZA CAMPOS M. EN C. ANDRES', 'https://www.misprofesores.com/profesores/Andres-Ortigoza-Campos_41860', 8.4, 88.0, 4.1),
    ('ORTIZ CASTILLO MARCO ANTONIO', 'ORTIZ CASTILLO MARCO ANTONIO', 'https://www.misprofesores.com/profesores/Marco-Antonio-Ortiz-Castillo_186347', 8.3, 80.0, 2.6),
    ('ORTIZ RAMIREZ JOSE ANTONIO', 'ORTIZ RAMIREZ JOSE ANTONIO', 'https://www.misprofesores.com/profesores/JOSE-ANTONIO-ORTIZ-RAMIREZ_40751', 8.6, 89.0, 1.1),
    ('ORTUÑO ARAUJO JESUS', 'ORTUNO ARAUJO JESUS', 'https://www.misprofesores.com/profesores/Jesus-Ortuno-Araujo_38716', 8.3, 85.0, 3.0),
    ('PACHUCA HERRERA YANIRA', 'PACHUCA HERRERA YANIRA', 'https://www.misprofesores.com/profesores/Yanira-Pachuca-Herrera_161429', 8.1, 83.0, 1.6),
    ('PALACIOS SOLANO ROCIO', 'PALACIOS SOLANO ROCIO', 'https://www.misprofesores.com/profesores/Rocio-Solano-Palacios_95392', 7.5, 71.0, 3.6),
    ('PALMA OROZCO ROSAURA', 'PALMA OROZCO ROSAURA', 'https://www.misprofesores.com/profesores/Rosaura-Palma-Orozco_46507', 7.6, 70.0, 1.5),
    ('PAREDES CADENA MYRIAM NOEMI', 'PAREDES CADENA MYRIAM NOEMI', 'https://www.misprofesores.com/profesores/Myriam-Noemi-Paredes-Cadena_113407', 6.8, 46.0, 1.2),
    ('PASTRANA FERNANDEZ CARLOS JESUS', 'PASTRANA FERNANDEZ CARLOS JESUS', 'https://www.misprofesores.com/profesores/Carlos-Jesus-Pastrana-Fernandez_72344?pag=2', 4.7, 30.0, 4.5),
    ('PEREZ DE LOS SANTOS MONDRAGON TANIBET', 'PEREZ DE LOS SANTOS MONDRAGON TANIBET', 'https://www.misprofesores.com/profesores/Mondragon-Tanibet-Perez-de-los-santos_41488', 5.8, 46.0, 4.0),
    ('PEREZ PEREZ JOSE JUAN', 'PEREZ PEREZ JOSE JUAN', 'https://www.misprofesores.com/profesores/Jose-Juan-Perez-Perez_182852', 7.8, 75.0, 1.5),
    ('PEREZ VERA SANDRA MERCEDES', 'PEREZ VERA SANDRA MERCEDES', 'https://misprofesores.com/profesores/Sandra-Mercedes-Perez-Vera_18619', 8.9, 93.0, 1.9),
    ('PESCADOR ROJAS MIRIAM', 'PESCADOR ROJAS MIRIAM', 'https://misprofesores.com/profesores/Miriam-Pescador-Rojas_35950', 7.4, 71.0, 3.2),
    ('PINEDA GUERRERO CARLOS', 'PINEDA GUERRERO CARLOS', 'https://www.misprofesores.com/profesores/Carlos-Pineda-Guerrero_120837', 8.1, 82.0, 3.3),
    ('PORTILLO CEDILLO MANUEL', 'PORTILLO CEDILLO MANUEL', 'https://misprofesores.com/profesores/Manuel-Portillo-Cedillo_191248', 10.0, 100.0, 2.7),
    ('PUEBLA LOMAS JAIME HUGO', 'PUEBLA LOMAS JAIME HUGO', 'https://www.misprofesores.com/profesores/jaime-hugo-puebla-lomas_50910', 6.3, 52.0, 3.9),
    ('QUINTANAR GUZMÁN ANA CRISTINA', 'QUINTANAR GUZMAN ANA CRISTINA', NULL, NULL, NULL, NULL),
    ('QUINTERO TELLEZ ROLANDO', 'QUINTERO TELLEZ ROLANDO', NULL, NULL, NULL, NULL),
    ('RAMIREZ GUZMAN ALICIA MARCELA', 'RAMIREZ GUZMAN ALICIA MARCELA', 'https://misprofesores.com/profesores/Alicia-Marcela-Remirez-Guzman_172787', 10.0, 100.0, 0.0),
    ('RAMIREZ MARTINEZ ELIA TZINDEJHE', 'RAMIREZ MARTINEZ ELIA TZINDEJHE', 'https://misprofesores.com/profesores/Elia-Tzindejhe-Ramirez-Martinez_139668', 8.5, 50.0, 1.0),
    ('RAMIREZ MORALES MARIO AUGUSTO', 'RAMIREZ MORALES MARIO AUGUSTO', 'https://misprofesores.com/profesores/Mario-Augusto-Ramirez_32043', 8.1, 82.0, 4.0),
    ('RAMIREZ ROMERO TONAHTIU ARTURO', 'RAMIREZ ROMERO TONAHTIU ARTURO', 'https://www.misprofesores.com/profesores/TONAHTIU-ARTURO-RAMIREZ-ROMERO_69232', 7.2, 63.0, 4.1),
    ('RAMIREZ TENORIO RAFAEL', 'RAMIREZ TENORIO RAFAEL', 'https://misprofesores.com/profesores/Rafael-Ramirez-Tenorio_36964', 5.9, 34.0, 4.4),
    ('RANGEL NAHUM CARLOS ALEXIS', 'RANGEL NAHUM CARLOS ALEXIS', 'https://misprofesores.com/profesores/Carlos-Alexis-Rangel-Nahum_172668', 3.4, 29.0, 2.3),
    ('RANGEL PÉREZ MARÍA TERESA', 'RANGEL PEREZ MARIA TERESA', 'https://misprofesores.com/profesores/Maria-Teresa-Rangel-Perez_181584', 10.0, 100.0, 0.0),
    ('RESENDIZ MUÑOZ ROCIO', 'RESENDIZ MUNOZ ROCIO', 'https://www.misprofesores.com/profesores/Rocio-Resendiz-Munoz_31944', 5.8, 43.0, 5.1),
    ('REYES BERMEJO TLATOANI DE JESUS', 'REYES BERMEJO TLATOANI DE JESUS', 'https://www.misprofesores.com/profesores/TLATOANI-DE-JESUS-REYES-BERMEJO_31985', 6.4, 48.0, 5.2),
    ('REYES VERA ABDIEL', 'REYES VERA ABDIEL', 'https://www.misprofesores.com/profesores/Abdiel-Reyes-Vera_181487', 6.3, 67.0, 4.0),
    ('RIVERA DE LA ROSA MONICA', 'RIVERA DE LA ROSA MONICA', 'https://www.misprofesores.com/profesores/Monica-Rivera-de-la-Rosa_34427', 5.3, 57.0, 1.8),
    ('ROCHA BERNABE MARÍA DEL ROSARIO', 'ROCHA BERNABE MARIA DEL ROSARIO', 'https://misprofesores.com/profesores/ROSARIO-ROCHA-BERNABE_36705', 7.9, 75.0, 4.1),
    ('RODRIGUEZ CASTILLO MIGUEL ANGEL', 'RODRIGUEZ CASTILLO MIGUEL ANGEL', 'https://www.misprofesores.com/profesores/Miguel-Angel-Rodriguez-Castillo_124446', 8.9, 89.0, 1.4),
    ('RODRIGUEZ JORDAN GABRIEL DE JESUS', 'RODRIGUEZ JORDAN GABRIEL DE JESUS', 'https://www.misprofesores.com/profesores/Gabriel-de-Jesus-Rodriguez-Jordan_165125', 6.9, 50.0, 2.3),
    ('RODRIGUEZ ORDAZ MARISOL', 'RODRIGUEZ ORDAZ MARISOL', 'https://www.misprofesores.com/profesores/Marisol-Rodriguez-Ordaz_107759', 6.3, 55.0, 1.9),
    ('RODRIGUEZ SARABIA TANIA', 'RODRIGUEZ SARABIA TANIA', 'https://www.misprofesores.com/profesores/TANIA-RODRIGUEZ-SARABIA_100422', 5.2, 36.0, 2.0),
    ('RODRIGUEZ VILLARREAL JOSE GREGORIO', 'RODRIGUEZ VILLARREAL JOSE GREGORIO', 'https://www.misprofesores.com/profesores/Jose-Gregorio-Rodriguez_173007', 7.8, 75.0, 4.0),
    ('ROJAS MEXICANO ISMAEL', 'ROJAS MEXICANO ISMAEL', 'https://www.misprofesores.com/profesores/Ismael-Rojas-Mexicano_27473', 6.8, 70.0, 1.0),
    ('ROMÁN GODÍNEZ RODRIGO FRANCISCO', 'ROMAN GODINEZ RODRIGO FRANCISCO', 'https://www.misprofesores.com/profesores/Rodrigo-Francisco-Roman-Godinez_181435', 7.3, 67.0, 3.8),
    ('ROMERO HERRERA RODOLFO', 'ROMERO HERRERA RODOLFO', 'https://www.misprofesores.com/profesores/rodolfo-romero-herrera_56142', 5.9, 46.0, 3.6),
    ('ROSAS CARRILLO ARY SHARED', 'ROSAS CARRILLO ARY SHARED', 'https://www.misprofesores.com/profesores/Ary-Shared-Rosas-Castillo_166948', 7.2, 67.0, 1.7),
    ('ROSAS TRIGUEROS JORGE LUIS', 'ROSAS TRIGUEROS JORGE LUIS', 'https://www.misprofesores.com/profesores/Jorge-Luis-Rosas-Mendoza_43076', NULL, NULL, NULL),
    ('RUEDA MELENDEZ JOSE MARCO ANTONIO', 'RUEDA MELENDEZ JOSE MARCO ANTONIO', 'https://misprofesores.com/profesores/MARCO-ANTONIO-RUEDA-MELENDEZ_36697', 7.3, 68.0, 2.2),
    ('RUIZ LEDESMA ELENA FABIOLA', 'RUIZ LEDESMA ELENA FABIOLA', 'https://www.misprofesores.com/profesores/Elena-Fabiola-Ruiz-Ledesma_18618', 7.4, 69.0, 3.1),
    ('SALAS RAMIREZ ISRAEL', 'SALAS RAMIREZ ISRAEL', 'https://misprofesores.com/profesores/Israel-Salas-Ramirez_156308', 7.7, 100.0, 1.0),
    ('SALAZAR RAMIREZ MANUEL', 'SALAZAR RAMIREZ MANUEL', 'https://www.misprofesores.com/profesores/Manuel-Salazar-Ramirez_46659', 7.8, 81.0, 2.8),
    ('SALAZAR URBINA ALVARO', 'SALAZAR URBINA ALVARO', 'https://misprofesores.com/profesores/ALVARO-SALAZAR-URBINA_191568', 6.0, 100.0, 4.0),
    ('SALDÍVAR ALMOREJO MARÍA MAGDALENA', 'SALDIVAR ALMOREJO MARIA MAGDALENA', 'https://www.misprofesores.com/profesores/Maria-Magdalena-Saldivar-Almorejo_177039', 2.4, 0.0, 2.8),
    ('SALINAS CALLEJAS MARÍA DE LOURDES', 'SALINAS CALLEJAS MARIA DE LOURDES', 'https://www.misprofesores.com/profesores/Maria-de-lourdes-callejas-salinas_182584', 8.2, 100.0, 0.0),
    ('SALINAS HERNANDEZ ENCARNACION', 'SALINAS HERNANDEZ ENCARNACION', 'https://www.misprofesores.com/profesores/encarnacion-salinas-hernandez_43174', 6.6, 54.0, 5.7),
    ('SANCHEZ ARROYO JOSE EMILIO', 'SANCHEZ ARROYO JOSE EMILIO', 'https://www.misprofesores.com/profesores/Jose-Emilio-Sanchez-Arroyo_134871', 3.6, 20.0, 3.7),
    ('SANCHEZ BRITO MIGUEL', 'SANCHEZ BRITO MIGUEL', 'https://www.misprofesores.com/profesores/Miguel-Sanchez-Brito_154593', 5.5, 25.0, 5.7),
    ('SANCHEZ CRUZ VIRGINIA', 'SANCHEZ CRUZ VIRGINIA', 'https://www.misprofesores.com/profesores/VIRGINIA-SANCHEZ-CRUZ_32050', 6.1, 51.0, 3.3),
    ('SANCHEZ GARCIA LUZ MARIA', 'SANCHEZ GARCIA LUZ MARIA', 'https://www.misprofesores.com/profesores/Luz-Maria-Sanchez-Garcia_41700', 7.6, 69.0, 1.5),
    ('SANCHEZ GARFIAS Dr. FLAVIO ARTURO', 'SANCHEZ GARFIAS DR. FLAVIO ARTURO', 'https://misprofesores.com/profesores/FLAVIO-ARTURO-SANCHEZ-GARFIAS_40748', 7.8, 75.0, 2.2),
    ('SANCHEZ JUAREZ JOSE', 'SANCHEZ JUAREZ JOSE', 'https://www.misprofesores.com/profesores/Jose-Sanchez-Juarez_105323', 7.7, 100.0, 0.7),
    ('SANCHEZ MANILLA ANGELES ALEJANDRA', 'SANCHEZ MANILLA ANGELES ALEJANDRA', 'https://misprofesores.com/profesores/SANCHEZ-MANILLA-ANGELES-ALEJANDRA_177416', 8.4, 100.0, 2.0),
    ('SANCHEZ MORENO ADRIANA DE LA P', 'SANCHEZ MORENO ADRIANA DE LA P', 'https://www.misprofesores.com/profesores/Adriana-Sanchez-Moreno_38715', 9.4, 94.0, 0.9),
    ('SANCHEZ PALACIOS MARIA SUSANA', 'SANCHEZ PALACIOS MARIA SUSANA', 'https://www.misprofesores.com/profesores/Maria-Susana-Sanchez-Palacios_42022', 5.5, 43.0, 3.7),
    ('SANCHEZ QUINTANILLA GILBERTO', 'SANCHEZ QUINTANILLA GILBERTO', 'https://www.misprofesores.com/profesores/Gilberto-Sanchez-Quintanilla_36963', 6.1, 45.0, 4.9),
    ('SANCHEZ VARGAS PERLA REBECA', 'SANCHEZ VARGAS PERLA REBECA', 'https://www.misprofesores.com/profesores/Sanchez-Vargas-Perla-Rebeca_92539', 7.7, 84.0, 3.3),
    ('SANCHEZ VELEZ RICARDO', 'SANCHEZ VELEZ RICARDO', 'https://www.misprofesores.com/profesores/Ricardo-Sanchez-Velez_166082', 4.9, 27.0, 5.1),
    ('SANTIAGO VALENTIN ERIC', 'SANTIAGO VALENTIN ERIC', 'https://www.misprofesores.com/profesores/Eric-Santiago-Valentin_166233', 8.9, 81.0, 2.8),
    ('SANTILLAN LUNA RAUL', 'SANTILLAN LUNA RAUL', 'https://www.misprofesores.com/profesores/Raul-Santillan-Luna_56290', 7.6, 78.0, 2.9),
    ('SERRANO ROMERO CLAUDIA WENDY', 'SERRANO ROMERO CLAUDIA WENDY', 'https://misprofesores.com/profesores/Claudia-Wendy-Serrano-Romero_189554', 6.7, 67.0, 2.7),
    ('SERRANO TALAMANTES J. FELIX', 'SERRANO TALAMANTES J. FELIX', 'https://misprofesores.com/profesores/J.-FELIX-SERRANO-TALAMANTES_46875', 6.4, 54.0, 3.1),
    ('SILVA MARTINEZ JORGE JAVIER', 'SILVA MARTINEZ JORGE JAVIER', 'https://www.misprofesores.com/profesores/Jorge-Javier-Silva-Martinez_32563', 9.5, 94.0, 1.3),
    ('SILVA SANCHEZ CARLOS', 'SILVA SANCHEZ CARLOS', 'https://www.misprofesores.com/profesores/Carlos-Silva_28421', 6.8, 44.0, 4.9),
    ('SOLORZA GUZMAN MISAEL', 'SOLORZA GUZMAN MISAEL', 'https://www.misprofesores.com/profesores/Misael-Solorza-Guzman_32991', 4.0, 11.0, 5.7),
    ('SOSA ADAN FANNY', 'SOSA ADAN FANNY', 'https://misprofesores.com/profesores/Fanny-Adan-Sosa_135983', 8.8, 88.0, 1.6),
    ('SOTO RAMOS MANUEL ALEJANDRO', 'SOTO RAMOS MANUEL ALEJANDRO', 'https://www.misprofesores.com/profesores/MANUEL-ALEJANDRO-SOTO-RAMOS_28304', 7.3, 78.0, 2.8),
    ('SUAREZ CASTAÑON MIGUEL SANTIAGO', 'SUAREZ CASTANON MIGUEL SANTIAGO', 'https://misprofesores.com/profesores/MIGUEL-SANTIAGO-SUAREZ-CASTANON_33039', 7.4, 68.0, 3.5),
    ('TECLA PARRA ROBERTO', 'TECLA PARRA ROBERTO', 'https://www.misprofesores.com/profesores/Roberto-Tecla-Parra_32018', 7.2, 79.0, 1.5),
    ('TELLEZ BARRERA JUAN CARLOS', 'TELLEZ BARRERA JUAN CARLOS', 'https://www.misprofesores.com/profesores/Juan-Carlos-Tellez-Barrera_113020', 8.6, 82.0, 2.1),
    ('TELLEZ REYES MA. DEL SOCORRO', 'TELLEZ REYES MA. DEL SOCORRO', 'https://www.misprofesores.com/profesores/Maria-del-Socorro-Tellez-Reyes_108013', 9.6, 100.0, 0.2),
    ('TENORIO MARRON MARCO ANTONIO', 'TENORIO MARRON MARCO ANTONIO', 'https://www.misprofesores.com/profesores/Marco-Antonio-Marron-Tenorio_154635', 9.3, 100.0, 1.1),
    ('TESTA NAVA ALEXIS', 'TESTA NAVA ALEXIS', 'https://www.misprofesores.com/profesores/Alexis-Testa-Navas_113459', 5.7, 45.0, 5.1),
    ('TORRES GONZALEZ ENRIQUE', 'TORRES GONZALEZ ENRIQUE', 'https://www.misprofesores.com/profesores/ENRIQUE-TORRES-GONZALEZ_36707', 7.1, 64.0, 0.9),
    ('TORRES RUIZ MIGUEL JESUS', 'TORRES RUIZ MIGUEL JESUS', 'https://misprofesores.com/profesores/Miguel-Jesus-Torres-Ruiz_181485', 9.5, 100.0, 1.0),
    ('URIARTE ARCIA ABRIL VALERIA', 'URIARTE ARCIA ABRIL VALERIA', 'https://misprofesores.com/profesores/Abril-Valeria-Uriarte-Arcia_161631', 9.0, 89.0, 1.1),
    ('VASQUEZ GÓMEZ JUAN IRVING', 'VASQUEZ GOMEZ JUAN IRVING', 'https://misprofesores.com/profesores/Juan-Irving-Vasquez-Gomez_170853', 8.4, 63.0, 2.0),
    ('VAZQUEZ ARREGUIN ROBERTO', 'VAZQUEZ ARREGUIN ROBERTO', 'https://www.misprofesores.com/profesores/Roberto-Vazquez-Arreguin_36420', 6.9, 68.0, 2.1),
    ('VAZQUEZ GONZALEZ LEONOR', 'VAZQUEZ GONZALEZ LEONOR', 'https://misprofesores.com/profesores/Leonor-Vazquez-Gonzalez_36229', 8.0, 91.0, 3.3),
    ('VAZQUEZ ORTIZ MIJAIL', 'VAZQUEZ ORTIZ MIJAIL', 'https://www.misprofesores.com/profesores/Mijail-Vazquez-Ortiz_80630', 7.6, 75.0, 3.8),
    ('VELEZ SALDAÑA ULISES', 'VELEZ SALDANA ULISES', 'https://www.misprofesores.com/profesores/Ulises-Velez-Saldana_31636', 6.1, 47.0, 5.7),
    ('VERA HERNANDEZ GUMERSINDO', 'VERA HERNANDEZ GUMERSINDO', 'https://misprofesores.com/profesores/Gumersindo-Vera-Hernandez_41486', 8.0, 81.0, 1.4),
    ('VILLEGAS NAVARRETE SONIA', 'VILLEGAS NAVARRETE SONIA', 'https://www.misprofesores.com/profesores/Sonia-Villegas-Navarrete_54380', 8.4, 86.0, 2.0),
    ('VIVEROS VELA KARINA', 'VIVEROS VELA KARINA', 'https://www.misprofesores.com/profesores/Karina-Viveros-Vela_18612', 8.3, 86.0, 3.6),
    ('ZAGAL FLORES ROBERTO ESWART', 'ZAGAL FLORES ROBERTO ESWART', 'https://misprofesores.com/profesores/ROBERTO-ESWART-ZAGAL-FLORES_28303', 7.7, 83.0, 3.2),
    ('ZARATE CARDENAS ALEJANDRO', 'ZARATE CARDENAS ALEJANDRO', 'https://www.misprofesores.com/profesores/Alejandro-Zarate-Cardenas_126790', 7.4, 86.0, 1.0)
ON CONFLICT (nombre_norm) DO NOTHING;

-- --- Ofertas y sus sesiones -----------------------------------------
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AM1', 'A101', (SELECT id FROM profesor WHERE nombre_norm = 'RUEDA MELENDEZ JOSE MARCO ANTONIO'), '1', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AM1', 'A102', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ VILLANUEVA MARTHA PATRICIA'), '2', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AM1', 'A103', (SELECT id FROM profesor WHERE nombre_norm = 'CENTENO ARRAZOLA MARIA SOLEDAD'), '1', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AM1', 'A104', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA GUILLEN DIDIER'), '1', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AM1', 'A105', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ CRUZ MACARIO'), '1', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AM2', 'A101', (SELECT id FROM profesor WHERE nombre_norm = 'ALCANTARA MENDEZ ALBERTO JESUS'), '1', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AM2', 'A102', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ PALACIOS MARIA SUSANA'), '1', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (2, 3), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AM2', 'A103', (SELECT id FROM profesor WHERE nombre_norm = 'QUINTANAR GUZMAN ANA CRISTINA'), '1', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AM2', 'A104', (SELECT id FROM profesor WHERE nombre_norm = 'VAZQUEZ ARREGUIN ROBERTO'), '1', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AM2', 'A105', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIZ CASTILLO MARCO ANTONIO'), '1', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AV1', 'A101', (SELECT id FROM profesor WHERE nombre_norm = 'GUTIERREZ GARCIA JUAN JESUS'), '1', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AV1', 'A102', (SELECT id FROM profesor WHERE nombre_norm = 'PACHUCA HERRERA YANIRA'), '1', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AV1', 'A103', (SELECT id FROM profesor WHERE nombre_norm = 'GOMEZ TRESS MARIANA'), '1', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AV1', 'A104', (SELECT id FROM profesor WHERE nombre_norm = 'LEVARIO MEDINA SERGIO'), '1', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AV1', 'A105', (SELECT id FROM profesor WHERE nombre_norm = 'RANGEL NAHUM CARLOS ALEXIS'), '1', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (5, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AV2', 'A101', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIZ CASTILLO MARCO ANTONIO'), '1', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AV2', 'A102', (SELECT id FROM profesor WHERE nombre_norm = 'MONTIEL SANCHEZ ANGEL SALVADOR'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AV2', 'A103', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES CORDERO MARTHA MARGARITA'), '1', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AV2', 'A104', (SELECT id FROM profesor WHERE nombre_norm = 'JURADO JIMENEZ ROBERTO'), '1', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1AV2', 'A105', (SELECT id FROM profesor WHERE nombre_norm = 'RANGEL NAHUM CARLOS ALEXIS'), '1', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BM1', 'B101', (SELECT id FROM profesor WHERE nombre_norm = 'FIGUEROA DEL PRADO FELIPE DE JESUS'), '1', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BM1', 'B102', (SELECT id FROM profesor WHERE nombre_norm = 'HERRERA YANEZ CRISPIN'), '1', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BM1', 'B103', (SELECT id FROM profesor WHERE nombre_norm = 'GUTIERREZ LUQUE DIANA'), '1', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BM1', 'B104', (SELECT id FROM profesor WHERE nombre_norm = 'VAZQUEZ ARREGUIN ROBERTO'), '1', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BM1', 'B105', (SELECT id FROM profesor WHERE nombre_norm = 'SALINAS HERNANDEZ ENCARNACION'), '1', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BM1', 'B106', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ PERALES JOSE CRUZ'), '1', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BM2', 'B101', (SELECT id FROM profesor WHERE nombre_norm = 'SUAREZ CASTANON MIGUEL SANTIAGO'), '1', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BM2', 'B102', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ VILLANUEVA MARTHA PATRICIA'), '2', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (2, 4), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BM2', 'B103', (SELECT id FROM profesor WHERE nombre_norm = 'CENTENO ARRAZOLA MARIA SOLEDAD'), '1', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BM2', 'B104', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA GUILLEN DIDIER'), '1', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BM2', 'B105', (SELECT id FROM profesor WHERE nombre_norm = 'MUNOZ SALAZAR LAURA'), '1', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BM2', 'B106', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ CRUZ VIRGINIA'), '1', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BV1', 'B101', (SELECT id FROM profesor WHERE nombre_norm = 'GUTIERREZ GARCIA JUAN JESUS'), '1', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BV1', 'B102', (SELECT id FROM profesor WHERE nombre_norm = 'LUCIO PENA PERLA CECILIA'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5), (5, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BV1', 'B103', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES CORDERO MARTHA MARGARITA'), '1', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BV1', 'B104', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES MERAZ YESICA SONIA'), '1', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BV1', 'B105', (SELECT id FROM profesor WHERE nombre_norm = 'LEVARIO MEDINA SERGIO'), '1', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BV1', 'B106', (SELECT id FROM profesor WHERE nombre_norm = 'ESTRADA ELIZALDE SERAFIN'), '1', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BV2', 'B101', (SELECT id FROM profesor WHERE nombre_norm = 'DE LA O TORRES SAUL'), '1', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BV2', 'B102', (SELECT id FROM profesor WHERE nombre_norm = 'NAVA LARA JOEL'), '1', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 5), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BV2', 'B103', (SELECT id FROM profesor WHERE nombre_norm = 'GOMEZ TRESS MARIANA'), '1', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BV2', 'B104', (SELECT id FROM profesor WHERE nombre_norm = 'LEVARIO MEDINA SERGIO'), '1', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BV2', 'B105', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ ROJAS JORGE ALBERTO'), '1', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 5), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1BV2', 'B106', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ PERALES JOSE CRUZ'), '1', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM1', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'RESENDIZ MUNOZ ROCIO'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM1', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'VAZQUEZ GONZALEZ LEONOR'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM1', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES FUENTES NARIA ADRIANA'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM1', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ VILLARREAL JOSE GREGORIO'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM1', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ MORENO ADRIANA DE LA P'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM2', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'PAREDES CADENA MYRIAM NOEMI'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM2', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ PALACIOS MARIA SUSANA'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (3, 4), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM2', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VARGAS PERLA REBECA'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM2', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VELEZ RICARDO'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM2', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'CENTENO ARRAZOLA MARIA SOLEDAD'), '1', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM3', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'FRANCO MARTINEZ EDGARDO ADRIAN'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM3', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VARGAS PERLA REBECA'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (4, 4), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM3', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'ARCOS DIAZ ELSA LETICIA'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM3', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ TRUJILLO MIGUEL ANGEL'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM3', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'CENTENO ARRAZOLA MARIA SOLEDAD'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM4', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'FIGUEROA DEL PRADO FELIPE DE JESUS'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM4', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'MOSSO GARCIA M. EN C. IVAN GIOVANNY'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (2, 4), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM4', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VARGAS PERLA REBECA'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM4', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ CARRERA BENJAMIN'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM4', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'TELLEZ REYES MA. DEL SOCORRO'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM5', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'RESENDIZ MUNOZ ROCIO'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM5', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VARGAS PERLA REBECA'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM5', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES VILLA CLAUDIA JISELA'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM5', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VELEZ RICARDO'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM5', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'TELLEZ REYES MA. DEL SOCORRO'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM6', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'DAVALOS LOPEZ JOSE CARLOS'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM6', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'HERRERA YANEZ CRISPIN'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM6', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES VILLA CLAUDIA JISELA'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM6', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VELEZ RICARDO'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM6', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'ARREDONDO SANCHEZ ANA LAURA'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM7', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'DAVALOS LOPEZ JOSE CARLOS'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM7', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'REYES BERMEJO TLATOANI DE JESUS'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (2, 2), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM7', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ VELEZ RICARDO'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM7', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ VILLARREAL JOSE GREGORIO'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM8', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES FUENTES NARIA ADRIANA'), NULL, NULL)
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CM9', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA BLANQUEL CLAUDIA'), NULL, NULL)
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV1', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'ROMAN GODINEZ RODRIGO FRANCISCO'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV1', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'BUITRON DAMASO ISRAEL'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (2, 8), (3, 8), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV1', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'ZARATE CARDENAS ALEJANDRO'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV1', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'MANZANILLA GRANADOS HECTOR MANUEL'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV1', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'RANGEL PEREZ MARIA TERESA'), '1', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV2', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'RAMIREZ ROMERO TONAHTIU ARTURO'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV2', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'LUCIO PENA PERLA CECILIA'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (2, 9), (4, 6), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV2', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'AVILA SANCHEZ CRISTHIAN ALEJANDRO'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV2', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'MANZANILLA GRANADOS HECTOR MANUEL'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV2', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'LAZCANO XOXOTLA LAURA'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV3', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ GARFIAS DR. FLAVIO ARTURO'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV3', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'LUCIO PENA PERLA CECILIA'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 6), (2, 7), (3, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV3', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'SOLORZA GUZMAN MISAEL'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV3', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'LEON HERNANDEZ MIGUEL ABEL'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV3', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'LAZCANO XOXOTLA LAURA'), '1', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV4', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'AVILA SANCHEZ CRISTHIAN ALEJANDRO'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV4', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'MONTIEL SANCHEZ ANGEL SALVADOR'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (2, 5), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV4', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'JURADO JIMENEZ ROBERTO'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV4', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ HUERTA CLAUDIA CELIA'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV4', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'GOMEZ TRESS MARIANA'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV5', 'C101', (SELECT id FROM profesor WHERE nombre_norm = 'SANTILLAN LUNA RAUL'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (2, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV5', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'BUITRON DAMASO ISRAEL'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 9), (3, 9), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV5', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'DOMINGUEZ HERNANDEZ SAMUEL'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV5', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ HUERTA CLAUDIA CELIA'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV5', 'C105', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES CORDERO MARTHA MARGARITA'), '1', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV6', 'C102', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES MERAZ YESICA SONIA'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV6', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'SOLORZA GUZMAN MISAEL'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV6', 'C104', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ ROJAS JORGE ALBERTO'), '1', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '1CV7', 'C103', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANCHEZ HUGO'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AM1', 'A201', (SELECT id FROM profesor WHERE nombre_norm = 'SUAREZ CASTANON MIGUEL SANTIAGO'), '1', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AM1', 'A202', (SELECT id FROM profesor WHERE nombre_norm = 'ARCOS DIAZ ELSA LETICIA'), '1', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AM1', 'A203', (SELECT id FROM profesor WHERE nombre_norm = 'ORTEGA GONZALEZ JEAN MIA'), '1', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AM1', 'A204', (SELECT id FROM profesor WHERE nombre_norm = 'CARBALLO JIMENEZ JUAN MANUEL'), '1', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (4, 4), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AM1', 'A205', (SELECT id FROM profesor WHERE nombre_norm = 'RAMIREZ TENORIO RAFAEL'), '1', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AM2', 'A201', (SELECT id FROM profesor WHERE nombre_norm = 'RUEDA MELENDEZ JOSE MARCO ANTONIO'), '1', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AM2', 'A202', (SELECT id FROM profesor WHERE nombre_norm = 'REYES BERMEJO TLATOANI DE JESUS'), '1', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AM2', 'A203', (SELECT id FROM profesor WHERE nombre_norm = 'ORTEGA GONZALEZ JEAN MIA'), '1', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AM2', 'A204', (SELECT id FROM profesor WHERE nombre_norm = 'VAZQUEZ GONZALEZ LEONOR'), '1', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (3, 4), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AM2', 'A205', (SELECT id FROM profesor WHERE nombre_norm = 'RAMIREZ TENORIO RAFAEL'), '1', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AV1', 'A201', (SELECT id FROM profesor WHERE nombre_norm = 'PORTILLO CEDILLO MANUEL'), '1', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AV1', 'A202', (SELECT id FROM profesor WHERE nombre_norm = 'ORTUNO ARAUJO JESUS'), '1', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AV1', 'A203', (SELECT id FROM profesor WHERE nombre_norm = 'MORAN RUIZ ROBERTO'), '1', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AV1', 'A204', (SELECT id FROM profesor WHERE nombre_norm = 'DOMINGUEZ HERNANDEZ SAMUEL'), '1', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (2, 5), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AV1', 'A205', (SELECT id FROM profesor WHERE nombre_norm = 'VILLEGAS NAVARRETE SONIA'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AV2', 'A201', (SELECT id FROM profesor WHERE nombre_norm = 'CARMONA GARCIA ENRIQUE ALFONSO'), '1', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AV2', 'A202', (SELECT id FROM profesor WHERE nombre_norm = 'ORTUNO ARAUJO JESUS'), '1', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2AV2', 'A204', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES MERAZ YESICA SONIA'), '1', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 5), (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BM1', 'B201', (SELECT id FROM profesor WHERE nombre_norm = 'RUEDA MELENDEZ JOSE MARCO ANTONIO'), '1', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BM1', 'B202', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ CISNEROS ALEJANDRO'), '1', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BM1', 'B203', (SELECT id FROM profesor WHERE nombre_norm = 'AGUILAR SANCHEZ FERNANDO'), '1', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BM1', 'B204', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ VASQUEZ CESAR'), '1', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BM1', 'B205', (SELECT id FROM profesor WHERE nombre_norm = 'VERA HERNANDEZ GUMERSINDO'), '1', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BM1', 'B206', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ JAIME JOSEFINA'), '1', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BM2', 'B201', (SELECT id FROM profesor WHERE nombre_norm = 'ALBORTANTE MORATO CECILIA'), '1', '114')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BM2', 'B202', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ SANCHEZ JOSE MANUEL'), '1', '114')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BM2', 'B203', (SELECT id FROM profesor WHERE nombre_norm = 'MUJICA ASCENCIO CESAR'), '1', '114')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BM2', 'B204', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ VASQUEZ CESAR'), '1', '114')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BM2', 'B205', (SELECT id FROM profesor WHERE nombre_norm = 'VERA HERNANDEZ GUMERSINDO'), '1', '114')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BM2', 'B206', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ JAIME JOSEFINA'), '1', '114')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BV1', 'B201', (SELECT id FROM profesor WHERE nombre_norm = 'RAMIREZ ROMERO TONAHTIU ARTURO'), '1', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BV1', 'B202', (SELECT id FROM profesor WHERE nombre_norm = 'LEAL PACHECO CHRISTIAN RENE'), '1', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BV1', 'B203', (SELECT id FROM profesor WHERE nombre_norm = 'BARRON VERA JOSUE EMANUEL'), '1', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BV1', 'B204', (SELECT id FROM profesor WHERE nombre_norm = 'ZARATE CARDENAS ALEJANDRO'), '1', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BV1', 'B205', (SELECT id FROM profesor WHERE nombre_norm = 'OLALDE MOGOLLAN NORMA'), '1', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BV1', 'B206', (SELECT id FROM profesor WHERE nombre_norm = 'ESTRADA ELIZALDE SERAFIN'), '1', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BV2', 'B202', (SELECT id FROM profesor WHERE nombre_norm = 'SANTIAGO VALENTIN ERIC'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2BV2', 'B204', (SELECT id FROM profesor WHERE nombre_norm = 'LEON HERNANDEZ MIGUEL ABEL'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM1', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'TECLA PARRA ROBERTO'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM1', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'GUZMAN AGUILAR FLORENCIO'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM1', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'VIVEROS VELA KARINA'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM1', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'SALINAS HERNANDEZ ENCARNACION'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (2, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM1', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'ARREDONDO SANCHEZ ANA LAURA'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM1', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'CASTILLO MARRUFO JUAN ANTONIO'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM2', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'FRANCO MARTINEZ EDGARDO ADRIAN'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM2', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES GONZALEZ ANGEL'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM2', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'RUIZ LEDESMA ELENA FABIOLA'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM2', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ ROJAS JORGE ALBERTO'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM2', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'OLALDE MOGOLLAN NORMA'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM2', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'GALINANES RODRIGUEZ MARIA GABRIELA'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM3', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'FRANCO MARTINEZ EDGARDO ADRIAN'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM3', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ SANCHEZ JOSE MANUEL'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM3', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ ROJAS JORGE ALBERTO'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM3', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'CORREA COYAC DAVID'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (4, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM3', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ ARROYO JOSE EMILIO'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM3', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'MALDONADO MUNOZ MIGUEL ANGEL'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM4', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ JORDAN GABRIEL DE JESUS'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM4', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ CISNEROS ALEJANDRO'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM4', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ ROJAS JORGE ALBERTO'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM4', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'MUNOZ SALAZAR LAURA'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (2, 4), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM4', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ ARROYO JOSE EMILIO'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM4', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'TORRES GONZALEZ ENRIQUE'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM5', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'TECLA PARRA ROBERTO'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM5', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'CANEDO SUAREZ LETICIA'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM5', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'CEBALLOS SEBASTIAN RICARDO'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM5', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'CENTENO ARRAZOLA MARIA SOLEDAD'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM5', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'TORRES GONZALEZ ENRIQUE'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM6', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'ALBORTANTE MORATO CECILIA'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM6', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES GONZALEZ ANGEL'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM6', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'VIVEROS VELA KARINA'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM6', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ MORENO ADRIANA DE LA P'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CM6', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'CASTILLO MARRUFO JUAN ANTONIO'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV1', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'CARMONA GARCIA ENRIQUE ALFONSO'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV1', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'GUTIERREZ MEJIA DARWIN'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV1', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ LEON CARLOS'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV1', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'ESQUIVEL CENTENO JOSE ARMANDO'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (2, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV1', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ PERALES JOSE CRUZ'), '1', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV2', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ MENDEZ ANA BELEM'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV2', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'NAVA LARA JOEL'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV2', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ LEON CARLOS'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV2', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'CORREA COYAC DAVID'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (4, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV2', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'CABRERA CHAVEZ GLORIA LOURDES'), '1', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV3', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIZ CASTILLO MARCO ANTONIO'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV3', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'NAVA LARA JOEL'), '1', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV3', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'ZARATE CARDENAS ALEJANDRO'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV3', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'DOMINGUEZ HERNANDEZ SAMUEL'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (4, 4), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV3', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA SILVA OSCAR ALONSO'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV3', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'VILLEGAS NAVARRETE SONIA'), '1', '012')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV4', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'MOSCOSO MALAGON YOSAFAT'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV4', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ VILLARREAL JOSE GREGORIO'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV4', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ ROJAS JORGE ALBERTO'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV4', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'LEVARIO MEDINA SERGIO'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7), (5, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV4', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA SILVA OSCAR ALONSO'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV4', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'CABRERA CHAVEZ GLORIA LOURDES'), '1', '013')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV5', 'C201', (SELECT id FROM profesor WHERE nombre_norm = 'CARMONA GARCIA ENRIQUE ALFONSO'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV5', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES MERAZ YESICA SONIA'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV5', 'C203', (SELECT id FROM profesor WHERE nombre_norm = 'ZARATE CARDENAS ALEJANDRO'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV5', 'C204', (SELECT id FROM profesor WHERE nombre_norm = 'ESQUIVEL CENTENO JOSE ARMANDO'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8), (5, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV5', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'SERRANO ROMERO CLAUDIA WENDY'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV5', 'C206', (SELECT id FROM profesor WHERE nombre_norm = 'ESTRADA ELIZALDE SERAFIN'), '1', '014')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV6', 'C202', (SELECT id FROM profesor WHERE nombre_norm = 'GUTIERREZ MEJIA DARWIN'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '2CV6', 'C205', (SELECT id FROM profesor WHERE nombre_norm = 'SERRANO ROMERO CLAUDIA WENDY'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AM1', 'A301', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ GARCIA LUZ MARIA'), '2', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AM1', 'A302', (SELECT id FROM profesor WHERE nombre_norm = 'AGUILAR VELAZQUEZ DANIEL'), '2', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AM1', 'A303', (SELECT id FROM profesor WHERE nombre_norm = 'VELEZ SALDANA ULISES'), '2', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AM1', 'A304', (SELECT id FROM profesor WHERE nombre_norm = 'PACHUCA HERRERA YANIRA'), '2', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 2), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AM1', 'A305', (SELECT id FROM profesor WHERE nombre_norm = 'GUTIERREZ ALDANA EDUARDO'), '2', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (2, 5), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AM1', 'A306', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ CRUZ VIRGINIA'), '2', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AM2', 'A301', (SELECT id FROM profesor WHERE nombre_norm = 'ALBORTANTE MORATO CECILIA'), '2', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AM2', 'A302', (SELECT id FROM profesor WHERE nombre_norm = 'RAMIREZ MORALES MARIO AUGUSTO'), '2', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AM2', 'A303', (SELECT id FROM profesor WHERE nombre_norm = 'OCOTITLA ROJAS NANCY'), '2', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AM2', 'A304', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ RAMIREZ JAZMIN ADRIANA'), '2', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AM2', 'A305', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIGOZA CAMPOS M. EN C. ANDRES'), '2', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (3, 5), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AM2', 'A306', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ JAIME JOSEFINA'), '2', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AV1', 'A301', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ BRITO MIGUEL'), '2', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AV1', 'A302', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ BRITO MIGUEL'), '2', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AV1', 'A303', (SELECT id FROM profesor WHERE nombre_norm = 'BLANCO ALMAZAN IVAN EDUARDO'), '2', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AV1', 'A304', (SELECT id FROM profesor WHERE nombre_norm = 'SANTIAGO VALENTIN ERIC'), '2', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5), (5, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AV1', 'A305', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ JORDAN GABRIEL DE JESUS'), '2', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (3, 5), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AV1', 'A306', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES DELGADO RAQUEL'), '2', '203')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3AV2', 'A303', (SELECT id FROM profesor WHERE nombre_norm = 'CATALAN SALGADO EDGAR ARMANDO'), '2', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BM1', 'B301', (SELECT id FROM profesor WHERE nombre_norm = 'FRANCO MARTINEZ EDGARDO ADRIAN'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BM1', 'B302', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ JUAREZ JOSE'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BM1', 'B303', (SELECT id FROM profesor WHERE nombre_norm = 'AVILA SANCHEZ CRISTHIAN ALEJANDRO'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BM1', 'B304', (SELECT id FROM profesor WHERE nombre_norm = 'CHAVARRIA BAEZ LORENA'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BM1', 'B305', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ RODRIGUEZ CLAUDIA ALEJANDRA'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BM1', 'B306', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ ALBARRAN GISELA'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BM2', 'B301', (SELECT id FROM profesor WHERE nombre_norm = 'LUNA BENOSO BENJAMIN'), '2', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BM2', 'B302', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES RODRIGUEZ URSULA SAMANTHA'), '2', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BM2', 'B303', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA BLANQUEL CLAUDIA'), '2', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BM2', 'B304', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ RUBIO ERIKA'), '2', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BM2', 'B305', (SELECT id FROM profesor WHERE nombre_norm = 'TESTA NAVA ALEXIS'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BM2', 'B306', (SELECT id FROM profesor WHERE nombre_norm = 'RAMIREZ MARTINEZ ELIA TZINDEJHE'), '2', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BV1', 'B301', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA FLORIANO ANDRES'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BV1', 'B302', (SELECT id FROM profesor WHERE nombre_norm = 'DE LA O TORRES SAUL'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BV1', 'B303', (SELECT id FROM profesor WHERE nombre_norm = 'SANTIAGO VALENTIN ERIC'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BV1', 'B304', (SELECT id FROM profesor WHERE nombre_norm = 'HURTADO AVILES GABRIEL'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BV1', 'B305', (SELECT id FROM profesor WHERE nombre_norm = 'BARRALES LOPEZ ANA LUZ'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BV1', 'B306', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ VERA SANDRA MERCEDES'), '2', '204')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BV2', 'B301', (SELECT id FROM profesor WHERE nombre_norm = 'AVILA SANCHEZ CRISTHIAN ALEJANDRO'), '2', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BV2', 'B303', (SELECT id FROM profesor WHERE nombre_norm = 'ZARATE CARDENAS ALEJANDRO'), '2', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BV2', 'B304', (SELECT id FROM profesor WHERE nombre_norm = 'CATALAN SALGADO EDGAR ARMANDO'), '2', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3BV2', 'B305', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ RUIZ RENE BALTAZAR'), '2', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM1', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANTIAGO RICARDO FELIPE'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM1', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'DAVALOS LOPEZ JOSE CARLOS'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM1', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'SILVA MARTINEZ JORGE JAVIER'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM1', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'TESTA NAVA ALEXIS'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM1', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'ALCANTARA MENDEZ ALBERTO JESUS'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM1', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'OCOTITLA ROJAS NANCY'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM1', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'GALINANES RODRIGUEZ MARIA GABRIELA'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM2', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANTIAGO RICARDO FELIPE'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM2', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ CASTILLO MIGUEL ANGEL'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM2', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'MIGUEL PILAR ZELIN'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM2', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ PEREZ JOSE JUAN'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM2', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'CANCINO CALDERON SERGIO'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM2', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'CHAVARRIA BAEZ LORENA'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM2', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'AGUSTIN DOMINGUEZ VERONICA'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM3', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANTIAGO SANDRA'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM3', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'CORTES DAVALOS ANDRES'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM3', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'SILVA MARTINEZ JORGE JAVIER'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM3', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ SECUNDINO JOSE CELESTINO ELIAS'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM3', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'FIGUEROA DEL PRADO FELIPE DE JESUS'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM3', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'GALEANA CHAVEZ M. EN A.P. MARIA DEL ROSARIO'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM3', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'MENDOZA MACIAS ELBA'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM4', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ GARCIA LUZ MARIA'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM4', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ JUAREZ JOSE'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM4', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'CARBALLO JIMENEZ JUAN MANUEL'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM4', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'MUJICA ASCENCIO CESAR'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM4', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'ALMAZAN FARFAN ROCIO'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM4', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'MELARA ABARCA REYNA ELIA'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM4', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'MENDOZA MACIAS ELBA'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM5', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ CASTILLO MIGUEL ANGEL'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CM5', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'ALMAZAN FARFAN ROCIO'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV1', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA FLORIANO ANDRES'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV1', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ JORDAN GABRIEL DE JESUS'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV1', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'SALAZAR RAMIREZ MANUEL'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV1', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'SOTO RAMOS MANUEL ALEJANDRO'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV1', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ GUERRERO JOSE ALFREDO'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV1', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ SARABIA TANIA'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV1', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES DELGADO RAQUEL'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV2', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ MENDEZ ANA BELEM'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV2', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ BRITO MIGUEL'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV2', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'SALAZAR RAMIREZ MANUEL'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV2', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'SANTILLAN LUNA RAUL'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV2', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'HURTADO AVILES GABRIEL'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV2', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'GALINANES RODRIGUEZ MARIA GABRIELA'), '2', '207')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV3', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ BRITO MIGUEL'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV3', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES RODRIGUEZ URSULA SAMANTHA'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV3', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ CASTILLO JESUS ROBERTO'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV3', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ SECUNDINO JOSE CELESTINO ELIAS'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV3', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'SANTILLAN LUNA RAUL'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV3', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'GALEANA CHAVEZ M. EN A.P. MARIA DEL ROSARIO'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV3', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ GALAN YASMIN IVETTE'), '2', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV4', 'C301', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA FLORIANO ANDRES'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV4', 'C302', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ HERNANDEZ GUADALUPE ANA GABRIELA'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV4', 'C303', (SELECT id FROM profesor WHERE nombre_norm = 'AVILA SANCHEZ CRISTHIAN ALEJANDRO'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV4', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'BARRON VERA JOSUE EMANUEL'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV4', 'C305', (SELECT id FROM profesor WHERE nombre_norm = 'VAZQUEZ ORTIZ MIJAIL'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV4', 'C306', (SELECT id FROM profesor WHERE nombre_norm = 'HURTADO AVILES GABRIEL'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV4', 'C307', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ GALAN YASMIN IVETTE'), '2', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '3CV5', 'C304', (SELECT id FROM profesor WHERE nombre_norm = 'BARRALES LOPEZ ANA LUZ'), '1', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AM1', 'A401', (SELECT id FROM profesor WHERE nombre_norm = 'BAUTISTA ROSALES SANDRA IVETTE'), '2', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AM1', 'A402', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ TORRES BENJAMIN'), '2', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AM1', 'A403', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ GOMEZ ALEJANDRO'), '2', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AM1', 'A404', (SELECT id FROM profesor WHERE nombre_norm = 'SALAZAR URBINA ALVARO'), '2', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 4), (3, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AM1', 'A405', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ RAMIREZ JAZMIN ADRIANA'), '2', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3), (5, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AM2', 'A401', (SELECT id FROM profesor WHERE nombre_norm = 'CIFUENTES ALVAREZ ALEJANDRO SIGFRIDO'), '2', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AM2', 'A402', (SELECT id FROM profesor WHERE nombre_norm = 'IBANEZ ZAMORA LUIS ALBERTO'), '2', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AM2', 'A403', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ JORDAN GABRIEL DE JESUS'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AM2', 'A406', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ ALBARRAN GISELA'), '2', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AV1', 'A401', (SELECT id FROM profesor WHERE nombre_norm = 'SOTO RAMOS MANUEL ALEJANDRO'), '2', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AV1', 'A402', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ TORRES BENJAMIN'), '2', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7), (5, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AV1', 'A403', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES GUITRON SANDRA LUZ'), '2', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AV1', 'A404', (SELECT id FROM profesor WHERE nombre_norm = 'BOTELLO CASTILLO ALEJANDRO'), '2', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (2, 5), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AV1', 'A405', (SELECT id FROM profesor WHERE nombre_norm = 'SANTIAGO VALENTIN ERIC'), '2', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 5), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4AV1', 'A406', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES CORDERO MARTHA MARGARITA'), '2', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BM1', 'B401', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ CRUZ MACARIO'), '2', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BM1', 'B402', (SELECT id FROM profesor WHERE nombre_norm = 'CHAVEZ LIMA EDUARDO'), '2', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BM1', 'B403', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ CARRERA BENJAMIN'), '2', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BM1', 'B404', (SELECT id FROM profesor WHERE nombre_norm = 'OLMEDO AGUIRRE JOSE OSCAR'), '2', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BM1', 'B405', (SELECT id FROM profesor WHERE nombre_norm = 'MENDEZ SEGUNDO LAURA'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BM1', 'B406', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ MEZA MARIA ELENA'), '2', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BM2', 'B401', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ CRUZ MACARIO'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BM2', 'B402', (SELECT id FROM profesor WHERE nombre_norm = 'CHAVEZ LIMA EDUARDO'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BM2', 'B403', (SELECT id FROM profesor WHERE nombre_norm = 'AVILA SANCHEZ CRISTHIAN ALEJANDRO'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BM2', 'B404', (SELECT id FROM profesor WHERE nombre_norm = 'ENRIQUEZ ZARATE DR. JOSE ASUNCION'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BM2', 'B405', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ RUIZ GABRIELA DE JESUS'), '2', '002')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BM2', 'B406', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ MEZA MARIA ELENA'), '2', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BV1', 'B401', (SELECT id FROM profesor WHERE nombre_norm = 'CATALAN SALGADO EDGAR ARMANDO'), '2', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BV1', 'B402', (SELECT id FROM profesor WHERE nombre_norm = 'SANTIAGO VALENTIN ERIC'), '2', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BV1', 'B403', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ CASTILLO JESUS ROBERTO'), '2', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BV1', 'B404', (SELECT id FROM profesor WHERE nombre_norm = 'SALINAS CALLEJAS MARIA DE LOURDES'), '2', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BV1', 'B405', (SELECT id FROM profesor WHERE nombre_norm = 'MELARA ABARCA REYNA ELIA'), '2', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4BV1', 'B406', (SELECT id FROM profesor WHERE nombre_norm = 'DE LA O TORRES SAUL'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM1', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ MARTINEZ GENARO'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM1', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ GARCIA CESAR ROMAN'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM1', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'GUZMAN AGUILAR FLORENCIO'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM1', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'TESTA NAVA ALEXIS'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM1', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'DURAN CAMARILLO EDMUNDO RENE'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM1', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'BAUTISTA ROSALES SANDRA IVETTE'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM1', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'QUINTERO TELLEZ ROLANDO'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM2', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ MARTINEZ GENARO'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM2', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'CANEDO SUAREZ LETICIA'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM2', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ TRUJILLO MIGUEL ANGEL'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM2', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'MUJICA ASCENCIO CESAR'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM2', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ DIAZ JUAN CARLOS'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM2', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'RIVERA DE LA ROSA MONICA'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM2', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'FRANCO MARTINEZ EDGARDO ADRIAN'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM3', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'ALBORTANTE MORATO CECILIA'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM3', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ GARCIA CESAR ROMAN'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM3', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'CERVANTES ESPINOSA LUIS MOCTEZUMA'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM3', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'GALICIA MEJIA RUBEN'), '2', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM3', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'TELLEZ BARRERA JUAN CARLOS'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM3', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA CORTES ROCIO'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM4', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'ALBORTANTE MORATO CECILIA'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM4', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'CERVANTES ESPINOSA LUIS MOCTEZUMA'), '2', '206')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM4', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ RODRIGUEZ CLAUDIA ALEJANDRA'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM4', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'DURAN CAMARILLO EDMUNDO RENE'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM4', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'ESCAMILLA MIRANDA PATRICIA'), '2', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM4', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'IBANEZ ZAMORA LUIS ALBERTO'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM5', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'RUIZ LEDESMA ELENA FABIOLA'), '2', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM5', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ DIAZ JUAN CARLOS'), '2', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM5', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'ESCAMILLA MIRANDA PATRICIA'), '1', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM6', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ GARCIA CESAR ROMAN'), NULL, NULL)
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CM6', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'VAZQUEZ ARREGUIN ROBERTO'), NULL, NULL)
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV1', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'MOSCOSO MALAGON YOSAFAT'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV1', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'MONTIEL SANCHEZ ANGEL SALVADOR'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV1', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES MERAZ YESICA SONIA'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV1', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'PASTRANA FERNANDEZ CARLOS JESUS'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV1', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'VAZQUEZ ORTIZ MIJAIL'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV1', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'VELEZ SALDANA ULISES'), '2', '003')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV1', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'SALAS RAMIREZ ISRAEL'), '2', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV2', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'CAMACHO VAZQUEZ VANESSA ALEJANDRA'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV2', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ NUNO JESUS ALFREDO'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV2', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'CASTILLO MARTINEZ MIGUEL ANGEL'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV2', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ AGUILAR JOSE LUIS'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV2', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES GUITRON SANDRA LUZ'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV2', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ BENITEZ JOSE ALFREDO'), '2', '004')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV3', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'CAMACHO VAZQUEZ VANESSA ALEJANDRA'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV3', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ VILLARREAL JOSE GREGORIO'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV3', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ LEYVA LUIS OCTAVIO'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV3', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ GUERRERO JOSE ALFREDO'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV3', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'SOTO RAMOS MANUEL ALEJANDRO'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV3', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ DE LOS SANTOS MONDRAGON TANIBET'), '2', '005')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV4', 'C401', (SELECT id FROM profesor WHERE nombre_norm = 'HURTADO AVILES GABRIEL'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV4', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'LEAL PACHECO CHRISTIAN RENE'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV4', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'CEBALLOS SEBASTIAN RICARDO'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV4', 'C404', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ LEYVA LUIS OCTAVIO'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV4', 'C405', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ GUERRERO JOSE ALFREDO'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV4', 'C406', (SELECT id FROM profesor WHERE nombre_norm = 'SALINAS CALLEJAS MARIA DE LOURDES'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV4', 'C407', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ BENITEZ JOSE ALFREDO'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV5', 'C402', (SELECT id FROM profesor WHERE nombre_norm = 'SANTIAGO VALENTIN ERIC'), '2', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '4CV5', 'C403', (SELECT id FROM profesor WHERE nombre_norm = 'LEAL PACHECO CHRISTIAN RENE'), '2', '007')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5AM1', 'A501', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA MENDOZA CONSUELO VARINIA'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5AM1', 'A502', (SELECT id FROM profesor WHERE nombre_norm = 'REYES VERA ABDIEL'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5AM1', 'A503', (SELECT id FROM profesor WHERE nombre_norm = 'BOTELLO CASTILLO ALEJANDRO'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5AM1', 'A504', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ GOMEZ ALEJANDRO'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3), (5, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5AM1', 'A505', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANCHEZ HUGO'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (2, 5), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5AM1', 'A506', (SELECT id FROM profesor WHERE nombre_norm = 'RAMIREZ GUZMAN ALICIA MARCELA'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5AV1', 'A501', (SELECT id FROM profesor WHERE nombre_norm = 'MOLINA PEREZ DANIEL'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5AV1', 'A502', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES ESTRADA ITURIEL ENRIQUE'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5AV1', 'A503', (SELECT id FROM profesor WHERE nombre_norm = 'ZAGAL FLORES ROBERTO ESWART'), '2', '205')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5AV1', 'A504', (SELECT id FROM profesor WHERE nombre_norm = 'RANGEL NAHUM CARLOS ALEXIS'), '4', '010')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (4, 4), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5AV1', 'A505', (SELECT id FROM profesor WHERE nombre_norm = 'ROMAN GODINEZ RODRIGO FRANCISCO'), '1', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (3, 4), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5AV1', 'A506', (SELECT id FROM profesor WHERE nombre_norm = 'SALDIVAR ALMOREJO MARIA MAGDALENA'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BM1', 'B501', (SELECT id FROM profesor WHERE nombre_norm = 'REYES VERA ABDIEL'), '4', '010')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BM1', 'B502', (SELECT id FROM profesor WHERE nombre_norm = 'SERRANO TALAMANTES J. FELIX'), '4', '010')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BM1', 'B503', (SELECT id FROM profesor WHERE nombre_norm = 'LUNA BENOSO BENJAMIN'), '4', '010')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BM1', 'B504', (SELECT id FROM profesor WHERE nombre_norm = 'CASTILLO CABRERA GELACIO'), '4', '010')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BM1', 'B505', (SELECT id FROM profesor WHERE nombre_norm = 'ROSAS TRIGUEROS JORGE LUIS'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BM1', 'B506', (SELECT id FROM profesor WHERE nombre_norm = 'MORENO GALVAN ELIZABETH'), '4', '010')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BM2', 'B501', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA MENDOZA CONSUELO VARINIA'), '3', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BM2', 'B502', (SELECT id FROM profesor WHERE nombre_norm = 'SERRANO TALAMANTES J. FELIX'), '3', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BM2', 'B503', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ GARCIA LUZ MARIA'), '3', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BM2', 'B504', (SELECT id FROM profesor WHERE nombre_norm = 'GUTIERREZ ALDANA ALFONSO'), '3', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BM2', 'B505', (SELECT id FROM profesor WHERE nombre_norm = 'PESCADOR ROJAS MIRIAM'), '3', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BM2', 'B506', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA SALAS HORACIO ALBERTO'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BV1', 'B501', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ GARFIAS DR. FLAVIO ARTURO'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BV1', 'B502', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES GUITRON SANDRA LUZ'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BV1', 'B503', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ OLVERA LUIS ENRIQUE'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BV1', 'B504', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ TOALA IVAN'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BV1', 'B505', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ MARTINEZ GENARO'), '1', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5BV1', 'B506', (SELECT id FROM profesor WHERE nombre_norm = 'FLORES ESTRADA ITURIEL ENRIQUE'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM1', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIGOZA CAMPOS M. EN C. ANDRES'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM1', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'PUEBLA LOMAS JAIME HUGO'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM1', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'GOMEZ MAYORGA MARGARITA ELIZABETH'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM1', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'ORTEGA GONZALEZ RUBEN'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM1', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ RUIZ GABRIELA DE JESUS'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM1', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'AGUSTIN DOMINGUEZ VERONICA'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM1', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'HENESTROSA CARRASCO LETICIA'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM2', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'TECLA PARRA ROBERTO'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM2', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ TOALA IVAN'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM2', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'LERMA MAGANA CARLOS'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM2', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'ROCHA BERNABE MARIA DEL ROSARIO'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM2', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'ROJAS MEXICANO ISMAEL'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM2', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'GUZMAN FLORES JESSIE PAULINA'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM2', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'ALCARAZ TORRES JUAN JESUS'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM3', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ JUAREZ JOSE'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM3', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'LERMA MAGANA CARLOS'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM3', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'MUJICA ASCENCIO CESAR'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM3', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'CANCINO CALDERON SERGIO'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM3', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'MALDONADO CASTILLO IDALIA'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM3', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'AGUSTIN DOMINGUEZ VERONICA'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM3', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'ALCARAZ TORRES JUAN JESUS'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM4', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'TECLA PARRA ROBERTO'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM4', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'GUTIERREZ ALDANA EDUARDO'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM4', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'GOMEZ MAYORGA MARGARITA ELIZABETH'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM4', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'ALCANTARA MENDEZ ALBERTO JESUS'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM4', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'VELEZ SALDANA ULISES'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM4', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'GUZMAN FLORES JESSIE PAULINA'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM4', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'CORTEZ DUARTE NIDIA ASUNCION'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM5', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ TOALA IVAN'), '3', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM5', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'CASTILLO CABRERA GELACIO'), '3', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CM5', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ QUINTANILLA GILBERTO'), '3', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV1', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'ROMAN GODINEZ RODRIGO FRANCISCO'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV1', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'ARZATE GORDILLO JACQUELINE'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV1', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'PASTRANA FERNANDEZ CARLOS JESUS'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV1', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ AGUILAR JOSE LUIS'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV1', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'BLANCO ALMAZAN IVAN EDUARDO'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV1', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'CABRERA CHAVEZ GLORIA LOURDES'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV1', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ QUINTANILLA GILBERTO'), '3', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV2', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ BRITO MIGUEL'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV2', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'FERNANDEZ VAZQUEZ ALFONSO'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV2', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'IBANEZ ZAMORA LUIS ALBERTO'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV2', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'CERVANTES DE ANDA ISMAEL'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV2', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'BLANCO ALMAZAN IVAN EDUARDO'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV2', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'SILVA SANCHEZ CARLOS'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV2', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'HENESTROSA CARRASCO LETICIA'), '3', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV3', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'PORTILLO CEDILLO MANUEL'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV3', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'ARZATE GORDILLO JACQUELINE'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV3', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'LINARES VALLEJO ERICK EUGENIO'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV3', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'ROCHA BERNABE MARIA DEL ROSARIO'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV3', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'CALDERON SAMBARINO MARIA JULIA'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV3', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'HENESTROSA CARRASCO LETICIA'), '3', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV4', 'C501', (SELECT id FROM profesor WHERE nombre_norm = 'CARMONA GARCIA ENRIQUE ALFONSO'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV4', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'LINARES VALLEJO ERICK EUGENIO'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV4', 'C503', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES CRUZ JUAN CARLOS'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV4', 'C504', (SELECT id FROM profesor WHERE nombre_norm = 'CERVANTES DE ANDA ISMAEL'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV4', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'BLANCO ALMAZAN IVAN EDUARDO'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV4', 'C506', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ ORDAZ MARISOL'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV4', 'C507', (SELECT id FROM profesor WHERE nombre_norm = 'PUEBLA LOMAS JAIME HUGO'), '3', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV5', 'C502', (SELECT id FROM profesor WHERE nombre_norm = 'LINARES VALLEJO ERICK EUGENIO'), '2', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '5CV5', 'C505', (SELECT id FROM profesor WHERE nombre_norm = 'ROSAS CARRILLO ARY SHARED'), '3', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AM1', 'A601', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ GAMBINO JOEL OMAR'), '3', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AM1', 'A602', (SELECT id FROM profesor WHERE nombre_norm = 'SANCHEZ MANILLA ANGELES ALEJANDRA'), '3', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AM1', 'A603', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA BLANQUEL CLAUDIA'), '3', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AM1', 'A604', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA BLANQUEL CLAUDIA'), '3', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AM1', 'A620', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ GOMEZ ALEJANDRO'), '3', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AM1', 'A627', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA CORTES ROCIO'), '3', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AM2', 'A626', (SELECT id FROM profesor WHERE nombre_norm = 'TORRES RUIZ MIGUEL JESUS'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AV1', 'A601', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIZ CASTILLO MARCO ANTONIO'), '3', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AV1', 'A602', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ HERNANDEZ GUADALUPE ANA GABRIELA'), '3', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AV1', 'A603', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANCHEZ HUGO'), '3', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AV1', 'A604', (SELECT id FROM profesor WHERE nombre_norm = 'DONG _ SHIHAI'), '3', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AV1', 'A624', (SELECT id FROM profesor WHERE nombre_norm = 'ROSAS CARRILLO ARY SHARED'), '3', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6AV1', 'A631', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ JORDAN GABRIEL DE JESUS'), '3', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BM1', 'B601', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA SANTILLAN RODRIGO'), '3', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BM1', 'B602', (SELECT id FROM profesor WHERE nombre_norm = 'CAMACHO VAZQUEZ VANESSA ALEJANDRA'), '3', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BM1', 'B603', (SELECT id FROM profesor WHERE nombre_norm = 'CARRETO ARELLANO CHADWICK'), '3', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BM1', 'B604', (SELECT id FROM profesor WHERE nombre_norm = 'SERRANO ROMERO CLAUDIA WENDY'), '3', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BM1', 'B642', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA SALAS HORACIO ALBERTO'), '3', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BM1', 'B643', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ CRUZ MACARIO'), '3', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BM2', 'B601', (SELECT id FROM profesor WHERE nombre_norm = 'IBANEZ ZAMORA LUIS ALBERTO'), '3', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BM2', 'B602', (SELECT id FROM profesor WHERE nombre_norm = 'VASQUEZ GOMEZ JUAN IRVING'), '3', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BM2', 'B603', (SELECT id FROM profesor WHERE nombre_norm = 'MALDONADO CASTILLO IDALIA'), '3', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BM2', 'B604', (SELECT id FROM profesor WHERE nombre_norm = 'SALDIVAR ALMOREJO MARIA MAGDALENA'), '3', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BM2', 'B645', (SELECT id FROM profesor WHERE nombre_norm = 'REYES VERA ABDIEL'), '3', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BM2', 'B650', (SELECT id FROM profesor WHERE nombre_norm = 'MALDONADO CASTILLO IDALIA'), '3', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BV1', 'B601', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ BENITEZ JOSE ALFREDO'), '3', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BV1', 'B602', (SELECT id FROM profesor WHERE nombre_norm = 'DE LA O TORRES SAUL'), '3', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BV1', 'B603', (SELECT id FROM profesor WHERE nombre_norm = 'BLANCO ALMAZAN IVAN EDUARDO'), '3', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BV1', 'B604', (SELECT id FROM profesor WHERE nombre_norm = 'SALDIVAR ALMOREJO MARIA MAGDALENA'), '3', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BV1', 'B641', (SELECT id FROM profesor WHERE nombre_norm = 'PAREDES CADENA MYRIAM NOEMI'), '3', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6BV1', 'B648', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ TORRES BENJAMIN'), '3', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM1', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'AGUILAR VELAZQUEZ DANIEL'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM1', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'AGUILAR SANCHEZ FERNANDO'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM1', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'MARQUEZ ARREGUIN GUILLERMO'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM1', 'C610', (SELECT id FROM profesor WHERE nombre_norm = 'CORTEZ DUARTE NIDIA ASUNCION'), '4', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM1', 'C616', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ ROJAS ARIEL'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM1', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'ROJAS MEXICANO ISMAEL'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM1', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'MORENO CERVANTES AXEL ERNESTO'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM2', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'ROMERO HERRERA RODOLFO'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM2', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ PEREZ JOSE JUAN'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM2', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'MARQUEZ ARREGUIN GUILLERMO'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM2', 'C605', (SELECT id FROM profesor WHERE nombre_norm = 'CORDERO LOPEZ MARTHA ROSA'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM2', 'C607', (SELECT id FROM profesor WHERE nombre_norm = 'TELLEZ BARRERA JUAN CARLOS'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM2', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'CORDERO LOPEZ MARTHA ROSA'), '3', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM2', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'MORENO CERVANTES AXEL ERNESTO'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM3', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ CARLIN EFREN'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM3', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ PEREZ JOSE JUAN'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM3', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ ROJAS ARIEL'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM3', 'C604', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ SARABIA TANIA'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM3', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'ROJAS MEXICANO ISMAEL'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM3', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'BAUTISTA ROSALES SANDRA IVETTE'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM4', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ RUIZ GABRIELA DE JESUS'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM4', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'HERNANDEZ SECUNDINO JOSE CELESTINO ELIAS'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM4', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ ROJAS ARIEL'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM4', 'C611', (SELECT id FROM profesor WHERE nombre_norm = 'REYES VERA ABDIEL'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM4', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'VELEZ SALDANA ULISES'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM4', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'BAUTISTA ROSALES SANDRA IVETTE'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM5', 'C606', (SELECT id FROM profesor WHERE nombre_norm = 'MIGUEL PILAR ZELIN'), '1', '214')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CM5', 'C608', (SELECT id FROM profesor WHERE nombre_norm = 'ALEMAN ARCE MIGUEL ANGEL'), '1', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV1', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ RUIZ GABRIELA DE JESUS'), '3', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV1', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ PEREZ JOSE JUAN'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV1', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'LOPEZ ROJAS ARIEL'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV1', 'C609', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA SANTILLAN RODRIGO'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV1', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ RAMIREZ MARKO ALFONSO'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV1', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'SALAS RAMIREZ ISRAEL'), '2', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV2', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA FLORIANO ANDRES'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV2', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ RUIZ RENE BALTAZAR'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV2', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'MEDINA MEJIA VIRGINIA'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV2', 'C614', (SELECT id FROM profesor WHERE nombre_norm = 'URIARTE ARCIA ABRIL VALERIA'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV2', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ RAMIREZ MARKO ALFONSO'), '3', '211')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV2', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'SALAS RAMIREZ ISRAEL'), '2', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV3', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'CAMACHO VAZQUEZ VANESSA ALEJANDRA'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV3', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'LINARES VALLEJO ERICK EUGENIO'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV3', 'C603', (SELECT id FROM profesor WHERE nombre_norm = 'MEDINA MEJIA VIRGINIA'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV3', 'C613', (SELECT id FROM profesor WHERE nombre_norm = 'PALMA OROZCO ROSAURA'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV3', 'C618', (SELECT id FROM profesor WHERE nombre_norm = 'SALINAS CALLEJAS MARIA DE LOURDES'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 9), (3, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV3', 'C619', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ DE LOS SANTOS MONDRAGON TANIBET'), '3', '212')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV4', 'C601', (SELECT id FROM profesor WHERE nombre_norm = 'ESCALANTE NOTARIO ENRIQUE'), '3', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (3, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV4', 'C602', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES CRUZ JUAN CARLOS'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV4', 'C610', (SELECT id FROM profesor WHERE nombre_norm = 'PORTILLO CEDILLO MANUEL'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '6CV4', 'C612', (SELECT id FROM profesor WHERE nombre_norm = 'MOLINA PEREZ DANIEL'), '3', '213')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7AM1', 'A701', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ SARABIA TANIA'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7AM1', 'A702', (SELECT id FROM profesor WHERE nombre_norm = 'REYES VERA ABDIEL'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7AM1', 'A704', (SELECT id FROM profesor WHERE nombre_norm = 'GUZMAN FLORES JESSIE PAULINA'), '4', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (3, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7AM1', 'A722', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA SALAS HORACIO ALBERTO'), '4', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7AM1', 'A728', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ SARABIA TANIA'), '4', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7AV1', 'A701', (SELECT id FROM profesor WHERE nombre_norm = 'RANGEL NAHUM CARLOS ALEXIS'), '4', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7AV1', 'A702', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIZ CASTILLO MARCO ANTONIO'), '4', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7AV1', 'A704', (SELECT id FROM profesor WHERE nombre_norm = 'PALACIOS SOLANO ROCIO'), '3', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (3, 5), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7AV1', 'A725', (SELECT id FROM profesor WHERE nombre_norm = 'ROSAS TRIGUEROS JORGE LUIS'), '3', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7AV1', 'A729', (SELECT id FROM profesor WHERE nombre_norm = 'PAREDES CADENA MYRIAM NOEMI'), '4', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7AV2', 'A721', (SELECT id FROM profesor WHERE nombre_norm = 'ROMAN GODINEZ RODRIGO FRANCISCO'), '3', '210')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7BM1', 'B702', (SELECT id FROM profesor WHERE nombre_norm = 'NUNEZ PRADO CESAR JESUS'), '4', '009')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7BM1', 'B703', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ ORDAZ MARISOL'), '4', '009')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7BM1', 'B746', (SELECT id FROM profesor WHERE nombre_norm = 'ROMAN GODINEZ RODRIGO FRANCISCO'), '4', '009')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7BM1', 'B752', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA SANTILLAN RODRIGO'), '4', '009')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7BV1', 'B702', (SELECT id FROM profesor WHERE nombre_norm = 'CARMONA GARCIA ENRIQUE ALFONSO'), '4', '009')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7BV1', 'B703', (SELECT id FROM profesor WHERE nombre_norm = 'SILVA SANCHEZ CARLOS'), '4', '009')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7BV1', 'B747', (SELECT id FROM profesor WHERE nombre_norm = 'GARCIA SALAS HORACIO ALBERTO'), '4', '009')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7BV1', 'B749', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIZ CASTILLO MARCO ANTONIO'), '4', '009')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM1', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'CARRETO ARELLANO CHADWICK'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM1', 'C706', (SELECT id FROM profesor WHERE nombre_norm = 'TELLEZ BARRERA JUAN CARLOS'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM1', 'C709', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANTIAGO SANDRA'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM1', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'RIVERA DE LA ROSA MONICA'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM1', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ ROSALES RICARDO'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1), (5, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM2', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'CORONILLA CONTRERAS UKRANIO'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM2', 'C704', (SELECT id FROM profesor WHERE nombre_norm = 'ENRIQUEZ ZARATE DR. JOSE ASUNCION'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM2', 'C707', (SELECT id FROM profesor WHERE nombre_norm = 'LERMA MAGANA CARLOS'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM2', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'RIVERA DE LA ROSA MONICA'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM2', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ ROSALES RICARDO'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM3', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'CORONILLA CONTRERAS UKRANIO'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM3', 'C710', (SELECT id FROM profesor WHERE nombre_norm = 'JUAREZ GAMBINO JOEL OMAR'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM3', 'C713', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ MEZA MARIA ELENA'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM3', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'CIFUENTES ALVAREZ ALEJANDRO SIGFRIDO'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM3', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'TENORIO MARRON MARCO ANTONIO'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM4', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'CORONILLA CONTRERAS UKRANIO'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM4', 'C705', (SELECT id FROM profesor WHERE nombre_norm = 'MARTINEZ HERNANDEZ GUADALUPE ANA GABRIELA'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM4', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'CIFUENTES ALVAREZ ALEJANDRO SIGFRIDO'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM4', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'TENORIO MARRON MARCO ANTONIO'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CM5', 'C715', (SELECT id FROM profesor WHERE nombre_norm = 'DIAZ SANCHEZ HUGO'), '2', '006')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV1', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'OJEDA SANTILLAN RODRIGO'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV1', 'C711', (SELECT id FROM profesor WHERE nombre_norm = 'ROSAS CARRILLO ARY SHARED'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV1', 'C712', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ CARLIN EFREN'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV1', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'MORALES GUITRON SANDRA LUZ'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV1', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'SOTO RAMOS MANUEL ALEJANDRO'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV2', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'PINEDA GUERRERO CARLOS'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV2', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIZ RAMIREZ JOSE ANTONIO'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV2', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'PINEDA GUERRERO CARLOS'), '4', '108')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV3', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'PINEDA GUERRERO CARLOS'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV3', 'C709', (SELECT id FROM profesor WHERE nombre_norm = 'CORTEZ DUARTE NIDIA ASUNCION'), '4', '008')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV3', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'ORTIZ RAMIREZ JOSE ANTONIO'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV3', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'GASPAR MEDINA FABIAN'), '4', '109')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV4', 'C702', (SELECT id FROM profesor WHERE nombre_norm = 'PINEDA GUERRERO CARLOS'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9), (4, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV4', 'C703', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ SARABIA TANIA'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV4', 'C708', (SELECT id FROM profesor WHERE nombre_norm = 'PALACIOS SOLANO ROCIO'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV4', 'C717', (SELECT id FROM profesor WHERE nombre_norm = 'HURTADO AVILES GABRIEL'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6), (5, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '7CV4', 'C718', (SELECT id FROM profesor WHERE nombre_norm = 'GASPAR MEDINA FABIAN'), '4', '110')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8AM1', 'A801', (SELECT id FROM profesor WHERE nombre_norm = 'RAMIREZ MARTINEZ ELIA TZINDEJHE'), '4', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8AM1', 'A802', (SELECT id FROM profesor WHERE nombre_norm = 'MENDOZA MACIAS ELBA'), '4', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (3, 3), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8AV1', 'A801', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES CORDERO MARTHA MARGARITA'), '4', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 5), (2, 5), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8AV1', 'A802', (SELECT id FROM profesor WHERE nombre_norm = 'PAREDES CADENA MYRIAM NOEMI'), '4', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8), (5, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8BM1', 'B801', (SELECT id FROM profesor WHERE nombre_norm = 'DURAN CAMARILLO EDMUNDO RENE'), NULL, NULL)
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (5, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8BM1', 'B801', (SELECT id FROM profesor WHERE nombre_norm = 'RESENDIZ MUNOZ ROCIO'), NULL, NULL)
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8BM1', 'B801', (SELECT id FROM profesor WHERE nombre_norm = 'FIGUEROA DEL PRADO FELIPE DE JESUS'), NULL, NULL)
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8BM1', 'B802', (SELECT id FROM profesor WHERE nombre_norm = 'MALDONADO MUNOZ MIGUEL ANGEL'), '4', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8BM1', 'B804', (SELECT id FROM profesor WHERE nombre_norm = 'ESPARZA SALINAS ROCIO'), '4', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8BM2', 'B801', (SELECT id FROM profesor WHERE nombre_norm = 'BAUTISTA ROSALES SANDRA IVETTE'), NULL, NULL)
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8BM2', 'B801', (SELECT id FROM profesor WHERE nombre_norm = 'ALMAZAN FARFAN ROCIO'), NULL, NULL)
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 1), (4, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8BM2', 'B802', (SELECT id FROM profesor WHERE nombre_norm = 'RODRIGUEZ ORDAZ MARISOL'), '4', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8BM2', 'B804', (SELECT id FROM profesor WHERE nombre_norm = 'ESPARZA SALINAS ROCIO'), '4', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8BV1', 'B802', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ GALAN YASMIN IVETTE'), '3', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8BV1', 'B804', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES CORDERO MARTHA MARGARITA'), '4', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 9), (3, 9)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM1', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'GONZALEZ ALBARRAN GISELA'), '4', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM1', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'MALDONADO MUNOZ MIGUEL ANGEL'), '4', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 1), (3, 1), (5, 1)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM1', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'SERRANO ROMERO CLAUDIA WENDY'), '4', '209')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM2', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'FERRER TENORIO JORGE'), '4', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (2, 2), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM2', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'MALDONADO MUNOZ MIGUEL ANGEL'), '4', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 2), (3, 2), (4, 2)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM2', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'SERRANO ROMERO CLAUDIA WENDY'), '4', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM3', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'FERRER TENORIO JORGE'), '4', '208')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (4, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM3', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'LOYOLA ESPINOSA ARACELI'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 4), (3, 5)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM4', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'FERRER TENORIO JORGE'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 4), (3, 4), (4, 4)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM4', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'SOSA ADAN FANNY'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 3), (3, 3), (5, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CM4', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'OLALDE MOGOLLAN NORMA'), '2', '202')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 3), (4, 3)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CV1', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'CRUZ LAZARO ING. APOLINAR FRANCISCO'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CV1', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'SOSA ADAN FANNY'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6), (5, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CV1', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'DORANTES CORDERO MARTHA MARGARITA'), '4', '113')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CV2', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ VERA SANDRA MERCEDES'), '4', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 8), (2, 7), (4, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CV2', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'VILLEGAS NAVARRETE SONIA'), '4', '011')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CV2', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'SERRANO ROMERO CLAUDIA WENDY'), '4', '112')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 6), (3, 6)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CV3', 'C802', (SELECT id FROM profesor WHERE nombre_norm = 'PEREZ VERA SANDRA MERCEDES'), '4', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (2, 8), (3, 8), (5, 8)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CV3', 'C803', (SELECT id FROM profesor WHERE nombre_norm = 'JIMENEZ GALAN YASMIN IVETTE'), '4', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 7), (3, 7), (4, 7)) AS s(dia, bloque);
WITH o AS (INSERT INTO oferta (periodo, grupo, materia, profesor, edificio, salon)
VALUES ('27/1', '8CV3', 'C805', (SELECT id FROM profesor WHERE nombre_norm = 'SERRANO ROMERO CLAUDIA WENDY'), '4', '111')
  RETURNING id)
INSERT INTO sesion (oferta, dia, bloque) SELECT o.id, s.dia, s.bloque FROM o, (VALUES (1, 6), (4, 6)) AS s(dia, bloque);

-- --- Cupos e inscritos ----------------------------------------------
INSERT INTO cupo (periodo, grupo, materia, cupo, inscritos) VALUES
('27/1', '1AM1', 'A101', 33, 33),
('27/1', '1AM1', 'A102', 29, 29),
('27/1', '1AM1', 'A103', 28, 28),
('27/1', '1AM1', 'A104', 36, 36),
('27/1', '1AM1', 'A105', 30, 30),
('27/1', '1AM2', 'A101', 32, 32),
('27/1', '1AM2', 'A102', 36, 36),
('27/1', '1AM2', 'A103', 31, 31),
('27/1', '1AM2', 'A104', 37, 37),
('27/1', '1AM2', 'A105', 29, 29),
('27/1', '1AV1', 'A101', 31, 31),
('27/1', '1AV1', 'A102', 28, 28),
('27/1', '1AV1', 'A103', 35, 35),
('27/1', '1AV1', 'A104', 32, 32),
('27/1', '1AV1', 'A105', 26, 26),
('27/1', '1AV2', 'A101', 24, 24),
('27/1', '1AV2', 'A102', 32, 32),
('27/1', '1AV2', 'A103', 23, 23),
('27/1', '1AV2', 'A104', 7, 7),
('27/1', '1AV2', 'A105', 22, 22),
('27/1', '1BM1', 'B101', 36, 36),
('27/1', '1BM1', 'B102', 37, 37),
('27/1', '1BM1', 'B103', 36, 36),
('27/1', '1BM1', 'B104', 37, 37),
('27/1', '1BM1', 'B105', 28, 28),
('27/1', '1BM1', 'B106', 34, 34),
('27/1', '1BM2', 'B101', 34, 34),
('27/1', '1BM2', 'B102', 33, 33),
('27/1', '1BM2', 'B103', 32, 32),
('27/1', '1BM2', 'B104', 37, 37),
('27/1', '1BM2', 'B105', 36, 36),
('27/1', '1BM2', 'B106', 30, 30),
('27/1', '1BV1', 'B101', 37, 37),
('27/1', '1BV1', 'B102', 35, 35),
('27/1', '1BV1', 'B103', 27, 27),
('27/1', '1BV1', 'B104', 26, 26),
('27/1', '1BV1', 'B105', 19, 19),
('27/1', '1BV1', 'B106', 23, 23),
('27/1', '1BV2', 'B101', 30, 30),
('27/1', '1BV2', 'B102', 30, 30),
('27/1', '1BV2', 'B103', 23, 23),
('27/1', '1BV2', 'B104', 29, 29),
('27/1', '1BV2', 'B105', 23, 23),
('27/1', '1BV2', 'B106', 22, 22),
('27/1', '1CM1', 'C101', 36, 36),
('27/1', '1CM1', 'C102', 36, 36),
('27/1', '1CM1', 'C103', 38, 38),
('27/1', '1CM1', 'C104', 35, 35),
('27/1', '1CM1', 'C105', 38, 38),
('27/1', '1CM2', 'C101', 38, 38),
('27/1', '1CM2', 'C102', 37, 37),
('27/1', '1CM2', 'C103', 37, 37),
('27/1', '1CM2', 'C104', 36, 36),
('27/1', '1CM2', 'C105', 37, 37),
('27/1', '1CM3', 'C101', 38, 38),
('27/1', '1CM3', 'C102', 38, 38),
('27/1', '1CM3', 'C103', 37, 37),
('27/1', '1CM3', 'C104', 36, 36),
('27/1', '1CM3', 'C105', 38, 38),
('27/1', '1CM4', 'C101', 37, 37),
('27/1', '1CM4', 'C102', 38, 38),
('27/1', '1CM4', 'C103', 37, 37),
('27/1', '1CM4', 'C104', 38, 38),
('27/1', '1CM4', 'C105', 37, 37),
('27/1', '1CM5', 'C101', 36, 36),
('27/1', '1CM5', 'C102', 38, 38),
('27/1', '1CM5', 'C103', 36, 36),
('27/1', '1CM5', 'C104', 38, 38),
('27/1', '1CM5', 'C105', 36, 36),
('27/1', '1CM6', 'C101', 32, 32),
('27/1', '1CM6', 'C102', 31, 31),
('27/1', '1CM6', 'C103', 32, 32),
('27/1', '1CM6', 'C104', 32, 32),
('27/1', '1CM6', 'C105', 32, 32),
('27/1', '1CM7', 'C101', 35, 35),
('27/1', '1CM7', 'C102', 35, 35),
('27/1', '1CM7', 'C103', 37, 37),
('27/1', '1CM7', 'C104', 37, 37),
('27/1', '1CM8', 'C103', 37, 37),
('27/1', '1CM9', 'C103', 16, 16),
('27/1', '1CV1', 'C101', 29, 29),
('27/1', '1CV1', 'C102', 18, 18),
('27/1', '1CV1', 'C103', 35, 35),
('27/1', '1CV1', 'C104', 29, 29),
('27/1', '1CV1', 'C105', 25, 25),
('27/1', '1CV2', 'C101', 33, 33),
('27/1', '1CV2', 'C102', 36, 36),
('27/1', '1CV2', 'C103', 30, 30),
('27/1', '1CV2', 'C104', 33, 33),
('27/1', '1CV2', 'C105', 31, 31),
('27/1', '1CV3', 'C101', 36, 36),
('27/1', '1CV3', 'C102', 36, 36),
('27/1', '1CV3', 'C103', 33, 33),
('27/1', '1CV3', 'C104', 26, 26),
('27/1', '1CV3', 'C105', 31, 31),
('27/1', '1CV4', 'C101', 33, 33),
('27/1', '1CV4', 'C102', 38, 38),
('27/1', '1CV4', 'C103', 24, 24),
('27/1', '1CV4', 'C104', 33, 33),
('27/1', '1CV4', 'C105', 30, 30),
('27/1', '1CV5', 'C101', 31, 31),
('27/1', '1CV5', 'C102', 17, 17),
('27/1', '1CV5', 'C103', 35, 35),
('27/1', '1CV5', 'C104', 36, 36),
('27/1', '1CV5', 'C105', 30, 30),
('27/1', '1CV6', 'C102', 39, 39),
('27/1', '1CV6', 'C103', 18, 18),
('27/1', '1CV6', 'C104', 38, 38),
('27/1', '1CV7', 'C103', 38, 38),
('27/1', '2AM1', 'A201', 36, 23),
('27/1', '2AM1', 'A202', 36, 37),
('27/1', '2AM1', 'A203', 36, 32),
('27/1', '2AM1', 'A204', 36, 21),
('27/1', '2AM1', 'A205', 36, 32),
('27/1', '2AM2', 'A201', 36, 35),
('27/1', '2AM2', 'A202', 36, 25),
('27/1', '2AM2', 'A203', 36, 34),
('27/1', '2AM2', 'A204', 36, 35),
('27/1', '2AM2', 'A205', 36, 35),
('27/1', '2AV1', 'A201', 36, 37),
('27/1', '2AV1', 'A202', 36, 37),
('27/1', '2AV1', 'A203', 36, 33),
('27/1', '2AV1', 'A204', 36, 35),
('27/1', '2AV1', 'A205', 36, 21),
('27/1', '2AV2', 'A201', 36, 21),
('27/1', '2AV2', 'A202', 36, 25),
('27/1', '2AV2', 'A204', 36, 6),
('27/1', '2BM1', 'B201', 36, 36),
('27/1', '2BM1', 'B202', 36, 36),
('27/1', '2BM1', 'B203', 36, 38),
('27/1', '2BM1', 'B204', 36, 36),
('27/1', '2BM1', 'B205', 36, 34),
('27/1', '2BM1', 'B206', 36, 36),
('27/1', '2BM2', 'B201', 36, 37),
('27/1', '2BM2', 'B202', 36, 36),
('27/1', '2BM2', 'B203', 36, 32),
('27/1', '2BM2', 'B204', 36, 34),
('27/1', '2BM2', 'B205', 36, 33),
('27/1', '2BM2', 'B206', 36, 35),
('27/1', '2BV1', 'B201', 36, 22),
('27/1', '2BV1', 'B202', 36, 31),
('27/1', '2BV1', 'B203', 36, 27),
('27/1', '2BV1', 'B204', 36, 36),
('27/1', '2BV1', 'B205', 36, 32),
('27/1', '2BV1', 'B206', 36, 37),
('27/1', '2BV2', 'B202', 36, 15),
('27/1', '2BV2', 'B204', 36, 8),
('27/1', '2CM1', 'C201', 36, 36),
('27/1', '2CM1', 'C202', 36, 39),
('27/1', '2CM1', 'C203', 36, 36),
('27/1', '2CM1', 'C204', 36, 33),
('27/1', '2CM1', 'C205', 36, 37),
('27/1', '2CM1', 'C206', 36, 37),
('27/1', '2CM2', 'C201', 36, 37),
('27/1', '2CM2', 'C202', 36, 34),
('27/1', '2CM2', 'C203', 36, 35),
('27/1', '2CM2', 'C204', 36, 38),
('27/1', '2CM2', 'C205', 36, 37),
('27/1', '2CM2', 'C206', 36, 36),
('27/1', '2CM3', 'C201', 36, 36),
('27/1', '2CM3', 'C202', 36, 38),
('27/1', '2CM3', 'C203', 36, 36),
('27/1', '2CM3', 'C204', 36, 38),
('27/1', '2CM3', 'C205', 36, 26),
('27/1', '2CM3', 'C206', 36, 38),
('27/1', '2CM4', 'C201', 36, 32),
('27/1', '2CM4', 'C202', 36, 35),
('27/1', '2CM4', 'C203', 36, 38),
('27/1', '2CM4', 'C204', 36, 36),
('27/1', '2CM4', 'C205', 36, 29),
('27/1', '2CM4', 'C206', 36, 36),
('27/1', '2CM5', 'C201', 36, 35),
('27/1', '2CM5', 'C202', 36, 32),
('27/1', '2CM5', 'C204', 36, 34),
('27/1', '2CM5', 'C205', 36, 35),
('27/1', '2CM5', 'C206', 36, 32),
('27/1', '2CM6', 'C201', 36, 36),
('27/1', '2CM6', 'C202', 36, 34),
('27/1', '2CM6', 'C203', 36, 37),
('27/1', '2CM6', 'C205', 36, 37),
('27/1', '2CM6', 'C206', 36, 36),
('27/1', '2CV1', 'C201', 36, 36),
('27/1', '2CV1', 'C202', 36, 36),
('27/1', '2CV1', 'C203', 36, 34),
('27/1', '2CV1', 'C204', 36, 38),
('27/1', '2CV1', 'C206', 36, 30),
('27/1', '2CV2', 'C201', 36, 36),
('27/1', '2CV2', 'C202', 36, 35),
('27/1', '2CV2', 'C203', 36, 19),
('27/1', '2CV2', 'C204', 36, 36),
('27/1', '2CV2', 'C206', 36, 36),
('27/1', '2CV3', 'C201', 36, 37),
('27/1', '2CV3', 'C202', 36, 37),
('27/1', '2CV3', 'C203', 36, 39),
('27/1', '2CV3', 'C204', 36, 35),
('27/1', '2CV3', 'C205', 36, 29),
('27/1', '2CV3', 'C206', 36, 16),
('27/1', '2CV4', 'C201', 36, 30),
('27/1', '2CV4', 'C202', 36, 36),
('27/1', '2CV4', 'C203', 36, 35),
('27/1', '2CV4', 'C204', 36, 20),
('27/1', '2CV4', 'C205', 36, 29),
('27/1', '2CV4', 'C206', 36, 35),
('27/1', '2CV5', 'C201', 36, 35),
('27/1', '2CV5', 'C202', 36, 14),
('27/1', '2CV5', 'C203', 36, 38),
('27/1', '2CV5', 'C204', 36, 37),
('27/1', '2CV5', 'C205', 36, 31),
('27/1', '2CV5', 'C206', 36, 36),
('27/1', '2CV6', 'C202', 36, 36),
('27/1', '2CV6', 'C205', 36, 37),
('27/1', '3AM1', 'A301', 36, 35),
('27/1', '3AM1', 'A302', 36, 37),
('27/1', '3AM1', 'A303', 36, 31),
('27/1', '3AM1', 'A304', 36, 31),
('27/1', '3AM1', 'A305', 36, 37),
('27/1', '3AM1', 'A306', 36, 34),
('27/1', '3AM2', 'A301', 36, 39),
('27/1', '3AM2', 'A302', 36, 38),
('27/1', '3AM2', 'A303', 36, 36),
('27/1', '3AM2', 'A304', 36, 36),
('27/1', '3AM2', 'A305', 36, 37),
('27/1', '3AM2', 'A306', 36, 36),
('27/1', '3AV1', 'A301', 36, 10),
('27/1', '3AV1', 'A302', 36, 7),
('27/1', '3AV1', 'A303', 36, 37),
('27/1', '3AV1', 'A304', 36, 30),
('27/1', '3AV1', 'A305', 36, 38),
('27/1', '3AV1', 'A306', 36, 32),
('27/1', '3AV2', 'A303', 18, 8),
('27/1', '3BM1', 'B301', 36, 38),
('27/1', '3BM1', 'B302', 36, 36),
('27/1', '3BM1', 'B303', 36, 37),
('27/1', '3BM1', 'B304', 36, 32),
('27/1', '3BM1', 'B305', 36, 36),
('27/1', '3BM1', 'B306', 36, 37),
('27/1', '3BM2', 'B301', 35, 25),
('27/1', '3BM2', 'B302', 36, 34),
('27/1', '3BM2', 'B303', 36, 12),
('27/1', '3BM2', 'B304', 36, 36),
('27/1', '3BM2', 'B305', 35, 16),
('27/1', '3BM2', 'B306', 36, 29),
('27/1', '3BV1', 'B301', 36, 34),
('27/1', '3BV1', 'B302', 36, 19),
('27/1', '3BV1', 'B303', 36, 15),
('27/1', '3BV1', 'B304', 36, 16),
('27/1', '3BV1', 'B305', 36, 18),
('27/1', '3BV1', 'B306', 36, 21),
('27/1', '3BV2', 'B301', 36, 4),
('27/1', '3BV2', 'B303', 36, 36),
('27/1', '3BV2', 'B304', 18, 3),
('27/1', '3BV2', 'B305', 36, 13),
('27/1', '3CM1', 'C301', 36, 36),
('27/1', '3CM1', 'C302', 36, 37),
('27/1', '3CM1', 'C303', 36, 36),
('27/1', '3CM1', 'C304', 36, 36),
('27/1', '3CM1', 'C305', 36, 38),
('27/1', '3CM1', 'C306', 36, 36),
('27/1', '3CM1', 'C307', 36, 37),
('27/1', '3CM2', 'C301', 36, 36),
('27/1', '3CM2', 'C302', 36, 38),
('27/1', '3CM2', 'C303', 36, 38),
('27/1', '3CM2', 'C304', 36, 38),
('27/1', '3CM2', 'C305', 36, 36),
('27/1', '3CM2', 'C306', 36, 33),
('27/1', '3CM2', 'C307', 36, 38),
('27/1', '3CM3', 'C301', 36, 35),
('27/1', '3CM3', 'C302', 36, 36),
('27/1', '3CM3', 'C303', 36, 36),
('27/1', '3CM3', 'C304', 36, 38),
('27/1', '3CM3', 'C305', 36, 36),
('27/1', '3CM3', 'C306', 36, 36),
('27/1', '3CM3', 'C307', 36, 37),
('27/1', '3CM4', 'C301', 36, 36),
('27/1', '3CM4', 'C302', 36, 37),
('27/1', '3CM4', 'C303', 36, 36),
('27/1', '3CM4', 'C304', 36, 38),
('27/1', '3CM4', 'C305', 36, 37),
('27/1', '3CM4', 'C306', 36, 38),
('27/1', '3CM4', 'C307', 36, 37),
('27/1', '3CM5', 'C301', 36, 38),
('27/1', '3CM5', 'C305', 36, 36),
('27/1', '3CV1', 'C301', 36, 38),
('27/1', '3CV1', 'C302', 36, 36),
('27/1', '3CV1', 'C303', 36, 33),
('27/1', '3CV1', 'C304', 36, 36),
('27/1', '3CV1', 'C305', 36, 35),
('27/1', '3CV1', 'C306', 36, 38),
('27/1', '3CV1', 'C307', 36, 38),
('27/1', '3CV2', 'C301', 36, 36),
('27/1', '3CV2', 'C302', 36, 7),
('27/1', '3CV2', 'C303', 36, 31),
('27/1', '3CV2', 'C305', 36, 32),
('27/1', '3CV2', 'C306', 36, 40),
('27/1', '3CV2', 'C307', 36, 37),
('27/1', '3CV3', 'C301', 33, 5),
('27/1', '3CV3', 'C302', 36, 23),
('27/1', '3CV3', 'C303', 36, 25),
('27/1', '3CV3', 'C304', 36, 38),
('27/1', '3CV3', 'C305', 36, 24),
('27/1', '3CV3', 'C306', 36, 36),
('27/1', '3CV3', 'C307', 36, 37),
('27/1', '3CV4', 'C301', 36, 36),
('27/1', '3CV4', 'C302', 36, 36),
('27/1', '3CV4', 'C303', 36, 38),
('27/1', '3CV4', 'C304', 36, 36),
('27/1', '3CV4', 'C305', 36, 26),
('27/1', '3CV4', 'C306', 36, 30),
('27/1', '3CV4', 'C307', 36, 38),
('27/1', '3CV5', 'C304', 36, 25),
('27/1', '4AM1', 'A401', 36, 36),
('27/1', '4AM1', 'A402', 36, 36),
('27/1', '4AM1', 'A403', 36, 18),
('27/1', '4AM1', 'A404', 36, 37),
('27/1', '4AM1', 'A405', 36, 36),
('27/1', '4AM2', 'A401', 36, 14),
('27/1', '4AM2', 'A402', 36, 8),
('27/1', '4AM2', 'A403', 36, 24),
('27/1', '4AM2', 'A406', 36, 30),
('27/1', '4AV1', 'A401', 36, 36),
('27/1', '4AV1', 'A402', 36, 35),
('27/1', '4AV1', 'A403', 36, 38),
('27/1', '4AV1', 'A404', 35, 27),
('27/1', '4AV1', 'A405', 36, 34),
('27/1', '4AV1', 'A406', 36, 36),
('27/1', '4BM1', 'B401', 36, 37),
('27/1', '4BM1', 'B402', 36, 22),
('27/1', '4BM1', 'B403', 36, 35),
('27/1', '4BM1', 'B404', 35, 25),
('27/1', '4BM1', 'B405', 36, 33),
('27/1', '4BM1', 'B406', 36, 30),
('27/1', '4BM2', 'B401', 36, 22),
('27/1', '4BM2', 'B402', 36, 9),
('27/1', '4BM2', 'B403', 36, 37),
('27/1', '4BM2', 'B404', 36, 31),
('27/1', '4BM2', 'B405', 36, 5),
('27/1', '4BM2', 'B406', 35, 27),
('27/1', '4BV1', 'B401', 36, 14),
('27/1', '4BV1', 'B402', 36, 38),
('27/1', '4BV1', 'B403', 36, 21),
('27/1', '4BV1', 'B404', 36, 15),
('27/1', '4BV1', 'B405', 36, 34),
('27/1', '4BV1', 'B406', 36, 17),
('27/1', '4CM1', 'C401', 36, 15),
('27/1', '4CM1', 'C402', 36, 38),
('27/1', '4CM1', 'C403', 36, 38),
('27/1', '4CM1', 'C404', 36, 36),
('27/1', '4CM1', 'C405', 36, 36),
('27/1', '4CM1', 'C406', 36, 36),
('27/1', '4CM1', 'C407', 36, 38),
('27/1', '4CM2', 'C401', 36, 9),
('27/1', '4CM2', 'C402', 36, 36),
('27/1', '4CM2', 'C403', 36, 18),
('27/1', '4CM2', 'C404', 36, 34),
('27/1', '4CM2', 'C405', 36, 35),
('27/1', '4CM2', 'C406', 36, 35),
('27/1', '4CM2', 'C407', 36, 36),
('27/1', '4CM3', 'C401', 36, 38),
('27/1', '4CM3', 'C402', 36, 38),
('27/1', '4CM3', 'C403', 36, 31),
('27/1', '4CM3', 'C404', 36, 36),
('27/1', '4CM3', 'C405', 36, 38),
('27/1', '4CM3', 'C407', 36, 37),
('27/1', '4CM4', 'C401', 36, 38),
('27/1', '4CM4', 'C403', 36, 36),
('27/1', '4CM4', 'C404', 36, 36),
('27/1', '4CM4', 'C405', 36, 36),
('27/1', '4CM4', 'C406', 36, 36),
('27/1', '4CM4', 'C407', 36, 29),
('27/1', '4CM5', 'C402', 36, 38),
('27/1', '4CM5', 'C405', 36, 27),
('27/1', '4CM5', 'C406', 35, 35),
('27/1', '4CM6', 'C402', 36, 37),
('27/1', '4CM6', 'C403', 36, 36),
('27/1', '4CV1', 'C401', 36, 37),
('27/1', '4CV1', 'C402', 36, 37),
('27/1', '4CV1', 'C403', 36, 20),
('27/1', '4CV1', 'C404', 36, 35),
('27/1', '4CV1', 'C405', 36, 36),
('27/1', '4CV1', 'C406', 36, 6),
('27/1', '4CV1', 'C407', 36, 33),
('27/1', '4CV2', 'C401', 36, 39),
('27/1', '4CV2', 'C403', 36, 35),
('27/1', '4CV2', 'C404', 36, 37),
('27/1', '4CV2', 'C405', 36, 37),
('27/1', '4CV2', 'C406', 36, 19),
('27/1', '4CV2', 'C407', 36, 20),
('27/1', '4CV3', 'C401', 36, 38),
('27/1', '4CV3', 'C402', 36, 37),
('27/1', '4CV3', 'C404', 36, 25),
('27/1', '4CV3', 'C405', 36, 13),
('27/1', '4CV3', 'C406', 36, 35),
('27/1', '4CV3', 'C407', 36, 19),
('27/1', '4CV4', 'C401', 36, 25),
('27/1', '4CV4', 'C402', 36, 36),
('27/1', '4CV4', 'C403', 36, 32),
('27/1', '4CV4', 'C404', 36, 10),
('27/1', '4CV4', 'C405', 36, 23),
('27/1', '4CV4', 'C406', 36, 36),
('27/1', '4CV4', 'C407', 36, 35),
('27/1', '4CV5', 'C402', 36, 37),
('27/1', '4CV5', 'C403', 36, 32),
('27/1', '5AM1', 'A501', 35, 36),
('27/1', '5AM1', 'A502', 35, 26),
('27/1', '5AM1', 'A503', 36, 25),
('27/1', '5AM1', 'A504', 36, 33),
('27/1', '5AM1', 'A505', 36, 34),
('27/1', '5AM1', 'A506', 36, 38),
('27/1', '5AV1', 'A501', 34, 32),
('27/1', '5AV1', 'A502', 36, 20),
('27/1', '5AV1', 'A503', 35, 35),
('27/1', '5AV1', 'A504', 36, 36),
('27/1', '5AV1', 'A505', 36, 36),
('27/1', '5AV1', 'A506', 36, 33),
('27/1', '5BM1', 'B501', 36, 15),
('27/1', '5BM1', 'B502', 36, 37),
('27/1', '5BM1', 'B503', 36, 35),
('27/1', '5BM1', 'B504', 36, 35),
('27/1', '5BM1', 'B505', 36, 35),
('27/1', '5BM1', 'B506', 36, 37),
('27/1', '5BM2', 'B501', 36, 38),
('27/1', '5BM2', 'B502', 36, 35),
('27/1', '5BM2', 'B503', 36, 36),
('27/1', '5BM2', 'B504', 36, 21),
('27/1', '5BM2', 'B505', 35, 34),
('27/1', '5BM2', 'B506', 36, 33),
('27/1', '5BV1', 'B501', 36, 16),
('27/1', '5BV1', 'B502', 36, 16),
('27/1', '5BV1', 'B503', 36, 27),
('27/1', '5BV1', 'B504', 36, 35),
('27/1', '5BV1', 'B505', 36, 7),
('27/1', '5BV1', 'B506', 36, 16),
('27/1', '5CM1', 'C501', 36, 35),
('27/1', '5CM1', 'C502', 36, 29),
('27/1', '5CM1', 'C503', 36, 25),
('27/1', '5CM1', 'C504', 36, 34),
('27/1', '5CM1', 'C505', 36, 16),
('27/1', '5CM1', 'C506', 36, 36),
('27/1', '5CM1', 'C507', 36, 36),
('27/1', '5CM2', 'C501', 36, 38),
('27/1', '5CM2', 'C502', 36, 38),
('27/1', '5CM2', 'C503', 36, 37),
('27/1', '5CM2', 'C504', 36, 26),
('27/1', '5CM2', 'C505', 36, 37),
('27/1', '5CM2', 'C506', 36, 31),
('27/1', '5CM2', 'C507', 36, 36),
('27/1', '5CM3', 'C501', 36, 37),
('27/1', '5CM3', 'C502', 36, 37),
('27/1', '5CM3', 'C503', 36, 28),
('27/1', '5CM3', 'C504', 36, 33),
('27/1', '5CM3', 'C505', 36, 35),
('27/1', '5CM3', 'C506', 36, 39),
('27/1', '5CM3', 'C507', 36, 37),
('27/1', '5CM4', 'C501', 36, 38),
('27/1', '5CM4', 'C502', 36, 6),
('27/1', '5CM4', 'C503', 36, 35),
('27/1', '5CM4', 'C504', 36, 36),
('27/1', '5CM4', 'C505', 36, 20),
('27/1', '5CM4', 'C506', 36, 29),
('27/1', '5CM4', 'C507', 36, 34),
('27/1', '5CM5', 'C502', 36, 35),
('27/1', '5CM5', 'C503', 36, 39),
('27/1', '5CM5', 'C507', 36, 17),
('27/1', '5CV1', 'C501', 36, 38),
('27/1', '5CV1', 'C502', 35, 37),
('27/1', '5CV1', 'C503', 36, 19),
('27/1', '5CV1', 'C504', 36, 35),
('27/1', '5CV1', 'C505', 36, 36),
('27/1', '5CV1', 'C506', 36, 35),
('27/1', '5CV1', 'C507', 36, 37),
('27/1', '5CV2', 'C501', 33, 10),
('27/1', '5CV2', 'C502', 36, 25),
('27/1', '5CV2', 'C503', 35, 37),
('27/1', '5CV2', 'C504', 36, 28),
('27/1', '5CV2', 'C505', 36, 36),
('27/1', '5CV2', 'C506', 36, 8),
('27/1', '5CV2', 'C507', 36, 36),
('27/1', '5CV3', 'C501', 36, 38),
('27/1', '5CV3', 'C502', 35, 37),
('27/1', '5CV3', 'C503', 36, 38),
('27/1', '5CV3', 'C504', 36, 13),
('27/1', '5CV3', 'C506', 36, 11),
('27/1', '5CV3', 'C507', 36, 36),
('27/1', '5CV4', 'C501', 36, 32),
('27/1', '5CV4', 'C502', 36, 39),
('27/1', '5CV4', 'C503', 36, 34),
('27/1', '5CV4', 'C504', 36, 36),
('27/1', '5CV4', 'C505', 36, 17),
('27/1', '5CV4', 'C506', 36, 38),
('27/1', '5CV4', 'C507', 36, 22),
('27/1', '5CV5', 'C502', 36, 38),
('27/1', '5CV5', 'C505', 36, 35),
('27/1', '6AM1', 'A601', 36, 36),
('27/1', '6AM1', 'A602', 36, 28),
('27/1', '6AM1', 'A603', 36, 31),
('27/1', '6AM1', 'A604', 35, 27),
('27/1', '6AM1', 'A620', 35, 17),
('27/1', '6AM1', 'A627', 35, 34),
('27/1', '6AM2', 'A626', 36, 24),
('27/1', '6AV1', 'A601', 35, 38),
('27/1', '6AV1', 'A602', 35, 30),
('27/1', '6AV1', 'A603', 35, 36),
('27/1', '6AV1', 'A604', 35, 37),
('27/1', '6AV1', 'A624', 36, 36),
('27/1', '6AV1', 'A631', 36, 28),
('27/1', '6BM1', 'B601', 36, 37),
('27/1', '6BM1', 'B602', 36, 37),
('27/1', '6BM1', 'B603', 35, 32),
('27/1', '6BM1', 'B604', 36, 36),
('27/1', '6BM1', 'B642', 36, 24),
('27/1', '6BM1', 'B643', 35, 37),
('27/1', '6BM2', 'B601', 34, 21),
('27/1', '6BM2', 'B602', 35, 30),
('27/1', '6BM2', 'B603', 36, 34),
('27/1', '6BM2', 'B604', 35, 33),
('27/1', '6BM2', 'B645', 34, 11),
('27/1', '6BM2', 'B650', 35, 32),
('27/1', '6BV1', 'B601', 36, 35),
('27/1', '6BV1', 'B602', 36, 37),
('27/1', '6BV1', 'B603', 36, 25),
('27/1', '6BV1', 'B604', 36, 18),
('27/1', '6BV1', 'B641', 36, 33),
('27/1', '6BV1', 'B648', 35, 35),
('27/1', '6CM1', 'C601', 36, 35),
('27/1', '6CM1', 'C602', 36, 38),
('27/1', '6CM1', 'C603', 36, 35),
('27/1', '6CM1', 'C610', 36, 35),
('27/1', '6CM1', 'C616', 36, 38),
('27/1', '6CM1', 'C618', 36, 35),
('27/1', '6CM1', 'C619', 34, 35),
('27/1', '6CM2', 'C601', 36, 30),
('27/1', '6CM2', 'C602', 35, 37),
('27/1', '6CM2', 'C603', 36, 37),
('27/1', '6CM2', 'C605', 36, 38),
('27/1', '6CM2', 'C607', 36, 36),
('27/1', '6CM2', 'C618', 36, 20),
('27/1', '6CM2', 'C619', 36, 33),
('27/1', '6CM3', 'C601', 34, 35),
('27/1', '6CM3', 'C602', 35, 35),
('27/1', '6CM3', 'C603', 35, 37),
('27/1', '6CM3', 'C604', 36, 37),
('27/1', '6CM3', 'C618', 36, 38),
('27/1', '6CM3', 'C619', 36, 33),
('27/1', '6CM4', 'C601', 36, 23),
('27/1', '6CM4', 'C602', 36, 36),
('27/1', '6CM4', 'C603', 36, 38),
('27/1', '6CM4', 'C611', 36, 30),
('27/1', '6CM4', 'C618', 36, 19),
('27/1', '6CM4', 'C619', 36, 35),
('27/1', '6CM5', 'C606', 36, 37),
('27/1', '6CM5', 'C608', 36, 38),
('27/1', '6CV1', 'C601', 33, 15),
('27/1', '6CV1', 'C602', 36, 37),
('27/1', '6CV1', 'C603', 36, 37),
('27/1', '6CV1', 'C609', 36, 38),
('27/1', '6CV1', 'C618', 36, 38),
('27/1', '6CV1', 'C619', 36, 38),
('27/1', '6CV2', 'C601', 35, 38),
('27/1', '6CV2', 'C602', 36, 31),
('27/1', '6CV2', 'C603', 36, 38),
('27/1', '6CV2', 'C614', 36, 37),
('27/1', '6CV2', 'C618', 36, 37),
('27/1', '6CV2', 'C619', 36, 38),
('27/1', '6CV3', 'C601', 36, 37),
('27/1', '6CV3', 'C602', 36, 39),
('27/1', '6CV3', 'C603', 36, 36),
('27/1', '6CV3', 'C613', 36, 38),
('27/1', '6CV3', 'C618', 36, 36),
('27/1', '6CV3', 'C619', 36, 35),
('27/1', '6CV4', 'C601', 35, 35),
('27/1', '6CV4', 'C602', 36, 34),
('27/1', '6CV4', 'C610', 36, 40),
('27/1', '6CV4', 'C612', 36, 37),
('27/1', '7AM1', 'A701', 35, 34),
('27/1', '7AM1', 'A702', 36, 24),
('27/1', '7AM1', 'A704', 35, 25),
('27/1', '7AM1', 'A722', 35, 15),
('27/1', '7AM1', 'A728', 36, 36),
('27/1', '7AV1', 'A701', 36, 37),
('27/1', '7AV1', 'A702', 35, 38),
('27/1', '7AV1', 'A704', 35, 39),
('27/1', '7AV1', 'A725', 36, 36),
('27/1', '7AV1', 'A729', 36, 38),
('27/1', '7AV2', 'A721', 36, 29),
('27/1', '7AX1', 'A703', 250, 0),
('27/1', '7BM1', 'B702', 36, 34),
('27/1', '7BM1', 'B703', 36, 36),
('27/1', '7BM1', 'B746', 36, 37),
('27/1', '7BM1', 'B752', 36, 22),
('27/1', '7BV1', 'B702', 36, 38),
('27/1', '7BV1', 'B703', 36, 35),
('27/1', '7BV1', 'B747', 36, 33),
('27/1', '7BV1', 'B749', 36, 32),
('27/1', '7BX1', 'B701', 255, 0),
('27/1', '7CM1', 'C702', 35, 34),
('27/1', '7CM1', 'C706', 36, 28),
('27/1', '7CM1', 'C709', 36, 36),
('27/1', '7CM1', 'C717', 36, 35),
('27/1', '7CM1', 'C718', 36, 36),
('27/1', '7CM2', 'C702', 36, 23),
('27/1', '7CM2', 'C704', 36, 34),
('27/1', '7CM2', 'C707', 36, 35),
('27/1', '7CM2', 'C717', 36, 36),
('27/1', '7CM2', 'C718', 36, 14),
('27/1', '7CM3', 'C702', 36, 29),
('27/1', '7CM3', 'C710', 35, 37),
('27/1', '7CM3', 'C713', 36, 15),
('27/1', '7CM3', 'C717', 35, 14),
('27/1', '7CM3', 'C718', 33, 32),
('27/1', '7CM4', 'C702', 36, 30),
('27/1', '7CM4', 'C705', 34, 37),
('27/1', '7CM4', 'C717', 35, 27),
('27/1', '7CM4', 'C718', 36, 35),
('27/1', '7CM5', 'C715', 35, 25),
('27/1', '7CV1', 'C702', 36, 35),
('27/1', '7CV1', 'C711', 35, 33),
('27/1', '7CV1', 'C712', 34, 34),
('27/1', '7CV1', 'C717', 36, 38),
('27/1', '7CV1', 'C718', 35, 33),
('27/1', '7CV2', 'C702', 36, 36),
('27/1', '7CV2', 'C717', 36, 35),
('27/1', '7CV2', 'C718', 36, 31),
('27/1', '7CV3', 'C702', 34, 34),
('27/1', '7CV3', 'C709', 36, 39),
('27/1', '7CV3', 'C717', 36, 36),
('27/1', '7CV3', 'C718', 36, 38),
('27/1', '7CV4', 'C702', 33, 33),
('27/1', '7CV4', 'C703', 36, 35),
('27/1', '7CV4', 'C708', 36, 39),
('27/1', '7CV4', 'C717', 35, 37),
('27/1', '7CV4', 'C718', 34, 34),
('27/1', '7CX1', 'C701', 255, 0),
('27/1', '7CX2', 'C701', 255, 0),
('27/1', '8AM1', 'A801', 36, 31),
('27/1', '8AM1', 'A802', 36, 15),
('27/1', '8AV1', 'A801', 36, 35),
('27/1', '8AV1', 'A802', 36, 31),
('27/1', '8AX1', 'A803', 255, 0),
('27/1', '8BM1', 'B801', 36, 29),
('27/1', '8BM1', 'B802', 36, 28),
('27/1', '8BM1', 'B804', 36, 26),
('27/1', '8BM2', 'B801', 36, 13),
('27/1', '8BM2', 'B802', 36, 22),
('27/1', '8BM2', 'B804', 36, 16),
('27/1', '8BV1', 'B802', 36, 36),
('27/1', '8BV1', 'B804', 36, 35),
('27/1', '8BX1', 'B801', 255, 0),
('27/1', '8CM1', 'C802', 36, 34),
('27/1', '8CM1', 'C803', 36, 33),
('27/1', '8CM1', 'C805', 36, 21),
('27/1', '8CM2', 'C802', 36, 31),
('27/1', '8CM2', 'C803', 35, 34),
('27/1', '8CM2', 'C805', 36, 24),
('27/1', '8CM3', 'C802', 36, 18),
('27/1', '8CM3', 'C805', 36, 28),
('27/1', '8CM4', 'C802', 34, 32),
('27/1', '8CM4', 'C803', 36, 35),
('27/1', '8CM4', 'C805', 36, 35),
('27/1', '8CV1', 'C802', 36, 37),
('27/1', '8CV1', 'C803', 36, 37),
('27/1', '8CV1', 'C805', 36, 36),
('27/1', '8CV2', 'C802', 34, 33),
('27/1', '8CV2', 'C803', 36, 38),
('27/1', '8CV2', 'C805', 36, 36),
('27/1', '8CV3', 'C802', 36, 36),
('27/1', '8CV3', 'C803', 36, 38),
('27/1', '8CV3', 'C805', 36, 35),
('27/1', '8CX2', 'C801', 255, 0);
