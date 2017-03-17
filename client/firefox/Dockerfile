FROM selenium/standalone-firefox-debug:2.53.1
MAINTAINER Tito Alvarez <tito@community.joomla.org> (@jaTITOam)

# Install PHP
RUN apt-get update && apt-get install -y php curl php-curl php-dom php-mbstring php-zip git

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Test directories
RUN	mkdir /usr/src/scripts

# User-mounted test directory
VOLUME /usr/src/tests

# Copy scripts
COPY entry_point.sh /opt/bin/entry_point.sh
RUN chmod +x /opt/bin/entry_point.sh
COPY startup.sh /usr/src/scripts/startup.sh
RUN chmod +x /usr/src/scripts/startup.sh

CMD ["/usr/src/scripts/startup.sh"]
