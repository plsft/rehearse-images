#!/bin/sh
set -eu
python3 --version | grep -q '3.12'
which psql >/dev/null
python3 -c "import psycopg2" 2>/dev/null
test -d /workspace
echo "ok"
