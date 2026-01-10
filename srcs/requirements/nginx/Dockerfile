FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	nginx \
	openssl \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=ES/ST=Vizcaya/L=Urduliz/O=42/OU=42/CN=veragarc.42.fr/UID=veragarc"

COPY conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/run/nginx

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["/bin/bash", "-c", "sleep 10; nginx -g 'daemon off;'"]
