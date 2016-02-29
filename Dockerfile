FROM httpd

MAINTAINER Jan Loufek <chap@chap.cz>

RUN apt-get update && apt-get -y install git curl php5-mcrypt php7-json php7-mysql php5-xdebug && apt-get -y autoremove && apt-get clean


RUN /usr/sbin/a2enmod rewrite

RUN /usr/sbin/a2enmod socache_shmcb || true

ADD 000-default.conf /etc/apache2/sites-available/
ADD 001-default-ssl.conf /etc/apache2/sites-available/
ADD xdebug.ini /etc/php5/apache2/conf.d/xdebug.ini

RUN /bin/rm /etc/apache2/sites-enabled/001-default-ssl
RUN /bin/ln -sf /etc/apache2/sites-available/001-default-ssl.conf /etc/apache2/sites-enabled/001-default-ssl.conf

RUN /usr/bin/curl -sS https://getcomposer.org/installer | /usr/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]