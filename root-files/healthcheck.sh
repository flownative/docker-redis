#!/bin/bash

# Liveness and readiness probe: succeeds when Redis answers a PING. The
# password reaches redis-cli through the environment, so it never shows up
# in the process list. Both probe types (--liveness, --readiness) run the
# same check.

set -o nounset

if [[ -z "${REDIS_PASSWORD:-}" && -f "${REDIS_PASSWORD_FILE:-}" ]]; then
    REDIS_PASSWORD="$(< "${REDIS_PASSWORD_FILE}")"
fi
if [[ -n "${REDIS_PASSWORD:-}" ]]; then
    export REDISCLI_AUTH="${REDIS_PASSWORD}"
fi

redis-cli PING 2>/dev/null | grep -q PONG
