#!/bin/bash -e

echo never > /sys/kernel/mm/transparent_hugepage/enabled

envsubst < /etc/redis/redis.conf.template > /etc/redis/redis.conf
