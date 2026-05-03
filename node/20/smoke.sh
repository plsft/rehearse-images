#!/bin/sh
set -eu
node --version | grep -q '^v20'
npm --version >/dev/null
pnpm --version >/dev/null
yarn --version >/dev/null
git --version >/dev/null
curl --version >/dev/null
jq --version >/dev/null
test "$(id -u)" -eq 1000
test -d /workspace
echo "ok"
