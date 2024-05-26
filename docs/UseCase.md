<h1 align="center">Energy Savings use case</h1>

<p align="justify">
The use case emphasizes energy savings by integrating SMO, Near-RT RIC, Non-RT RIC, xApps, and rApps. This integration ensures that energy-saving policies are formulated based on comprehensive data analysis and implemented effectively, promoting the network performance and minimizing energy consumption. The figure shows the sequence of interactions between components of the use case, considering three flows, i.e., Monitoring Flow, E2 Node Power Flow, and Handover Policy Flow. The process begins with a UE connection request forwarded by the E2 Node. Upon successful connection, the Monitoring xApp notifies the UE of their connection status and performance metrics. The Monitoring System exports these metrics to the Handover xApp and transmits them via the O1/VES interface. The Data River component dispatches these performance metrics to subscribed consumers. Concurrently, the Energy Savings rApp computes the energy optimization solution and issues the E2 Node radio power configuration via the O1 interface. This configuration is followed by transmitting the UE handover policy through the A1 interface, which occurs in parallel. The UE handover procedure is initiated using the State Machine (SM), which triggers the handover process for UEs using the E2AP protocol. A handover request is sent only upon a specific trigger, and upon completion, UE disconnection and re-connection sequences are initiated. Finally, the E2 Node adjusts the radio power configuration post-handover, completing the process.
</p>

<p align="justify">
</p>
<p align="center">
    <img src="/figs/Energy.png"/> 
</p>

**[Demonstration](https://youtu.be/l9ghO7ONcgc)**

Minimum SMO installation and configuration


## Installing packages to create and manage qemu/libvirt VMs
```bash
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients virt-manager
```
