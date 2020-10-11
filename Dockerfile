FROM ubuntu:latest
MAINTAINER Pablo Nuñez <fixwah@gmail.com>

RUN apt-get update
RUN apt install -y iproute2

#enable SSH for debugging
RUN apt-get install -y ssh
RUN apt-get install -y openssh-server
RUN service ssh restart

# Install Apache
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles
RUN apt-get install -y tzdata
RUN apt-get install -y apache2

RUN export LANG=C.UTF-8
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php -y
RUN apt-get update

# Install PHP
RUN apt-get install -y php5.6
RUN apt-get install -y php5.6-cli
RUN apt-get install -y php5.6-readline
RUN apt-get install -y php5.6-intl
RUN apt-get install -y php5.6-cli
RUN apt-get install -y php5.6-json
RUN apt-get install -y php5.6-mongo
RUN apt-get install -y php5.6-mysql
RUN apt-get install -y php5.6-curl
RUN apt-get install -y php5.6-dev
RUN apt-get install -y php5.6-xdebug

# Install expect
RUN apt-get install -y expect

# Add templates
ADD ./templates/apache2.conf /etc/apache2/apache2.conf
ADD ./templates/website.conf /etc/apache2/sites-available/website.conf
ADD ./templates/php.ini /etc/php5/apache2/
ADD ./templates/mongo.ini /usr/local/etc/php/conf.d/

# a2enmod & a2ensite
RUN a2enmod php5.6
RUN a2enmod rewrite
RUN a2ensite website.conf

RUN mkdir -p /vhost/current/
VOLUME /vhost/current/
RUN usermod -u 1000 www-data
RUN chown -R www-data:www-data /vhost/current/

RUN sed -i "s/;date.timezone =.*/date.timezone = America\/Los_Angeles/" /etc/php5/apache2/php.ini

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/apache2/symfony_access.log
RUN ln -sf /dev/stderr /var/log/apache2/symfony_error.log

# Port
EXPOSE 80

ADD initialize.sh ./initialize.sh
RUN chmod 755 ./initialize.sh
CMD ["./initialize.sh"]
