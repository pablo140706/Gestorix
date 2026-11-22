# Respaldar y restaurar la base

El respaldo trae **todo**: cuentas (con correos), avance, horarios, comentarios y los datos de
ESCOM. Por eso **nunca va al repo** (es público): guárdalo fuera, por ejemplo en `Documentos`.

## Sacar un respaldo (PowerShell, en la carpeta del proyecto)

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
