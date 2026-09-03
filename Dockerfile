FROM harbor.flownative.io/docker/base:trixie-slim

LABEL org.opencontainers.image.authors="Robert Lemke <robert@flownative.com>"
LABEL org.opencontainers.image.base.name="harbor.flownative.io/docker/base:trixie-slim"

LABEL org.label-schema.name="Beach Redis"
LABEL org.label-schema.description="Docker image providing Redis for Beach instances"
LABEL org.label-schema.vendor="Flownative GmbH"

# -----------------------------------------------------------------------------
# Redis
# Latest versions: https://packages.debian.org/trixie/redis-server

ENV REDIS_VERSION="5:8.0.2-3+deb13u2" \
    REDIS_BASE_PATH=/opt/flownative/redis \
    PATH="/opt/flownative/redis/bin:$PATH" \
    LOG_DEBUG=false

USER root
COPY root-files /

# Installation and build script share one layer, so the files build.sh moves
# and chowns are not stored twice:
RUN install_packages \
        redis-server=${REDIS_VERSION} \
        redis-tools=${REDIS_VERSION} \
    && /build.sh \
    && rm /build.sh

EXPOSE 6379

USER 1000
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "run" ]
