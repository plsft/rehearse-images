FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_INPUT=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
      git curl ca-certificates jq make gcc g++ libpq-dev libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# pip is bundled. Add poetry + uv (both top-3 modern PyPI tools).
RUN pip install --no-cache-dir poetry uv

COPY shared/top-pypi.txt /tmp/top-pypi.txt
COPY shared/warm-pip.sh /tmp/warm-pip.sh
RUN chmod +x /tmp/warm-pip.sh && /tmp/warm-pip.sh /tmp/top-pypi.txt && rm /tmp/warm-pip.sh

COPY shared/runner-user.sh /tmp/runner-user.sh
RUN chmod +x /tmp/runner-user.sh && /tmp/runner-user.sh && rm /tmp/runner-user.sh

WORKDIR /workspace
USER runner

COPY python/3.12/smoke.sh /smoke.sh
LABEL org.opencontainers.image.source="https://github.com/rehearse-sh/images" \
      org.opencontainers.image.title="rehearse-pro/python:3.12-warm" \
      org.opencontainers.image.description="Python 3.12 + pip/poetry/uv warmed for CI."
