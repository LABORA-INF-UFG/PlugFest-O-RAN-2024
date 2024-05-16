First, we must adjust the  a1mediator image from Near-RT RIC to be compatible with the Non-RT RIC:
```bash
kubectl set image deployment/deployment-ricplt-a1mediator container-ricplt-a1mediator=alexandrehuff/a1mediator -n ricplt
kubectl rollout status deployment/deployment-ricplt-a1mediator -n ricplt

```
We also must adjust the vespamgr image from Near-RT RIC to be compatible with the ves-collector of our minimal SMO:
```bash
kubectl set image deployment/deployment-ricplt-vespamgr container-ricplt-vespamgr=zanattabruno/ric-plt-vespamgr:energy-saver -n ricplt
kubectl rollout status deployment/deployment-ricplt-vespamgr  -n ricplt

```
Next, we must install a tool to store the Non-RT RIC components. The option chosen was the Rancher local path, the documentation for which is available [here](https://github.com/rancher/local-path-provisioner). Rancher can be installed using the command:
```bash
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.26/deploy/local-path-storage.yaml
```
We must clone the Non-RT RIC by following the steps described here. Furthermore, we need to change all instances of storageClassName to local-path, as shown in the example in the file below, where there are six changes.
dep/nonrtric/RECIPE_EXAMPLE/example_recipe.yaml
```yaml
…
  volume1:
    # Set the size to 0 if you do not need the volume (if you are using Dynamic Volume Provisioning)
    size: 0
    storageClassName: local-path
    hostPath: /var/nonrtric/pms-storage
  volume2:
     # Set the size to 0 if you do not need the volume (if you are using Dynamic Volume Provisioning)
    size: 0
    storageClassName: local-path
    hostPath: /var/nonrtric/ics-storage
  volume3:
    size: 0
    storageClassName: local-path
…
```
