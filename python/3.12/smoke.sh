#!/bin/sh
set -eu
python3 --version | grep -q '3.12'
pip --version >/dev/null
poetry --version >/dev/null
uv --version >/dev/null
git --version >/dev/null
test "$(id -u)" -eq 1000
test -d /workspace
echo "ok"
