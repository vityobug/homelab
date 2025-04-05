# Install NextCloud All in One

```bash
```

helm install nextcloud-aio nextcloud-aio/nextcloud-aio-helm-chart -f nextcloud-values.yaml

```
```

In my case the DB pod was failing. I resolved it by fixing the permissions on the NFS server which hosts the PV.
For referrence: [Nextcloud Helm Charts](https://github.com/nextcloud/helm)
