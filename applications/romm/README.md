# ROMM

## Overview

ROMM is an application designed to manage and organize games efficiently.
It provides a structured way to handle ROM metadata, images, and database
records while ensuring seamless access to ROMs stored on a networked file system.

## Storage Architecture

* Database & Metadata: Stored locally on each Kubernetes node, ensuring
quick access and efficient processing.

* Images: Stored locally alongside metadata to optimize retrieval speed.

* ROM Files: Stored on an NFS share, providing a centralized location for
larger files and ensuring easy access from multiple nodes.

## Persistent Storage Configuration

The ROMM application relies on Kubernetes Persistent Volumes (PVs) and
Persistent Volume Claims (PVCs) to manage its storage needs.
These are defined in the following configuration files:

* pv.yml – Defines the Persistent Volume (PV) for ROM storage.

* pvc.yml – Defines the NFS Persistent Volume Claim (PVC) used by the application.

## Environment Variables

All necessary environment variables, including database credentials,
are stored separately in `romm-secrets.yml`. This file defines Kubernetes Secrets,
ensuring sensitive information is managed securely.
These secrets should be applied before deploying the application:

`kubectl apply -f romm-secrets.yml`

Ensure proper access control is in place to protect these secrets.

## Deployment

### Initialization and Health Checks

* The ROMM deployment includes an init container that checks if the database is ready before starting the main application.

* The database deployment has both liveness and readiness probes to ensure it remains operational and accessible.

To ensure proper resource allocation, apply the Secrets, PV and PVC configurations
before deploying the ROMM application:

kubectl apply -f secrets.yml
kubectl apply -f pv.yml
kubectl apply -f pvc.yml
kubectl apply -f deploy-db.yml
kubectl apply -f deploy-romm.yml

Ensure that the NFS share is properly configured and accessible by
the Kubernetes nodes to prevent storage access issues.
