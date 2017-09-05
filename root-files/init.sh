#!/bin/bash -e

envsubst < /etc/redis/redis.conf.template > /etc/redis/redis.conf
