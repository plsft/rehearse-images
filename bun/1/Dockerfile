FROM oven/bun:1-debian

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC

RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
      git curl ca-certificates jq make g++ python3 \
    && rm -rf /var/lib/apt/lists/*

# Warm bun cache with the same npm-compatible top-N list.
COPY shared/top-npm.txt /tmp/top-npm.txt
RUN mkdir -p /tmp/warm-bun && cd /tmp/warm-bun && bun init -y >/dev/null \
    && xargs -a /tmp/top-npm.txt -L 5 bun add >/dev/null 2>&1 || true \
    && cd / && rm -rf /tmp/warm-bun

COPY shared/runner-user.sh /tmp/runner-user.sh
RUN chmod +x /tmp/runner-user.sh && /tmp/runner-user.sh && rm /tmp/runner-user.sh

WORKDIR /workspace
USER runner

COPY bun/1/smoke.sh /smoke.sh
LABEL org.opencontainers.image.source="https://github.com/rehearse-sh/images" \
      org.opencontainers.image.title="rehearse-pro/bun:1-warm" \
      org.opencontainers.image.description="Bun 1 with warmed npm-compatible cache."
