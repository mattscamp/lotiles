#!/usr/bin/env bash

echo ">>> Installing Tileserver"

#
# Clone datasource
#
cd $ROOT_DIR
yes yes | git clone https://github.com/mapzen/vector-datasource.git
(cd vector-datasource && git checkout tags/v1.2.0)

#
# Grab some data
#
wget $EXTRACT_URL

#
# Import the data using mapzen style
#
export PGPASSWORD=PG_PASS
osm2pgsql -s -C 1024 -S vector-datasource/osm2pgsql.style -j bangkok_thailand.osm.pbf -d $PG_DB -U $PG_USER
cd $ROOT_DIR/vector-datasource/data
python bootstrap.py
make -f Makefile-import-data
./import-shapefiles.sh | psql -d $PG_DB -U $PG_USER
./perform-sql-updates.sh -d $PG_DB -U $PG_USER
make -f Makefile-import-data clean

#
# Install osm
#
cd $ROOT_DIR
yes yes | git clone https://github.com/mapzen/tileserver.git
(cd tileserver && git checkout tags/v1.4.0)
sudo pip install -U -r tileserver/requirements.txt
cd $ROOT_DIR/tileserver
sudo python setup.py develop

#
# Install tilequeue
#
cd $ROOT_DIR
yes yes | git clone https://github.com/tilezen/tilequeue.git
(cd tilequeue && git checkout tags/v1.6.0)
cd $ROOT_DIR/tilequeue
sudo python setup.py develop

cd $ROOT_DIR/vector-datasource
sudo python setup.py develop

#
# Set up config
#
cd $ROOT_DIR/tileserver
bash $SYNC_DIR/configs/ts.sh
sudo pip install gunicorn
gunicorn -b 127.0.0.1:3002 "tileserver:wsgi_server('$ROOT_DIR/tileserver/config.yaml')" &