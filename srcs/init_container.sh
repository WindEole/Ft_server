# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    init_container.sh                                  :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: iderighe <iderighe@42.fr>                  +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/04/28 13:33:46 by iderighe          #+#    #+#              #
#    Updated: 2021/05/12 16:45:22 by iderighe         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#service mysql start

# Config Access
chown -R www-data:www-data /var/www/*
chmod -R 755 /var/www/*

# Generate website folder
#mkdir /var/www/localhost && 
touch /var/www/localhost/index.php
echo "<?php phpinfo(); ?>" >> /var/www/localhost/index.php

# SSL
mkdir /etc/nginx/ssl
#openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/certs/localhost.crt -keyout /etc/nginx/ssl/certs/localhost.key -subj "/C=FR/ST=75/L=Paris/O=42/OU=iderighe/CN=localhost"

# Config NGINX
#mv ./srcs/nginx.conf /etc/nginx/sites-available/localhost
#ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost
#rm -rf /etc/nginx/sites-enabled/default

# Config MYSQL
service mysql start
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

# DL phpmyadmin
#mkdir /var/www/localhost/phpmyadmin
#wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
#tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/localhost/phpmyadmin
#mv ./tmp/phpmyadmin.inc.php /var/www/localhost/phpmyadmin/config.inc.php

# DL wordpress
#cd /tmp/
#wget -c https://wordpress.org/latest.tar.gz
#tar -xvzf latest.tar.gz
#mv wordpress/ /var/www/localhost
#mv /tmp/wp-config.php /var/www/localhost/wordpress

# start services
service mysql restart
service php7.3-fpm start
service nginx start
bash
