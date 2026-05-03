FROM mcr.microsoft.com/dotnet/sdk:8.0

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    DOTNET_NOLOGO=1

RUN apt-get update && apt-get install -y --no-install-recommends \
      git curl ca-certificates jq make \
    && rm -rf /var/lib/apt/lists/*

# Warm NuGet cache with a representative set of packages.
RUN mkdir -p /tmp/warm-net && cd /tmp/warm-net && \
    dotnet new console -o app >/dev/null && cd app && \
    for pkg in Newtonsoft.Json Serilog xunit Microsoft.EntityFrameworkCore Dapper FluentValidation Polly Swashbuckle.AspNetCore; do \
      dotnet add package "$pkg" >/dev/null 2>&1 || true; \
    done && cd / && rm -rf /tmp/warm-net

COPY shared/runner-user.sh /tmp/runner-user.sh
RUN chmod +x /tmp/runner-user.sh && /tmp/runner-user.sh && rm /tmp/runner-user.sh

WORKDIR /workspace
USER runner

COPY dotnet/8/smoke.sh /smoke.sh
LABEL org.opencontainers.image.source="https://github.com/rehearse-sh/images" \
      org.opencontainers.image.title="rehearse-pro/dotnet:8-warm" \
      org.opencontainers.image.description=".NET 8 SDK with warmed NuGet cache."
