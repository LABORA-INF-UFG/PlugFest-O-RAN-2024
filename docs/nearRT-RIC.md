You can deploy the Near-RT RIC following the steps described below:

## 1. Install and configure Docker
```bash
sudo apt install -y docker.io 
sudo usermod -aG docker $USER && newgrp docker &
```
## 2. Download and install Minikube
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
```
## 3. Start Minikube
```bash
minikube start --driver=docker
```
## 4. Download and install Kubelet 
```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
```
## 5. Install Helm and Chartmuseum
```bash
mkdir temp; cd temp
wget https://get.helm.sh/helm-v3.11.2-linux-amd64.tar.gz
wget https://get.helm.sh/chartmuseum-v0.13.1-linux-amd64.tar.gz
tar xvzpf helm-v3.11.2-linux-amd64.tar.gz
tar xvzpf chartmuseum-v0.13.1-linux-amd64.tar.gz
mkdir -p ~/.local/bin
sudo cp linux-amd64/chartmuseum linux-amd64/helm /usr/local/bin/
```
## 6. Install the Chartmuseum Push plugin
```bash
helm plugin install https://github.com/chartmuseum/helm-push
```
## 7. Start Chartmuseum 
```bash
chartmuseum --debug --port 18080 --storage local --storage-local-rootdir $HOME/helm/chartsmuseum/ &
sleep 3
```
## 8. Set up local Helm repository 
```bash
helm repo add local http://localhost:18080/
helm repo add influxdata https://helm.influxdata.com
```
## 9. Clone and prepare Near-RT RIC
```bash
git clone "https://github.com/o-ran-sc/ric-plt-ric-dep.git" ~/nearrt_ric
cd ~/nearrt_ric/new-installer/helm/charts
sudo apt install -y make
make nearrtric; make nearrtric
kubectl create ns ricplt
kubectl create ns ricxapp
```
## 10. Install H Release
```bash
cd ~/nearrt_ric/RECIPE_EXAMPLE
helm install nearrtric -n ricplt local/nearrtric -f example_recipe_oran_h_release.yaml --values ~/nearrt_ric/new-installer/helm-overrides/nearrtric/minimal-nearrt-ric.yaml
```
## 11. Install DMS_CLI
```bash
git clone "https://gerrit.o-ran-sc.org/r/ric-plt/appmgr" ~/appmgr
cd ~/appmgr/xapp_orchestrater/dev/xapp_onboarder
sudo apt install -y python3-pip
pip3 install ./
echo "export CHART_REPO_URL=http://localhost:18080" >> ~/.bashrc
source ~/.bashrc
```

## 12. Load Minikube environment variables
```bash
eval $(minikube -p minikube docker-env)
```
