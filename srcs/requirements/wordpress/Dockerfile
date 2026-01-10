FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	wget \
	php8.2 \
	php8.2-fpm \
	php8.2-mysql \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN mkdir -p /run/php && chown www-data:www-data /run/php

WORKDIR /var/www/html

COPY tools/auto_config.sh /usr/local/bin/auto_config.sh
RUN chmod +x /usr/local/bin/auto_config.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/auto_config.sh"]
