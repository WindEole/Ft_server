# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: iderighe <iderighe@42.fr>                  +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/04/17 10:40:20 by iderighe          #+#    #+#              #
#    Updated: 2021/04/26 12:22:59 by iderighe         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster-slim

#RUN apt-get update && apt-get install -y procps && apt_get install nano && apt-get install -y wget

# UPDATE
RUN apt-get update
RUN apt-get upgrade -y

# paauet procps : fournit des outils de commande et plein ecran pour naviguer dans procfs (INUTILE)
#RUN apt-get -y install procps
# paauet nano : c'est un petit editeur de texte GNU (INUTILE)
#RUN apt-get -y install nano

# INSTALL TOOLS  paauet wget : c'est un programme de telechargement de fichiers depuis le Web (UTILE)
RUN apt-get -y install wget

# INSTALL NGINX paauet Nginx : c'est le logiciel libre de serveur Web (OBLIGATOIRE)
RUN apt-get -y install nginx

# INSTALL MYSQL paauet MariaDB-server : c'est la base de donnees ~ mySQL (OBLIGATOIRE)
RUN apt-get -y install mariadb-server

# INSTALL PHP paquet php7.3 : avant-derniere version de php
RUN apt-get -y install php7.3 php-mysql php-fpm php-cli php-mbstring

# COPY CONTENT
COPY ./srcs/init_container.sh /var/
COPY ./srcs/mysql_setup.sql /var/
COPY ./srcs/wordpress.sql /var/
COPY ./srcs/wordpress.tar.gz /var/www/html/
COPY ./srcs/nginx.conf /etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost

# INSTALL PHPMYADMIN
WORKDIR /var/www/html/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.1/phpMyAdmin-4.9.1-english.tar.gz
RUN tar xf phpMyAdmin-4.9.1-english.tar.gz && rm -rf phpMyAdmin-4.9.1-english.tar.gz
RUN mv phpMyAdmin-4.9.1-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin

# INSTALL WORDPRESS
RUN tar xf ./wordpress.tar.gz && rm -rf wordpress.tar.gz
RUN chmod 755 -R wordpress

# SETUP SERVER
RUN service mysql start && mysql -u root mysql < /var/mysql_setup.sql && mysql wordpress -u root --password= < /var/wordpress.sql
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=sdunckel' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt
RUN chown -R www-data:www-data *
RUN chmod 755 -R *

# START SERVER
CMD bash /var/start.sh

EXPOSE 80 443


#CMD bash init_container.sh
