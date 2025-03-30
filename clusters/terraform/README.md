# High Availability Kubernetes Cluster on Ubuntu 24.04 using Terraform

## Overview

This guide is step-by-step instructions to deploy a highly available Kubernetes
 cluster on Ubuntu 24.04 using Terraform on Proxmox in my lab.
VMs are provisioned with cloud-init Ubuntu images. The topology can be
visualised as follows.

┌───────────────────────────────────────────────────────────────┐
│ PVE                                                           │
│ ┌──────────────┐      ┌───────────────┐     ┌───────────────┐ │
│ │  master-121  │      │   master-122  │     │   master-123  │ │
│ │ 172.31.31.121│      │ 172.31.31.122 │     │ 172.31.31.123 │ │
│ └──────────────┴──────┴───────┬───────┴─────┴───────────────┘ │
│                               │                               │
│             ┌─────────────────▼───────────────────┐           │
│             │ ┌──────────┐          ┌──────────┐  │           │
│             │ │ HAproxy1 │          │ HAproxy2 │  │           │
│             │ └──────────┘          └──────────┘  │           │
│             │                                     │           │
│             │        VRRP IP: 172.31.31.210       │           │
│       ┌─────┴─────────┬───────────────┬───────────┘           │
│       │               │               │                       │
│┌──────▼──────┐ ┌──────▼──────┐ ┌──────▼──────┐ ┌─────────────┐│
││ worker-131  │ │ worker-132  │ │  worker-133 │ │ storage-134 ││
││172.31.31.131│ │172.31.31.132│ │172.31.31.133│ │172.31.31.134││
│└─────┬───────┘ └──────┬──────┘ └──────┬──────┘ └───────▲─────┘│
│      │                │               │                │      │
│      │                │               │                │      │
│      └────────────────┴───────────────┴────────────────┘      │
│                                                               │
└───────────────────────────────────────────────────────────────┘

The cluster consists of:

- 2 HAProxy nodes for load balancing
- 3 control-plane nodes
- 3 worker nodes

## Prerequisites

- Proxmox server with sufficient resources
- Terraform installed on your local machine
- SSH key pair for authentication

---

## Step 1: Define Terraform Environment Variables

Export the necessary Terraform variables for Proxmox authentication:

```bash
export TF_VAR_PVE_URL="https://172.16.21.222:8006/"
export TF_VAR_PVE_PASSWORD='superpassword'
export TF_VAR_PVE_USERNAME='root@pam'
```

---

## Step 2: Modify `resources.tf`

Customize the Terraform configuration by modifying `resources.tf`:

- Copy your public SSH key (`id_rsa.pub`) to ./files/.
- Adjust the number of control-plane (`master_vm`) nodes if needed.
- Ensure VM IDs match the last octet of the IP address (e.g., `172.31.31.121` → `master-121`).
- Modify CPU, memory, disk, and IP configurations as necessary.
- Set `user_account` to match your username.
- Update `datastore_id` to match the Proxmox storage ID.

---

## Step 3: Deploy the Cluster with Terraform

Run the following commands to deploy the VMs:

```bash
terraform plan
```

Review the output, and if everything looks correct, apply the changes:

```bash
terraform apply
```

This will create:

- 3 control-plane nodes
- 2 worker nodes
- 2 HAProxy nodes
- 1 Shared storage (TODO: Add Terraform code.
To save space when all VMs are on the same host)

---

## Step 4: Connect to the Nodes

Once the VMs are created, connect via SSH using the configured private key:

```bash
ssh -i ~/.ssh/id_rsa your_user@<node_ip>
```

---

## Step 5: Install Prerequisites

Run the following commands on **each** node:

```bash
sudo apt install qemu-guest-agent apt-transport-https curl containerd -y

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
```

Follow the official guide to install `kubeadm`, `kubelet`, and `kubectl`:

[Install Kubernetes Components](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

Load required kernel modules:

```bash
sudo modprobe overlay
sudo modprobe br_netfilter
```

Configure sysctl parameters:

```bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system
```

---

## Step 6: Initialize the First Control-Plane Node

Follow the HA Kubernetes setup guide:

[Kubernetes High Availability Setup](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/)

After initialization, you will see an output similar to this:

```bash
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes running the following command on each as root:

  kubeadm join 172.31.31.210:6443 --token 6jdm9m.5hr443563455st3o6 \
        --discovery-token-ca-cert-hash sha256:b132743563456345a34563417b5b48d00baa015473074829347a \
        --control-plane --certificate-key 34c2b1f13e9a885c82345234526272583456da6ee7717d6e37120c7f36

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.31.31.210:6443 --token 6jdm9m.5hr443563455st3o6 \
        --discovery-token-ca-cert-hash sha256:b132743563456345a34563417b5b48d00baa015473074829347a
```

Notice the join command points to the haproxy Virtual IP that both nodes have.

Copy your generated `kubeadm join` commands for control-plane and worker nodes.

---

## Step 7: Install Calico Network Plugin

Before joining additional nodes, install Calico for networking.
Calico allows to practice network policies which are required for the CKA exam.

```bash
curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.3/manifests/calico.yaml -O
kubectl apply -f calico.yaml
```

Refer to the official Calico documentation:

[Calico Installation Guide](https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises)

---

## Step 8: Join Additional Nodes

Run the respective `kubeadm join` command on each control-plane node:

```bash
kubeadm join 172.31.31.210:6443 --token <token> \
    --discovery-token-ca-cert-hash <hash> \
    --control-plane --certificate-key <cert-key>
```

Run the following on each worker node:

```bash
kubeadm join 172.31.31.210:6443 --token <token> \
    --discovery-token-ca-cert-hash <hash>
```

---

## Step 9: Configure Kubectl on Local Machine

Copy the Kubernetes configuration to your local machine for administration:

```bash
scp your_user@<master_node_ip>:/etc/kubernetes/admin.conf ~/.kube/config
```

Now you can interact with your cluster:

```bash
kubectl get nodes
```

---

## Notes

- **TODO:** Add Terraform code for 2 HAProxy nodes and their configuration.
- This setup does not include an automated Ansible script but can be enhanced later.
- Ensure HAProxy is configured correctly to distribute traffic across control-plane nodes.

---

## References

- [Kubernetes Official Docs](https://kubernetes.io/docs/)
- [Kubeadm HA Guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/)
- [Calico Installation Guide](https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises)
