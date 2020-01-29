# Flownative Redis Image

A Docker image providing Redis for [Beach](https://www.flownative.com/beach),
[Local Beach](https://www.flownative.com/localbeach) and other purposes.

## Building this image

Build this image with `docker build`. You need to specify the desired version for some
of the tools as build arguments:

```bash
docker build \
    --build-arg REDIS_VERSION=5:5.0.3-4+deb10u1 \
    -t flownative/redis:latest .
```

Check the latest stable release on the tool's respective websites:
 
- Redis: https://packages.debian.org/buster/redis-server

## Security

Some draft notes about security:

- the container can (and should) be started with `--security-opt=no-new-privileges`
- in Kubernetes, the [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) should be configured with `allowPrivilegeEscalation: false`
- this repository contains a work-in-progress [seccomp](https://docs.docker.com/engine/security/seccomp/) profile which may work but is not ready for production yet
