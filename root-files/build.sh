#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Modify the existing user and group "redis":

groupmod --gid 1000 redis
usermod --uid 1000 --gid 1000 --shell /usr/sbin/nologin --home "${REDIS_BASE_PATH}" redis

mkdir -p \
    "${REDIS_BASE_PATH}/etc" \
    "${REDIS_BASE_PATH}/bin" \
    /var/lib/redis

mv /etc/redis/redis.conf "${REDIS_BASE_PATH}/etc/redis-default.conf"
mv /usr/bin/redis* "${REDIS_BASE_PATH}/bin/"

chown -R root:root "${REDIS_BASE_PATH}"
chmod -R g+rwX "${REDIS_BASE_PATH}"

# The data directory must be writable by the redis daemon (uid 1000), otherwise
# RDB snapshotting fails with a MISCONF error as soon as persistence is enabled.
# In Kubernetes this path is usually masked by a (world-writable) emptyDir volume,
# but standalone (e.g. Local Beach) the image-internal directory is used.
chown -R redis:redis /var/lib/redis
chmod -R 755 /var/lib/redis

chmod 664 "${REDIS_BASE_PATH}/etc/redis-default.conf"
chown redis:redis "${REDIS_BASE_PATH}/etc/redis-default.conf"
chmod 775 "${REDIS_BASE_PATH}/etc"
chown redis:redis "${REDIS_BASE_PATH}/etc"
