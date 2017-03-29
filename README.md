# lotiles

Various shell scripts for throwing up a production like [tileserver](https://github.com/tilezen/tileserver)

## Install

- `sudo bash provision.sh`
- Edit the tileserver config to run on port 3002
- Start the tileserver via GUnicorn or just manually via python

## Detailed

The tilerserver is run port 3002. Requests are routed to varnish on port 8080 which tries to hit NGINX cache or goes directly to tileserver. Varnish passes request to NGINX which is listening on 3000(cache) and 3001(tileserver routing to 3002).

## TODO

- Automate tileserver config and GUnicorn
- Set up automated cacheing of tiles
