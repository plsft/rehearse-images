#!/bin/sh
# Ensure a non-root `runner` user exists at UID/GID 1000.
#
# Many official base images (node:slim, oven/bun, etc.) already create a user
# at UID 1000 (e.g. `node`, `bun`). Creating a new one fails with
# "groupadd: GID '1000' already exists". So if 1000 is taken, rename the
# existing user/group to `runner` rather than fighting it.
#
# Idempotent — safe to run on a base image that already has `runner`.

set -eu

existing_user=$(getent passwd 1000 2>/dev/null | cut -d: -f1 || true)
existing_group=$(getent group 1000 2>/dev/null | cut -d: -f1 || true)

# Rename existing UID 1000 user → runner.
if [ -n "$existing_user" ] && [ "$existing_user" != "runner" ]; then
  if command -v usermod >/dev/null 2>&1; then
    usermod -l runner -d /home/runner -m "$existing_user" 2>/dev/null || true
  fi
fi

# Rename existing GID 1000 group → runner.
if [ -n "$existing_group" ] && [ "$existing_group" != "runner" ]; then
  if command -v groupmod >/dev/null 2>&1; then
    groupmod -n runner "$existing_group" 2>/dev/null || true
  fi
fi

# If neither was present, create from scratch.
if ! getent group runner >/dev/null 2>&1; then
  if command -v groupadd >/dev/null 2>&1; then
    groupadd -g 1000 runner
  else
    addgroup -g 1000 runner
  fi
fi
if ! id runner >/dev/null 2>&1; then
  if command -v useradd >/dev/null 2>&1; then
    useradd -u 1000 -g runner -m -s /bin/bash runner
  elif command -v adduser >/dev/null 2>&1 && adduser --help 2>&1 | grep -q -- '--disabled-password'; then
    adduser --disabled-password --gecos '' --uid 1000 --ingroup runner runner
  else
    adduser -D -u 1000 -G runner runner
  fi
fi

# Make sure the home directory exists and is owned correctly.
mkdir -p /home/runner /workspace
chown -R runner:runner /home/runner /workspace
