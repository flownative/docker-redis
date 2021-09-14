[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Maintenance level: Love](https://img.shields.io/badge/maintenance-%E2%99%A1%E2%99%A1%E2%99%A1-ff69b4.svg)](https://www.flownative.com/en/products/open-source.html)

# Flownative Redis Image

A Docker image providing Redis for [Beach](https://www.flownative.com/beach),
[Local Beach](https://www.flownative.com/localbeach) and other purposes.

## Configuration

### Environment variables

| Variable Name              | Type    | Default                   | Description                                    |
|:---------------------------|:--------|:--------------------------|:-----------------------------------------------|
| REDIS_BASE_PATH            | string  | /opt/flownative/redis     | Base path for Redis (read-only)                |
| REDIS_CONF_PATH            | string  | /opt/flownative/redis/etc | Configuration path for Redis (read-only)       |
| REDIS_DATABASES            | integer | 50                        | Maximum number of databases                    |
| REDIS_MAXMEMORY            | string  | 150mb                     | Maximum memory                                 |
| REDIS_MAXMEMORY_POLICY     | string  | allkeys-lru               | Policy for dealing with exhausted memory limit |
| REDIS_DAEMON_USER          | string  | redis                     | Username for Redis daemon (read-only)          |
| REDIS_DAEMON_GROUP         | string  | redis                     | Group for Redis daemon (read-only)             |
| REDIS_DISABLE_COMMANDS     | string  |                           | A list of commands to disable                  |
| REDIS_PASSWORD             | string  |                           | A clear text password for Redis authentication |
| REDIS_ALLOW_EMPTY_PASSWORD | boolean | false                     | If Redis may start without a password set      |

## Helm Chart

This Git repository also contains a Helm chart which can be used to
deploy Redis using this Docker image.

| Value Name                      | Type     | Default                 | Description                                                |
|:--------------------------------|:---------|:------------------------|:-----------------------------------------------------------|
| deployment.revisionHistoryLimit | integer  | 1                       | Number of revisions to keep of deployments                 |
| resources.requests.cpu          | string   | 50m                     | Requested CPU resources                                    |
| resources.requests.memory       | string   | 128Mi                   | Requested memory                                           |
| resources.limit.cpu             | string   | 1                       | Limit for CPU usage                                        |
| resources.limit.memory          | string   | 128Mi                   | Limit for memory usage                                     |
| image.pullSecrets               | string[] |                         | Optional array of secret names containing credentials      |
| image.registry                  | string   | docker.io               | Registry providing the Redis image                         |
| image.repository                | string   | flownative/redis        | Repository and image name of the Redis image               |
| image.tag                       | string   | {{ .Chart.AppVersion }} | Tag of the Redis image                                     |
| image.pullPolicy                | string   | Always                  | Pull policy for the Redis image                            |
| redis.maxMemory                 | integer  | 50000000                | Maximum memory for Redis                                   |
| redis.password                  | integer  |                         | A clear text password for Redis authentication             |
| redis.credentialsSecret         | string   |                         | Name of a secret containing the password (key: "password") |

## Building this image

Check the latest stable release on the tool's respective websites:

- Redis: https://packages.debian.org/buster/redis-server

## Security

Some draft notes about security:

- the container can (and should) be started with
  `--security-opt=no-new-privileges`
- in Kubernetes, the
  [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
  should be configured with `allowPrivilegeEscalation: false`
- this repository contains a work-in-progress
  [seccomp](https://docs.docker.com/engine/security/seccomp/) profile
  which may work but is not ready for production yet
