FROM golang:1.23

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC \
    GOPROXY=https://proxy.golang.org,direct \
    GOFLAGS=-buildvcs=false

RUN apt-get update && apt-get install -y --no-install-recommends \
      git curl ca-certificates jq make \
    && rm -rf /var/lib/apt/lists/*

# Warm module cache with a few common modules. Realistic warming for Go is
# project-specific; we seed proxy state for popular libraries.
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

# Reseed module cache into the runner user's GOPATH.
ENV GOPATH=/home/runner/go \
    GOCACHE=/home/runner/.cache/go-build
RUN mkdir -p $GOPATH $GOCACHE && chown -R runner:runner /home/runner

WORKDIR /workspace
USER runner

COPY go/1.23/smoke.sh /smoke.sh
LABEL org.opencontainers.image.source="https://github.com/rehearse-sh/images" \
      org.opencontainers.image.title="rehearse-pro/go:1.23-warm" \
      org.opencontainers.image.description="Go 1.23 with warmed module proxy cache."
