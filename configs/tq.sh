echo "queue:
  # type can be `sqs`, `multisqs`, `file`, `mem`, or `redis`
  type: redis
  name: tq
  # for multisqs
  zoom-queue-map:
    # keys are <start-zoom>-<end-zoom> (inclusive) ranges
    # values are the queue name to use for zooms in that range
    0-10: qa
    11-20: qb
store:
  type: directory # Can also be `directory`, which would dump the tiles to disk.
  name: $ROOT_DIR/tiles
  # The following store properties are s3 specific.
  path: osm
  reduced-redundancy: true
  date-prefix: 19851026
aws:
  # credentials are optional, and better to use an iam role assigned
  # to the instance if possible
  credentials:
    aws_access_key_id: <aws_access_key_id>
    aws_secret_access_key: <aws_secret_access_key>
tiles:
  seed:
    # can use any combination of the following options for the
    # tilequeue seed command

    # all tiles in a particular zoom range
    all:
      zoom-start: 0
      zoom-until: 10

    # parse the json from Mapzen's metro extracts for a particular
    # zoom range
    metro-extract:
      url: https://raw.githubusercontent.com/mapzen/metroextractor-cities/master/cities.json
      zoom-start: 11
      zoom-until: 15

      # Can also be set to an array of metro-extract city names, like
      # 'new-york_new-york', to only seed tiles from those areas
      # rather than all of them.
      cities:
        - new-york_new-york

    # parse the csv file from Mapbox's post on the top 50k most
    # requested tiles
    top-tiles:
      url: https://gist.github.com/brunosan/b7ce3df8b48229a61b5b/raw/37e42e77f253bc204076111c92acc4d5e653edd2/top_50k_tiles.csv
      zoom-start: 11
      zoom-until: 20

    # Specify any number of custom bounding boxes to seed tiles for.
    custom:
      zoom-start: 10
      zoom-until: 10

      # Must be set to an array of bounding boxes in `[left, bottom, right,
      # top]` (or `[min lon, min lat, max lon, max lat]`) format
      bboxes:

    # whether the tiles that are seeded should also be added to the
    # tiles of interest, or just enqueued
    should-add-to-tiles-of-interest: true

    # how many threads to use when enqueueing
    n-threads: 20

    # whether the tiles should be unique in memory
    # when seeding many tiles that are known to be unique, this should
    # be set to false to save memory
    unique: true

  intersect:
    # directory path to where expired tile files are generated
    expired-location: /home/vagrant/expired-tiles
    # the lowest zoom level to consider when enqueueing tiles to
    # process on update
    parent-zoom-until: 11

process:
  # number of simultaneous \"querysets\" to issue to the database.  The
  # query for each layer will be issued in parallel to the same
  # database. This can be 0 or unspecified, in which case the number
  # will be inferred from the number of database names configured
  # below.
  n-simultaneous-query-sets: 1
  # whether to print out the internal python queue sizes
  log-queue-sizes: true
  # and at what interval
  log-queue-sizes-interval-seconds: 30
  query-config: /home/vagrant/vector-datasource/queries.yaml
  template-path: /home/vagrant/vector-datasource/queries
  # whether to reload jinja query templates on each request. This
  # should be off in production.
  reload-templates: false
  # extensions of formats to generate
  # buffered Mapbox Vector Tiles are also possible by specifying mvtb
  formats: [json, topojson, mvt]
  # additionally, the data included for some formats expects to be
  # buffered. This is where buffers per layer or per geometry type can
  # be specified, with layers trumping geometry types
  buffer:
    mvtb:
      layer:
        earth: {point: 256}
        water: {point: 256}
        places: {point: 128}
      geometry:
        point: 64
        line: 8
        polygon: 8
logging:
  # logging.conf on this page:
  # https://docs.python.org/2/howto/logging.html#logging-basic-tutorial
  config: logging.conf.sample
redis:
  # stub or redis_client. The stub type can be useful for mocking out
  # tiles of interest and in flight enqueueing operations.
  type: stub
  host: localhost
  port: 6379
  db: 0
  cache-set-key: tilequeue.tiles-of-interest
# expected data source is postgresql
postgresql:
  host: localhost
  port: 5432
  # multiple databases can be specified, and these are iterated
  # through to balance query loads. This is useful when connecting to
  # pgbouncer, which can dispatch to different back end databases
  # based on the name.
  dbnames: [gis]
  user: osm
  password:

wof:
  # url path to neighbourhoods, microhoods, and macrohoods meta csv files
  neighbourhoods-meta-url: https://github.com/whosonfirst/whosonfirst-data/raw/master/meta/wof-neighbourhood-latest.csv
  microhoods-meta-url: https://github.com/whosonfirst/whosonfirst-data/raw/master/meta/wof-microhood-latest.csv
  macrohoods-meta-url: https://github.com/whosonfirst/whosonfirst-data/raw/master/meta/wof-macrohood-latest.csv
  boroughs-meta-url: https://github.com/whosonfirst/whosonfirst-data/raw/master/meta/wof-borough-latest.csv
  # url path prefix for wof raw data
  data-prefix-url: http://whosonfirst.mapzen.com/data
  # filesystem path to wof data checkout
  data-path: /tmp/whosonfirst-data
  postgresql:
    host: localhost
    port: 5432
    dbname: gis
    user: osm
    password:

# Set the metatile size to 1 to have tilequeue save metatiles to storage rather
# than individual tiles. This can have major benefits for reducing the number of
# writes to disk. Set the size to null, or omit the entry, to disable metatile
# writing and store individual tiles.
metatile:
  # Only metatiles of size 1 are currently supported, although other sizes may
  # be available in the future.
  size: 1

  # if this is set to true, then tilequeue will write the individual formats in
  # addition to the metatile. this can be useful when gracefully \"cutting over\"
  # to a metatile-based system from an individual format based one.
  store_metatile_and_originals: false" > $ROOT_DIR/tilequeue/config.yaml