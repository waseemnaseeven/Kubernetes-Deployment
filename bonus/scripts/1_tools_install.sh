!/bin/bash

PURPLE="\033[35m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${GREEN} ~~  INSTALLING EVERY TOOLS ~~ ${RESET}"
sudo apt-get update -y
sudo apt-get install vim git curl ncdu -y 

echo -e "${GREEN} ~~  INSTALLING DOCKER ~~ ${RESET}"
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo chmod 666 /var/run/docker.sock
rm get-docker.sh

echo -e "${GREEN} ~~  INSTALLING KUBECTL ~~ ${RESET}"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

echo -e "${PURPLE} ~~  1) echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check ~~ ${RESET}"
echo -e "${PURPLE} ~~  2) sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl ~~ ${RESET}"

sleep 60

echo -e "${GREEN} ~~  INSTALLING K3D ~~ ${RESET}"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo -e "${GREEN} ~~  INSTALLING ARGOCD ~~ ${RESET}"

echo -e "${PURPLE} ~~  1) curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 ~~ ${RESET}"
echo -e "${PURPLE} ~~  2) sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd ~~ ${RESET}"
echo -e "${PURPLE} ~~  3) rm argocd-linux-amd64 ~~ ${RESET}"

sleep 20

echo -e "${GREEN} ~~  K3S CONTAINER CLUSTER CREATION WITH K3D ~~ ${RESET}"

echo -e "${PURPLE} ~~  1) k3d cluster create wnaseeve --port "8081:80@loadbalancer" ~~ ${RESET}"
echo -e "${PURPLE} ~~  2) k3d cluster start wnaseeve ~~ ${RESET}"
