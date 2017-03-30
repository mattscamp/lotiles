#!/usr/bin/env bash

. ../config.sh

echo ">>> Seeding tiles to S3 or Local"

tilequeue seed --config $ROOT_DIR/tilequeue/config.yaml
tilequeue process --config $ROOT_DIR/tilequeue/config.yaml