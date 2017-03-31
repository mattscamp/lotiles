# lotiles

Various shell scripts for throwing up a local, production like [tileserver](https://github.com/tilezen/tileserver). Not meant for production, but can be modified and used as pleased. Much of this work is based off the deprecated [vagrant-tiles](https://github.com/mapzen/vagrant-tiles).

## Install

- Edit config.sh variables
- Run `sudo bash provision.sh`

## Core Components `(./init)`

`Postgres` - stores OSM data from PBF formatted in the style that tileserver expects.
`Redis` - Used as our worker queue for tilequeue.
`Tilequeue` - Main process used for seeding and pulling work from redis. Caches tiles into S3 or locally.
`Tileserver` - Serves tiles via web requests. Runs via GUnicorn on port 3002.
`NGINX` - Direct to cached tiles or upstream to tileserver. Serves cache from port 3000 and redirects to tileserver on port 3001.
`Varnish` - Tries to hit cache via NGINX, if fails, redirects directly to tileserver. Runs on port 80.

## Optional Components `(./etc)`

`Osmosis` - Pulls in new updated OSM data, creates a diff, then updates the database.
`Seed` - Runs tilequeue commands to seed, process, and expire tiles for cacheing.

## Warning

Right now all the configs are set up for local development and ease of use, they are not safe for production.
Our postgres config makes updates that trusts all local requests. If you intend to do anything else, please configure
to your needs.

## TODO

- Add CLI parsing for optional components
- Create jobs for seeding and osmosis processing
- Better config system