#!/bin/bash

# Modified version originally taken from https://github.com/UKHomeOffice/docker-redis

: ${SENTINEL_HOST:=${1}}
: ${SENTINEL_PORT:=${2}}


find_master() {
  if [[ -z ${SENTINEL_HOST} ]] || [[ -z ${SENTINEL_PORT} ]]; then
    echo "Seems that we're bootstrapping initially.."
    return 2
  fi
  counter=0
  while [[ ${counter} -lt 3 ]]; do
    master=$(redis-cli -h ${SENTINEL_HOST} -p ${SENTINEL_PORT} --csv SENTINEL get-master-addr-by-name mymaster | awk -F',' '{print $1}')
    if [[ -n ${master} ]]; then
      master="${master//\"}"

      redis-cli -h ${master} INFO
      if [[ "$?" == "0" ]]; then
        echo "Master found: ${master}"
        return 0
      fi

    fi
    counter=$((${counter} + 1))
    sleep ${1}
  done
    echo "Failed to find master.."
    return 1
}


start_master() {
  exec redis-server /etc/redis/redis.conf
}


start_sentinel() {
  find_master 10
  if [[ $? == '2' ]]; then
    master=$(hostname -i)
  fi
  sed "s/%MASTER%/${master}/" -i /etc/redis/redis-sentinel.conf
  exec redis-sentinel /etc/redis/redis-sentinel.conf
}

start_slave() {
  echo "slaveof ${master} 6379" >> /etc/redis/redis.conf
  exec redis-server /etc/redis/redis.conf
}


if [[ ${SENTINEL} == "true" ]]; then
  echo "Starting redis sentinel"
  start_sentinel
fi

find_master 30
if [[ -n ${master} ]] && [[ $? == '0' ]]; then
  echo "Starting redis slave"
  start_slave
else
  echo "Starting redis master"
  start_master
fi
