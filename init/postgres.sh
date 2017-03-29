#!/usr/bin/env bash

. ./etc/parse_yaml.sh

eval $(parse_yaml config.yml "config_")

echo ">>> Installing PostgreSQL"

sudo apt-get install -y postgresql postgresql-contrib postgis postgresql-9.3-postgis-2.1

#
# Set up postgres
#
sudo -u postgres createuser -S $config_postgres_user --no-password
sudo -u postgres createdb -E UTF8 -O $config_postgres_user $config_postgres_database
useradd -m $config_postgres_user
sudo -u postgres psql --command="CREATE EXTENSION postgis; CREATE EXTENSION hstore;" --dbname=$config_postgres_database

# Make sure changes are reflected by restarting
sudo service postgresql restart