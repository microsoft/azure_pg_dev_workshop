# Dockerfile
FROM php:8.2-apache

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY start-apache.sh /usr/local/bin

RUN a2enmod rewrite

COPY src /var/www/
RUN chown -R www-data:www-data /var/www

RUN chmod 755 /usr/local/bin/start-apache.sh

CMD ["start-apache.sh"]

EXPOSE 80