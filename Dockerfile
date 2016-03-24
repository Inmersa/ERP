
#FROM php:5.6.18-apache
FROM php5-mysqli

COPY pack/docker/php/php.ini /usr/local/etc/php/
COPY vhost/ /var/www/html

