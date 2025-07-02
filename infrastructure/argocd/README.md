# Argo CD with HashiCorp Vault Plugin

## Installation

1. Create a secret for Vault Integration

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: vault-configuration
  namespace: argocd
data:
  VAULT_ADDR: aHR0cDovL3ZhdWx0LmRlZmF1bHQ6ODIwMA==
  VAULT_TOKEN: aHZzLkRQekVyQnFQaVQ2clRhSnA4WVUyZUFkVg==
  AVP_TYPE: dmF1bHQ=
  AVP_AUTH_TYPE: dG9rZW4=
type: Opaque
```

2. Apply the configs and install ArgoCD using Helm

```
kubectl create ns argocd
kubectl apply -f secret.yaml -n argocd
kubectl apply -f avp-cm.yaml -n argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd -n argocd -f values.yaml
```

3. Create an Ingress with MetalLB

```
kubectl apply -f ./ingress.yaml
```
