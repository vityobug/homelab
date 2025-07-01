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

## Environment Variables

All necessary environment variables, including database credentials,
are stored separately in `secrets.yaml`. This file defines Kubernetes Secrets,
ensuring sensitive information is managed securely.
These secrets should be stored in Vault before deploying the application.

Ensure proper access control is in place to protect these secrets.

## Deployment

### Initialization and Health Checks

* The ROMM deployment includes an init container that checks if the database is
ready before starting the main application.

* The database deployment has both liveness and readiness probes to ensure it
remains operational and accessible.

Use ArgoCD to deploy the app by pointing to the dir in the git repo.
Or deploy manually using the following commands:

```sh
kubectl apply -f secrets.yaml
kubectl apply -f database.yaml
kubectl apply -f deployment.yml
```

Ensure that the NFS share is properly configured and accessible by
the Kubernetes nodes to prevent storage access issues.
