#!/bin/sh
set -eu
php --version | grep -q '8.3'
composer --version >/dev/null
git --version >/dev/null
test "$(id -u)" -eq 1000
test -d /workspace
echo "ok"
