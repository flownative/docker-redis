FROM registry.gitlab.com/flownative/docker/base:1
MAINTAINER Robert Lemke <robert@flownative.com>

# See: https://launchpad.net/~chris-lea/+archive/ubuntu/redis-server?field.series_filter=bionic
ENV REDIS_VERSION 5:5.0.7-1chl1~bionic1

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
