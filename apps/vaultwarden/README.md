# Vaultwarden

Bitwarden compatible password manager
Based on the `docker-compose` in the [Vaultwarden github repo](https://github.com/dani-garcia/vaultwarden)

## Requirements

* NGINX ingress controller
* Metallb load balancer
* Longhorn storage provider
* DNS entry for bitwarden.bugaychuk.com
  * Change to your preferred domain in the deployment.yaml
