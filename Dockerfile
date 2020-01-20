FROM docker.pkg.github.com/flownative/docker-base/base:1
MAINTAINER Robert Lemke <robert@flownative.com>

LABEL org.label-schema.name="Beach Redis"
LABEL org.label-schema.description="Docker image providing Redis for Beach instances"
LABEL org.label-schema.vendor="Flownative GmbH"

# -----------------------------------------------------------------------------
# Redis
# Latest versions: https://launchpad.net/~chris-lea/+archive/ubuntu/redis-server?field.series_filter=bionic

ARG REDIS_VERSION
ENV REDIS_VERSION ${REDIS_VERSION}


RUN add-apt-repository ppa:chris-lea/redis-server \
    && apt-get update \
    && apt-get install -y redis-server=${REDIS_VERSION}  \
    && rm -rf /var/lib/apt/lists/*

COPY redis-run.sh /redis-run.sh
RUN chmod u=rwx /redis-run.sh
COPY redis.conf.template /etc/redis/redis.conf.template
COPY redis-sentinel.conf /etc/redis/redis-sentinel.conf
COPY root-files /

EXPOSE 6379

ENTRYPOINT ["/entrypoint.sh"]
