# Kubernetes Homelab

This repository documents my **highly-available Kubernetes lab**, designed
for self-hosted services. The cluster consists of **3 master nodes and
3 worker nodes**, using **Calico** for networking and **Longhorn** for storage.
Longhorn replicates storage across all three worker nodes, ensuring redundancy.
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

* **Bazarr** – Subtitle management for media libraries.
* **Jellyfin** – Open-source media server for streaming content.
* **Jellyseer** – Web-based request management for media downloads.
* **Lidarr** – Music collection manager for automatic downloads.
* **Prowlarr** – Indexer manager for media search and automation.
* **Radarr** – Movie collection manager with automation.
* **Romm** – A self-hosted ROM manager that scans, enriches,
and organizes game collections for emulators.
* **Sonarr** – TV show collection manager with automation.

## Future Plans

Currently, several applications are running in Docker inside LXC on Proxmox,
and the plan is to migrate them to this Kubernetes cluster over time. These include:

* **Nextcloud** for file synchronization
* **Immich** for photo and video management
* **Paperless** for document archiving
* An internal **email server** for notifications
* Private GitOps for automation
* A self-hosted password manager (**Bitwarden**)

Monitoring will remain separate for now, with Zabbix running on a
dedicated VM. In the future, I plan to explore Grafana and
**Prometheus** for observability.

This lab setup is a work in progress, evolving as
I refine the infrastructure and configurations.
