<p align="justify">
First, we must adjust the  a1mediator image from Near-RT RIC to be compatible with the Non-RT RIC.
</p>

```bash
kubectl set image deployment/deployment-ricplt-a1mediator container-ricplt-a1mediator=alexandrehuff/a1mediator -n ricplt
kubectl rollout status deployment/deployment-ricplt-a1mediator -n ricplt

```




