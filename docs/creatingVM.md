
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
<blockquote>
<p align="justify">
<strong>Note:</strong> The VM must be created using the 172.30.0.0/24 network, as the VM has a fixed IP that must be used to configure the Kubernetes cluster (172.30.0.174). This configuration allows the final VM to have a fixed internal network for use by the Kubernetes cluster and a dynamic external network for user access with any IP range.
</p>
</blockquote>

## Creating a VM instance from the virt-install command:
```bash
virt-install --name <VM_name> –vcpus <vCPUs_quantity> --memory <memory_in_MBs> --disk size=<storage_in_GB> --cdrom <path_to_iso_ubuntu_server_20.04>
```
<blockquote>
<p align="justify">
<strong>Note:</strong> For creating VMs to the Near-RT RIC from OSC, two vCPUs, six GB of RAM, and 20 GB of disk space are recommended.
</p>
</blockquote>

## Operating system installation

In the language, select “English” and use your keyboard layout.
Go through the next steps, and do not update the installer (if asked).
In “Guided storage configuration”, select the “Custom storage layout” option and create the partitions according to the table below:
| Partition - Format | Size |
|-------------|-------------|
|/boot - ext4 | 1 GB | 
|/ - ext4 | ~19 GB | 

After completing the partition configuration, create the operating system's default user. The user must be called **"openran-br"** and have the password **"openran-br"**. 
Finally, activate the "Install OpenSSH server" option, proceed twice, and wait for the system to be installed.

## Configurações adicionais na VM

**1. Updating the repository list**
```bash
sudo apt update
sudo apt upgrade
```
**2. Configuring default network interface names**
Edit grub settings using the command:
```bash
sudo nano /etc/default/grub
```
Replace the GRUB_CMDLINE_LINUX=" " line with:
```bash
GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"
```
Save the modified file and update grub:
```bash
sudo update-grub
```
Edit the network configuration file:
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```
Modify the file so that it looks as this:
Abaixo está um exemplo do arquivo de configuração `config.yml` usado em nosso projeto:
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
     dhcp4: no
     addresses: [172.30.0.174/24]
     gateway4: 172.30.0.1
     nameservers:
       addresses: [8.8.8.8,1.1.1.1]
```
Once done, save the modified file, apply the new settings, and restart the VM:
```bash
sudo netplan apply
```
**3. Script to disable swap and forward logs**
Create a file using the command:
```bash
sudo nano /etc/init.d/swap_off.sh
```
Add text to file:
```bash
#!/bin/sh
sudo swapoff -a
sudo sysctl -w kernel.printk="3 4 1 7"
```
Create the executable with permission:
```bash
sudo chmod +x /etc/init.d/swap_off.sh
```
Add the script created to the operating system startup routine:
```bash
sudo crontab -e
```
At the end of the file add the line:
```bash
@reboot /etc/init.d/swap_off.sh
```
Now, restart the machine:
```bash
sudo reboot
```
**4. Configuring dummy interfaces for Kubernetes cluster configuration**
Create a new interface file using the command:
```bash
sudo nano /etc/systemd/network/bpi.netdev
```
Add the following text to the file:
```bash
[NetDev]
Name=bpi
Kind=dummy
```
Create a new network file using the command:
```bash
sudo nano  /etc/systemd/network/bpi.network
```
Add the following text to the file:
```bash
[Match]
Name=bpi

[Network]
Address=172.30.0.174
Mask=255.255.255.0
```
Once this is done, modify the network configuration file to receive dynamic IP.
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```
Delete the previous text in the file and add the following text:
```yaml
network:
  ethernets:
    eth0:
      dhcp4: true
  version: 2
```
Now, update your network settings:
```bash
sudo netplan apply
```

**[Demonstration](https://youtu.be/91KGYsaKU8s)**
