FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update && apt-get install -y --no-install-recommends \
      git curl ca-certificates jq make gcc g++ libpq-dev libffi-dev \
      postgresql postgresql-contrib \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir poetry uv psycopg2-binary

COPY shared/top-pypi.txt /tmp/top-pypi.txt
COPY shared/warm-pip.sh /tmp/warm-pip.sh
RUN chmod +x /tmp/warm-pip.sh && /tmp/warm-pip.sh /tmp/top-pypi.txt && rm /tmp/warm-pip.sh

COPY shared/runner-user.sh /tmp/runner-user.sh
RUN chmod +x /tmp/runner-user.sh && /tmp/runner-user.sh && rm /tmp/runner-user.sh

COPY combos/python-3.12-postgres/init-pg.sh /init-pg.sh
RUN chmod +x /init-pg.sh && /init-pg.sh

WORKDIR /workspace
USER runner

COPY combos/python-3.12-postgres/entrypoint.sh /entrypoint.sh
USER root
RUN chmod +x /entrypoint.sh
USER runner

COPY combos/python-3.12-postgres/smoke.sh /smoke.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]

LABEL org.opencontainers.image.source="https://github.com/rehearse-sh/images" \
      org.opencontainers.image.title="rehearse-pro/python:3.12-postgres-warm" \
      org.opencontainers.image.description="Python 3.12 + Postgres 16 + psycopg2."
