#!/usr/bin/env bash

echo ">>> Installing Tileserver"

EXTRACT_URL=https://s3.amazonaws.com/metro-extracts.mapzen.com/bangkok_thailand.osm.pbf

#
# Clone datasource
#
cd ~
yes yes | git clone https://github.com/mapzen/vector-datasource.git
(cd vector-datasource && git checkout tags/v1.2.0)

#
# Grab some data
#
wget $EXTRACT_URL

#
# Import the data using mapzen style
#
osm2pgsql -s -C 1024 -S vector-datasource/osm2pgsql.style -j bangkok_thailand.osm.pbf -d gis -U osm
cd vector-datasource/data
python bootstrap.py
make -f Makefile-import-data
./import-shapefiles.sh | psql -d gis -U osm
./perform-sql-updates.sh -d gis -U osm
make -f Makefile-import-data clean

#
# Install osm
#
cd ~
yes yes | git clone https://github.com/mapzen/tileserver.git
(cd tileserver && git checkout tags/v1.4.0)
sudo pip install -U -r tileserver/requirements.txt
cd tileserver
sudo python setup.py develop

#
# Install tilequeue
#
cd ~
yes yes | git clone https://github.com/tilezen/tilequeue.git
(cd tilequeue && git checkout tags/v1.6.0)
cd tilequeue
sudo python setup.py develop

cd ~
cd vector-datasource
sudo python setup.py develop

#
# Set up config
#
cd ../tileserver
sudo cp config.yaml.sample config.yaml
sudo pip install gunicorn