#!/bin/sh
# Warm npm/pnpm/yarn caches by installing each package in shared/top-npm.txt
# into a throwaway project, then deleting node_modules but keeping the global
# package-manager content cache.
set -eu

LIST="${1:-/tmp/top-npm.txt}"
WARM="${WARM_DIR:-/tmp/warm-npm}"

mkdir -p "$WARM"
cd "$WARM"
npm init -y >/dev/null

# Install via npm with cache-only side effect (we discard the install tree).
xargs -a "$LIST" -L 1 npm pack >/dev/null 2>&1 || true

# Make sure pnpm + yarn caches are also seeded if the package manager exists.
if command -v pnpm >/dev/null 2>&1; then
  xargs -a "$LIST" -L 5 pnpm add --save-dev >/dev/null 2>&1 || true
  rm -rf node_modules pnpm-lock.yaml package-lock.json
fi
if command -v yarn >/dev/null 2>&1; then
  xargs -a "$LIST" -L 5 yarn add --dev >/dev/null 2>&1 || true
  rm -rf node_modules yarn.lock package-lock.json
fi

cd /
rm -rf "$WARM"
echo "npm/pnpm/yarn cache warmed from $LIST"
