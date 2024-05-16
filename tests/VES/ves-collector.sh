#!/bin/bash

echo "Logs from ves-collector pod"
pod_name=$(kubectl get pods -n smo -l app=ves-collector -o jsonpath='{.items[0].metadata.name}')
kubectl logs pod/$pod_name --namespace=smo --container=ves-collector -f --since=0 --tail=100