#!/bin/bash

getlock()
{
  if [ -s $1 ]; then
    if [ "$(ps -p `cat $1` | wc -l)" -gt 1 ]; then
      return 1 #false
    fi
  fi

  echo $$ >"$1"
  return 0 #true
}

freelock()
{
  rm "$1"
}

if ! getlock "/home/vagrant/osm2pgsql/osm-update.pid"; then
  echo "pid `cat /home/vagrant/osm2pgsql/osm-update.pid` still running"
  exit 3
fi

if ! osmosis --read-replication-interval workingDirectory=~/osmosis --simplify-change --write-xml-change "/home/vagrant/osmosis/osm-diff.$$.osc" 1>&2 2>> "/home/vagrant/osmosis/osmosis.log"; then
  echo osmosis error
  exit 1
fi

if ! osm2pgsql -U osm -d gis --append --slim --hstore --cache 2048 --merc --prefix planet_osm --style ~/vector-datasource/osm2pgsql.style --verbose --expire-tiles 18-18 --expire-output "/var/vagrant/expired-tiles-$(date +%Y%m%d%H%M%S).list" --number-processes 1 "/home/vagrant/osmosis/osm-diff.$$.osc" 1>&2 2>> "/home/vagrant/osm2pgsql/osm2pgsql-update.log"; then
  echo osm2pgsql error
  exit 2
fi

freelock "/home/vagrant/osm2pgsql/osm-update.pid"

/bin/rm -f "/home/vagrant/osmosis/osm-diff.$$.osc"