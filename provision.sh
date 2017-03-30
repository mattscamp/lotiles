#! /bin/sh

. config.sh

#
# Install dependencies
#
sudo apt-add-repository ppa:tilezen -y
sudo apt-get update -y
sudo apt-get install -y git build-essential autoconf libtool pkg-config python-dev python-virtualenv libgeos-dev libpq-dev python-pip python-pil libmapnik2.2 libmapnik-dev mapnik-utils python-mapnik python-yaml python-jinja2 osm2pgsql osmosis

bash ./init/postgres.sh
bash ./init/nginx.sh
bash ./init/redis.sh
bash ./init/varnish.sh
bash ./init/tileserver.sh

mkdir $ROOT_DIR/osm2pgsql
mkdir $ROOT_DIR/osmosis
mkdir $ROOT_DIR/gunicorn
mkdir $ROOT_DIR/tiles

sudo cp /vagrant/configs/osmosis $ROOT_DIR/osmosis/configuration.txt

echo "Finished"