#!/bin/sh
set -eu
bun --version >/dev/null
git --version >/dev/null
test "$(id -u)" -eq 1000
test -d /workspace
echo "ok"
