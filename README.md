# Flownative Beach Redis Image

A Docker image providing Redis for [Beach](https://www.flownative.com/beach) and [Local Beach](https://www.flownative.com/localbeach).

## Building this image

Build this image with `docker build`. You need to specify the desired version for some
of the tools as build arguments:

```bash
docker build \
    --build-arg REDIS_VERSION=5:5.0.7-1chl1~bionic1 \
    -t flownative/beach-redis:latest .
```

Check the latest stable release on the tool's respective websites:
 
- Redis: https://launchpad.net/~chris-lea/+archive/ubuntu/redis-server?field.series_filter=bionic
