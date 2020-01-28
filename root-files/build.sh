#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

mkdir -p \
    "${REDIS_BASE_PATH}/etc" \
    "${REDIS_BASE_PATH}/bin" \
    /var/lib/redis

mv /etc/redis/redis.conf "${REDIS_BASE_PATH}/etc/redis-default.conf"
mv /usr/bin/redis* "${REDIS_BASE_PATH}/bin/"

chown -R root:root "${REDIS_BASE_PATH}"
chmod -R g+rwX "${REDIS_BASE_PATH}"
chmod 664 "${REDIS_BASE_PATH}/etc/redis-default.conf"

chown -R root:root /var/lib/redis
chmod -R g+rwX /var/lib/redis
