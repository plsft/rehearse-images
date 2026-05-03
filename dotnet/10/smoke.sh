#!/bin/sh
set -eu
dotnet --version | grep -q '^10\.'
git --version >/dev/null
test "$(id -u)" -eq 1000
test -d /workspace
echo "ok"
