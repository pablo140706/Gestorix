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
- **Puertos sugeridos:** la app en `localhost:8080` (en Windows el 80 suele estar ocupado) y pgAdmin en `localhost:5050`. El preview viejo de iscweb usaba `localhost:8123`.
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
│   ├── api/*.php                        endpoints que regresan JSON
│   ├── lib/db.php                       una sola conexión PDO, con getenv
│   └── materias/<clave>.pdf             planes sintéticos
├── docs/                    fases, decisiones, aviso de privacidad
├── screenshots/
└── README.md
```

- **PHP sin framework, sin Composer** salvo que el envío de correos lo exija. Front **vanilla JS**, sin bundler.
- **El importador corre dentro de Docker:** `docker compose run --rm web php importador/…`.
- **pgAdmin** es donde el usuario corrige los datos.
- El prototipo en Node de la Fase 1 queda en el zip del usuario como referencia (§9); no entra al repo.

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
| `historial.js` | Historial de 26/2 y 27/1 (solo ISC) |
| `planes.js` (seriación) | ISC: 21 pares oficiales. IA y LCD: 12 + 11 pares aprobados por el usuario |

5. Lo que no existe todavía se muestra **como faltante**, sin inventarlo: historial de IA y LCD, métricas de 73 profes, links de 65 y cédulas.

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
- **En la app:** hasta la media, sin aviso. Entre la media y 9, se permite con un aviso de que requiere trámite ante la Unidad Académica. Más de 9 no se permite.
- **No se modela la situación escolar** (adeudos, desfase, dictamen, baja temporal): solo la carga media.
- **TT I y TT II valen 2 UA cada una.** Las demás, 1.
- **Las UA adeudadas cuentan** en la carga.
- La app **avisa** (no bloquea) en dos casos: el Art. 98 (no cursar materias de más de 3 periodos consecutivos, ni adeudar de más de 2 periodos previos) y las bajas que no proceden (si recursas la materia, o si quedas bajo la mínima).
- Los créditos se muestran como dato informativo.

### 4.2 Cursos, recurse y ETS (igual en las tres carreras)

- Cada materia se cursa **como máximo 2 veces**: ordinario (`veces` = 1) y recurse (`veces` = 2).
- **El ETS no cuenta como curso.** Flujo:
  - Reprobaste el **ordinario** → puedes recursar **o** presentar ETS.
  - Reprobaste el **recurse** → el ETS es **obligatorio**: ya no se puede volver a cursar.
- **Aprobar por ETS cuenta como aprobada y entra al promedio.**
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
- **ISC:** se sigue la trayectoria de su rama (`mapaCurricularISC2020_optativas.pdf`): 14 ramas, cada una con una materia de 6.º y una de 7.º. El procedimiento da de baja las optativas inscritas fuera de la trayectoria.
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

- Código `[1-8][ABC][MVX][1-9]`. `C` = ISC, `B` = IA, `A` = LCD. Número ≥ 6 = recurse.
- **Trabajo Terminal** va en grupos `X`, sin horario fijo: ISC `7CX1` (TT I) y `8CX1` (TT II), IA `7BX1`/`8BX1`, LCD `7AX1`/`8AX1`. En TT, `grupo + materia` no es llave única (varios asesores).
- **Cupo: 40 de 2.º semestre en adelante** (36 regulares + 4 de sobrecupo); **36 en 1.er semestre**. El usuario mandará los cupos actualizados de las 3 carreras.
- **Profesor sin asignar:** se guarda **sin profesor** (`NULL`) y el usuario lo corrige a mano. Caso actual: `6CM5`.
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
- **Cédula:** la busca el usuario en el Registro Nacional de Profesionistas (SEP) y la captura en pgAdmin.
- Cifras confirmadas: **665 ofertas, 276 maestros.** El prototipo cargó 275; el que falta se revisa con la versión de la PC.
- **Correcciones de captura** que se aplican al cargar: BARRALES recomiendan 1.4 → 14; TELLEZ BARRERA rec/dif invertidos; LUNA BENOSO dificultad 44 → 4.4; MÁRQUEZ ARREGUÍN 33 → 3.3; OLALDE MOGOLLÁN calidad 83 → 8.3; **LEVARIO MEDINA dificultad 6.4 → 3.5** (confirmado en MisProfesores por el usuario).
- Los nombres se cruzan siempre normalizados (sin acentos) y se muestra el acentuado.

### 4.7 Materias

- **Un PDF de plan sintético por materia**: el usuario ya los tiene de las 3 carreras. Se sirven como archivos estáticos; la base solo guarda la ruta.
- **Descripción corta** por materia, que **genera Claude a partir del PDF** (propósito y temas). Se marca como resumen y el PDF queda como la referencia oficial.

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

---

## 7. Agenda

- Recordatorios personales sobre el calendario: **fecha, hora, título** y materia opcional ("12 nov, 10:00, Examen de Bases de Datos").
- Solo los ve su dueño.
- **Solo se muestran en el calendario.** No mandan avisos por correo ni notificaciones.

---

## 8. Esquema (propuesta para cerrar en la Fase 0)

```
carrera          codigo PK · letra · nombre · plan · carga_min_ua (4) · carga_media_ua (7/6)
                 · carga_max_ua (9)
materia          clave PK · carrera · nombre · nombre_saes · tipo (OBL/OPT) · semestre · creditos
                 · ua (1, o 2 en TT) · horas_t · horas_p · orden · descripcion · pdf
seriacion        materia · requisito · oficial (bool)
ruta_optativa    id · carrera · nombre               (14 ramas ISC + 7 parejas IA/LCD)
ruta_materia     ruta · materia · semestre
periodo          codigo PK (27/1) · inicio · fin
evento_calendario id · periodo · inicio · fin · tipo · nombre · prioridad
profesor         id · nombre · nombre_norm UNIQUE · cedula · titulo_profesional
                 · mp_link · mp_calidad · mp_recomiendan · mp_dificultad
oferta           id · periodo · grupo · materia · profesor (NULL = sin asignar) · turno (M/V/X)
                 · edificio · salon · cupo (40; 36 en 1.º) · inscritos
sesion           oferta · dia (1–6) · bloque (1–9)
usuario          id · correo UNIQUE · hash · verificado · alias UNIQUE · rol · carrera
                 · creado · suspendido_hasta · baneado
token            usuario · tipo (verificar/recuperar) · hash · expira
avance           usuario · materia · veces (1–2) · calif · acreditada_por (ordinario/recurse/ets)
                 · calif_ets · ruta_optativa
horario          usuario · oferta
recordatorio     id · usuario · fecha_hora · titulo · materia (opcional) · nota
comentario       id · usuario · profesor · materia (etiqueta, de las del profesor) · calidad
                 · recomienda · dificultad · texto VARCHAR(500) · creado · estado (visible/oculto)
                 (sin UNIQUE: un usuario puede comentar las veces que quiera)
rubrica          comentario · concepto · porcentaje
reporte          id · comentario · reportante · motivo · estado · resuelto_por
bitacora         id · actor · accion (ocultar/suspender/banear/…) · objetivo · motivo · cuando
```

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
