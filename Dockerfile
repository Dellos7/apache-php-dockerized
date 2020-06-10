FROM php:7.4-apache
EXPOSE 80
EXPOSE 8081
COPY ./public/ /var/www/
COPY ./apache2.conf /etc/apache2/apache2.conf
COPY ./my-000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./sites-available/* /etc/apache2/sites-available/
COPY ./userdir/ /home/

RUN echo "Listen 8081" >> /etc/apache2/ports.conf

RUN a2ensite web1
RUN ln -sf /var/www/web1/index.html /var/www/web1/1masindexes/enlace.html

RUN a2ensite web2

RUN a2enmod userdir
RUN useradd david -d /home/david \
    && chown -R david:david /home/david \
    && chmod -R 775 /home/david

# Crea una contraseña en el fichero de contraseñas /home/david/.htpasswd (para directiva Auth de Apache)
RUN htpasswd -b -c /home/david/.htpasswd david 12345

RUN a2enmod rewrite

RUN sed -i 's/ServerTokens.*/ServerTokens Major/' /etc/apache2/conf-available/security.conf

RUN echo "alias ll='ls -l'" >> /root/.bashrc && . /root/.bashrc
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y vim