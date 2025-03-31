# Cluster Upgrade Process notes

On control plane nodes:

```bash
# see possible versions
kubeadm upgrade plan

# show available versions
apt-cache show kubeadm

# can be different for you
apt-get install kubeadm=1.32.2-1.1

# could be a different version for you, it can also take a bit to finish!
kubeadm upgrade apply v1.32.2
```

Next we update kubectl and kubelet :

```bash
# can be a different version for you
apt-get install kubectl=1.32.2-1.1 kubelet=1.32.2-1.1

service kubelet restart
```

Repeat the apt part on worker nodes.

```bash
    # can be a different version for you
    apt-get install kubeadm=1.32.2-1.1
    kubeadm upgrade node

        # can be a different version for you
    apt-get install kubelet=1.32.2-1.1
    
    service kubelet restart
```
