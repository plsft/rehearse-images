FROM golang:1.24

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC \
    GOPROXY=https://proxy.golang.org,direct \
    GOFLAGS=-buildvcs=false

# Patch the OS layer; Go stdlib is current via the 1.24 image.
RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
      git curl ca-certificates jq make \
    && rm -rf /var/lib/apt/lists/*

# Warm module cache with curated popular modules.
RUN mkdir -p /tmp/warm-go && cd /tmp/warm-go && go mod init warm && \
    go get \
      github.com/stretchr/testify@latest \
      github.com/google/uuid@latest \
      github.com/spf13/cobra@latest \
      github.com/gorilla/mux@latest \
      github.com/lib/pq@latest \
      github.com/go-redis/redis/v8@latest \
      github.com/labstack/echo/v4@latest \
      github.com/gin-gonic/gin@latest \
      go.uber.org/zap@latest \
    >/dev/null 2>&1 || true && cd / && rm -rf /tmp/warm-go

COPY shared/runner-user.sh /tmp/runner-user.sh
RUN chmod +x /tmp/runner-user.sh && /tmp/runner-user.sh && rm /tmp/runner-user.sh

ENV GOPATH=/home/runner/go \
    GOCACHE=/home/runner/.cache/go-build
RUN mkdir -p $GOPATH $GOCACHE && chown -R runner:runner /home/runner

WORKDIR /workspace
USER runner

COPY go/1.24/smoke.sh /smoke.sh
LABEL org.opencontainers.image.source="https://github.com/plsft/rehearse-images" \
      org.opencontainers.image.title="rehearse-pro/go:1.24-warm" \
      org.opencontainers.image.description="Go 1.24 with warmed module proxy cache."
