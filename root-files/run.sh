#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Load library
. "${FLOWNATIVE_LIB_PATH}/redis.sh"

# Load Redis environment variables
eval "$(redis_env)"

exec redis-server "${REDIS_CONF_PATH}/redis.conf" --daemonize no
