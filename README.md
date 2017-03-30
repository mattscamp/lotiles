# lotiles

Various shell scripts for throwing up a production like [tileserver](https://github.com/tilezen/tileserver)

## Install

- `sudo bash provision.sh`

## Explanation

Varnish passes request to NGINX which is listening on 3000(cache) and 3001(tileserver routing to local 3002).

## TODO
- Option to seed and create jobs
- Add CLI parsing