#!/bin/sh
# Prime npm's content-addressable cache with the curated top-N list so that
# `npm install <one of those>` inside the container resolves from local
# cache instead of hitting registry.npmjs.org.
#
# We DON'T warm pnpm/yarn separately — their stores are huge and most of
# v0's customers use npm. Pnpm/yarn binaries are still installed; we just
# don't prepopulate their caches.
#
# Side effects: ~/.npm/_cacache populated with package + metadata blobs for
# the listed packages and their transitive deps.

set -eu

LIST="${1:-/tmp/top-npm.txt}"
WARM_DIR="${WARM_DIR:-/tmp/warm-npm}"

# npm cache add downloads + verifies the tarball for a package and stores it
# in $NPM_CONFIG_CACHE. Resolves much faster than a real install (no
# dependency tree to compute, no node_modules write).
mkdir -p "$WARM_DIR"
cd "$WARM_DIR"

# Install all listed packages once into a throwaway project. This pulls the
# full transitive tree into ~/.npm/_cacache, which is exactly what we want
# customers to hit on their first `npm install <X>`.
npm init -y >/dev/null
npm install --no-audit --no-fund --no-progress --silent --no-save $(cat "$LIST") 2>/dev/null || true

# Discard the install tree but KEEP the global cache.
cd /
rm -rf "$WARM_DIR"

# Compact the cache (removes orphans + stale metadata).
npm cache verify >/dev/null 2>&1 || true

echo "npm cache warmed from $LIST"
