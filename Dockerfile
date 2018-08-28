FROM eu.gcr.io/flownative-beach/base:0.10.2-1
MAINTAINER Robert Lemke <robert@flownative.com>

ENV REDIS_VERSION 5:4.0.11-1chl1~xenial1

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
