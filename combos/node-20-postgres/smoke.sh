#!/bin/sh
set -eu
node --version | grep -q '^v20'
npm --version >/dev/null
which psql >/dev/null
test -d /workspace
echo "ok"
