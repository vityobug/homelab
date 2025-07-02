# MetalLB installation instructions

This one's a must if you have a bare metal cluster and you have
resources that you need to expose.

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml
kubectl apply -f k8s-config.yaml
```

References:
[MetalLB Installation](https://metallb.io/installation/)

### How to install in k3s

* Place the k3s yaml in the `/var/lib/rancher/k3s/server/manifests` dir.
