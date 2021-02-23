#!/bin/bash
  sudo docker run -it --rm \
  --volumes-from f384b1f361b5 \
  --network container:f384b1f361b5 \
    wordpress:cli-2.4 wp core install \
          --url=http://localhost:8000 \
          --title=WordPress \
          --admin_user=wordpress \
          --amdin_password=wordpress \
          --admin_email=vagrant@vagrant.com \
          --skip-email

# sudo docker run -it --rm --volumes-from f384b1f361b5 --network container:f384b1f361b5 wordpress:cli-2.4 wp core install --url=http://localhost:8000 --title=WordPress --admin_user=wordpress --admin_password=wordpress --admin_email=vagrant@vagrant.com --skip-email