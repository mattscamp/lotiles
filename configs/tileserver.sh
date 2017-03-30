echo "upstream unicorn_tileserver {
  server localhost:$GUNICORN_PORT fail_timeout=0;
}

server {
  listen localhost:$NGINX_TILESERVER_PORT;

  location /osm {
    rewrite ^/osm/(.*) /\$1 break;
    proxy_pass http://unicorn_tileserver;
  }

  location / {
    return 404 \"Not Found\";
  }

}" > /etc/nginx/sites-available/tileserver

sudo ln -s /etc/nginx/sites-available/tileserver /etc/nginx/sites-enabled/tileserver