#!/usr/bin/env bash

echo ">>> Installing Nginx"

# Add repo for latest stable nginx
sudo add-apt-repository -y ppa:nginx/stable

# Update Again
sudo apt-get update

# Install Nginx
sudo apt-get install -qq nginx

# Add vagrant user to www-data group
usermod -a -G www-data vagrant

sudo bash $SYNC_DIR/configs/tileserver.sh
sudo bash $SYNC_DIR/configs/tile-cache.sh
sudo rm /etc/nginx/sites-available/default
sudo service nginx restart