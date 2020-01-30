#!/bin/bash
# shellcheck disable=SC1090

# =======================================================================================
# LIBRARY: REDIS
# =======================================================================================

# Load helper lib

. "${FLOWNATIVE_LIB_PATH}/log.sh"
. "${FLOWNATIVE_LIB_PATH}/files.sh"
. "${FLOWNATIVE_LIB_PATH}/validation.sh"

# ---------------------------------------------------------------------------------------
# redis_env() - Load global environment variables for configuring Redis
#
# @global REDIS_* The REDIS_ evnironment variables
# @return Export statements which can be passed to eval()
#
redis_env() {
    cat <<"EOF"
export REDIS_BASE_PATH="${REDIS_BASE_PATH}"
export REDIS_CONF_PATH="${REDIS_CONF_PATH:-${REDIS_BASE_PATH}/etc}"
export REDIS_DATABASES="${REDIS_DATABASES:-50}"
export REDIS_MAXMEMORY="${REDIS_MAXMEMORY:-150mb}"
export REDIS_MAXMEMORY_POLICY="${REDIS_MAXMEMORY_POLICY:-allkeys-lru}"
export REDIS_DAEMON_USER="redis"
export REDIS_DAEMON_GROUP="redis"
export REDIS_DISABLE_COMMANDS="${REDIS_DISABLE_COMMANDS:-}"
export REDIS_PASSWORD="${REDIS_PASSWORD:-}"
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
EOF
    if [[ -f "${REDIS_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export REDIS_PASSWORD="$(< "${REDIS_PASSWORD_FILE}")"
EOF
    fi
}

# ---------------------------------------------------------------------------------------
# redis_conf_set() - Set a configuration option in redis.conf
#
# @global REDIS_CONF_PATH Full path leading to the directory containing redis.conf
# @arg $1 Name of the configuration option
# @arg $2 New value of the option
# @return void
#
redis_conf_set() {
    local name="${1:?missing option name}"
    local value="${2:-}"

    value="${value//\\/\\\\}"
    value="${value//\?/\\?}"
    value="${value//&/\\&}"
    [[ "$value" == "" ]] && value="\"$value\""

    if [ "${name}" == "requirepass" ]; then
        debug "Configuration: Setting '$name' to <redacted>"
    else
        debug "Configuration: Setting '$name' to '$value'"
    fi
    sed -i "s?^#*\s*$name .*?$name $value?g" "${REDIS_CONF_PATH}/redis.conf"
}

# ---------------------------------------------------------------------------------------
# redis_unset_conf() - Unset a configuration option in redis.conf
#
# @global REDIS_CONF_PATH Full path leading to the directory containing redis.conf
# @arg $1 Name of the configuration option to unset
# @return void
#
redis_conf_unset() {
    local name="${1:?missing option name}"
    debug "Configuration: Unsetting '$name'"
    sed -i "s?^\s*$name .*??g" "${REDIS_CONF_PATH}/redis.conf"
}

# ---------------------------------------------------------------------------------------
# redis_conf_validate() - Validates configuration options passed as REDIS_* env vars
#
# @global REDIS_* The REDIS_* environment variables
# @return void
#
redis_conf_validate() {
    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        warn "The environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD} is enabled. Please do not use this flag in production."
    elif [ -z "${REDIS_PASSWORD}" ]; then
        error "The REDIS_PASSWORD environment variable is empty or not set. Either set the variable ALLOW_EMPTY_PASSWORD=yes to allow Redis to be started without a password."
        exit 1
    fi
}

# ---------------------------------------------------------------------------------------
# redis_initialize() - Initialize Redis configuration and check required files and dirs
#
# @global REDIS_* The REDIS_* environment variables
# @return void
#
redis_initialize() {
    info "Initializing Redis ..."

    rm -f "${REDIS_BASE_PATH}/tmp/redis.pid"
    file_move_if_exists "${REDIS_CONF_PATH}/redis-default.conf" "${REDIS_CONF_PATH}/redis.conf"

    redis_conf_validate

    redis_conf_set logfile ""
    redis_conf_set pidfile "${REDIS_BASE_PATH}/tmp/redis.pid"
    redis_conf_set daemonize yes
    redis_conf_set bind 0.0.0.0

    redis_conf_set maxmemory "${REDIS_MAXMEMORY}"
    redis_conf_set maxmemory-policy "${REDIS_MAXMEMORY_POLICY}"
    redis_conf_set databases "${REDIS_DATABASES}"
    redis_conf_unset save
    if [[ -n "${REDIS_PASSWORD}" ]]; then
        redis_conf_set requirepass "${REDIS_PASSWORD}"
    else
        redis_conf_unset requirepass
    fi
}
