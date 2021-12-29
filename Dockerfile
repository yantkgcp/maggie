## image

FROM php:7.3.20-apache


## envs

ENV INSTALL_DIR /var/www/html


## install libraries

RUN requirements="cron libpng-dev libmcrypt-dev libmcrypt4 libcurl3-dev libfreetype6 libjpeg62-turbo libjpeg62-turbo-dev libfreetype6-dev libicu-dev libxslt1-dev libzip-dev" \
 && apt-get update \
 && apt-get install -y $requirements \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-install pdo_mysql \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install gd \
 && docker-php-ext-install mbstring \
 && docker-php-ext-install zip \
 && docker-php-ext-install intl \
 && docker-php-ext-install xsl \
 && docker-php-ext-install soap \
 && docker-php-ext-install bcmath \
 && pecl install mcrypt-1.0.4 \
 && docker-php-ext-enable mcrypt \
 && docker-php-ext-install sockets

RUN pecl install redis-5.1.1 \
 && pecl install xdebug-2.8.1 \
 && docker-php-ext-enable redis xdebug


## add magento cron job

#COPY ./crontab-fargate /etc/cron.d/magento2-cron

#RUN chmod 0644 /etc/cron.d/magento2-cron

#RUN crontab -u www-data /etc/cron.d/magento2-cron

## turn on mod_rewrite

RUN a2enmod rewrite
RUN a2enmod remoteip
## set memory limits & config files

RUN echo "memory_limit=4096M" > /usr/local/etc/php/conf.d/memory-limit.ini
COPY ./apache2.conf /etc/apache2/apache2.conf
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./apache2.php.ini /usr/local/etc/php/php.ini
## clean apt-get

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## switch user to www-data

USER www-data

## copy sources with proper user
#RUN mkdir $INSTALL_DIR/shop
ADD --chown=www-data:www-data ./magento236.tar.gz $INSTALL_DIR
ADD --chown=www-data:www-data ./healthy.html $INSTALL_DIR
ADD --chown=www-data:www-data ./phpinfo.php $INSTALL_DIR
ADD --chown=www-data:www-data ./index.html $INSTALL_DIR

# Change to root user
USER root

#COPY --chown=www-data ./phpinfo.php $INSTALL_DIR

## www-data should own /var/www
#USER root
#RUN chown -R www-data:www-data /var/www

## set working dir
WORKDIR $INSTALL_DIR/shop

## chmod directories
RUN pwd && chmod u+x $INSTALL_DIR/shop/bin/magento
#RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
#RUN find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#ADD --chown=www-data:www-data ./auth.json /$INSTALL_DIR/shop
## run cron alongside apache

EXPOSE 80

CMD apache2-foreground

