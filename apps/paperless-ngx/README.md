# Paperless-ngx

Based on the `docker-compose.postgres.yml` in the [paperless-ngx github repo](https://github.com/paperless-ngx/paperless-ngx/tree/main/docker/compose)

## Requirements

* NGINX ingress controller
* Metallb load balancer
* Longhorn storage provider
* External psql db such as CNPG
* DNS entry for external access, such as `docs.bugaychuk.com`

## Backup and restore database

* *Currently Removed from Git*
* Backup using `kubectl apply -f db-backup.yaml`
* Restore using `kubectl apply -f db-restore.yaml`
* Re-add the backup parameters to the cluster `k edit cluster -n restricted paperless-cluster`

### Backup using the CNPG built-in backup

```yaml
  backup:
    barmanObjectStore:
      destinationPath: s3://databases/paperless
      endpointURL: https://gateway.storjshare.io
      s3Credentials:
        accessKeyId:
          name: backup-creds
          key: ACCESS_KEY_ID
        secretAccessKey:
          name: backup-creds
          key: ACCESS_SECRET_KEY
      data:
        compression: gzip
        encryption: AES256
        immediateCheckpoint: false
        jobs: 2
    retentionPolicy: "60d"

```

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
I disabled WAL archiving because PSQL throws an error when attempting to upload the archive to STORJ's S3
For now I'll perform only manual backups, as I do not write too much data.

* Made some changes to the manifests so I can use this in ArgoCD
