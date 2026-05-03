#!/bin/sh
# Adds a non-root `runner` user with UID/GID 1000 to any base image.
# Idempotent — safe to run on bases that already have the user/group.
set -eu

if ! getent group runner >/dev/null 2>&1; then
  if command -v addgroup >/dev/null 2>&1; then
    addgroup -g 1000 runner 2>/dev/null || groupadd -g 1000 runner
  else
    groupadd -g 1000 runner
  fi
fi
if ! id runner >/dev/null 2>&1; then
  if command -v adduser >/dev/null 2>&1 && adduser --help 2>&1 | grep -q -- '--disabled-password'; then
    adduser --disabled-password --gecos '' --uid 1000 --ingroup runner runner
  elif command -v adduser >/dev/null 2>&1; then
    adduser -D -u 1000 -G runner runner
  else
    useradd -u 1000 -g runner -m runner
  fi
fi
mkdir -p /workspace
chown -R runner:runner /workspace
