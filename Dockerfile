# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: iderighe <iderighe@42.fr>                  +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/04/17 10:40:20 by iderighe          #+#    #+#              #
#    Updated: 2021/05/12 16:32:18 by iderighe         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#OS
FROM debian:buster-slim
WORKDIR /var/www/localhost

# UPDATE
RUN apt-get update && apt-get upgrade -y

# TOOLS  paauet wget : programme de telechargement de fichiers depuis le Web
RUN apt-get -y install wget

# PHP paquet php7.3 : avant-derniere version de php (langage pour creer des sites web dynamiques)
RUN apt-get -y install php7.3-fpm php7.3-common php7.3-mysql php7.3-gmp php7.3-curl php7.3-intl php7.3-xmlrpc php7.3-xml php7.3-cli php7.3-zip php7.3-soap php7.3-mbstring php7.3-imap

# NGINX (install & config) paauet Nginx : logiciel libre de serveur Web
RUN apt-get -y install nginx
COPY ./srcs/nginx.conf /etc/nginx/sites-available/localhost
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
RUN rm -rf /etc/nginx/sites-enabled/default

# MYSQL paauet MariaDB-server : base de donnees ~ mySQL
RUN apt-get -y install mariadb-server

# COPY CONTENT
#COPY ./srcs/init_container.sh /var/
#COPY ./srcs/mysql_setup.sql /var/
#COPY ./srcs/wordpress.sql /var/
#COPY ./srcs/wordpress.tar.gz /var/www/html/

# PHPMYADMIN
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz
RUN tar xzf phpMyAdmin-5.1.0-english.tar.gz && rm -rf phpMyAdmin-5.1.0-english.tar.gz
RUN mv phpMyAdmin-5.1.0-english phpmyadmin
COPY ./srcs/phpmyadmin.inc.php /var/www/localhost/phpmyadmin/

# WORDPRESS
RUN wget https://wordpress.org/latest.tar.gz
RUN tar xzf latest.tar.gz && rm -rf latest.tar.gz
RUN chmod 755 -R wordpress
COPY ./srcs/wp-config.php wordpress/.

# SETUP SERVER
#RUN service mysql start #&& mysql -u root mysql < /var/mysql_setup.sql && mysql wordpress -u root --password= < /var/wordpress.sql
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=sdunckel' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt
RUN chown -R www-data:www-data *
RUN chmod 755 -R *

EXPOSE 80 443

# START SERVER
COPY ./srcs/init_container.sh /var/
CMD bash /var/init_container.sh
