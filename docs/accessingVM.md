

## Blueprint Image Download

As part of our activites in the O-RAN Spring PlugFest 2024, we make available a VM blueprint for download.
The VM contains an operational deployment of Near- and Non-RT RICs ready for testing and development of xApps and rApps out of the box.

To download the VM image in qcow2 format, please click the link below:

[Blueprint VM Image](https://virginiatech-my.sharepoint.com/:u:/g/personal/joaosantos_vt_edu/EThwYC1W_-ZFtWjtBUBmSPgBnvAuicRdmVmr1hVU8j57ew?e=qM9uPl) [60GB]


The VM's credentials are as follows:

```bash
Login: experimenter
Password: blueprint
```

To start the Kubernetes cluster, run the following command: 

```bash
minikube start --driver=docker --mount --mount-string="/home/$USER/persistent_storage/:/var/nonrtric" --mount-uid="nonrtric" --mount-gid="nonrtric"
```
