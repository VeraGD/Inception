#!/bin/bash

SQL_PASSWORD=$(cat /run/secrets/db_password)
SQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

service mariadb start

sleep 5

if [ -d "/var/lib/mysql/$SQL_DATABASE" ]; then
    echo "✅ La base de datos ya existe. Arrancando sin reconfigurar..."
else
    echo "⚙️ Configurando MariaDB por primera vez..."

    sleep 2

    mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
    mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

    mysql -e "FLUSH PRIVILEGES;"
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
    
    echo "✅ Configuración terminada. Reiniciando en modo seguro..."
fi

mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

exec mysqld_safe
