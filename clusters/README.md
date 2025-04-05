# Cluster Upgrade Process notes

On control plane nodes:

```bash
# add current version to the repo
sudo vi /etc/apt/sources.list.d/kubernetes.list

# update repo
sudo apt update

# see possible versions
sudo kubeadm upgrade plan

# show available versions
sudo apt-cache show kubeadm

# can be different for you
sudo apt-get install kubeadm=1.32.2-1.1

# could be a different version for you, it can also take a bit to finish!
sudo kubeadm upgrade apply v1.32.2
```

Next we update kubectl and kubelet :

```bash
# can be a different version for you
apt-get install kubectl=1.32.2-1.1 kubelet=1.32.2-1.1

service kubelet restart
```

On the worker nodes issue upgrade node and update the kubelet component.

```bash
# can be a different version for you
apt-get install kubeadm=1.32.2-1.1
kubeadm upgrade node

# can be a different version for you
apt-get install kubelet=1.32.2-1.1
   
service kubelet restart
```
