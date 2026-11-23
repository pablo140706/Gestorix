# Respaldar y restaurar la base

El respaldo trae **todo**: cuentas (con correos), avance, horarios, comentarios y los datos de
ESCOM. Por eso **nunca va al repo** (es público): guárdalo fuera, por ejemplo en `Documentos`.

## Lo más fácil: desde la app (2026-11-22)

Pestaña **Admin → Tablero → 💾 Descargar respaldo de datos** (solo el admin; pide tu contraseña otra
vez). Baja `gestorix-datos-AAAA-MM-DD-HHMM.sql` con los **datos** de todas las tablas. El esquema no
viene: ya está en `sql/00-tablas.sql` y `migraciones/`. Queda anotado en la bitácora y el tablero dice
cuándo fue el último.

Para restaurarlo (**borra lo que haya en esas tablas** y pone lo del archivo):

```powershell
Get-Content -Raw "RUTA\gestorix-datos-AAAA-MM-DD-HHMM.sql" | docker compose exec -T db sh -c 'psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"'
```

No usa `pg_dump` porque el del contenedor web es el 15 y la base es Postgres 17: lo arma PHP con
`COPY`, tabla por tabla en el orden de las llaves foráneas. Se probó restaurándolo en un Postgres 17
vacío con `sql/00-tablas.sql`: quedan las mismas filas.

## Con pg_dump (PowerShell, en la carpeta del proyecto)

```powershell
docker compose exec db sh -c 'pg_dump -U "$POSTGRES_USER" -d "$POSTGRES_DB" --clean --if-exists -f /tmp/gestorix.sql'
```
```powershell
docker compose cp db:/tmp/gestorix.sql "$HOME\Documents\gestorix-$(Get-Date -Format yyyy-MM-dd-HHmm).sql"
```

Queda en Documentos con la fecha y hora en el nombre. Sácalo antes de la expo, antes de cargar un
periodo nuevo y antes de cambiar el esquema.

## Restaurarlo (aquí o en la laptop)

**Reemplaza la base completa** por la del respaldo: lo que se haya registrado después se pierde.

```powershell
docker compose cp "RUTA\gestorix-AAAA-MM-DD-HHMM.sql" db:/tmp/gestorix.sql
```
```powershell
docker compose exec db sh -c 'psql -q -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /tmp/gestorix.sql'
```

Pueden salir avisos `NOTICE`; eso está bien. Para comprobar, en pgAdmin:
`SELECT id, alias, rol FROM usuario;`
