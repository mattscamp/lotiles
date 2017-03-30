#!/usr/bin/env bash

echo ">>> Installing Nginx"

# Add repo for latest stable nginx
sudo add-apt-repository -y ppa:nginx/stable

# Update Again
sudo apt-get update

# Install Nginx
# -qq implies -y --force-yes
sudo apt-get install -qq nginx

# Add vagrant user to www-data group
usermod -a -G www-data vagrant

bash $SYNC_DIR/configs/tileserver.sh
bash $SYNC_DIR/configs/tile-cache.sh
sudo service nginx restart