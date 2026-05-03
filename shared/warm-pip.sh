#!/bin/sh
# Warm pip cache by downloading wheels for the top-pypi list. We use
# `pip download` rather than `install` so we don't leave a polluted
# global site-packages — only the wheel cache survives.
set -eu

LIST="${1:-/tmp/top-pypi.txt}"
WARM="${WARM_DIR:-/tmp/warm-pip}"

mkdir -p "$WARM"
pip download -d "$WARM" -r "$LIST" >/dev/null 2>&1 || true
rm -rf "$WARM"

echo "pip cache warmed from $LIST"
