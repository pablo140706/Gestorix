# Migraciones

Aquí van los cambios de esquema **una vez que la base publicada tenga datos de usuarios**. Hoy la
carpeta está vacía a propósito: todavía no hay base en producción (eso llega en la Fase 6).

## Los tres tipos de scripts del proyecto

| Tipo | Dónde | Cuándo corre |
|---|---|---|
| **Creación** | [`sql/00-tablas.sql`](../sql/00-tablas.sql) | Solo la primera vez, cuando el volumen de Postgres está vacío (`docker-entrypoint-initdb.d`) |
| **Carga inicial** | [`sql/01`–`09`](../sql/) y [`sql/99-rol-app.sh`](../sql/99-rol-app.sh) (el usuario de la app con mínimo privilegio) | Igual: solo al crear la base, en orden de número |
| **Carga repetible** | [`importador/`](../importador/): `horarios.php`, `cupos.php` y `salones.php` | Cada vez que hay HTML nuevo de SAES. Se pueden repetir sin duplicar (`ON CONFLICT`) y cada una corre en una transacción |
| **Migración** | `migraciones/` (aquí) | A mano, sobre una base que ya tiene datos que no se pueden perder |

## Por qué todavía no hay migraciones

Mientras la base solo existe en la PC de desarrollo, cambiar el esquema es barato: se corrige
`sql/00-tablas.sql` y se aplica el mismo cambio a la base local, o se vuelve a sembrar desde cero
(`docker compose down -v` y `up -d`). Así se hicieron, por ejemplo, la tabla `cupo` (antes el cupo
estaba en `oferta`) y el grupo de dos dígitos (`1CM10`).

Cuando la base publicada tenga cuentas, avance y comentarios, ya no se puede volver a sembrar:
`initdb` no vuelve a correr y borrar el volumen borraría a los usuarios. Desde ese momento cada
cambio de esquema es un archivo aquí.

## Cómo se escribe una migración

- Nombre: `AAAA-MM-DD-que-cambia.sql`, por ejemplo `2026-12-10-indice-oferta-profesor.sql`. El
  orden por nombre es el orden en que se aplican.
- Todo dentro de una transacción, para que un error no deje la base a medias:

  ```sql
  BEGIN;
  ALTER TABLE ...;
  -- si hace falta, mover datos con UPDATE / INSERT ... SELECT
  COMMIT;
  ```

- El mismo cambio se copia a `sql/00-tablas.sql`, para que una base nueva nazca igual que la que
  ya migró.
- Se corre con el administrador, porque la app no tiene permiso de cambiar tablas:

  ```bash
  docker compose exec -T db psql -v ON_ERROR_STOP=1 -U gestorix_admin -d gestorix < migraciones/2026-12-10-indice-oferta-profesor.sql
  ```

- Las tablas nuevas le dan permisos a la app solas, gracias al `ALTER DEFAULT PRIVILEGES` de
  `sql/99-rol-app.sh`.
