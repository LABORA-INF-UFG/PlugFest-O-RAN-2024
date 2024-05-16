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


