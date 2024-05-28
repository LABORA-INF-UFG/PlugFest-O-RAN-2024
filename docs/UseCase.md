<h1 align="center">Energy Savings use case</h1>

<p align="justify">
We validated our blueprint with an energy savings use case, leveraging a homebrewed SMO, an Energy Savings rApp, Handover and Monitoring xApps, and simulated E2 nodes. Moreover, the use case emphasizes energy savings by integrating SMO, Near-RT RIC, Non-RT RIC, xApps, and rApps. This integration ensures that energy-saving policies are formulated based on comprehensive data analysis and implemented effectively, promoting the network performance and minimizing energy consumption. The figure shows the sequence of interactions between components of the use case, considering three flows, i.e., Monitoring Flow, E2 Node Power Flow, and Handover Policy Flow. The process begins with a UE connection request forwarded by the E2 Node. Upon successful connection, the Monitoring xApp exports the UEs and their connection status and performance metrics to the Monitoring System. The Monitoring System transmits them via the O1/VES interface. The Data River component dispatches these performance metrics to subscribed consumers. Concurrently, the Energy Savings rApp computes the energy optimization solution and issues the E2 Node radio power configuration via the O1 interface. This configuration is followed by transmitting the UE handover policy through the A1 interface, which occurs in parallel. The UE handover procedure is initiated using the State Machine (SM), which triggers the handover process for UEs using the E2AP protocol. A handover request is sent only upon a specific trigger, and upon completion, UE disconnection and re-connection sequences are initiated. Finally, the E2 Node adjusts the radio power configuration post-handover, completing the process.
</p>

<p align="justify">
</p>
<p align="center">
    <img src="/figs/Energy.png"/> 
</p>

## Minimum SMO installation and configuration
<p align="justify">
First, we need to adjust the vesmgr image so that it is compatible with the new metrics that will be stored in Prometheus and exported to SMO via VES:
</p>

```bash
kubectl set image deployment/deployment-ricplt-vespamgr container-ricplt-vespamgr=zanattabruno/ric-plt-vespamgr:0.1 -n ricplt
kubectl rollout status deployment/deployment-ricplt-a1mediator -n ricplt
```

Create in the namespace for installing the minimum SMO components:
```bash
kubectl create namespace smo
```

Deploy Kafka and its kafdrop webui (data river):
```bash
git clone https://github.com/zanattabruno/ves-collector.git
cd ves-collector/extras
helm install kafka kafka/ -n smo
helm install kafkdrop kafdrop/ -n smo
```
<p align="justify">
Deploy the exports for additional metrics, such as latencies that are exported to Prometheus through node-exporter and information about Kubernetes node resources that are exported through black box exporter:
</p>

```bash
cd ves-collector/extras/prometheus/configs
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update 
helm upgrade --install blackbox-node1 prometheus-community/prometheus-blackbox-exporter -f values-blackbox1.yaml -n ricinfra
```

Deploy ves-collector:
```bash
cd ../ves-collector/helm
helm install ves-collector ves-collector/ -n smo
```

Deploy influxdb and its webui (data lake):
```bash
git clone https://github.com/zanattabruno/influxdb-connector.git
cd influxdb-connector/extras
helm install influxdb influxdb/ -n smo
helm install chronograf chronograf/ -n smo
```

Deploy influxdb-connector:
```bash
cd ../influxdb-connector/helm
helm install influxdb-connector influxdb-connector/ -n smo
```

Restart the VM and verify that the VM has internet access and that the pods are running.

<blockquote>
<p align="justify">
<strong>Note 1:</strong> After a few minutes, all pods must display a “Running” STATUS.
</p>
</blockquote>

<blockquote>
<p align="justify">
<strong>Note 2:</strong> After the pods have the “Running” STATUS, sometime later, it is common for some pods to restart or present the “CrashLoopBackOff” STATUS, mainly e2term, a1mediator, and e2mgr. This behavior occurs due to OSC's Near-RT RIC implementation, not blueprint configurations.
</p>
</blockquote>


**[Demonstration of the Energy Savings use case](https://www.youtube.com/watch?v=77nJ2helGl4&t=6s)**
