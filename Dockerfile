FROM europe-docker.pkg.dev/flownative/docker/base:bullseye

LABEL org.opencontainers.image.authors="Robert Lemke <robert@flownative.com>"

LABEL org.label-schema.name="Beach Redis"
LABEL org.label-schema.description="Docker image providing Redis for Beach instances"
LABEL org.label-schema.vendor="Flownative GmbH"

# -----------------------------------------------------------------------------
# Redis
# Latest versions: https://packages.debian.org/bullseye/redis-server

ENV FLOWNATIVE_LIB_PATH=/opt/flownative/lib \
    REDIS_VERSION="5:6.0.16-1+deb11u2" \
    REDIS_BASE_PATH=/opt/flownative/redis \
    PATH="/opt/flownative/redis/bin:$PATH" \
    LOG_DEBUG=false

USER root
COPY --from=europe-docker.pkg.dev/flownative/docker/bash-library:1 /lib $FLOWNATIVE_LIB_PATH

RUN install_packages \
    ca-certificates \
    redis-server=${REDIS_VERSION} \
    redis-tools=${REDIS_VERSION}

COPY root-files /
RUN /build.sh

EXPOSE 6379

USER 1000
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "run" ]
