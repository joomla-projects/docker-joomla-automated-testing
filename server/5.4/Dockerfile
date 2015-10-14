FROM php:5.4-apache
MAINTAINER Tito Alvarez <augustoalvarez@gmail.com> (@jaTITOam)

# Enable Apache Rewrite Module
RUN a2enmod rewrite

# Install PHP extensions
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev zip unzip && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd
RUN docker-php-ext-install mysqli

# Test directories
RUN	mkdir /usr/src/test
RUN	mkdir /usr/src/app
RUN	mkdir /usr/src/scripts

# Copy scripts
COPY docker-entrypoint.sh /usr/src/scripts/entrypoint.sh
COPY makedb.php /usr/src/scripts/makedb.php

RUN rm -rf /var/www/html \
	&& ln -s /usr/src/test /var/www/html \
	&& chown -R www-data:www-data /usr/src/test

ENTRYPOINT ["/usr/src/scripts/entrypoint.sh"]
CMD ["apache2-foreground"]
