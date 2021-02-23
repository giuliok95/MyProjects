#!/bin/bash
sudo apt-get update
sudo apt install -y php-curl php-gd php-mbstring php-xml php-xmlrpc php-fpm php-mysql
sudo apt-get install -y mysql-server

# sudo apt-get install -y tasksel
# sudo tasksel install lamp-server

# sudo systemctl start php7.2-fpm
# sudo systemctl enable php7.2-fpm

wget https://wordpress.org/latest.tar.gz
tar xpf latest.tar.gz
touch wordpress/wp-config.php

# sudo apt-get remove apache2
# sudo apt-get remove apache2-bin
# sudo apt-get remove apache2-data
# sudo apt-get remove apache2-utils

sudo apt-get install -y nginx

sudo chmod 777 /etc/nginx/nginx.conf
sudo chmod 777 /etc/nginx/sites-available/default



