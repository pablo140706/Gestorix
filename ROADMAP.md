# ROADMAP — Gestorix

> Actualizado 2026-11-08. Reglas y decisiones en `CLAUDE.md`. Este archivo es el **orden de trabajo**.
> **Entrega: semana del 30 de noviembre al 4 de diciembre de 2026, funcionando en un sitio web.**
> Meta interna: todo listo el 28 de noviembre, para tener una semana de margen.

---

## Fases

| # | Fase | Fechas | Listo cuando… |
|---|---|---|---|
| 0 | Arranque | 9–10 nov | Repo `gestorix` creado con la versión de iscweb de la PC, Student Pack pedido, servicio de correo elegido, esquema cerrado |
| 1 ✅ | Base de datos y datos | 10–14 nov (hecha el 8) | `docker compose up` levanta Postgres 17, Apache + PHP y pgAdmin; el importador carga las 3 carreras desde el HTML de SAES; cuadran 665 ofertas y 276 maestros |
| 2 ✅ | API y front leyendo de la base | 15–19 nov (hecha el 8) | Las pestañas actuales de iscweb funcionan con datos de `src/api/*.php`, sin `schedule.js` ni los demás `.js` de datos |
| 3 ✅ | Cuentas, avance y horario | 19–22 nov (hecha el 8; el correo real queda para el final) | Registro con verificación de correo, alias, avance (con recurse y ETS) y horario guardados; carga en UA (aviso arriba de la media, tope en 9); avisos de seriación y desfase |
| 4 ✅ | Profesores y comentarios | 23–25 nov (hecha el 20) | Ficha única del profesor (MisProfesores + link, comentarios por materia, horario, cédula), comentarios con rúbrica, edición en 24 h, reportes, ocultar, suspender y banear |
| 5 ✅ | Materias y agenda | 25–27 nov (hecha el 20) | PDF y descripción por materia; recordatorios con fecha y hora en el calendario |
| 6 ✅ | Publicación | 27–29 nov (hecha el 20–21) | **Cambió con el PDF del 2.º parcial:** la PC es el servidor (Docker) y ngrok la saca a internet con HTTPS y dominio fijo; correos reales por Gmail; seguridad del registro (límite de intentos, CSP, sin detalles internos) |
| 7 | Cierre y margen | 30 nov – 4 dic | README con los enlaces que pide el PDF, capturas del registro, video de respaldo, demo y arreglos de último momento |

**Si no da el tiempo, se recorta en este orden** (confirmado): agenda → PDFs y descripciones → cédula → rúbrica. **Mínimo para entregar:** fases 1, 2, 3 y 6.

---

## Fase 0 — Lo que tienes que hacer tú

> **Pospuesto hasta el final** (decisión del usuario, 2026-11-08): Student Pack, servicio de correo
> y nombre del responsable. Ojo con dos dependencias: el **correo** hace falta en la **Fase 3**
> (verificación de cuentas) y el **Student Pack** en la **Fase 6** (servidor y dominio; la
> aprobación puede tardar días).

1. ~~Crear el repo~~ ✅ `pablo140706/Gestorix`, público, clonado en `C:\db\repos\proyectos\gestorix`.
2. ~~Darle acceso a Claude a `pablo140706`~~ ✅ (2026-11-08).
3. ~~Verificar Docker Desktop~~ ✅ Docker 29.9.2 y Compose v5.6.1, con la imagen `postgres:17` ya descargada (2026-11-08).
4. **Pedir el GitHub Student Pack** (servidor y dominio). Pasos en el mensaje de la sesión del 2026-11-08.
5. **Correo:** se usa **uno que el usuario ya tiene**, como contacto del aviso de privacidad y como remitente. Él lo pone en el aviso y en `.env`.
6. **Elegir el servicio de envío** para la verificación y el "olvidé mi contraseña". Recomiendo **Brevo** (plan gratuito, sin tarjeta) o, si ese correo es de Gmail, una **contraseña de aplicación**.
7. **Datos:**
   - cupos actualizados de las 3 carreras (HTML de SAES);
   - quién es el profe de `6CM5`;
   - los PDFs de plan sintético, uno por materia;
   - métricas de 72 profes y links de 69 (contados en la base: profes con clase en 27/1), cuando los tengas;
   - cédulas: las capturas tú en pgAdmin cuando ya exista la base.

## Fase 0 — Preguntas que quedan

1. ~~Subir la versión con calendario~~ ✅ `pablo140706/iscweb-inicio`, rama `feat/multi-carrera-ia-lcd`, commit `2419470`.
2. ~~Correo de contacto~~ ✅ Uno que ya tiene el usuario. Falta: ¿qué nombre va como responsable? Por defecto, "Gestorix, proyecto escolar".
3. ~~Optativas de IA y LCD con dos claves~~ ✅ Se guardan las dos; la que no marca el PDF lleva `se_ofrece = false`.
4. ~~Cupo~~ ✅ Tal cual SAES; la app suma el +4 de sobrecupo de 2.º en adelante. Los valores raros ya se explican: 250/255 son los grupos X de TT (sin límite), los chicos de 1.er semestre se cerraron al llenarse (cupo = inscritos), y el 1 es `6CM5` Aprendizaje automático.
5. ~~Escalas de cada comentario~~ ✅ Recomienda sí/no; calidad y dificultad enteros de 0 a 10.
6. ~~Al borrar una cuenta~~ ✅ Sus comentarios se quedan como "usuario eliminado".

## Fase 0 — Lo que ya quedó (2026-11-08)

- **Front de iscweb** (`2419470`) copiado a `src/`: `index.html`, `styles.css`, `favicon.svg`, `manifest.webmanifest`, `sw.js` y los 19 `.js` de módulos. **No** se copiaron los 9 `.js` de datos (`roster`, `metrics`, `schedule`, `calendario`, `planes`, `optativas`, `cupos`, `historial`, `maestros_manual`): por eso el front no arranca solo hasta la Fase 2, cuando lea de la API.
- **HTML de SAES** copiado a `data/{isc,ia,lcd}/` (11 archivos). Los PDFs se quedan en iscweb.
- **Esquema** en `sql/00-tablas.sql`, probado en un Postgres 17 desechable. Resumen y cambios en `CLAUDE.md` §8.

---

## Fase 1 — Base de datos y datos ✅ (2026-11-08)

**Hecho:**
- `Dockerfile` (como el de Seismic, con `php.ini` de producción y zona horaria de CDMX), `docker-compose.yml` (web en `:8080`, db sin publicar, pgAdmin en `127.0.0.1:5051` (el 5050 lo usa otro proyecto) con el servidor ya registrado), `.env.example` y `.gitignore`. Tu `.env` ya existe, con contraseñas al azar.
- **Usuario de la app con mínimo privilegio** (`sql/99-rol-app.sh`): lee y escribe datos, pero no puede crear ni borrar tablas (probado).
- **Carga inicial** `sql/01`–`08`: 3 carreras, 4 periodos y 48 eventos del calendario, 209 materias (27 con `se_ofrece = false`), 44 pares de seriación, 21 rutas, 205 profes con métricas o link (4 correcciones aplicadas) + 5 que solo salen en el historial, 430 ofertas de 26/2 y las 5 ofertas extra de 27/1. Los `sql/02`–`07` salieron **una vez** de iscweb con `importador/iscweb/convertir.php`.
- **Importador** `importador/horarios.php`: lee el HTML de SAES de las 3 carreras. Se puede repetir sin duplicar ni pisar lo corregido en pgAdmin.
- **Cifras de 27/1:** 664 ofertas (659 de SAES + 5 extra), 2,021 sesiones, 663 cupos, 260 profes con clase y ninguna oferta sin profesor. Probado también desde cero.
- **`6CM5` Aprendizaje automático (C611) quitado** (usuario, 2026-11-08): sin profe, cupo 1 y no sale en el PDF; no se abrió. Está en `data/excluir.csv`, así que los importadores no lo vuelven a meter.

**Lo que no cuadró con lo que traíamos:**

| Cifra | Antes | En la base | Por qué |
|---|---|---|---|
| Maestros | 276 | **274** | 260 con clase en 27/1 + 14 que solo dieron clase en 26/2. Revisé duplicados (mismo profe escrito distinto): no hay. El 276 del prototipo probablemente contaba distinto |
| Sin métricas | 73 | **72** | Contado en la base sobre los 260 con clase en 27/1 |
| Sin link | 65 | **69** | Igual |
| Grupos | `[1-8][ABC][MVX][1-9]` | **1 o 2 dígitos** | En 26/2 existió `1CM10`. Esquema e importador ya lo aceptan |
| TT en grupos X | — | **No hay grupos X** | El HTML de 27/1 trae TT I de ISC en `7CM1`/`7CM2` (extra) y TT II de IA en `8BM1`/`8BM2` |

**Cupos y salones (2026-11-08, misma tarde):**
- **Cupos** de las 3 carreras (`data/*/cupos.html`) con `importador/cupos.php`: 664 grupo + materia, en una **tabla propia `cupo`** (decisión del usuario: el cupo es de grupo + materia, no de cada profe). Incluye los 7 grupos X de TT (cupo 250/255, sin oferta). Las únicas 5 ofertas sin cupo son las 5 extra.
- **Salones** con el PDF oficial de ESCOM (`data/salones/27-1.pdf`) y `importador/salones.php`: **el PDF manda** (decisión del usuario). 651 ofertas cruzaron: 128 salones llenados, 20 corregidos, el resto igual. El laboratorio no se guarda.
- Todo probado desde cero en un proyecto aparte: misma huella que la base local.

| Corregido con el PDF | SAES → PDF |
|---|---|
| `1CV2` Matemáticas discretas | 1001 → 2002 |
| `2CV1` Mecánica y electromagnetismo | 1007 → 1213 |
| `1CM8` y `1CM9` Cálculo | 2212 y 2211 → sin asignar |
| `3CM1` Análisis y diseño de algoritmos · Finanzas | 1206 → 2206 · 2206 → 2006 |
| `4CM3` Diseño de sistemas digitales | 2005 → 2213 |
| `6CM2` Ingeniería de software · Aseguramiento de la calidad | 4011 ⇄ 3011 (estaban al revés) |
| `6CM4` Sistemas en chip | 4009 → 3213 |
| `1AM2` Cálculo | 1103 → 1203 |
| `2AV2` Algoritmos y estructuras de datos | 112 → 1112 |
| `3AV1` Análisis y diseño de algoritmos | 2003 → 2203 |
| `5AV1` Analítica y visualización | 3308 → 3008 |
| `6AV1` (6 materias) | 3313 → 3113 |

**Lo que el PDF trae y SAES no** (solo se reporta; las ofertas salen de SAES): `1CM6` completo, `7BM2` (Formulación, Innovación, Reconocimiento de voz), `2CV2` Ética (salón 1007, el mismo de la extra `2CV1` Ética) y `3BV2` Paradigmas. **Lo que SAES trae y el PDF no:** `4CM6` (2), `6CM5` Aprendizaje automático (la oferta sin profe), `5CV5` Procesamiento digital de señales, `3AV2` Bases de datos, `8AV1` Gestión empresarial, los TT de `8BM1`/`8BM2` y 3 de las extra.

---

## Fase 2 — API y front leyendo de la base ✅ (2026-11-08)

**Hecho:**
- **9 endpoints** en `src/api/` que regresan JSON, uno por cada `.js` de datos de iscweb y **con la misma forma**: `planes`, `horarios`, `historial`, `roster`, `metricas`, `links`, `calendario`, `optativas` y `cupos`. Comparten `src/lib/api.php` (periodo vigente, errores en JSON sin detalles).
- **`src/arranque.js`** pide a la API los 6 datos del primer pintado, los deja en las mismas variables de antes (`PLANES`, `SCHEDULE`…) y luego carga los módulos en el orden de siempre. `lazy.js` pide a la API cupos, links e historial cuando hacen falta. El `index.html` ya no carga ningún `.js` de datos.
- **Comparado dato por dato contra iscweb:** planes, calendario, ramas y links idénticos; métricas iguales salvo las 4 correcciones; horarios iguales salvo `6CM5` C611; historial 26/2 igual salvo la clase de 3 h partida en 2 bloques.
- **Probado en el navegador:** las 6 pestañas en ISC, IA y LCD, lista de maestros de una materia, ficha del maestro con historial y cupos de 26/2, agregar al horario, reconstruir un horario compartido y el buscador (Ctrl+K). Sin errores en la consola.
- **Datos que faltaban** (convertidos una vez de iscweb): íconos de las 14 ramas (`ruta_optativa.icono`), nombre en inglés de las 28 optativas de ISC (`materia.nombre_en`) y los 476 cupos de 26/2 (`sql/09-cupos-26-2.sql`). Desde cero sale idéntico a la base local.

**Lo que cambió en el comportamiento** (por las reglas nuevas, no por gusto):
- Optativas de IA y LCD: cada una aparece solo en el semestre de su PDF (`se_ofrece`), no en los dos.
- Optativas de ISC: se quitó el filtro A = matutino / B = vespertino (salía del Excel del roster, que ya no existe).
- IA y LCD ya tienen cupos en las tarjetas (antes solo ISC).

**Sin probar:** el *service worker* (abrir sin internet). El navegador integrado de Claude no deja registrarlo; `sw.js` se sirve bien. Pruébalo en tu Chrome: abre la app, apaga Docker y recarga.

## Fase 3 — Cuentas, avance y horario ✅ (2026-11-08)

**Decisiones del usuario** (en `CLAUDE.md`): correos al log mientras no haya servicio; al entrar, si la cuenta está vacía se sube lo del navegador; las "solo por ETS" ocupan carga; el promedio es solo de aprobadas.

**Back** (`src/api/cuenta/` y `src/api/mis-datos.php`, con `src/lib/sesion.php`, `cuenta.php` y `correo.php`):
- Registro con cualquier correo y carrera fija; alias al azar ("Puma Sereno 66") que se puede cambiar (único sin importar mayúsculas).
- Verificación con enlace de un solo uso (48 h) y "olvidé mi contraseña" (enlace de 1 h). En la base solo se guarda el sha256 del enlace.
- No se puede entrar sin activar la cuenta, ni baneado o suspendido. Sesión de PHP de 30 días (cookie `HttpOnly`, `SameSite=Lax`, `Secure` en HTTPS).
- Los POST solo aceptan JSON del mismo sitio (protección CSRF). Las respuestas de registro y "olvidé" no revelan si un correo tiene cuenta.
- `mis-datos.php` guarda avance y horario completos, revisando que las materias sean de tu carrera, las calificaciones enteros de 0 a 10 y las ofertas del periodo vigente.

**Front** (`src/cuenta.js`):
- Botón "Entrar" en el encabezado, con ventanas para entrar, crear cuenta, olvidé, contraseña nueva y "Tu cuenta" (alias, correo, carrera, salir).
- Con sesión, cada cambio se sube solo a la cuenta (~0.7 s después), y al cerrar la pestaña también. Con sesión, el selector de carrera queda fijo en la tuya.
- **Al salir se borra de ese navegador lo de la cuenta** (para compus compartidas; sigue en tu cuenta).

**Reglas** (CLAUDE.md §4):
- Campo de **ETS** cuando reprobaste el curso. Estados: Aprobada por ETS, Reprobada · recurse o ETS, Solo por ETS (ya no se inscribe).
- **Promedio** solo con la calificación con que se aprobó.
- **Carga en UA** (TT = 2): la tarjeta muestra UA contra la media, en amarillo arriba de la media y en rojo arriba de la máxima. **No deja agregar** si pasarías de 9. El modo Automático llena **hasta la media**.
- **Avisos** que no bloquean: carga (abajo de la mínima, arriba de la media), seriación (al agregar y en la pestaña), Art. 98 y bajas que no proceden (recurse o quedar abajo de la mínima: pregunta antes de quitar).

**Probado:** todo el flujo con `curl` (20 casos: activar, enlace usado dos veces, CSRF desde otro sitio, sin sesión, calificación 11, materia de otra carrera…) y en el navegador: entrar, que se apliquen los datos de la cuenta sin ciclarse, que un cambio se suba, cada regla y salir. La cuenta de prueba se borró.

**También:** Apache ahora manda `Cache-Control: no-cache` (`Dockerfile`), para que nadie quede con JS nuevo y CSS viejo después de una actualización.

## Fase 4 — Profesores y comentarios ✅ (2026-11-20)

**Decisiones del usuario** (en `CLAUDE.md` §6): el suspendido entra pero no comenta; rúbrica opcional que suma 100 %; el autor ve su comentario oculto, marcado; banear oculta todos los comentarios de la cuenta.

**Back:**
- `api/profesor.php?nombre=…`: la ficha en una llamada (cédula, materias que ha dado, comentarios y su resumen). No se guarda en caché.
- `api/comentarios/`: `guardar.php` (nuevo o editar), `borrar.php` y `reportar.php`. Reglas en `src/lib/comentarios.php`.
- `api/moderacion/`: `reportes.php` (pendientes, agrupados por comentario) y `accion.php` (ocultar, mostrar, descartar, suspender 1/7/30 días, banear, desbanear). Todo con motivo y en la bitácora.
- Índices nuevos: `oferta(profesor)`, `comentario(profesor, creado)` y los reportes pendientes.

**Front** (`src/comentarios.js`, en la ficha del maestro):
- Cédula ("Sin cédula registrada" si falta), las calificaciones de MisProfesores y, aparte, el promedio de los comentarios propios.
- Formulario con materia, calidad, ¿lo recomiendas?, dificultad, texto con contador y rúbrica que avisa si no suma 100.
- Editar y borrar (24 h), reportar con motivo, y para moderadores: ocultar, mostrar, descartar, suspender y banear.
- "Tu cuenta" muestra el rol y, a moderadores, la ventana **Reportes pendientes** con "Ver en la ficha".

**Probado:** con `curl` (40 casos: validaciones, CSRF, sin sesión, 24 h, ocultos, jerarquía de roles, suspensión, baneo y bitácora) y en el navegador, también a 375 px. Las 3 cuentas de prueba y todo lo que crearon se borraron.

**Para usarlo:** nadie es moderador todavía. Regístrate y en pgAdmin: `UPDATE usuario SET rol = 'admin' WHERE correo = '…';` (lo mismo con `'moderador'` para nombrar moderadores).

**También (2026-11-20):** en la pestaña Maestros, "Imparte / Ya no" dejó de ser una nota manual: sale de la base (ver el pendiente 20).

## Fase 5 — Materias y agenda ✅ (2026-11-20)

**Decisiones del usuario** (en `CLAUDE.md` §4.7 y §7): descripción = propósito y temas tal cual el PDF; los escaneados, con una descripción investigada; PDFs en el repo; ventana al tocar la materia. Agenda solo con cuenta, clic en el día + "Próximos", hora opcional, los pasados se quedan en gris.

**Materias:**
- 177 PDFs en `src/materias/<clave>.pdf`; **203 de 209 materias** con PDF y descripción (162 del programa oficial; el resto, gemelas de IA/LCD y las 22 escaneadas, marcadas como orientativas con su fuente).
- Herramientas: `importador/programas/mapear.php` (una vez), `importador/programas/copiar.sh` y `importador/materias.php`. Columna nueva `materia.descripcion_fuente`.
- Front: botón ⓘ en Mi avance y Optativas → ventana con datos del plan, seriación, propósito, temas y el PDF (`materia-ui.js`, `api/materias.php`).

**Agenda:**
- `recordatorio` cambió `fecha_hora` por `fecha` + `hora` (opcional). `api/agenda.php` (ver, guardar, borrar).
- En Calendario: "Tus próximos recordatorios", clic en un día para agregar o ver, puntito en los días con recordatorio (gris si ya pasó) (`agenda.js`).

**Probado:** la API de la agenda con `curl` (sin sesión, fechas y horas inválidas, título vacío o largo, materia de otra carrera, que otra cuenta no vea ni toque lo ajeno, editar y borrar) y todo en el navegador, también a 375 px. Una base nueva desde cero con `sql/` carga sin errores. Las cuentas de prueba se borraron.

**Generar horario, más compacto (2026-11-20, pedido del usuario):**
- Las 4 tarjetas de carga y promedios → una franja de una línea. Sin pestañas Manual / Automático: el automático es una sola barra (Turno · De · a · Máx. · Generar · 🎲 Otra · ?), con la explicación en el "?" y el resultado en una línea.
- Cada materia del horario tiene **🔄 Cambiar** (los otros grupos y maestros de esa materia: primero los que no chocan y los de tu turno, con calidad, cupo y horario), **📌 Mantener** (el automático no la toca con 🎲 Otra) y **✕ Quitar**. Lo mismo al tocar la materia en la rejilla (menú corto).

## Fase 6 — Publicación ✅ (2026-11-21)

El PDF del 2.º parcial pide que el profesor se registre desde un link y que el registro aparezca
en la base **de nuestra PC**. Eso cambia el plan original (servidor en la nube, dominio propio,
Student Pack): ya no hacen falta.

- **Túnel:** ngrok con dominio fijo gratis, `https://thwarting-earthling-evasive.ngrok-free.dev` →
  `localhost:8080`. Se abre con `ngrok http --url=thwarting-earthling-evasive.ngrok-free.dev 8080`.
  Se descartaron Supabase (la base quedaría en su nube, no en la PC) y Heroku (de pago, y tampoco
  es la PC).
- **Puertos:** la web y pgAdmin escuchan solo en `127.0.0.1`; Postgres no publica nada.
- **Correo:** Gmail por SMTP (`lib/correo.php`, sin Composer) con contraseña de aplicación en
  `.env`. Caen en spam (cuenta nueva + dominio de ngrok): se avisa al profe que revise ahí.
- **Seguridad:** `lib/limite.php` (429 en registro, entrar, olvidé y recuperar),
  `apache/seguridad.conf` (CSP, `nosniff`, `X-Frame-Options`, sin listado, `lib/` cerrada),
  `expose_php` apagado, Apache sin versión. El script del tema salió de `index.html` a
  `tema-inicial.js` para que la CSP no lo bloquee.
- **Probado:** tres cuentas creadas desde celulares fuera de la red, con el correo recibido y
  activadas.
- **Para que el link funcione:** PC prendida, Docker Desktop y la ventana de ngrok abiertas.

**Fase 7 (lo que falta):** capturas en `screenshots/` (las suben los compañeros), el video de
respaldo (hecho) y lo del proyecto asignado y el artículo en `Catscoms`.

## Lo que queda incompleto o sin decidir (revisado el 2026-11-08)

**Datos que vas a mandar o capturar**
1. **`1CM6`** (lo mandas esta semana): el PDF le da 5 materias en el salón 1212, pero SAES no lo trae. Cuando llegue: pegarlo en `data/isc/` y correr los tres importadores.
2. **Otros grupos que el PDF trae y SAES no:** `7BM2` (Formulación, Innovación, Reconocimiento de voz), `2CV2` Ética (1007) y `3BV2` Paradigmas. Mismo caso que `1CM6`: ¿existen?
3. **Al revés, SAES los trae y el PDF no:** `4CM6` (Probabilidad, Matemáticas avanzadas), `5CV5` Procesamiento digital de señales, `3AV2` Bases de datos, `8AV1` Gestión empresarial, y 3 de las extra (`2CV1` Ética, `7CM1` y `7CM2` TT I). Se quedan, sin confirmar.
4. **12 ofertas sin salón:** `1CM8` y `1CM9` Cálculo y `6CM5` Sistemas en chip (el PDF dice SA), `4CM6` (2) y los TT (`7CM1`, `7CM2`, `8BM1` ×3, `8BM2` ×2; en TT es normal).
5. **Profes de 27/1:** ~~72 sin métricas~~ ✅ (2026-11-20) 60 cargadas; quedan 12 sin métricas: 9 sin perfil en MisProfesores y 3 con muy pocas reseñas (ARREDONDO, CARMONA, ROSAS TRIGUEROS), que arrancan solo con los comentarios de Gestorix (decisión del usuario). ~~69 sin link~~ ✅ (2026-11-20) quedan 9, que no tienen perfil en MisProfesores. Cédulas: 50 de 260 (110 cédulas de 54 profes, de `data/profesores/links-cedulas.csv`); faltan las de los profes de la C a la T.
6. ~~**PDF de plan sintético**~~ ✅ (Fase 5, 2026-11-20) 203 de 209 materias con PDF y descripción. Faltan los PDFs de Estancia profesional (C804, B803, A804), Tópicos selectos de algoritmos bioinspirados (B653/B753) y Aprendizaje automático aplicado a visión (C614).
7. **Fechas:** 26/2 no tiene inicio ni fin, y a 28/1 le falta el fin (el calendario no lo trae). Menor.
8. **Historial de IA y LCD:** no existe; se muestra como faltante.

**Decisiones abiertas**
9. **TT en el horario del alumno:** SAES tiene 7 grupos X con cupo "sin límite" pero sin oferta, y los TT con asesor están en `8BM1`/`8BM2` (IA) y `7CM1`/`7CM2` (extra de ISC). Cómo mete un alumno su TT al horario se decide en la Fase 3.
10. **Nombres de profe con título o cortados en SAES** (7): `DR.`, `ING.`, `M. EN C.`, `M. EN A.P.` y `SANCHEZ MORENO ADRIANA DE LA P`. ¿Se limpian para mostrarlos? Y 3 mal capturados en `metrics.js`: `DURÀN CAMARILLO EDMUNDO RENÈ` y `HERNÀNDEZ CRUZ MACARIO` (acento grave en vez de agudo) y `DONG _ SHIHAI` (guion bajo). Cruzan bien, pero se ven mal.
11. **Carga máxima de 9 UA:** falta confirmarla en el Art. 52 del Reglamento General de Estudios.

**De la Fase 0, pospuesto al final** (ver arriba)
12. ~~Servicio de correo~~ ✅ Gmail (2026-11-20). ~~Student Pack~~ ya no hace falta (Fase 6 con ngrok). Quedan: datos del aviso de privacidad (responsable, contacto, proveedores y los plazos entre corchetes) y contraseñas fuertes antes de publicar.

**Fase 3: lo que falta o hay que confirmar**
16. ~~Borrar la cuenta~~ ✅ (2026-11-08) "Tu cuenta" → "Borrar mi cuenta". Pide la contraseña, borra correo, avance, horario, agenda y enlaces, y deja los comentarios como "usuario eliminado". Si eres el único admin, no te deja (primero nombra a otro).
17. **Art. 98** como lo interpreta la app: avisa si el horario abarca más de 3 semestres seguidos, o si adeudas materias de más de 2 semestres antes del más alto que inscribes. Confírmalo con el reglamento.
18. El modo Automático llena **hasta la media**; para pasarla (con trámite) se agregan materias a mano.
19. Cambiar la contraseña con sesión iniciada no existe aparte; se hace con "Olvidé mi contraseña".
20. ~~Las anotaciones de materias por maestro (`teacherMats`)~~ ✅ (2026-11-20) Ya no son notas manuales: "Imparte" (verde) = la da en el periodo vigente; "Ya no" (rojo, con el último periodo) = la dio antes y ya no. Sale de `api/horarios.php` y `api/roster.php`, comparando por nombre de la materia.

**Mío**
13. ~~Commit de las Fases 1, 2 y 3~~ ✅ `c9b47a5` y `d39449e` (2026-11-20). La Fase 4 está sin commit.
14. Probar el *service worker* (abrir sin internet) en un navegador normal.
15. El front todavía se llama "Avance ESCOM" en el título y el `manifest.webmanifest`; cambiarlo a Gestorix cuando lo pidas.

---

## Ya resuelto

| Tema | Decisión |
|---|---|
| Nombre | Gestorix (repo y sitio) |
| Dueño | El usuario, solo |
| Repo | `pablo140706/Gestorix`, público, limpio: sin historial ni archivos del iscweb viejo. Local: `C:\db\repos\proyectos\gestorix` |
| Dónde se trabaja | En la PC, que tiene la versión buena de iscweb (con calendario) |
| Entrega | Primera semana de diciembre, en un sitio web |
| Stack | Como Seismic: `php:8.2-apache` + `postgres:17` + pgAdmin, `sql/` numerado, `src/` servido por Apache. Sin framework |
| Front | Vanilla JS de iscweb, leyendo de la API |
| Fuente | HTML de SAES pegado → importador en Docker → base. Después se edita en pgAdmin |
| CSV | Obsoletos, salvo para la carga inicial (`CLAUDE.md` §3) |
| Esquema de la P3 | Solo referencia |
| Carga | En UA: mínima 4, media 7 (ISC) o 6 (IA, LCD), máxima 9. Aviso arriba de la media. Sin situación escolar |
| Cursos | 2 (ordinario y recurse). Tras reprobar el ordinario: recurse o ETS. Tras reprobar el recurse: ETS obligatorio. El ETS aprobado cuenta como aprobada y entra al promedio |
| Optativas | ISC por rama. IA y LCD solo en el semestre de su PDF; rutas solo con las parejas obvias |
| Seriación | ISC oficial + propuesta IA/LCD aprobada. Solo avisa |
| Cupo | 40 de 2.º en adelante, 36 en 1.º |
| Sin cuenta | Se puede usar la app; la cuenta guarda de forma permanente y permite comentar |
| Registro | Cualquier correo, con verificación. Alias generado y cambiable. Carrera fija |
| Privacidad | Sin boleta, teléfono ni nombre. El correo solo lo ven moderadores y admins |
| Comentarios | Sobre el profesor, con etiqueta de la materia (elegida de las suyas). Los que quiera cada usuario, máximo 500 caracteres. Edición en 24 h. Con rúbrica |
| Dificultad | Escala 0–10 (JURADO 6.4 y JUÁREZ LEÓN 6.1 son reales). LEVARIO corregido a 3.5 |
| Recordatorios | Solo en el calendario, sin avisos |
| Moderación | Ocultar, suspender y banear. El admin (tú) nombra moderadores |
| Cédula | La capturas tú en `data/profesores/links-cedulas.csv` y la carga `importador/profesores.php` (tabla `cedula`, varias por profe) |
| Plan sintético | Un PDF por materia; descripción generada por Claude desde el PDF |
| Agenda | Recordatorios con fecha y hora |
| Profesor sin asignar | Se guarda sin profesor y se corrige a mano |
| Cifras | 27/1: 664 ofertas (659 de SAES + 5 extra de iscweb), 2,021 sesiones, 663 cupos, 260 profes con clase. 274 profesores en total |
| `6CM5` Aprendizaje automático | Quitado: no se abrió. En `data/excluir.csv` |
| Historial | Solo 26/2 (ISC). El 27/1 viejo de `historial.js` no se carga: lo reemplaza SAES |
| Correcciones | OLALDE 8.3 y LEVARIO 3.5 (más las de LUNA, MÁRQUEZ, BARRALES y TELLEZ) |
| Carga máxima | 9 UA, confirmado |
| Importar avance de iscweb | No hace falta: solo lo usas tú |
| Prácticas 4–5 | Ya entregadas; no se retoman |
| Recortes | Agenda → PDFs → cédula → rúbrica |
| Nada se borra | Ni del prototipo ni de iscweb |
