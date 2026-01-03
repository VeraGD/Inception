#!/bin/bash

# Iniciar mariab en segundo plano para poder configurarlo
service mariadb start

# esperar a que el servicio ste listo
sleep 5

# Vemos si la base de datos existe. Si no, es proque es la primera vez que arrancamos y hay que creerla.
if [ ! -d "var/lib/mysql/$SQL_DATABASE" ]; then

	echo "Setting DataBase"
	
	# crear base de datos con variable del .env
	mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

	# crear usuario para Wordpress
	mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

	# dar permisos totales sobre la base de datos al usuario
	mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

	# cambiar contraseña del usuario root y refrescar permisos
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
	mysql -e "FLUSH PRIVILEGES;"

	# apagar el servicio temporal para reiniciarlo en modo seguro
	mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown
else
	echo "Database already exists. Skiping settings"

	# si ya existe tambien tenemos que parar el servicio que ejecutamos arriba
	mysqladmin -u root -p$SQL_PASS_PASSWORD shutown
fi

# Lanzar mariadb en primer plano.
exec mysql_safe
