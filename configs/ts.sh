echo "postgresql:
  host: localhost
  port: 5432
  # multiple databases can be specified, and these are iterated
  # through to balance query loads. This is useful when connecting to
  # pgbouncer, which can dispatch to different back end databases
  # based on the name.
  dbnames: [$PG_DB]
  user: $PG_USER
  password:
queries:
  config: $ROOT_DIR/vector-datasource/queries.yaml
  template-path: $ROOT_DIR/vector-datasource/queries
  # whether to reload the jinja query templates. This should be off in
  # production.
  reload-templates: true

# format extensions to support
# buffered Mapbox Vector Tiles are also possible by specifying mvtb
formats: [json, topojson, mvt]
# buffer configuration, see tilequeue sample config for details
buffer: {}

server:
  host: localhost
  port: $GUNICORN_PORT
  debug: true
  reload: true
  threaded: false

# whether to include cors headers on responses
cors: true

# optional for health checks. This can be useful for monitoring to
# verify that the service is still running and can connect to the
# database.
health:
  # request path to listen for health checks
  url: /_health

# to cache tiles locally, enable a store. This can be useful when
# experiencing timeouts for low or mid zoom ranges. See the tilequeue
# sample config for details.
# store:
#   type: directory
#   name: tiles" > $ROOT_DIR/tileserver/config.yaml