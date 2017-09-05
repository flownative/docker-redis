#!/bin/bash

READINESS=0
LIVENESS=0

if [ ! -z $1 ]; then
    [ $1 == "--readiness" ] && READINESS=1
    [ $1 == "--liveness" ] && LIVENESS=1
fi

return_ok()
{
    exit 0
}
return_fail()
{
    exit 1
}

status=0
if [ `redis-cli -a ${REDIS_PASSWORD} PING | grep PONG` ]; then
    return_ok
fi

return_fail
