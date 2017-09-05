#!/bin/bash -e

export REDIS_DATABASES=${REDIS_DATABASES:-50}
export REDIS_MAX_MEMORY=${REDIS_MAX_MEMORY:-157286400}
export REDIS_PASSWORD=${REDIS_PASSWORD:-password}

. init.sh

exec redis-server /etc/redis/redis.conf
