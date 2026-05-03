#!/bin/sh
set -eu
java -version 2>&1 | grep -q '21'
mvn --version >/dev/null
gradle --version >/dev/null
test "$(id -u)" -eq 1000
test -d /workspace
echo "ok"
