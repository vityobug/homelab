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

* Can be installed by pointing to the repo dir with ArgoCD
