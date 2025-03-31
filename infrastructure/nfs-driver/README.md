# Instructions for installing the NFS auto provisioner

* Install the driver

```bash
helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts
helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --namespace kube-system --set controller.replicas=2 --set externalSnapshotter.enabled=true
```

* Create a Storage Class using the yml in the same dir

* Create PVC

* Attach the PVC in a pod/deployment

For referrence: [csi-driver-nfs](https://github.com/kubernetes-csi/csi-driver-nfs/tree/master)
