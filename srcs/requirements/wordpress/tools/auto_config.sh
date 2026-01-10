#!/bin/bash

SQL_PASSWORD=$(cat /run/secrets/db_password)
ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
USER1_PASS=$(cat /run/secrets/wp_user_password)

cd /var/www/html

echo "Waiting MariaDB..."
while ! mariadb -h mariadb -u$SQL_USER -p$SQL_PASSWORD $SQL_DATABASE &>/dev/null; do
	sleep 3
done
echo "MariaDB connected and ready."

if [ ! -f ./wp-config.php ]; then
	echo "Instaling WordPress..."

	wp core download --allow-root

	wp config create \
		--dbname=$SQL_DATABASE \
		--dbuser=$SQL_USER \
		--dbpass=$SQL_PASSWORD \
		--dbhost=mariadb:3306 \
		--allow-root

	wp core install \
		--url=$DOMAIN_NAME \
		--title=$SITE_TITLE \
		--admin_user=$ADMIN_USER \
		--admin_password=$ADMIN_PASSWORD \
		--admin_email=$ADMIN_EMAIL \
		--allow-root

	wp user create \
		$USER1_LOGIN \
		$USER1_EMAIL \
		--user_pass=$USER1_PASS \
		--role=author \
		--allow-root

	echo "WordPress instaled correctly"
else
	echo "WordPress already instaled. Skiping configuration"
fi

chown -R www-data:www-data /var/www/html

chmod -R 755 /var/www/html

echo "Initiating PHP-FP..."
exec /usr/sbin/php-fpm8.2 -F
