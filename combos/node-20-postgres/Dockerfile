FROM rehearse-build/node-20-warm:local AS warm
# This combo is composed from the standard node:20-warm with Postgres added.
# In production publish.yml builds against the just-pushed registry tag.

FROM node:20-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC

RUN apt-get update && apt-get install -y --no-install-recommends \
      git curl ca-certificates jq make g++ python3 \
      postgresql postgresql-contrib supervisor \
    && rm -rf /var/lib/apt/lists/*

# Configure PG to listen on localhost.
RUN sed -i "s/#listen_addresses.*/listen_addresses = 'localhost'/" /etc/postgresql/*/main/postgresql.conf || true

# Bring across the warmed npm caches from the warm stage.
COPY --from=warm /home/runner/.npm /home/runner-warm-cache/.npm

RUN corepack enable && corepack prepare pnpm@9.15.0 --activate \
    && corepack prepare yarn@1.22.22 --activate

COPY shared/runner-user.sh /tmp/runner-user.sh
RUN chmod +x /tmp/runner-user.sh && /tmp/runner-user.sh && rm /tmp/runner-user.sh

# Promote the cached files into the runner user's home.
RUN cp -r /home/runner-warm-cache/.npm /home/runner/.npm 2>/dev/null \
    && rm -rf /home/runner-warm-cache \
    && chown -R runner:runner /home/runner

# Postgres init: create db `app` owned by runner.
COPY combos/node-20-postgres/init-pg.sh /init-pg.sh
RUN chmod +x /init-pg.sh && /init-pg.sh

WORKDIR /workspace
USER runner

COPY combos/node-20-postgres/smoke.sh /smoke.sh
COPY combos/node-20-postgres/entrypoint.sh /entrypoint.sh
USER root
RUN chmod +x /entrypoint.sh
USER runner

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]

LABEL org.opencontainers.image.source="https://github.com/rehearse-sh/images" \
      org.opencontainers.image.title="rehearse-pro/node:20-postgres-warm" \
      org.opencontainers.image.description="Node 20 + Postgres 16 + warmed npm caches."
