#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Load lib
. "${FLOWNATIVE_LIB_PATH}/banner.sh"
. "${FLOWNATIVE_LIB_PATH}/redis.sh"

banner_flownative REDIS

eval "$(redis_env)"

if [[ "$*" = *"run"* ]]; then
    redis_initialize
    exec redis-server "${REDIS_CONF_PATH}/redis.conf" --daemonize no
else
    "$@"
fi
