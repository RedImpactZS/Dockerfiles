FROM php:7.3.33-fpm

RUN apt update

RUN apt install --yes zlib1g-dev libpng-dev libzip-dev

RUN docker-php-ext-install gd pdo pdo_mysql mysqli bcmath zip

RUN echo "upload_max_filesize = 1000M">>/usr/local/etc/php/conf.d/upload.ini
RUN echo "post_max_size = 1000M">>/usr/local/etc/php/conf.d/upload.ini
RUN echo "php_flag[display_errors] = On">>/usr/local/etc/php-fpm.conf
RUN echo "php_admin_flag[log_errors] = On">>/usr/local/etc/php-fpm.conf
RUN echo "php_admin_value[display_errors] = 'stderr'">>/usr/local/etc/php-fpm.conf
