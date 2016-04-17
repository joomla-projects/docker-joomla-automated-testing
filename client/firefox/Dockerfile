FROM selenium/standalone-firefox-debug
MAINTAINER Tito Alvarez <augustoalvarez@gmail.com> (@jaTITOam)

# Install PHP
RUN apt-get update && apt-get install -y php curl php-curl php-dom php-mbstring git

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Test directories
RUN	mkdir /usr/src/scripts
RUN	mkdir /usr/src/app

# Copy scripts
COPY docker-entrypoint.sh /usr/src/scripts/entrypoint.sh

CMD ["/usr/src/scripts/entrypoint.sh"]
