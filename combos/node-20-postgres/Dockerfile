FROM node:20-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC \
    NPM_CONFIG_AUDIT=false \
    NPM_CONFIG_FUND=false

RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
      git curl ca-certificates jq make g++ python3 sudo \
      postgresql postgresql-contrib \
    && rm -rf /var/lib/apt/lists/*

# PG listens on localhost only.
RUN sed -i "s/#listen_addresses.*/listen_addresses = 'localhost'/" /etc/postgresql/*/main/postgresql.conf || true

RUN corepack enable && corepack prepare pnpm@9.15.0 --activate \
    && corepack prepare yarn@1.22.22 --activate

# Warm npm/pnpm/yarn caches with curated top-N list.
COPY shared/top-npm.txt /tmp/top-npm.txt
COPY shared/warm-npm.sh /tmp/warm-npm.sh
RUN chmod +x /tmp/warm-npm.sh && /tmp/warm-npm.sh /tmp/top-npm.txt && rm /tmp/warm-npm.sh

# Non-root runner user.
COPY shared/runner-user.sh /tmp/runner-user.sh
RUN chmod +x /tmp/runner-user.sh && /tmp/runner-user.sh && rm /tmp/runner-user.sh

# Promote any warmed caches placed by warm-npm.sh into the runner home.
RUN if [ -d /root/.npm ]; then cp -r /root/.npm /home/runner/.npm; fi \
    && chown -R runner:runner /home/runner

# Postgres init.
COPY combos/node-20-postgres/init-pg.sh /init-pg.sh
RUN chmod +x /init-pg.sh && /init-pg.sh

# Allow the runner user to start postgres on container boot.
RUN echo 'runner ALL=(ALL) NOPASSWD: /usr/sbin/service postgresql *' >> /etc/sudoers

COPY combos/node-20-postgres/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /workspace
USER runner

ENV NPM_CONFIG_CACHE=/home/runner/.npm \
    PNPM_HOME=/home/runner/.local/share/pnpm \
    YARN_CACHE_FOLDER=/home/runner/.cache/yarn

COPY combos/node-20-postgres/smoke.sh /smoke.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]

LABEL org.opencontainers.image.source="https://github.com/plsft/rehearse-images" \
      org.opencontainers.image.title="rehearse-pro/node:20-postgres-warm" \
      org.opencontainers.image.description="Node 20 + Postgres 16 + warmed npm caches."
