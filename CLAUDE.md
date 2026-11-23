# Gestorix — gestor académico de ESCOM

App web para que un alumno de ESCOM (ISC, IA o LCD) lleve su avance, arme su horario, conozca a sus profesores, deje comentarios y apunte recordatorios. Es la evolución de **iscweb**, ahora con base de datos relacional, backend y sitio publicado.

> Memoria actualizada el **2026-11-08**, con dos rondas de respuestas del usuario, el
> *Procedimiento de Reinscripción 27/1* de ESCOM y la revisión del repo de Seismic. **Manda sobre**
> `MEMORIA-FASE-BD.md`, el `ROADMAP.md` y el `CLAUDE.md` de iscweb en todo lo que se contradiga.
> El plan de trabajo está en `ROADMAP.md` y el aviso de privacidad en `docs/aviso-de-privacidad.md`.

---

## 1. Quién, qué y cuándo

- **Nombre:** Gestorix (repo y sitio).
- **Dueño y único desarrollador:** el usuario. Los compañeros de Catscoms (Emiliano y David) hacen el proyecto de Seismic; este proyecto no es del equipo.
- **Repositorio: `pablo140706/Gestorix`, público**, rama `main` (commit inicial `b645a73`, solo `README.md`). Empieza **limpio**: no trae el historial ni los archivos viejos de iscweb, solo el proyecto contenerizado. Ahí se documentan las fases y lo que cambia.
- **El front sale de iscweb:** `pablo140706/iscweb-inicio`, rama `feat/multi-carrera-ia-lcd`, commit `2419470` (2026-11-08). Es la versión buena: calendario, carga diferida, portada, buscador, comparador, tema, atajos, compartir y PWA (72 archivos). Ese commit **todavía trae** errores de métricas (OLALDE 83, LUNA 44, MÁRQUEZ 33, LEVARIO 6.4): se corrigen al cargar la base, no en iscweb.

### Entorno de trabajo (sesión local de Claude Code)

| Qué | Dónde |
|---|---|
| Máquina | La **PC** del usuario, con Windows. La laptop no se usa |
| Terminal | MSYS2 **UCRT64** (bash); a veces PowerShell |
| Este proyecto | `C:\db\repos\proyectos\gestorix` (`/c/db/repos/proyectos/gestorix`) |
| iscweb (fuente del front y de los datos) | `C:\db\repos\iscweb-inicio`, rama `feat/multi-carrera-ia-lcd` |
| HTML de SAES y PDFs oficiales | `C:\db\repos\iscweb-inicio\data\{isc,ia,lcd}\` (`mp.html`, `horario-m.html`, `horario-v.html`, `opta.html`, mapas curriculares y de optativas) |
| Calendario del IPN | `C:\db\repos\iscweb-inicio\calendario.csv` y `data\calendarioipn-escolarizada.pdf` |
| Prototipo de la Fase 1 (Node) | Solo en el zip `gestor-escom-fase1.zip` que descargó el usuario. **No** está en el repo |
| Git | Credenciales del usuario como `pablo140706` |

- **Docker:** hace falta **Docker Desktop** (con WSL2). PHP y Postgres corren en contenedores, **no** se instalan en Windows. Antes de empezar, verifica `docker --version` y `docker compose version`.
- **Puertos sugeridos:** la app en `localhost:8080` (en Windows el 80 suele estar ocupado) y pgAdmin en `localhost:5051` (el 5050 lo usa otro proyecto). El preview viejo de iscweb usaba `localhost:8123`.
- **Lo que se copia de iscweb a Gestorix:** el front (`index.html`, los `.js` de módulos, `styles.css`, `favicon.svg`, `manifest.webmanifest`, `sw.js`) a `src/`, y el HTML de SAES a `data/`. Los CSV y los `.js` de datos **no** se copian: se convierten **una vez** en `.sql` de carga inicial y se commitea el SQL.
- **Entrega:** **primera semana de diciembre de 2026, funcionando en un sitio web.** La meta interna es terminar el 28 de noviembre.
- **Requisitos del profesor:** contenerizado, base de datos relacional, con back y front, y publicado. El stack es libre.
- **El usuario está aprendiendo** back, front y despliegue, y trabaja entre semana con poco tiempo. Todo debe quedar **sencillo y sin pretensiones**: que se vea bien, que se parezca a Seismic y que no consuma su semana.
- **Lo ya entregado** (Prácticas 2–5) vive en `pablo140706/catscoms`. El esquema de la Práctica 3 **ya no manda**: es solo referencia.

---

## 2. Stack y estructura

**Decidido: el mismo patrón que `pablo140706/Seismic-Data-Visualization-System`.** Ese repo tiene:

```
Dockerfile           php:8.2-apache + libpq-dev + pdo / pdo_pgsql / pgsql, a2enmod rewrite
docker-compose.yml   web (build . , puerto 80, ./src montado en /var/www/html) + db (postgres:17)
sql/00-…05-*.sql     montados uno por uno en /docker-entrypoint-initdb.d/
src/*.php            páginas PHP sueltas, conexión con getenv('POSTGRES_HOST')
screenshots/  README.md  LICENSE
```

**Gestorix copia esa forma:**

```
gestorix/
├── Dockerfile               igual al de Seismic
├── docker-compose.yml       web + db + pgadmin
├── .env.example             contraseñas (el .env real nunca va a git)
├── sql/                     00-tablas.sql, 01-…  carga inicial numerada (initdb)
├── migraciones/             cambios de esquema con la base ya en uso
├── importador/              scripts PHP de línea de comandos: HTML de SAES → base
├── data/isc|ia|lcd/         HTML pegado de SAES
├── src/                     lo que sirve Apache
│   ├── index.html, *.js, styles.css     front vanilla de iscweb
│   ├── arranque.js                      pide los datos a la API y luego carga los módulos
│   ├── api/*.php                        endpoints que regresan JSON
│   ├── api/cuenta/*.php                 registro, verificar, entrar, salir, yo, alias, olvide, recuperar, borrar
│   ├── api/mis-datos.php                avance y horario del usuario con sesión
│   ├── cuenta.js                        ventana de la cuenta y sincronización con la base
│   ├── lib/db.php                       una sola conexión PDO, con getenv
│   ├── lib/api.php                      lo común de los endpoints
│   ├── lib/sesion.php, cuenta.php, correo.php   sesión, CSRF, tokens, alias, envío de correo
│   └── materias/<clave>.pdf             planes sintéticos
├── docs/                    fases, decisiones, aviso de privacidad
├── screenshots/
└── README.md
```

- **PHP sin framework, sin Composer** salvo que el envío de correos lo exija. Front **vanilla JS**, sin bundler.

**Cómo lee datos el front (Fase 2, 2026-11-08):**
- Cada endpoint reemplaza un `.js` de datos de iscweb y regresa **la misma forma**, en la misma variable global: `planes`→`PLANES`, `horarios`→`SCHEDULE`, `roster`→`ROSTER`, `metricas`→`TEACHER_METRICS`, `calendario`→`CALENDARIO`, `optativas`→`ESPECIALIZACIONES` (estos 6 los pide `arranque.js` antes de cargar los módulos) y `cupos`→`CUPOS`+`CUPOS_HIST`, `links`→`MANUAL_LINKS`, `historial`→`HISTORIAL` (estos 3 los pide `lazy.js` cuando hacen falta).
- **Periodo vigente** = el más reciente con ofertas (`max(periodo)`). El historial y los cupos viejos usan llaves `"2026/2"`/`"2027/1"`, porque `maestros.js` las tiene escritas así: `periodoLargo()` en `lib/api.php`.
- `materia` en horarios, historial y cupos es `nombre_saes`: así cruza el front plan, ofertas y cupos (con `norm()`). Cada oferta trae también su `clave`.
- `planes` solo manda optativas con `se_ofrece`, y trae `ua` por materia y `carga: {min, media, max}` por carrera (en el front, `CARGA` y `uaDe(id)`). `slots` (A1/B1/A2/B2 en ISC, A/B/C/D en IA y LCD) siguen fijos en `api/planes.php`. El viejo `maxCred: 55` ya no existe.
- `roster` ya no es el Excel: son los profes de periodos pasados **sin** oferta en el vigente, con sus materias y sin grupos. Sirve para que salgan en la lista de Maestros.
- El filtro A/B de optativas de ISC se quitó de `core.js` (`scheduleFor`).
- `arranque.js` carga los módulos después del evento `load`, por eso `init.js` registra el *service worker* aunque `load` ya haya pasado.

**Cuentas y sincronización (Fase 3, 2026-11-08):**
- En el navegador el avance va por **posición** (`state.subjects["s0-0"]`) y en la base por **clave**. `cuenta.js` traduce con `ID_DE_CLAVE`/`CLAVE_DE_ID` (`estadoAFilas`, `aplicarDatos`). Los lugares de optativa guardan `clave` y `name`; cada renglón del horario guarda `oferta` (el id) y se arma con `armarItemHorario()` (`avance.js`).
- `cuenta.js` envuelve `save()`: con sesión, cada guardado local programa una subida a `mis-datos.php` (POST con todo el estado). Al cerrar la pestaña, `sendBeacon`.
- El plan se dibuja una sola vez al cargar. Si la cuenta trae datos distintos a los del navegador, se guardan y se **recarga una vez**; `firmaDelEstado()` evita el ciclo.
- No se entra sin activar la cuenta. Al **salir** se borra la llave de `localStorage` de esa carrera. El *service worker* no guarda en caché `api/cuenta/*` ni `api/mis-datos.php`.
- Estados con ETS en `getSub()`: `status` sigue siendo pendiente/aprobada/reprobada, más `porEts` y `soloEts`. `califFinal()` alimenta el promedio.
- Carga en UA: `cargaActual()`, `cabeEnCarga()` (no deja pasar de la máxima), `avisosDelHorario()` y `confirmarBaja()` en `horario.js`. El automático llena hasta la **media**.
- **Art. 98 como lo interpreta la app** (falta confirmarlo): avisa si el horario abarca más de 3 semestres seguidos, o si adeudas materias de más de 2 semestres antes del más alto que inscribes.
- Apache manda `Cache-Control: no-cache` para todo `src/` (`Dockerfile`): el navegador revalida (304) y nadie se queda con archivos viejos.
- **El importador corre dentro de Docker:** `docker compose run --rm web php importador/…`.

**Comandos (Fase 1, 2026-11-08):**

| Para | Comando |
|---|---|
| Levantar todo | `docker compose up -d` → app en `localhost:8080`, pgAdmin en `localhost:5051` |
| 1. Cargar horarios de SAES | `docker compose run --rm web php importador/horarios.php 27/1` (repetible: no duplica ni pisa lo corregido en pgAdmin) |
| 2. Cargar cupos de SAES | `docker compose run --rm web php importador/cupos.php 27/1` (aquí SAES **sí pisa**: deja la tabla `cupo` igual que el HTML) |
| 3. Corregir salones con el PDF oficial | En Git Bash: `pdftotext -table -enc UTF-8 data/salones/27-1.pdf data/salones/27-1.txt` y luego `docker compose run --rm web php importador/salones.php 27/1` |
| 4. Propósito, temas y PDF de cada materia | `docker compose run --rm web php importador/materias.php` (lee `src/materias/*.pdf`, `data/programas/*.txt` e `investigadas.csv`; repetible). Si hay PDFs nuevos: `mapa.csv` + `sh importador/programas/copiar.sh "…/Planes de estudio"` en Git Bash |
| 5. Links de MisProfesores y cédulas | `docker compose run --rm web php importador/profesores.php` (lee `data/profesores/links-cedulas.csv`; `--prueba` solo reporta; repetible: no pisa links y reemplaza las cédulas de quien venga en el CSV) |
| Apagar | `docker compose down` (la base se queda en el volumen `gestorix_pgdata`) |
| Volver a sembrar desde cero | `docker compose down -v` y luego `up -d` + importador. **Borra la base**: solo si no hay nada que conservar |

- `sql/` se monta entero en `/docker-entrypoint-initdb.d/` y **solo corre cuando el volumen está vacío**. Si un `.sql` truena, el volumen queda a medias: hay que borrarlo (`down -v`) y volver a levantar.
- `sql/02`–`07` los generó **una vez** `importador/iscweb/convertir.php` desde iscweb `2419470`. No se vuelve a correr: las correcciones van en pgAdmin o en `migraciones/`.
- `sql/08-ofertas-extra.sql`: las 5 ofertas de 27/1 que no vienen en SAES y el usuario conservó.
- **Desde el 2026-11-21 la base publicada tiene usuarios reales:** cada cambio de esquema es un archivo en `migraciones/` (`AAAA-MM-DD-que-cambia.sql`, en transacción, aplicado con el administrador) y se copia también a `sql/00-tablas.sql`. La primera: `2026-11-21-comentarios-se-borran-con-la-cuenta.sql`.
- `pdftotext` (xpdf 4.06) viene con MSYS2 UCRT64, no con el contenedor; por eso el texto del PDF se saca en la PC y se guarda junto al PDF.
- En el contenedor `web`: `/var/www/html` = `src/`, `/var/www/importador` y `/var/www/data` de solo lectura. La app entra con `APP_DB_USER` (variables `DB_*`); pgAdmin, con el administrador (`POSTGRES_USER`).
- **pgAdmin** es donde el usuario corrige los datos.
- El prototipo en Node de la Fase 1 queda en el zip del usuario como referencia (§9); no entra al repo.

**Publicación (Fase 6, 2026-11-21):**
- **Manda el PDF del 2.º parcial** (`bdProyectoParcial2ISC_2027-1.pdf`): la **PC del usuario es el servidor** y la base vive en su Docker. A internet sale por **ngrok**: `ngrok http --url=thwarting-earthling-evasive.ngrok-free.dev 8080` (dominio fijo gratis; `APP_URL` en `.env` apunta ahí). Sin Supabase, Heroku, servidor en la nube ni Student Pack.
- La web y pgAdmin escuchan solo en `127.0.0.1`; Postgres no publica puertos.
- **Correo por Gmail** (`lib/correo.php`, SMTP propio sin Composer, puerto 465). `SMTP_USER` y `SMTP_PASSWORD` (contraseña de aplicación) van solo en `.env`. Si faltan o Gmail falla, el correo sale en `docker compose logs web`. Llegan a spam.
- **Seguridad:** `lib/limite.php` (intentos por IP y por correo, en `/tmp` del contenedor, una carpeta por usuario del sistema: `/tmp/gestorix-limites-33` es la de Apache. **Las pruebas a mano con `docker compose exec` corren como root**; si una carpeta queda de root, Apache no puede escribir y el login da 500 (pasó el 2026-11-22). Entrar: 5 fallidos por correo y 20 por IP → 15 min; con ngrok la IP real es la última de `X-Forwarded-For`), `apache/seguridad.conf` (CSP sin scripts en línea, `nosniff`, `DENY`, sin listado, `lib/` cerrada) y `expose_php` apagado. **No escribir `<script>` ni `onclick=` dentro del HTML:** la CSP los bloquea.
- El navegador integrado de Claude no registra *service workers*: ese error de consola no es de la app.

**Cupo, tema y celular (2026-11-21):**
- El cupo se muestra en todos lados como **`inscritos/cupo`** (`cupoBadge()` en `core.js`), con color por disponibilidad y el detalle al pasar el mouse. Igual en el JPG y el XLSX.
- **Tema oscuro:** los chips pastel y las materias de la rejilla se voltean con `filter: invert(1) hue-rotate(180deg)` (mismo tono, fondo oscuro, texto claro). **El calendario no:** mezcla pastel con colores fuertes, así que cada tipo de día (`.cd.t-*`) tiene su color propio en oscuro, al inicio de `styles.css`. Nada de fondos claros fijos (`#fff…`): usar las variables (`--bg-repr`, `--bg-apro`, `color-mix` con `--accent`). El usuario pidió **mantener el botón de tema**.
- **Controles nativos** (listas, casillas): `color-scheme` sigue el tema de la APP, no el del sistema (con Windows en oscuro y la app en clara, las listas del Historial salían blanco sobre blanco; 2026-11-21).
- **Celular (≤ 620 px, bloque al final de `styles.css`):** pestañas en un renglón deslizable; rejilla del horario deslizable de lado con la hora fija; tabla de maestros a lo ancho con títulos cortos (`corto` en `PROF_COLS`).

**Pruebas, docs y app instalable (2026-11-21):**
- **Pruebas de las reglas:** `pruebas/reglas.test.js` carga `data.js` y `core.js` tal cual en Node (con `pruebas/planes.json`, copia de `api/planes.php`) y revisa promedio, desfase, ventana, carga, regulares y grupos de recurse, con "hoy" fijo en 27/1. Correr: `MSYS_NO_PATHCONV=1 docker run --rm -v "$(pwd -W):/app" -w /app node:22-alpine node pruebas/reglas.test.js` (27 pruebas). Si cambia una regla a propósito, se actualiza la prueba.
- **Docs para el usuario:** `docs/cargar-periodo-nuevo.md` (27/2 paso a paso), `docs/respaldo.md` (pg_dump fuera del repo), `docs/guion-expo.md` (6 minutos).
- **Nombre e instalación:** el título y el manifest dicen **Gestorix**; íconos `icono-192.png` y `icono-512.png` (dibujados con System.Drawing de Windows) para instalarla en el celular.
- **Respuestas del usuario (2026-11-21):** el automático se queda **al azar** (el alumno arma lo que le conviene; sin preferir grupo completo). **Tema claro por defecto** (ya no se sigue al sistema; el botón lo cambia y se recuerda).
- **Equivalencias entre carreras** (SAES, tabla `equivalencia`, migración `2026-11-21-equivalencias.sql` + `sql/10-equivalencias.sql`, 70 pares): `api/planes.php` manda `equiv` por carrera en los dos sentidos (`EQUIV`, `EQUIV_A_MIA` en `data.js`). Van **escondidos por defecto** (usuario, 2026-11-21): en la lista de grupos de una materia, el botón **"Mostrar equivalencias (N)"** los agrega con la etiqueta "Equivalente · IA"; en el automático, la casilla **"Equivalencias"**. Cuentan como tu materia. El comparador y "Cambiar" solo usan tu carrera (`scheduleFor(s, i, false)`). Las optativas no buscan equivalentes.

**Los defectos de Seismic no se copian:**

| Seismic | Gestorix |
|---|---|
| `POSTGRES_HOST_AUTH_METHOD=trust` | Quitado |
| `POSTGRES_PASSWORD=postgres` en el compose y en cada `.php` | Contraseñas en `.env` y `getenv()`, en un solo `lib/db.php` |
| Postgres publicado en el puerto 5433 | No se publica; pgAdmin solo en local o detrás de contraseña |
| `display_errors = 1` | Apagado en producción |
| La app entra como `postgres` | Rol de mínimo privilegio |
| Solo initdb | initdb para sembrar + `migraciones/` para evolucionar |

---

## 3. Fuente de datos

1. **SAES manda.** El usuario copia el HTML de la tabla oficial (mapa curricular, horarios, cupos) y lo pega en `data/<carrera>/`. Ya no hay OCR ni captura a mano.
2. El **importador** (en Docker) parsea ese HTML y actualiza la base.
3. Después de cargar, **la base es la fuente de verdad**. Las correcciones se hacen en **pgAdmin**.
4. **Los CSV de iscweb quedan obsoletos.** Solo sirven para la carga inicial de lo que no existe en otro lado:

| Archivo de iscweb | Qué aporta que no está en SAES |
|---|---|
| `calendario.csv` | Calendario del IPN transcrito a mano (el PDF lo marca con colores) |
| `nombres.csv` | Nombre legible con acentos y **orden** de cada materia dentro de su semestre |
| `AESTR_*.csv` → `metrics.js` | Métricas de MisProfesores (202 profes), ya corregidas |
| `maestros_manual.csv` | 205 links a MisProfesores |
| `historial.js` | Historial de 26/2 (solo ISC). Su 27/1 (350 filas, versión vieja) **no se carga**: lo reemplaza SAES (usuario, 2026-11-08) |
| `planes.js` (seriación) | ISC: 21 pares oficiales. IA y LCD: 12 + 11 pares aprobados por el usuario |

5. Lo que no existe todavía se muestra **como faltante**, sin inventarlo: historial de IA y LCD, métricas de 72 profes y las cédulas que falten (links: solo 9 sin perfil en MisProfesores, 2026-11-20).

---

## 4. Reglas de negocio

### 4.1 Carga académica

**Se cuenta en unidades de aprendizaje (UA), no en créditos.** El tope de 55 créditos queda **derogado**.

| Carrera | Mínima | Media | Máxima |
|---|---|---|---|
| ISC 20 | 4 | 7 | 9 |
| IIA 20 | 4 | 6 | 9 |
| LCD 20 | 4 | 6 | 9 |

- La mínima y la media salen del Procedimiento de Reinscripción 27/1. **La máxima de 9 la dio el usuario**; el procedimiento remite al Art. 52 del Reglamento General de Estudios. Está pendiente confirmarla ahí.
- **En la app:** hasta la media, sin aviso. Entre la media y 9, se permite con un aviso de que requiere trámite. **Solo los regulares** (no deben nada de semestres anteriores) llegan a 9; **los irregulares, hasta la media** (usuario, 2026-11-21; `esRegular()`/`cargaMaxPermitida()` en `core.js`). Más de lo permitido no se deja agregar.
- ~~No se modela la situación escolar~~ → **Desfase y dictamen sí se avisan** (usuario, 2026-11-21; reglas en `docs/reglas-escolares.md`, mostradas **como regla oficial**, aunque salen de alumnos en Facebook). **Se cuenta desde el ordinario** (P = periodo en que reprobaste la 1.ª vez): P+2 "último" (3.er semestre); P+3 **desfasada → carta de 24 créditos**; P+4 o más **dictamen** (solo ETS, no puede inscribir nada). `desfaseDe()`/`TEXTO_DESFASE` en `core.js`. Avisa en Mi avance, la fila y el horario. El periodo (`avance.periodo_reprobada`, migración `2026-11-21-periodo-reprobada.sql`) se pregunta en la ventana de "Reprobaste…" o sale del Estado General de SAES. Solo avisa, nunca bloquea. Baja temporal no se modela (si la diste de baja, vuelve a ser 1.ª vez).
- **Importar de SAES:** en la bienvenida y bajo el avance, **"Importar de SAES"** lee el **Estado General** (archivo o código pegado; tablas `mainCopy_GV_Reprobadas/Adeudadas/Desfasadas`) con `DOMParser`, en el navegador. Reprobadas → sin número con sus veces y periodo (`20261` → `26/1`); no cursadas → pendientes; lo demás hasta el semestre más alto listado → aprobada sin número, con palomitas para quitar. **También lee el Kárdex** (`kardex.aspx`: tablas `bottomBorder` por semestre con "Clave, Materia, Fecha, Periodo, Forma Eval., Calificacion"; `REC` = recurse): calificaciones con número, ETS → aprobada por ETS, recurse → 2.ª vez, reprobadas con su periodo, optativas a su lugar (`slotDeOptativa`). Probado con el Kárdex real del usuario (2026-11-21). El Estado General se reconoce **solo por los ids de sus tablas** (el menú de SAES también dice "materias reprobadas"), y al importarlo después del Kárdex no pisa números y se queda el periodo más reciente.
- **Reiniciar y Cargar respaldo con sesión** primero suben a la cuenta (`guardarEnCuentaYa()`, `cuenta.js`) y luego recargan; si no, al recargar se bajaba lo viejo de la cuenta y los datos regresaban.
- **TT I y TT II valen 2 UA cada una.** Las demás, 1.
- **Las UA adeudadas cuentan** en la carga. **Cuáles** (usuario, 2026-11-21; antes solo las de "solo por ETS"): **todas las reprobadas** (1.ª vez o recurse) ocupan sus UA hasta que las apruebes, aunque no estén en el horario; si están en el horario se cuentan ahí, una sola vez (`materiasSoloEts()`/`uaBloqueadas()` en `core.js`). El automático descuenta las reprobadas que él mismo coloca para no contarlas doble.
- **Ventana de 3 semestres — se BLOQUEA** (usuario, 2026-11-21, "regla fundamental"): solo se inscriben materias desde el semestre más bajo que debes hasta dos más (debes de 1.º → 1.º a 3.º; lo más bajo es 2.º → 2.º a 4.º). `ventanaInscripcion()` en `core.js`; `toggleHorario()` no deja agregar fuera y el automático se ancla ahí.
- La app **avisa** (no bloquea) en dos casos: el Art. 98 (no cursar materias de más de 3 periodos consecutivos, ni adeudar de más de 2 periodos previos) y las bajas que no proceden (si recursas la materia, o si quedas bajo la mínima).
- Los créditos se muestran como dato informativo.

### 4.2 Cursos, recurse y ETS (igual en las tres carreras)

- Cada materia se cursa **como máximo 2 veces**: ordinario (`veces` = 1) y recurse (`veces` = 2).
- **El ETS no cuenta como curso.** Flujo:
  - Reprobaste el **ordinario** → puedes recursar **o** presentar ETS.
  - Reprobaste el **recurse** → el ETS es **obligatorio**: ya no se puede volver a cursar.
- **Aprobar por ETS cuenta como aprobada y entra al promedio.** ~~El promedio es solo de aprobadas (2026-11-08)~~ → **El promedio es como el del Kárdex de SAES** (usuario, 2026-11-21): la **última calificación con número de cada materia** —la del ETS si lo presentó, si no la del curso—, **aprobada o reprobada**. Las que no tienen número no cuentan. `califParaPromedio()` en `core.js`. La vista `avance_status.calif_final` sigue siendo la calificación con que se **aprobó** (no es el promedio).
- La calificación es un **entero de 0 a 10**. Aprobada con ≥ 6.
- Status derivado:

| Situación | Status |
|---|---|
| Sin calificación, primera vez | pendiente |
| Sin calificación, segunda vez | en recurse |
| Calificación ≥ 6 | aprobada |
| Calificación < 6, primera vez | reprobada (recurse o ETS) |
| Calificación < 6, segunda vez | **solo por ETS** (antes "bloqueada") |
| ETS aprobado | aprobada por ETS |

- Las obligatorias se cursan sí o sí; el alumno decide **cuándo**. En las optativas decide **cuáles**.

### 4.3 Optativas

- **Slots:** 2 en 6.º y 2 en 7.º, en las tres carreras. La división "A = matutino / B = vespertino" de ISC se abandona.
- **ISC:** se sigue la trayectoria de su rama (`mapaCurricularISC2020_optativas.pdf`): 14 ramas, cada una con una materia de 6.º y una de 7.º. El procedimiento da de baja las optativas inscritas fuera de la trayectoria: **la app avisa** (usuario, 2026-11-21; `optativasFueraDeTrayectoria()` en `horario.js`).
- **IA y LCD:** cada optativa **solo se ofrece en el semestre que marca su PDF** (`mapaCurricular{IIA,LCD}2020_optativas.pdf`), porque así lo exige el procedimiento. SAES tiene clave de 6.º y de 7.º para cada una, pero solo vale la del semestre del PDF. Esto **reemplaza** la regla anterior de "catálogo plano disponible en ambos semestres". IA tiene 7 en 6.º y 7 en 7.º; LCD, 6 y 7.
- **Rutas en IA y LCD: solo las parejas obvias.** Las demás optativas se eligen libres dentro de su semestre.

| Carrera | 6.º | → 7.º |
|---|---|---|
| IA | Sistemas Multiagentes | Aplicaciones de Sistemas Multiagentes |
| IA | Propiedad Intelectual | Innovación y Emprendimiento Tecnológico |
| IA | Minería de Datos | Big Data |
| LCD | Bioinformática Básica | Bioinformática Avanzada |
| LCD | Simulación Básica | Simulación Avanzada |
| LCD | Ciberseguridad | Protección de Datos |
| LCD | Propiedad Intelectual | Innovación y Emprendimiento Tecnológico |

### 4.4 Seriación

- **Solo avisa, nunca bloquea.**
- ISC: los 21 pares del mapa oficial.
- IA y LCD: la propuesta por nombres que el usuario aprobó el 2 nov (12 y 11 pares). Sus mapas no dibujan flechas; si ESCOM publica una oficial, manda ella.

### 4.5 Grupos, cupos y horario

- Código `[1-8][ABC][MVX][1-9][0-9]?`: el número **puede tener dos dígitos** (en 26/2 existió `1CM10`). `C` = ISC, `B` = IA, `A` = LCD. **Grupos de recurse (usuario, 2026-11-21): solo en 1.er semestre: en la mañana del 7 en adelante (`1CM7`–`1CM9`; `1CM1`–`1CM6` regulares) y en la tarde del 6 en adelante (`1CV6`, `1CV7`; `1CV1`–`1CV5` regulares)**. En los demás semestres no hay grupos de recurse (`esGrupoRecurse()` en `core.js`). El automático mete **primero las reprobadas que aún se pueden recursar**; en 1.º solo en grupos de recurse, y las nuevas de 1.º solo en regulares.
- **Trabajo Terminal** va en grupos `X`, sin horario fijo: ISC `7CX1` (TT I) y `8CX1` (TT II), IA `7BX1`/`8BX1`, LCD `7AX1`/`8AX1`. En TT, `grupo + materia` no es llave única (varios asesores). **Pero el HTML de SAES de 27/1 no trae grupos X**: TT I de ISC viene en `7CM1`/`7CM2` (de las 5 extra) y TT II de IA en `8BM1`/`8BM2`.
- **Cómo se abren los lugares** (alumnos, 2026-11-21; `docs/reglas-escolares.md`): 30 regulares + 4 irregulares sin desfase + 2 con desfase/dictamen/regreso de baja = 36; ya lleno, **sobrecupo de 2 a 4**, en persona, con permiso del profe y de subdirección. La app lo explica en el título del cupo y en "¿Cómo funciona el cupo y el sobrecupo?" (`NOTA_CUPO`, `core.js`).
- **Cupo: 40 de 2.º semestre en adelante** (36 regulares + 4 de sobrecupo); **36 en 1.er semestre**. Los cupos de SAES (27/1, cargados el 2026-11-08) lo confirman: 159 de 664 tienen más inscritos que cupo, como mucho +4.
- **El cupo es de grupo + materia, no de cada oferta** (en TT varios asesores comparten un cupo): vive en su propia tabla `cupo` (decisión del usuario, 2026-11-08). Los cupos de SAES sí traen grupos X de TT (`7CX1`, `7CX2`, `8CX2`, `7BX1`, `8BX1`, `7AX1`, `8AX1`) con cupo 250/255 = sin límite, aunque no tengan horario ni oferta.
- **Salones: manda el PDF oficial** "Distribución de salones" de ESCOM (`data/salones/27-1.pdf`) sobre el HTML de SAES (usuario, 2026-11-08). Formato `1206` = edificio 1, salón 206; `SA` = sin asignar. Llenó 128 salones vacíos y corrigió 20. **El laboratorio que trae el PDF no se guarda.**
- **Profesor sin asignar:** se guarda **sin profesor** (`NULL`) y el usuario lo corrige a mano. Hoy no hay ninguno: el único (`6CM5` C611, Aprendizaje automático) se quitó porque no se abrió (sin profe, cupo 1, no sale en el PDF).
- **Ofertas que no se cargan:** `data/excluir.csv` (periodo, grupo, materia, motivo). `horarios.php` y `cupos.php` se las saltan aunque vengan en SAES.
- Rejilla: 9 bloques de 1:30, de 07:00 a 21:30, con recesos de 10:00–10:30 y 18:00–18:30, de lunes a sábado.
- Periodo 27/1: clases del **24 de agosto al 18 de diciembre de 2026**.

### 4.6 Profesores

- **Ficha única por profesor**, que junta todo para elegir con quién inscribirse:
  - métricas de MisProfesores, con link;
  - comentarios propios, por materia;
  - qué materias da, en qué grupos y con qué horario (las tres carreras);
  - historial;
  - **cédula profesional**.
- Escalas de MisProfesores: calidad 0–10, recomiendan 0–100 %, dificultad (bajo = bueno). **Nunca se promedian** con las calificaciones de los comentarios propios: van lado a lado.
- **La dificultad no es de 0 a 6**, como suponía iscweb: MisProfesores muestra valores reales de 6.4 (JURADO JIMÉNEZ) y 6.1 (JUÁREZ LEÓN), confirmados por el usuario. El `CHECK` va de **0 a 10**. Los colores de iscweb siguen igual (≥ 5 es rojo fuerte).
- Las métricas son **globales por profesor**, no por carrera.
- **Cédula:** la busca el usuario en el Registro Nacional de Profesionistas (SEP) y la captura en `data/profesores/links-cedulas.csv` (columnas: link, licenciatura o ingeniería con "-L"/"-I", maestría, doctorado y **especialidad = numC-T**, usuario 2026-11-20). `importador/profesores.php` la carga en la **tabla `cedula`** (profesor, número, nivel; varias por profe), que reemplazó a `profesor.cedula` y `titulo_profesional`. En 6 profes la especialidad repetía el número del doctorado: se guarda una vez, como doctorado.
- **Cifras en la base (2026-11-08):** 27/1 tiene **669 ofertas** (664 del HTML de SAES, con `1CM6` agregado el 2026-11-21, + 5 extra; se quitó `6CM5` C611), 2,037 sesiones, 663 cupos y **260 profes con clase**. La tabla `profesor` tiene **274** (los 260 + 14 que solo dieron clase en 26/2), sin duplicados. El "276 maestros" del prototipo no cuadra con ningún conteo consistente; manda el de la base.
- **Correcciones de captura** que se aplican al cargar: BARRALES recomiendan 1.4 → 14; TELLEZ BARRERA rec/dif invertidos; LUNA BENOSO dificultad 44 → 4.4; MÁRQUEZ ARREGUÍN 33 → 3.3; OLALDE MOGOLLÁN calidad 83 → 8.3; **LEVARIO MEDINA dificultad 6.4 → 3.5** (confirmado en MisProfesores por el usuario). Su calidad 6.1 y recomiendan 47 % coinciden con los de JURADO JIMÉNEZ, pero el usuario confirmó que son correctos.
- Los nombres se cruzan siempre normalizados (sin acentos) y se muestra el acentuado.

### 4.7 Materias

- **Un PDF de plan sintético por materia**: el usuario ya los tiene de las 3 carreras. Se sirven como archivos estáticos; la base solo guarda la ruta.
- ~~Descripción corta que genera Claude~~ → **Decidido en la Fase 5 (usuario, 2026-11-20):** la descripción es el **propósito y la lista de unidades tal cual** el programa sintético (1.ª hoja del PDF), sin redactar nada. La ventana dice "Tal cual el programa sintético oficial".

**Cómo quedó (Fase 5, 2026-11-20):**
- Los PDFs originales están en `C:\Users\Px\Documents\Escuela\Planes de estudio\{ia,isc,lcd}` (177). Van **en el repo**, en `src/materias/<clave>.pdf` (44 MB; decisión del usuario).
- `data/programas/mapa.csv` dice qué PDF es de qué clave (lo armó una vez `importador/programas/mapear.php`). `importador/programas/copiar.sh` (Git Bash, necesita `pdftotext`) copia los PDFs y saca el texto de su 1.ª hoja con `pdftotext -raw -l 1` a `data/programas/<clave>.txt`. `importador/materias.php` llena `materia.pdf`, `descripcion` (propósito, línea en blanco, una línea por unidad "I. …") y `descripcion_fuente`.
- **22 PDFs son escaneos** (6 de IA, 16 de LCD), sin texto. El usuario pidió investigarlos: su descripción está en `data/programas/investigadas.csv` y lleva `descripcion_fuente` (la app la marca **"orientativa"** y remite al PDF). A729, A801 y A802 usan el programa oficial idéntico de IA/ISC; B746 usa los temas de Big Data de ISC/LCD; las demás son resúmenes propios a partir de los mapas curriculares de ESCOM. Los programas de esas materias no existen como texto en internet.
- En IA y LCD la clave gemela (la que no se ofrece) toma el PDF de su pareja del mismo nombre.
- Sin PDF (6): Estancia profesional (C804, B803, A804), Tópicos selectos de algoritmos bioinspirados (B653, B753) y Aprendizaje automático aplicado a visión (C614).
- "Teoría de Conjuntos y" (Matemáticas discretas, las 3 carreras) viene cortado **en el PDF oficial**; se deja tal cual.
- En la app: botón **ⓘ** junto a cada materia en Mi avance y Optativas (`materia-ui.js`) → ventana con clave, semestre, créditos, UA, horas, seriación (con enlaces), propósito, temas y "Ver programa oficial (PDF)". Los textos los trae `api/materias.php` la primera vez que se abre (`lazy.js`).

---

## 5. Usuarios y privacidad

- **La app se usa sin cuenta**: ver horarios, maestros y materias, y armar un horario. Sin cuenta, lo que captures vive solo en tu navegador.
- **La cuenta sirve para guardar de forma permanente** (avance, horario, agenda) y para comentar.
- Registro con **cualquier correo**. **Una cuenta por correo.** **Se verifica el correo** con un enlace, y hay "olvidé mi contraseña". Esto necesita un servicio de envío (pendiente elegirlo).
- La **carrera se elige al registrarse y queda fija.**
- La identidad pública es un **alias generado al azar, que el usuario puede cambiar** (único).
- **No se guardan boleta, teléfono ni nombre real.**
- **Solo moderadores y admins ven el correo**, y solo para casos graves (acusaciones sin fundamento, incitación al odio).
- Roles: alumno · moderador · admin. **El admin es el usuario, y él nombra a los moderadores.**
- Contraseñas con `password_hash`. Sesión con una cookie. Sin cookies de rastreo.
- Nadie más usa iscweb, así que **no hace falta importar avance** del navegador.
- **Al crear cuenta o iniciar sesión** (usuario, 2026-11-08): si la cuenta está vacía, se sube lo que ese navegador tenía capturado (avance y horario); si la cuenta ya tiene datos, manda la cuenta.
- **Borrar la cuenta** (`api/cuenta/borrar.php`, 2026-11-08): pide la contraseña otra vez. Las llaves foráneas hacen el resto: `CASCADE` en avance, horario, recordatorio, token y **comentario** (cambio del 2026-11-21 por un reporte de abuso: antes quedaba "usuario eliminado"); `SET NULL` en reporte y bitácora. El único admin no puede borrarse. **Con suspensión vigente no se puede borrar**, y el correo no se puede volver a registrar en **7 días** (tabla `correo_borrado`, solo el sha256; el registro avisa por correo, no en pantalla).
- **Bienvenida y calificación opcional** (usuario, 2026-11-21; `bienvenida.js`, migración `2026-11-21-resultado-sin-calificacion-e-ingreso.sql`):
  - **Solo con cuenta** (usuario, 2026-11-21): sale al activar la cuenta (`?cuenta=activada`, con "¡Tu cuenta está activa!") o al entrar a una cuenta que sigue vacía. **Sin cuenta no sale**: quien solo quiere ver, solo ve. La llaman `cuenta.js` (ya con tus datos bajados) y `portada.js`. Una vez vista o cerrada no vuelve para esa cuenta (llave con una huella del correo); se reabre con **Guía de inicio**, bajo el avance, que sí ve cualquiera.
  - **Nuevo ingreso:** periodo de ingreso + grupo de 1.er semestre (número 1–5; del 6 en adelante son de recurse) → se arma su horario con ese grupo.
  - **Otro semestre:** periodo de ingreso + semestre que va a cursar (se sugiere del ingreso) → lo anterior queda **"aprobada" sin número**, sin pisar lo ya capturado. Las optativas no se marcan: las elige él.
  - **Calificación opcional:** la casilla es una lista (`""`, Aprobada, Reprobada, 10…0); igual el ETS. En el navegador `res`/`res_ets`; en la base `avance.resultado`/`resultado_ets` (solo valen sin número). Cuentan para créditos y avance, **no para el promedio**, que dice "de X de Y aprobadas".
  - **Al marcar reprobada** se abre una ventana: ¿ordinario o recurse? ¿ETS (no / aprobado / reprobado, con número opcional)? y explica qué sigue (recursar o ETS / solo ETS y cuánta carga ocupa).
  - **Fechas** en Mi avance: ingreso (`usuario.ingreso`, "25/1"), **egreso según el plan** = ingreso + 7 periodos, y **egreso a tu ritmo** = UA que faltan ÷ carga media, desde el periodo en curso. `27/1` = ago–dic 2026; `27/2` = ene–jun 2027.
- **Correos** (2026-11-20): salen por **Gmail** con una contraseña de aplicación en `.env` (ver §2, Publicación). Si no está configurado, el texto y el enlace salen en `docker compose logs web`.
- Aviso de privacidad y reglas para comentar: `docs/aviso-de-privacidad.md` (borrador). El **correo de contacto** será uno que el usuario ya tiene; él lo escribe (no va en esta memoria). Faltan el nombre del responsable (por defecto, "Gestorix, proyecto escolar") y los proveedores de hosting y de correo.
- **Ese mismo correo** sirve como remitente de los correos de verificación y recuperación. Su contraseña de aplicación o su clave SMTP van **solo en `.env`**, nunca en el repo.

---

## 6. Comentarios y moderación

- **Cualquiera con cuenta puede comentar.** Se da por hecho que cursó con ese profesor.
- El comentario es sobre **un profesor**, con una **etiqueta de materia**: el usuario elige el nombre de la materia de entre las que ese profesor tiene indexadas, y se muestra como label.
- **Cada usuario pone los comentarios que quiera**, sin límite de cantidad. **Máximo 500 caracteres** por comentario.
- Califica con las escalas de MisProfesores (calidad, recomienda, dificultad), más el texto y la **rúbrica** (cómo evalúa: examen 60 %, proyecto 40 %…).
- **Editar o borrar el propio comentario solo en las primeras 24 h.**
- Los usuarios **reportan**. Moderadores y admins pueden **ocultar** el comentario, **suspender** la cuenta un tiempo o **banearla**. Cada acción queda en una bitácora.

**Decisiones al construirla (Fase 4, 2026-11-20):**
- **Suspendido:** entra, ve y guarda su avance y horario; **no comenta ni reporta** (`exigirQuePuedaComentar()` en `lib/sesion.php`). El baneado no entra.
- **Rúbrica opcional**; si se llena, máximo 6 conceptos que suman **exactamente 100 %**.
- **Oculto:** su autor lo sigue viendo, marcado "Oculto por moderación"; nadie más salvo moderadores. Ya no se puede editar ni borrar. El resumen de la ficha solo cuenta los visibles.
- **Banear** oculta de una vez todos los comentarios visibles de la cuenta (una línea de bitácora por cada uno). **Desbanear no los vuelve a mostrar**: se revisan uno por uno.
- Suspensión de **1, 7 o 30 días**. Toda acción lleva **motivo**, salvo descartar reportes.
- Jerarquía: nadie se modera a sí mismo; a un admin no se le modera; a un moderador solo lo modera un admin.
- Reportar: motivo de una lista (`MOTIVOS_REPORTE`) + detalle opcional; uno pendiente por persona y comentario; no se reporta lo propio.
- Los comentarios **se leen sin cuenta** y solo muestran el **alias**. El correo sigue solo en pgAdmin.
- **Admin y moderadores se nombran en pgAdmin** (`UPDATE usuario SET rol = …`). No hay pantalla para eso.
- **Alias y anónimos** (usuario, 2026-11-21, por un reporte de un compañero; migración `2026-11-21-alias-y-comentario-anonimo.sql`): ~~el alias se cambia máximo 2 veces en la vida de la cuenta~~ → **3 veces al año** (usuario, 2026-11-22; tabla `alias_cambio`, `aliasCambiosRestantes()`; `usuario.alias_cambios` ya no se usa). "Tu cuenta" dice cuántos quedan; los cambios que hace el admin no cuentan. Al publicar, la casilla **"Publicar como anónimo"** guarda en `comentario.anonimo` un nombre al azar de 10 caracteres (la columna acepta 6–15) que se muestra en vez del alias, marcado "anónimo"; al editar se conserva. Los moderadores ven también el alias real (`autor_real`). Sin verificación con Kárdex (basta el correo) y **sin importar el horario de SAES** por ahora (usuario, 2026-11-21).
- La ficha pide todo a `api/profesor.php?nombre=…` (por `profesor.nombre` exacto, que es el mismo que usa el front). El *service worker* no guarda en caché `api/profesor.php`, `api/comentarios/*` ni `api/moderacion/*`.
- El resumen de comentarios propios va **en su propio bloque**, bajo el de MisProfesores, nunca promediado con él.

---

**Pestaña Admin y seguridad (usuario, 2026-11-22; 27 respuestas):**
- **Pestaña "🛡️ Admin"** (`admin.js`, `api/admin/*.php`, `lib/admin.php`): solo la ven moderadores y admin, y `admin.js` solo se descarga para ellos (`mostrarPestanaAdmin()` en `cuenta.js`). La seguridad es del servidor: cada endpoint revisa sesión, rol y carrera. Secciones: **Tablero** (números; al admin, además, estado del sistema: base, sitio público por `APP_URL`, correo, último respaldo; botones **probar correo** y **descargar respaldo**), **Reportes**, **Comentarios** (todos, con filtros), **Bitácora** y **Usuarios** (solo admin: correo, rol, carreras que modera, cambiar alias). `?admin=reportes` abre esa sección (lo trae el correo de reporte).
- **Moderadores por carrera** (tabla `moderador_carrera`, migración `2026-11-22-moderadores-por-carrera.sql`): `carrerasQueModera()` en `lib/sesion.php`. La carrera de un comentario es la de su materia. Se aplica en la ficha (`moderable` por comentario), `moderacion/accion.php`, `moderacion/reportes.php` y la bitácora. El admin modera todas. Los admins se siguen nombrando solo en pgAdmin.
- **Contraseña otra vez** para lo delicado (usuarios/correos, rol, alias ajeno, respaldo): `api/admin/confirmar.php` deja `confirmado_hasta` en la sesión por **10 min** (`exigirConfirmado()`); 5 intentos fallidos → 15 min. Ver la lista de usuarios anota `ver_correo` en la bitácora, una vez por confirmación.
- **Bitácora** acepta además `carreras_moderador`, `cambiar_alias`, `respaldo`, `probar_correo`.
- **Correo al llegar un reporte**: al admin y a los moderadores de esa carrera, solo con el **primer** reporte pendiente del comentario; máximo 10 reportes por hora por cuenta.
- **Groserías** (`lib/groserias.php`): bloquea texto, rúbrica y alias en el servidor; deshace acentos, leetspeak, letras repetidas y separadas. "vergüenza", "computadora" y "disputa" pasan. Para agregar una palabra: lista `GROSERIAS`.
- **Respaldo desde la app** (`api/admin/respaldo.php`): solo datos, con `COPY` en orden de llaves foráneas (el `pg_dump` del contenedor es 15 y la base 17). Probado restaurándolo en un Postgres 17 vacío. Ver `docs/respaldo.md`.
- **Después de la expo** (pedidos, no hechos): subir el HTML de SAES desde la app, botón de periodo nuevo y editar profes/ofertas desde la app. Por ahora todo eso sigue en el importador y pgAdmin.
- Sin reenviar activación, sin vista de logs del servidor; la demo de borrar cuentas, en pgAdmin.

## 7. Agenda

- Recordatorios personales sobre el calendario: **fecha, hora, título** y materia opcional ("12 nov, 10:00, Examen de Bases de Datos").
- Solo los ve su dueño.
- **Solo se muestran en el calendario.** No mandan avisos por correo ni notificaciones.

**Decisiones al construirla (Fase 5, 2026-11-20):**
- **Solo con cuenta** (tabla `recordatorio`, `api/agenda.php`). Sin cuenta, el calendario invita a entrar. Un suspendido sí usa su agenda.
- **Se agregan tocando un día** del calendario (ventana con los del día y un formulario). Arriba del calendario, **"Tus próximos recordatorios"** (los 8 siguientes) y "+ Nuevo". Los días con recordatorio llevan un puntito.
- **La hora es opcional**: sin hora = "todo el día". Por eso el esquema cambió `fecha_hora` por `fecha DATE` + `hora TIME NULL`.
- **Los pasados se quedan**, en gris (puntito y lista del día); no salen en "Próximos". Se borran a mano.
- Materia opcional, solo de tu carrera. Título hasta 100 caracteres, nota hasta 500, máximo 1,000 recordatorios por cuenta.
- El *service worker* no guarda en caché `api/agenda.php`. Al borrar la cuenta se van con ella (`CASCADE`).

---

## 8. Esquema

**Escrito en `sql/00-tablas.sql` el 2026-11-08** y probado en un Postgres 17 desechable (carga sin
errores; los CHECK rechazan dificultad 64, una 3.ª vez cursada, alias repetido con otras mayúsculas,
grupo mal escrito y dos ofertas "sin profesor" iguales). Ese archivo manda; esto es el resumen.

**Decisiones del usuario al cerrarlo (2026-11-08):**
- Optativas de IA/LCD: se guardan **las dos claves** (6.º y 7.º); la que no marca el PDF lleva `se_ofrece = false`.
- **Cupo: se guarda tal cual viene de SAES.** El sobrecupo (+4 de 2.º en adelante) lo suma la app. Desde el 2026-11-08 va en su **propia tabla `cupo`** (periodo, grupo, materia), no en `oferta`.
- Comentario propio: **recomienda sí/no** (la ficha muestra el % de "sí"); **calidad y dificultad, enteros 0–10**.
- ~~Al borrar una cuenta, sus comentarios se quedan como "usuario eliminado"~~ → **se borran con la cuenta** (usuario, 2026-11-21; ver §5).

```
carrera          codigo PK (ISC/IA/LCD) · letra · nombre · plan · carga_min_ua · carga_media_ua · carga_max_ua
materia          clave PK · carrera · nombre · nombre_saes · nombre_en · tipo · semestre · creditos · ua · horas_t
                 · horas_p · orden · se_ofrece · descripcion · pdf       UNIQUE (carrera, semestre, nombre_saes)
seriacion        materia · requisito · oficial                       PK (materia, requisito)
ruta_optativa    id · carrera · nombre · icono
ruta_materia     ruta · materia
periodo          codigo PK (27/1) · inicio · fin
evento_calendario id · periodo (NULL = fuera de periodo) · inicio · fin (NULL = un día) · tipo
profesor         id · nombre · nombre_norm UNIQUE · mp_link · mp_calidad
                 · mp_recomiendan · mp_dificultad (0–10)
cedula           profesor · numero · nivel (licenciatura/ingenieria/especialidad/maestria/doctorado)   PK (profesor, numero)
oferta           id · periodo · grupo · materia · profesor (NULL) · turno (calculado del grupo) · edificio
                 · salon                             UNIQUE NULLS NOT DISTINCT (periodo, grupo, materia, profesor)
bloque           numero PK (1–9) · inicio · fin      (sembrado en el mismo archivo)
sesion           oferta · dia (1–6) · bloque         PK (oferta, dia, bloque)
cupo             periodo · grupo · materia · cupo · inscritos   PK (periodo, grupo, materia); se cruza con oferta
usuario          id · correo UNIQUE (minúsculas) · hash · verificado · alias (único sin importar
                 mayúsculas) · rol · carrera · creado · suspendido_hasta · baneado
token            hash PK (sha256) · usuario · tipo · expira          (se borra al usarlo)
avance           usuario · materia · veces · calif · calif_ets       PK (usuario, materia)
horario          usuario · oferta
recordatorio     id · usuario · fecha_hora · titulo · materia · nota
comentario       id · usuario (NULL = eliminado) · profesor · materia · calidad · recomienda (sí/no)
                 · dificultad · texto VARCHAR(500) · creado · editado · estado
rubrica          comentario · concepto · porcentaje
reporte          id · comentario · reportante · motivo · creado · estado · resuelto_por
bitacora         id · actor · accion · objetivo_usuario · objetivo_comentario · motivo · cuando
vista avance_status   status (pendiente / en recurse / aprobada / reprobada / solo por ETS /
                      aprobada por ETS) y calif_final, derivados de veces + calif + calif_ets
```

**Cambios contra la propuesta anterior:**

| Qué | Por qué |
|---|---|
| Fuera `avance.acreditada_por` | Se deduce de `veces` y `calif_ets`; ahora sale de la vista `avance_status` |
| Fuera `avance.ruta_optativa` | Cada optativa pertenece a una sola ruta (revisado en `optativas.js`): se deduce de `ruta_materia` |
| Fuera `ruta_materia.semestre` | Ya está en `materia.semestre` |
| Fuera `evento_calendario.nombre` y `prioridad` | El CSV no los trae; la prioridad es por tipo y vive en `calendario-ui.js` |
| `oferta.turno` calculado | Es la 3.ª letra del grupo; así no puede contradecirlo |
| Nueva tabla `bloque` | Las horas de los 9 bloques quedan en la base, no como número mágico |
| Nuevo `materia.se_ofrece` | Marca la clave de IA/LCD que no corresponde al semestre del PDF |
| `nombre_saes` guarda el texto completo de SAES | En ISC las optativas vienen como `MINERIA DE DATOS\|DATA MINING`; así cruzan tal cual |
| `bitacora.objetivo` → `objetivo_usuario` + `objetivo_comentario` | Dos llaves foráneas reales en vez de un texto |
| Sin tabla de sesiones de login | Se usa la sesión normal de PHP |
| Rol de mínimo privilegio | Va en la Fase 1, con un `.sh` de initdb que lee la contraseña del `.env` |
| `oferta.cupo` e `inscritos` → tabla `cupo` (2026-11-08) | El cupo de SAES es de grupo + materia: en TT lo comparten varios asesores y los grupos X tienen cupo sin oferta |
| `oferta.grupo` acepta 2 dígitos (2026-11-08) | En 26/2 existió `1CM10` |
| Nuevos `materia.nombre_en` y `ruta_optativa.icono` (2026-11-08) | El front de optativas de ISC los muestra; SAES escribe mal el inglés ("COMPUTTING") y no trae íconos. Salen de `optativas.js` |
| Nuevo `sql/09-cupos-26-2.sql` (2026-11-08) | La ficha del maestro muestra los inscritos de 26/2 |

---

## 9. Lecciones del prototipo (Fase 1 en Node, 2026-11-08)

En una sesión en la nube se armó un prototipo funcionando (Postgres 16 + API Node + datos reales, probado con `docker compose`). Está en el zip `gestor-escom-fase1.zip` del usuario y **no se sube** a Gestorix. Lo que importa son sus lecciones, porque aplican a cualquier esquema:

1. La **clave oficial** (`C101`, `B640`) es el identificador de la materia.
2. En IA y LCD el **nombre se repite** entre claves de 6.º y 7.º: no puede ser único.
3. **Un código de grupo no es una oferta:** 134 códigos dan 665 ofertas (grupo + materia + profesor).
4. **TT** repite grupo + materia con varios asesores.
5. El **cupo** solo existía para ISC desde 2.º semestre (350 filas).
6. Los profesores se identifican por **nombre normalizado**.
7. `edificio`/`salón` traen `X` y `POR DEFINIR` como relleno: se guardan vacíos.
8. Las **restricciones CHECK detectaron errores reales**: OLALDE 83 y LEVARIO 6.4 eran errores; JURADO 6.4 y JUÁREZ LEÓN 6.1 resultaron reales, y lo que estaba mal era la escala supuesta.
9. Una carga con `ON CONFLICT DO NOTHING` y claves naturales es **repetible**.
10. Cifras: 3 carreras, 209 claves de materia, 44 prerrequisitos, 275 profesores, 665 ofertas y 2,024 sesiones.

> ⚠️ Los archivos de Prácticas 4–5 generados antes en la sesión (`practica4-*.md`,
> `practica5-*.md`, `001-dominios.sql`, `poblar.sh`) **inventaron columnas**. No usarlos.

---

## 10. Cómo empezar una sesión

1. Leer `CLAUDE.md` (este archivo) y `ROADMAP.md` completos.
2. Ver en `ROADMAP.md` en qué fase vamos y qué falta de la Fase 0.
3. `git status` y `git pull` antes de tocar nada.
4. Al cerrar cada fase: commit con lo hecho, actualizar `ROADMAP.md` (marcar lo terminado) y anotar aquí las decisiones nuevas.

## 11. Cómo trabajar con el usuario

- **Español informal**, conciso y directo.
- **Explicar lo necesario sin dar nada por sabido**: está aprendiendo. Preferir siempre la solución más simple.
- Correcciones de datos: **reportar en tabla y esperar confirmación** antes de aplicar.
- Ante ambigüedad, **preguntar punto por punto**.
- **No borrar nada.** No subir nada a un repositorio sin que lo pida. No agregar features no pedidas.
