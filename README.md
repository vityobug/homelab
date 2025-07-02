# Kubernetes Homelab

This repository documents my **highly-available Kubernetes lab**, designed
for self-hosted services. The cluster consists of **3 master nodes and
3 worker nodes**, using **Calico** for networking and **Longhorn** for storage.
Longhorn replicates storage ensuring redundancy and manages backups.
If space is a concern you can use a separate node for NFS target which will
store the data for all tree nodes. Just make sure there is some kind of RAID.
Large files, such as ISOs and media files, are stored on an **NFS share**.
Ingress is managed by **NGINX Ingress Controller** and **MetalLB** for
external IP allocation.

While many deployed applications are not HA-compatible, they can be torn down
and recreated as needed due to persistent storage.

To recreate the environment use the instructions in clusters/terraform and
configs from clusters/ha-configs. The topology and more details are
available in the terraform README.md.

## Deployed Applications

The following application are deployed in the cluster using ArgoCD

* Vaultwarden - Bitwarden compatible password manager
* Paperless-ngx - Open-source document management system
* RomM - Games library manager (like jellyfin is for media)
* Nextcloud - FOSS Alternative to Google Drive, Calendar, Notes and MS Teams

## Future Plans

Currently, several applications are running in Docker inside LXC on Proxmox,
and the plan is to migrate them to this Kubernetes cluster over time. These include:

* **Immich** for photo and video management
* An internal **email server** for notifications

Monitoring will remain separate for now, with Zabbix running on a
dedicated VM. In the future, I plan to explore Grafana and
**Prometheus** for observability. As well as ELK for logging.

This lab setup is a work in progress, evolving as
I refine the infrastructure and configurations.
