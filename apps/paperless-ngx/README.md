# Paperless-ngx

Based on the `docker-compose.postgres.yml` in the [paperless-ngx github repo](https://github.com/paperless-ngx/paperless-ngx/tree/main/docker/compose)

## Requirements

* NGINX ingress controller
* Metallb load balancer
* Longhorn storage provider
* External psql db such as CNPG
* DNS entry for docs.bugaychuk.com
  * Change to your preferred domain in the deployment.yaml
