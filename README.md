# Gestorix

Gestor académico para alumnos de ESCOM (ISC, IA y LCD): avance, horario, profesores, comentarios y agenda.
Proyecto escolar: PHP + PostgreSQL + JavaScript, en contenedores de Docker.

Autor: Mora Acosta Pablo ([`pablo140706`](https://github.com/pablo140706)) · Bases de Datos · ESCOM-IPN · ISC 2020

## Proyecto del segundo parcial de Bases de Datos

| Entregable | Dónde |
|---|---|
| Aplicación web | **<https://thwarting-earthling-evasive.ngrok-free.dev>**. La PC del autor es el servidor: la base vive en su Docker y ngrok la saca a internet (ver [Publicación](#publicación-la-pc-como-servidor)). Funciona mientras esa PC esté prendida; si no responde, se levanta local con [Cómo levantarlo](#cómo-levantarlo) |
| Esquema (creación) | [`sql/00-tablas.sql`](sql/00-tablas.sql) |
| Modelo relacional, acciones referenciales y restricciones | [`docs/diagrama-er.md`](docs/diagrama-er.md) |
| Scripts de carga | [`sql/01`–`09`](sql/) (carga inicial), [`sql/99-rol-app.sh`](sql/99-rol-app.sh) (usuario de mínimo privilegio) e [`importador/`](importador/) (HTML de SAES → base) |
| Migraciones | [`migraciones/`](migraciones/README.md): cambios de esquema con la base ya en uso (7 al 2026-11-22) |
| Evidencia del registro | [`docs/evidencia-registro.md`](docs/evidencia-registro.md): formulario → `SELECT` en pgAdmin, y cómo viajan los datos a la base |
| Normalización (práctica 6–8) | [`docs/normalizacion.md`](docs/normalizacion.md) |
| Álgebra relacional y SQL (práctica 6–8) | [`docs/algebra.md`](docs/algebra.md): 13 ejercicios con su SQL, comparados en RelaX |
| Grupo de RelaX | [`docs/relax/gestorix.txt`](docs/relax/gestorix.txt) (se pega en el *Editor de Grupo* de [RelaX](https://dbis-uibk.github.io/relax/calc/local/uibk/local/0)) y los scripts que lo generan |
| Proyecto asignado (Sismos) y artículo | En el repositorio del equipo: [`pablo140706/Catscoms`](https://github.com/pablo140706/Catscoms) |

## Cómo levantarlo

Necesitas Docker Desktop.

1. Copia `.env.example` como `.env` y cambia las contraseñas.
2. Levanta todo. La primera vez crea la base y la llena con `sql/`:
   ```bash
   docker compose up -d
   ```
3. Carga los horarios y los cupos de SAES (`data/`) del periodo, y corrige los salones con el PDF oficial de ESCOM:
   ```bash
   docker compose run --rm web php importador/horarios.php 27/1
   docker compose run --rm web php importador/cupos.php 27/1
   docker compose run --rm web php importador/salones.php 27/1
   ```
   `salones.php` lee `data/salones/27-1.txt`, que se saca del PDF con `pdftotext -table -enc UTF-8` (viene con MSYS2).
4. Carga el propósito, los temas y el PDF de cada materia (los PDFs ya vienen en `src/materias/` y su texto en `data/programas/`):
   ```bash
   docker compose run --rm web php importador/materias.php
   ```
   Si llegan PDFs nuevos de programas: agrégalos a `data/programas/mapa.csv` y corre antes, en Git Bash, `sh importador/programas/copiar.sh "/ruta/a/Planes de estudio"`.
5. Carga los links de MisProfesores y las cédulas que capturas en `data/profesores/links-cedulas.csv` (con `--prueba` solo te dice qué cambiaría):
   ```bash
   docker compose run --rm web php importador/profesores.php
   ```

- App: <http://localhost:8080> (se usa sin cuenta; con cuenta, el avance y el horario se guardan en la base). Los correos de activación y de "olvidé mi contraseña" salen por Gmail si llenas `SMTP_USER` y `SMTP_PASSWORD` (una contraseña de aplicación de Google) en `.env`; si no, el enlace sale en `docker compose logs web`.
- pgAdmin: <http://localhost:5051> (correo y contraseña de `PGADMIN_*` en `.env`; el servidor "Gestorix" ya viene registrado y pide la contraseña de `POSTGRES_PASSWORD`).

## Publicación: la PC como servidor

El profesor pidió que la base viva en nuestra computadora y que, a la vez, el sitio esté en línea.
Por eso no se usa un hosting en la nube: Docker corre en la PC y [ngrok](https://ngrok.com) abre un
túnel HTTPS desde internet hasta `localhost:8080`.

```
navegador ──HTTPS──▶ ngrok (nube) ──túnel──▶ ngrok en la PC ──▶ localhost:8080 (web) ──▶ db (Postgres)
```

1. `docker compose up -d`
2. En `.env`, `APP_URL` con la dirección pública (los enlaces de los correos la usan).
3. `ngrok http --url=thwarting-earthling-evasive.ngrok-free.dev 8080` (necesita `ngrok config add-authtoken …` una vez).

Solo sale la web: Postgres no publica ningún puerto, pgAdmin escucha solo en `127.0.0.1` y la web
también (`127.0.0.1:8080`), así que de fuera solo se llega por el túnel.

**Seguridad del registro:**

| Riesgo | Cómo se cubre |
|---|---|
| Inyección SQL | Consultas preparadas (`prepare` + `execute`) en toda la API |
| HTML o JavaScript inyectado (XSS) | El front escapa todo lo que escribe el usuario (`esc()`), y además la política CSP de Apache ([`apache/seguridad.conf`](apache/seguridad.conf)) no deja correr JavaScript que no venga de un archivo del propio sitio |
| Datos inválidos | Validación en PHP (correo, contraseña de 8–72, carrera existente) y `CHECK` / llaves foráneas en la base |
| Probar contraseñas o mandar registros en masa | Límite de intentos por IP y por correo ([`src/lib/limite.php`](src/lib/limite.php)): responde 429 |
| Contraseñas robadas de la base | Solo se guarda el hash bcrypt (`password_hash`) |
| Peticiones desde otro sitio (CSRF) | Solo POST con JSON y `Origin` del mismo sitio; cookie `HttpOnly`, `SameSite=Lax` y `Secure` en HTTPS |
| Mostrar detalles internos | `display_errors` y `expose_php` apagados, Apache sin versión, sin listado de carpetas y `lib/` cerrada |
| Saber quién tiene cuenta | Registro y "olvidé mi contraseña" contestan lo mismo exista o no el correo |
| Adivinar la contraseña de alguien | 5 intentos fallidos por correo (20 por IP) y hay que esperar 15 minutos |
| Peticiones falsas desde la consola del navegador | Cada endpoint revisa en el servidor la sesión, el rol y la carrera que modera; esconder un botón no es la seguridad. La pestaña Admin ni se descarga para un alumno |
| Ver los usuarios, sus correos o la bitácora | Solo el admin ve correos, y tiene que escribir otra vez su contraseña (vale 10 minutos); cada vez queda en la `bitacora`. Los moderadores solo ven lo de sus carreras (`moderador_carrera`) |
| Groserías e insultos | Filtro en el servidor para comentarios, rúbrica y alias ([`src/lib/groserias.php`](src/lib/groserias.php)); deshace trucos como `p3nd3jo` o `p.e.n.d.e.j.o` |

## Estructura

| Carpeta | Qué hay |
|---|---|
| `sql/` | Esquema (`00-tablas.sql`) y carga inicial, en orden |
| `importador/` | Scripts de PHP que pasan el HTML de SAES a la base |
| `data/` | HTML de SAES por carrera |
| `migraciones/` | Cambios de esquema cuando la base publicada ya tenga datos |
| `src/` | Lo que sirve Apache: el front (JavaScript sin frameworks) y la API (`src/api/*.php`, regresa JSON) |
| `apache/` | Encabezados de seguridad de Apache (CSP y demás), que copia el `Dockerfile` |
| `docs/` | Aviso de privacidad, modelo relacional, normalización, álgebra relacional, evidencias, reglas escolares, guion de la expo, respaldo y cómo cargar un periodo nuevo |
| `migraciones/` | Cambios de esquema con la base ya en uso (desde el 2026-11-21) |
| `pruebas/` | Pruebas de las reglas de negocio: `docker run --rm -v "${PWD}:/app" -w /app node:22-alpine node pruebas/reglas.test.js` |

El avance por fases está en [`ROADMAP.md`](ROADMAP.md).
