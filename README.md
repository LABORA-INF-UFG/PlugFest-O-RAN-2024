<h1 align="center">Tutorial for creating the PlugFest O-RAN 2024 Blueprint</h1>

<p align="justify">
This guideline provides a detailed tutorial for creating and configuring the blueprint with the qemu/libvirt environment. Initially, the installation of necessary packages for creating and managing Virtual Machines (VMs) is described, followed by the setup of an internal network using a specific XML file. The document shows how to check and manage virtual networks and details the creation of a VM with specific CPU, memory, and disk configurations. The Ubuntu Server operating system installation process is detailed, including network settings, disk partitioning, and user creation. Additionally, instructions for adjusting system settings, turning off swap, configuring network interfaces, and preparing the VM for use with Kubernetes clusters are presented. After that, the tutorial addresses installing Near-RT RIC and Non-RT RIC components and settings for data storage and monitoring. Finally, the document describes how to compress and convert the VM disk for use on different platforms, such as VirtualBox, and introduces standard procedures for testing and maintaining component status.
</p>


## Installing packages to create and manage qemu/libvirt VMs
```bash
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients virt-manager
```

## Configuring network on the host
Before booting the VM, check if a network called “default” is listed using the following command:
```bash
virsh net-list
```
The expected result is:
| Name | State | Autostart | Autostart |
|-------------|-------------|-------------|-------------|
|default | active | yes | yes|

If the default network is created, delete the network using the command below:
```bash
virsh net-destroy default
```
Double-check that no networks are listed.
```bash
virsh net-list
```
After deleting the pre-configured default network, we will create a new default network for creating the VM using an XML configuration file.
```bash
virsh net-create <network_file_XML>
```
Below is the XML file for creating the default network used in the blueprints project:
```xml
<network>
  <name>default</name>
  <uuid>652bafa1-f57e-4670-b40a-2c05e5e96645</uuid>
  <forward mode="nat"/>
  <bridge name="virbr0" stp="on" delay="0"/>
  <mac address="52:54:00:fc:2b:a8"/>
  <domain name="default"/>
  <ip address="172.30.0.1" netmask="255.255.255.0">
    <dhcp>
      <range start="172.30.0.1" end="172.30.0.254"/>
    </dhcp>
  </ip>
</network>
```
+ Note: The VM must be created using the 172.30.0.0/24 network, as the VM has a fixed IP that must be used to configure the Kubernetes cluster (172.30.0.174). This configuration allows the final VM to have a fixed internal network for use by the Kubernetes cluster and a dynamic external network for user access with any IP range.


