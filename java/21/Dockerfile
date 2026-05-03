FROM eclipse-temurin:21-jdk

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=UTC

RUN apt-get update && apt-get -y upgrade && apt-get install -y --no-install-recommends \
      git curl ca-certificates jq make maven gradle \
    && rm -rf /var/lib/apt/lists/*

COPY shared/runner-user.sh /tmp/runner-user.sh
RUN chmod +x /tmp/runner-user.sh && /tmp/runner-user.sh && rm /tmp/runner-user.sh

WORKDIR /workspace
USER runner

COPY java/21/smoke.sh /smoke.sh
LABEL org.opencontainers.image.source="https://github.com/plsft/rehearse-images" \
      org.opencontainers.image.title="rehearse-pro/java:21-warm" \
      org.opencontainers.image.description="Temurin JDK 21 + Maven + Gradle for CI."
