# Paperless-ngx

Based on the `docker-compose.postgres.yml` in the [paperless-ngx github repo](https://github.com/paperless-ngx/paperless-ngx/tree/main/docker/compose)

## Requirements

* NGINX ingress controller
* Metallb load balancer
* Longhorn storage provider
* External psql db such as CNPG
* DNS entry for external access, such as `docs.bugaychuk.com`

## Backup and restore database

* Backup using `kubectl apply -f db-backup.yaml`
* Restore using `kubectl apply -f db-restore.yaml`

### Manually backup database

* `kubectl port-forward -n restricted svc/cluster-paperless-rw 5432:5432`
  * Or expose the service on the worker
* `pg_dump -h localhost -p 5432 -d paperless -U postgres -F c -f paperless.dump`

### Restore

* On the new machine expose the service as before
* `dropdb -h localhost -p 5432 -U postgres paperless`
* `createdb -h localhost -p 5432 -U postgres paperless`
* `pg_restore -h localhost -p 5432 -U postgres -d paperless -v paperless.dump`

## To setup

* Create the secrets with `kubectl apply -f secrets.yaml`
* Create the db using `kubectl apply -f db-create.yaml`
* Create the deployment, services, PVCs and ingress - `kubectl apply -f deployment.yaml`

## Notes

`migrate-data.yml` I used this to migrate data from docker volumes to the paperless PVCs.
