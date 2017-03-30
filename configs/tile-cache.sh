echo "server {
  listen $NGINX_CACHE_PORT;
  server_name localhost;
  rewrite ^/osm/all/(.*) /\$1;
  root ~/tiles;
}" > /etc/nginx/sites-available/tile-cache

sudo ln -s /etc/nginx/sites-available/tile-cache /etc/nginx/sites-enabled/tile-cache