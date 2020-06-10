## Descargar la imagen de docker

```shell
docker pull php:7.4-apache
```

## Construir imagen propia a partir de Dockerfile

Construiremos una imagen propia a partir del Dockerfile situado en el directorio `.`, llamada `apacheserver-php`

```shell
docker build -t apacheserver-php .
```

## Arrancar un contenedor de la imagen creada

Crearemos y arrancaremos un contenedor llamado `apacheserver-php1`, en segundo plano (`-d`), con mapeo del puerto `80` interno al puerto `8080` (externo).

```shell
docker run -d --name apacheserver-php1 -p 8080:80 apacheserver-php
```

Si queremos pararlo:

```shell
docker stop apacheserver-php1
```

Si lo queremos volver a arrancar:

```shell
docker start apacheserver-php1
```

Si lo queremos eliminar:

```shell
docker rm apacheserver-php1
```

## Montar la carpeta web dinámica para que se actualicen los ficheros

El problema anterior es que se crea la imagen con la carpeta web que hayamos especificado en el Dockerfile, pero por mucho que la actualicemos en el ordenador local, si no volvemos a generar la imagen, no veremos los cambios.

Para ello, indicaremos al contenedor que queremos montar la carpeta local donde tenemos la web:

```shell
docker run -d --name apacheserver-php1 -p 8080:80 -v "$PWD"/public:/var/www/html/ apacheserver-php
```

Algo más complejo:

```shell
docker run -d --name apacheserver-php1 -p 8080:80 -p 8081:8081 -v "$PWD"/public:/var/www/ -v "$PWD"/sites-available:/etc/apache2/sites-available/ -v "$PWD"/userdir/:/home/ apacheserver-php
```

Aquí, mapeamos varios puertos y montamos varias carpetsa desde el host hasta el contenedor.

## Ejecutar una terminal interactiva en el contenedor

```shell
docker exec -it apacheserver-php1 bash
```

## Obtener el `httpd.conf` del contenedor

Podemos obtener el `httpd.conf` del contenedor para modificarlo a nuestro antojo y después cargarlo al montar la imagen con las modificaciones que hayamos hecho.

```shell
docker exec apacheserver-php1 cat /etc/apache2/apache2.conf > my-apache2.conf
```