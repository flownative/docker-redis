#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

export DEBIAN_FRONTEND=noninteractive

# Modify the existing user and group "redis":

groupmod --gid 1000 redis
usermod --uid 1000 --gid 1000 --shell /usr/sbin/nologin --home "${REDIS_BASE_PATH}" redis

mkdir -p \
    "${REDIS_BASE_PATH}/etc" \
    "${REDIS_BASE_PATH}/bin" \
    "${REDIS_BASE_PATH}/tmp" \
    /var/lib/redis

mv /etc/redis/redis.conf "${REDIS_BASE_PATH}/etc/redis-default.conf"
mv /usr/bin/redis* "${REDIS_BASE_PATH}/bin/"

# Remove what the Debian package ships for running Redis as a system service;
# the entrypoint starts the server directly:
rm -rf \
    /etc/redis \
    /etc/default/redis-server \
    /etc/init.d/redis-server \
    /etc/logrotate.d \
    /usr/lib/systemd/system/redis-server.service \
    /usr/lib/systemd/system/redis-server@.service \
    /var/log/redis

# The base image ships supervisor, syslog-ng, logrotate and anacron for images
# running several processes. Redis is the only process here and logs to
# stdout, so they and the Python runtime behind Supervisor can go. Perl is
# purged last, because the maintainer scripts of the other packages still
# need it; nothing is built on top of this image:
apt-get purge -y supervisor syslog-ng-core logrotate anacron
apt-get autoremove --purge -y
apt-get purge -y --allow-remove-essential perl-base
rm -f /usr/bin/apt*
rm -f /usr/bin/debconf*
rm -rf "${SUPERVISOR_BASE_PATH}" "${SYSLOG_BASE_PATH}" "${LOGROTATE_BASE_PATH}"

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
chown redis:redis "${REDIS_BASE_PATH}/tmp"
