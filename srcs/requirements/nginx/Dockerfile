FROM debian:bookworm

# Instalar ngnix y openssl -> obligtorio certficado TLS/SSL
RUN apt-get update && apt-get install -y \
	nginx \
	openssl \
	&& rm -rf /var/lib/apt/lists/*

# Crear arpet para guardar el certifiado y la clave
RUN mkdir -p /etc/nginx/ssl

# generar certificado SSL auto-firmado. -x509 certificado standard, -nodes no pedir contraseña
# -out y -keyout donde guardar certificado y llave, -subj rellena datos automaticamente
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=ES/ST=Vizcaya/L=Urduliz/O=42/OU=42/CN=veragarc.42.fr/UID=veragarc"

# copiar nuestra configuracion
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Crear carpeta de archivos temporales y dar permisos
RUN mkdir -p /var/run/nginx

#Asignar permisos al usuario www-data
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

EXPOSE 443

# Arrancar en primer plano, daemon off -> evita que se vata al fondo y Docker piense que se ha cerrado
CMD ["nginx", "-g", "daemon off;"]
