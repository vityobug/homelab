# MetalLB installation instructions

This one's a must if you have a bear metal cluster and you have
resources that you need to expose.

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml
kubectl apply -f config.yml
```

References:
[MetalLB Installation](https://metallb.io/installation/)
