##  Install and configure Docker
```bash
sudo apt install -y docker.io 
sudo usermod -aG docker $USER && newgrp docker
```
## Download and install Minikube
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
```
## Start Minikube
```bash
minikube start --driver=docker
```
## Download and install Kubelet 
```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
```
## Clone the SMO repo
```bash
git clone "https://gerrit.o-ran-sc.org/r/it/dep"
```
## Install the Chartmuseum and set up Helm
```bash
./dep/smo-install/scripts/layer-0/0-setup-charts-museum.sh
./dep/smo-install/scripts/layer-0/0-setup-helm3.sh
```
## Build all the SMO charts
```bash
./dep/smo-install/scripts/layer-1/1-build-all-charts.sh
```
## Install the ONAP components
```bash
./dep/smo-install/scripts/layer-2/2-install-onap-only.sh
```
