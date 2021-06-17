FROM ubuntu:focal

LABEL maintainer="ppuppim@gmail.com"
LABEL description="Apache 2.4 / PHP 7.4"

# Set working directory
WORKDIR /var/www/html

RUN apt-get update 

RUN export DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install certbot python3-certbot-apache -y

RUN apt-get install -y \
apache2 \
curl \
vim \
php7.4 \
libapache2-mod-php7.4 \
php7.4-bcmath \
php7.4-gd \
php7.4-json \
php7.4-sqlite \
php7.4-mysql \
php7.4-curl \
php7.4-xml \
php7.4-mbstring \
php7.4-zip \
mcrypt \
php7.4-interbase \
php7.4-soap \
php7.4-memcache \
php7.4-intl \
php7.4-redis

RUN curl -sS https://getcomposer.org/installer | php -- --version=2.0.11 --install-dir=/usr/local/bin --filename=composer

RUN sed -i -e 's/^error_reporting\s*=.*/error_reporting = E_ALL/' /etc/php/7.4/apache2/php.ini
RUN sed -i -e 's/^display_errors\s*=.*/display_errors = On/' /etc/php/7.4/apache2/php.ini
RUN sed -i -e 's/^zlib.output_compression\s*=.*/zlib.output_compression = Off/' /etc/php/7.4/apache2/php.ini
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

RUN a2enmod rewrite
RUN a2enmod ssl

EXPOSE 80
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
