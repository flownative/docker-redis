#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Load lib
. "${FLOWNATIVE_LIB_PATH}/redis.sh"

eval "$(redis_env)"

if [[ "$*" = *"/run.sh"* ]]; then
    redis_initialize
fi

echo ""
exec "$@"
