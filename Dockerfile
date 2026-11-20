# Imagen de la app: Apache + PHP 8.2 con los drivers de Postgres.
# Igual que en Seismic, con dos cambios: php.ini de producción
# (display_errors apagado) y la zona horaria de la Ciudad de México.
FROM php:8.2-apache

RUN apt-get update \
 && apt-get install -y --no-install-recommends libpq-dev \
 && docker-php-ext-install pdo pdo_pgsql pgsql \
 && rm -rf /var/lib/apt/lists/*

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
 && echo "date.timezone = America/Mexico_City" > "$PHP_INI_DIR/conf.d/zona-horaria.ini"

RUN a2enmod rewrite headers

# Que el navegador pregunte siempre si un archivo cambió antes de usar su
# copia guardada (si no cambió, Apache contesta 304 sin mandarlo). Sin esto,
# después de actualizar la app alguien podía quedar con JS nuevo y CSS viejo.
RUN printf '<Directory /var/www/html>\n    Header set Cache-Control "no-cache"\n</Directory>\n' \
      > /etc/apache2/conf-available/gestorix-cache.conf \
 && a2enconf gestorix-cache
