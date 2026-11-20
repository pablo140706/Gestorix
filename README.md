# Gestorix

Gestor académico para alumnos de ESCOM (ISC, IA y LCD): avance, horario, profesores, comentarios y agenda.
Proyecto escolar: PHP + PostgreSQL + JavaScript, en contenedores de Docker.

Autor: Mora Acosta Pablo ([`pablo140706`](https://github.com/pablo140706)) · Bases de Datos · ESCOM-IPN · ISC 2020

## Proyecto del segundo parcial de Bases de Datos

| Entregable | Dónde |
|---|---|
| Aplicación web | Se ejecuta localmente: ver [Cómo levantarlo](#cómo-levantarlo). App en `http://localhost:8080` |
| Esquema (creación) | [`sql/00-tablas.sql`](sql/00-tablas.sql) |
| Modelo relacional, acciones referenciales y restricciones | [`docs/diagrama-er.md`](docs/diagrama-er.md) |
| Scripts de carga | [`sql/01`–`09`](sql/) (carga inicial), [`sql/99-rol-app.sh`](sql/99-rol-app.sh) (usuario de mínimo privilegio) e [`importador/`](importador/) (HTML de SAES → base) |
| Migraciones | [`migraciones/`](migraciones/README.md) (qué va ahí y por qué todavía está vacía) |
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

- App: <http://localhost:8080> (se usa sin cuenta; con cuenta, el avance y el horario se guardan en la base). Mientras no haya servicio de correo, el enlace para activar una cuenta sale en `docker compose logs web`.
- pgAdmin: <http://localhost:5051> (correo y contraseña de `PGADMIN_*` en `.env`; el servidor "Gestorix" ya viene registrado y pide la contraseña de `POSTGRES_PASSWORD`).

## Estructura

| Carpeta | Qué hay |
|---|---|
| `sql/` | Esquema (`00-tablas.sql`) y carga inicial, en orden |
| `importador/` | Scripts de PHP que pasan el HTML de SAES a la base |
| `data/` | HTML de SAES por carrera |
| `migraciones/` | Cambios de esquema cuando la base publicada ya tenga datos |
| `src/` | Lo que sirve Apache: el front (JavaScript sin frameworks) y la API (`src/api/*.php`, regresa JSON) |
| `docs/` | Aviso de privacidad, modelo relacional, normalización, álgebra relacional y evidencias |

El avance por fases está en [`ROADMAP.md`](ROADMAP.md).
