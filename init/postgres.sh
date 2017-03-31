#!/usr/bin/env bash

echo ">>> Installing PostgreSQL"

sudo apt-get install -y postgresql postgresql-contrib postgis postgresql-9.3-postgis-2.1

#
# Set up postgres
#
sudo -u postgres psql -c "CREATE USER $PG_USER WITH PASSWORD '$PG_PASS';"
sudo -u postgres createdb -E UTF8 -O $PG_USER $PG_DB
sudo useradd -m $PG_USER
sudo -u postgres psql --command="CREATE EXTENSION postgis; CREATE EXTENSION hstore;" --dbname=$PG_DB
sudo bash $SYNC_DIR/configs/pg_hba.sh

# Make sure changes are reflected by restarting
sudo service postgresql restart