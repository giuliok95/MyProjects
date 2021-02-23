#!/bin/bash
sudo apt-get update
sudo apt-get install -y mysql-server
sudo mysql -u root <<EOF
create database wordpress;
grant all privileges on wordpress.* to 'wordpress'@'%' identified by 'wordpress';
flush privileges;
EOF

sudo sed -i 's/bind.*/# bind_address/' /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql