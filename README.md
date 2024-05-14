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

