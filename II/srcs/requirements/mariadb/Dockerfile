# Imagen base del contenedor, Debian 12 -> Bookworm
FROM debian:bookworm

# Instalar servidor de base de datos con la opcion de yes, y borrar paquetes que no hacen falta
RUN apt-get update && apt-get install -y mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

# la comfiguración de mariadb pasara a ser la mia de la carpeta conf
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# socket mariadb, root no lo puede ejecutar, sino el usuario mysql
RUN mkdir -p /var/run/mysqld \
	&& chown -R mysql:mysql /var/run/mysqld \
	&& chmod 777 /var/run/mysqld

# Script que lee las variables de entorno y demás se ejecuta cuando ya esta levantado
COPY tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

# Puerto con el se comunica con Wordpress
EXPOSE 3306

# Comandos para el arranque del contenedor
ENTRYPOINT ["/usr/local/bin/script.sh"]
