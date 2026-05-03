FROM ruby:3.3-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC

RUN apt-get update && apt-get install -y --no-install-recommends \
      git curl ca-certificates jq make gcc g++ libpq-dev libffi-dev libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Warm gem cache with a small representative set.
RUN gem install --no-document bundler rails rspec rake nokogiri puma sidekiq pg redis 2>/dev/null || true

COPY shared/runner-user.sh /tmp/runner-user.sh
RUN chmod +x /tmp/runner-user.sh && /tmp/runner-user.sh && rm /tmp/runner-user.sh

WORKDIR /workspace
USER runner

COPY ruby/3.3/smoke.sh /smoke.sh
LABEL org.opencontainers.image.source="https://github.com/rehearse-sh/images" \
      org.opencontainers.image.title="rehearse-pro/ruby:3.3-warm" \
      org.opencontainers.image.description="Ruby 3.3 + Bundler with warmed gem cache."
