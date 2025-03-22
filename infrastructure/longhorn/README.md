# Longhorn for Kubernetes

Longhorn is a lightweight, reliable, and easy-to-use distributed block storage system for Kubernetes.

## Deployment

Longhorn should be deployed using Helm. Ensure you have Helm installed before proceeding.

### Install Longhorn

```sh
helm install longhorn longhorn/longhorn \
  --namespace longhorn-system \
  --create-namespace \
  --values values.yml
```

## Configure Ingress

An ingress configuration is available in ingress.yaml. Apply it after deployment:

`kubectl apply -f ingress.yml`

## Notes

* Modify values.yml to customize the installation.

* Ensure your cluster meets Longhorn’s requirements. (such as NFS or iSCSI)

* Check Longhorn UI and services after deployment.
