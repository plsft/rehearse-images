FROM node:20-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC \
    NPM_CONFIG_AUDIT=false \
    NPM_CONFIG_FUND=false

# System packages most CI workflows expect.
RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
      git curl ca-certificates jq make g++ python3 \
    && rm -rf /var/lib/apt/lists/*

# pnpm + yarn alongside the bundled npm.
RUN corepack enable && corepack prepare pnpm@9.15.0 --activate \
    && corepack prepare yarn@1.22.22 --activate

# Warm package-manager caches with a curated top-N list.
COPY shared/top-npm.txt /tmp/top-npm.txt
COPY shared/warm-npm.sh /tmp/warm-npm.sh
RUN chmod +x /tmp/warm-npm.sh && /tmp/warm-npm.sh /tmp/top-npm.txt && rm /tmp/warm-npm.sh

# Non-root runner user.
COPY shared/runner-user.sh /tmp/runner-user.sh
RUN chmod +x /tmp/runner-user.sh && /tmp/runner-user.sh && rm /tmp/runner-user.sh

WORKDIR /workspace
USER runner

# Expose the warmed cache locations for clarity.
ENV NPM_CONFIG_CACHE=/home/runner/.npm \
    PNPM_HOME=/home/runner/.local/share/pnpm \
    YARN_CACHE_FOLDER=/home/runner/.cache/yarn

COPY node/20/smoke.sh /smoke.sh
LABEL org.opencontainers.image.source="https://github.com/rehearse-sh/images" \
      org.opencontainers.image.title="rehearse-pro/node:20-warm" \
      org.opencontainers.image.description="Node 20 + npm/pnpm/yarn warmed for CI."
