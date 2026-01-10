#!/bin/bash

# Iniciamos el servicio sin configurar nada aún
service mariadb start

# Esperamos a que el PID esté activo
sleep 5

# COMPROBACIÓN: ¿Ya existe la base de datos?
if [ -d "/var/lib/mysql/$SQL_DATABASE" ]; then
    echo "✅ La base de datos ya existe. Arrancando sin reconfigurar..."
else
    # Si no existe, entramos aquí (SOLO LA PRIMERA VEZ)
    echo "⚙️ Configurando MariaDB por primera vez..."

    # 1. Aseguramos que root no tenga pass inicialmente para poder entrar
    # (Esto evita el error Access Denied durante la configuración)
    sleep 2

    # 2. Creamos la base de datos y el usuario
    mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
    mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
    
    # 3. Cerramos la puerta: Ponemos contraseña a root
    mysql -e "FLUSH PRIVILEGES;"
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
    
    echo "✅ Configuración terminada. Reiniciando en modo seguro..."
fi

# Apagamos el servicio temporal que usamos para configurar
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

# Arrancamos el servicio final en primer plano
exec mysqld_safe
