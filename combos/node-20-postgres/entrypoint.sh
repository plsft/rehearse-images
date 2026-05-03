#!/bin/sh
set -eu
sudo service postgresql start || service postgresql start || true
exec "$@"
