# Longhorn for Kubernetes

Longhorn is a lightweight, reliable, and easy-to-use distributed block storage system for Kubernetes.

## Deployment

Longhorn should be deployed using Helm. Ensure you have Helm installed before proceeding.

### Install Longhorn

```sh
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm upgrade --install longhorn longhorn/longhorn \
  -f values.yaml \
  --namespace longhorn-system --create-namespace
```

## Configure Ingress

An ingress configuration is available in ingress.yaml. Apply it after deployment:

```
kubectl apply -f ingress.yaml
```

## Notes

* Modify values.yaml to customize the installation.

* Ensure your cluster meets Longhorn’s requirements. (such as NFS or iSCSI)

* Check Longhorn UI and services after deployment.
