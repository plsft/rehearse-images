#!/bin/sh
set -eu
go version | grep -q 'go1.23'
git --version >/dev/null
test "$(id -u)" -eq 1000
test -d /workspace
echo "ok"
