#!/bin/sh
set -eu
service postgresql start
su - postgres -c "psql -c \"CREATE USER runner WITH SUPERUSER PASSWORD 'runner';\""
su - postgres -c "createdb -O runner app"
service postgresql stop
