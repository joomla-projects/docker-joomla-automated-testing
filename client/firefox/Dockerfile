FROM selenium/standalone-firefox-debug
MAINTAINER Tito Alvarez <augustoalvarez@gmail.com> (@jaTITOam)

# Install PHP
RUN apt-get update && apt-get install -y php curl php-curl php-dom php-mbstring git php-gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Test directories
RUN	mkdir /usr/src/scripts
RUN	mkdir /usr/src/app

# Copy scripts
COPY docker-startup.sh /usr/src/scripts/startup.sh

CMD ["/usr/src/scripts/startup.sh"]
