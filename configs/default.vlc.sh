echo "vcl 4.0;

backend nginx_cache {
  .host = \"localhost\";
  .port = \"$NGINX_CACHE_PORT\";
}

backend tileserver {
  .host = \"localhost\";
  .port = \"$NGINX_TILESERVER_PORT\";
}

sub vcl_recv {
  if (req.http.accept-encoding ~ \"gzip\") {
    set req.http.Accept-Encoding = \"gzip\";
  } else {
    unset req.http.Accept-Encoding;
  }
}

sub vcl_backend_fetch {
  if (bereq.retries == 0) {
    set bereq.backend = nginx_cache;
  } else {
    set bereq.backend = tileserver;
  }
}

sub vcl_backend_response {
  if (bereq.url ~ \"\.mvt$\" || bereq.http.accept-encoding == \"gzip\") {
    set beresp.do_gzip = true;
  }
  if (beresp.status > 400 && beresp.status < 600 && bereq.retries == 0) {
    return (retry);
  }
  if (bereq.retries == 0) {
    set beresp.http.X-Served-By = \"tile-cache\";
  } else {
    set beresp.http.X-Served-By = \"tileserver\";
  }
  if (beresp.status == 500 || beresp.status == 503) {
    set beresp.ttl = 1s;
    set beresp.grace = 5s;
    return (deliver);
  }
  return (deliver);
}

sub vcl_deliver {
  set resp.http.Access-Control-Allow-Origin = \"*\";
  set resp.http.Access-Control-Allow-Credentials = \"true\";
  set resp.http.Access-Control-Allow-Methods = \"GET, HEAD\";
  set resp.http.Access-Control-Allow-Headers = \"Authorization, Content-Type, Accept, Origin, User-Agent, Cache-Control, Keep-Alive, If-Modified-Since, If-None-Match\";
  set resp.http.Access-Control-Expose-Headers = \"Content-Type, Cache-Control, ETag, Expires, Last-Modified, Content-Length\";
  unset resp.http.Via;
  unset resp.http.Age;
  unset resp.http.Server;
  unset resp.http.X-Cache;
  unset resp.http.X-Cache-Hits;
  unset resp.http.X-Timer;
  unset resp.http.Accept-Ranges;

  return (deliver);
}" > /etc/varnish/default.vcl
