FROM debian:bookworm

# Inatalar PHP-FPM, el conector de MySQL y herramientas de descarga
# Usamos php8.2 versión por defecto en Debian 12
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	wget \
	php8.2 \
	ph8.2-fpm \
	php8.2-mysql \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

# instalar WP-CLI (herramienta de comandos de WordPress). DEscargar, dar permisos y mover al PATH.
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

# Copiar nuestro archivo de configuracion
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Crear directorio pra que PHP-FPM gurade el archivo .pid y damos permisos a www-data
RUN mkdir -p /run/php && chown www-data:www-data /run/php

# Definir directoriode tranajo donde estara WordPress
WORKDIR /var/www/html

# Copiar el arhivo que configurara al arancar
COPY tools/auto-config.sh /usr/local/bin/auto_config.sh
RUN chmod +x /usr/local/bin/auto_config.sh

# Puerto para hablar con Nginx
EXPOSE 9000

# Ejecutar el scipt de configuracion
ENTRYPOINT ["/usr/local/bin/auto_config.sh"]
