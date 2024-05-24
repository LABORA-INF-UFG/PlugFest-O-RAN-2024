##  Install and configure Docker
```bash
sudo apt install -y docker.io 
sudo usermod -aG docker $USER && newgrp docker &
```
## Download and install Minikube
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb
```

## Create Minikube mount points
```bash
mkdir -p /home/$USER/persistent_storage/pms-storage/database
mkdir -p /home/$USER/persistent_storage/ics-storage/database
```

## Start Minikube
```bash
minikube start --driver=docker --mount --mount-string="/home/$USER/persistent_storage/:/var/nonrtric" --mount-uid="nonrtric" --mount-gid="nonrtric"
```
## Download and install Kubelet 
```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
```
## Clone the Non-RT RIC repo
```bash
git clone "https://gerrit.o-ran-sc.org/r/it/dep"
```
## Install the Chartmuseum and set up Helm
```bash
./dep/smo-install/scripts/layer-0/0-setup-charts-museum.sh
./dep/smo-install/scripts/layer-0/0-setup-helm3.sh
```

## Set A1 Mediator URL in the Policy Management Service
```bash
 sed -i '0,/a1-sim-osc-0.a1-sim:8185/s//service-ricplt-a1mediator-http.ricplt.svc.cluster.local:10000/' ./dep/nonrtric/helm/policymanagementservice/resources/data/application_configuration.json
```

## Install the Helm Recipes
```bash
cd dep/bin/
sudo -E ./deploy-nonrtric -f ../nonrtric/RECIPE_EXAMPLE/example_recipe.yaml
```
