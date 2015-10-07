FROM flownative/base:latest
MAINTAINER Robert Lemke <robert@flownative.com>

RUN add-apt-repository ppa:chris-lea/redis-server \
    && apt-get update \
    && apt-get install -y redis-server \
    && rm -rf /var/lib/apt/lists/*

COPY redis-run.sh /redis-run.sh
RUN chmod u=rwx /redis-run.sh
COPY redis.conf /etc/redis/redis.conf
COPY redis-sentinel.conf /etc/redis/redis-sentinel.conf

CMD /bin/bash -c "/redis-run.sh ${SENTINEL_HOST} ${SENTINEL_PORT}"
