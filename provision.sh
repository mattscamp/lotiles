#! /bin/sh

. etc/parse_yaml.sh

eval $(parse_yaml config.yaml "config_")

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

cd ~
mkdir osm2pgsql
mkdir osmosis
mkdir gunicorn

sudo cp $config_sync_directory/configs/osmosis ./osmosis/configuration.txt

echo "Finished"