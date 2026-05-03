#!/bin/sh
set -eu
ruby --version | grep -q '3.3'
gem --version >/dev/null
bundle --version >/dev/null
test "$(id -u)" -eq 1000
test -d /workspace
echo "ok"
