#!/usr/bin/env bash

echo ">>> Installing PostgreSQL"

sudo apt-get install -y postgresql postgresql-contrib postgis postgresql-9.3-postgis-2.1

#
# Set up postgres
#
sudo -u postgres createuser -S $PG_USER --no-password
sudo -u postgres createdb -E UTF8 -O $PG_USER $PG_DB
sudo useradd -m $PG_USER
sudo -u postgres psql --command="CREATE EXTENSION postgis; CREATE EXTENSION hstore;" --dbname=$PG_DB
sudo bash $SYNC_DIR/configs/pg_hba.conf

# Make sure changes are reflected by restarting
sudo service postgresql restart