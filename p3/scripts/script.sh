#!/bin/bash

PURPLE="\033[35m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"


PORT_ARGOCD=30443

NAMESPACES_ARGOCD="argocd"
NAMESPACES_DEV="dev"

# ---- CONFIG ---- #

# echo -e "${GREEN} ~~  INSTALLING EVERY TOOLS ~~ ${RESET}"
# sudo apt-get update -y
# sudo apt-get install vim git curl ncdu -y 
# 
# echo -e "${GREEN} ~~  INSTALLING DOCKER ~~ ${RESET}"
# curl -fsSL https://get.docker.com -o get-docker.sh
# sh get-docker.sh
# sudo chmod 666 /var/run/docker.sock
# rm get-docker.sh
# 
# echo -e "${GREEN} ~~  INSTALLING KUBECTL ~~ ${RESET}"
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl)"
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
# 
# sleep 20
# 
# echo -e "${GREEN} ~~  INSTALLING K3D ~~ ${RESET}"
# curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bas
# mkdir -p ~/.kube
# touch ~/.kube/config
# 
# echo -e "${GREEN} ~~  INSTALLING ARGOCD ~~ ${RESET}"
# 
# curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 
# sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
# rm argocd-linux-amd64
# 
NODE_IP=$(kubectl get nodes -o wide | awk '/master/ {print $6}')

echo -e "${PURPLE} ~~  K3S CONTAINER CLUSTER CREATION WITH K3D ~~ ${RESET}"
k3d cluster create wnaseeve --port "8081:80@loadbalancer" --kubeconfig-update-default
k3d cluster start wnaseeve

export KUBECONFIG=$(k3d kubeconfig write wnaseeve)

# ---- CREAT NAMESPACES ---- #

echo -e "${PURPLE} ~~  CREATING NAMESPACES ~~ ${RESET}"
kubectl create namespace $NAMESPACES_ARGOCD 
kubectl create namespace $NAMESPACES_DEV

#---- LAUNCH ARGOCD ---- #

echo -e "${PURPLE} ~~ CREATING ARGOCD ~~ ${RESET}"
kubectl apply -n $NAMESPACES_ARGOCD -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f ../confs/argocd_nodeport.yaml

echo -e "${PURPLE} ~~ LETS ACCESS THE ARGOCD SERVER ~~ ${RESET}"

while true; do
  sleep 30
  curl --connect-timeout 5 https://$NODE_IP:$PORT_ARGOCD > /dev/null 
  if [ $? -eq 60 ]; then
    echo -e "${GREEN} ~~ DONE ! ~~ ${RESET}"
    break
  fi
  echo -e "${RED} ~~ WAITING ! ~~ ${RESET}"

done

ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n $NAMESPACES_ARGOCD -o yaml | grep 'password' | awk '{ print $2 }' | base64 --decode)

argocd login $NODE_IP:$PORT_ARGOCD --username admin --password $ARGOCD_PASSWORD --insecure
echo $ARGOCD_PASSWORD
# ---- LAUNCH DEV ---- #

echo -e "${PURPLE} ~~ LETS START SYNC OUR APP AND GITHUB REPO WITH OUR CLUSTER KUBERNETES ~~ ${RESET}"

kubectl config set-context --current --namespace=argocd

argocd app create wil-playground --repo https://github.com/waseemnaseeven/wnaseeve-configk8s.git --path wil_app --dest-server https://kubernetes.default.svc --dest-namespace dev

argocd app sync wil-playground

echo -e "${PURPLE} ~~ sync policies ~~ ${RESET}"
argocd app set wil-playground --sync-policy automated
argocd app set wil-playground --auto-prune
argocd app set wil-playground --self-heal

sleep 2

echo -e "${GREEN} ~~ display application infos ~~ ${RESET}"
argocd app get wil-playground
