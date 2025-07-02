# NGINX ingress controller

* Install using Helm:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
kubectl get pods --namespace=ingress-nginx
```

* Upgrade:

```bash
helm upgrade ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --version <version>
```

* In k3s place the k3s yaml in `/var/lib/rancher/k3s/server/manifests` and restart the k3s service.
