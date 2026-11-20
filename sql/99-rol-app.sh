#!/bin/sh
# =====================================================================
#  Gestorix · 99-rol-app.sh · usuario de la app con mínimo privilegio
# =====================================================================
#  Corre al final de la carga inicial (initdb), cuando ya existen todas
#  las tablas. Es .sh y no .sql porque necesita leer la contraseña del
#  .env (variables APP_DB_USER y APP_DB_PASSWORD del servicio db).
#
#  La app puede leer y escribir datos (SELECT, INSERT, UPDATE, DELETE),
#  pero no puede crear, cambiar ni borrar tablas. Eso solo lo hace el
#  administrador (POSTGRES_USER), que es el que usas en pgAdmin.
# =====================================================================
set -e

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
     -v app_user="$APP_DB_USER" -v app_pass="$APP_DB_PASSWORD" -v db="$POSTGRES_DB" <<'EOSQL'
CREATE ROLE :"app_user" LOGIN PASSWORD :'app_pass';

GRANT CONNECT ON DATABASE :"db" TO :"app_user";
GRANT USAGE ON SCHEMA public TO :"app_user";
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO :"app_user";
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO :"app_user";

-- Las tablas que se creen después (migraciones/) le dan los mismos permisos.
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO :"app_user";
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT USAGE, SELECT ON SEQUENCES TO :"app_user";
EOSQL
