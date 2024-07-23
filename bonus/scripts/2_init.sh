#!/bin/bash

PURPLE="\033[35m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${GREEN} ~~  K3S CONTAINER CLUSTER CREATION WITH K3D ~~ ${RESET}"

echo -e "${PURPLE} ~~  1) k3d cluster create wnaseeve --port "8081:80@loadbalancer" ~~ ${RESET}"
echo -e "${PURPLE} ~~  2) k3d cluster start wnaseeve ~~ ${RESET}"

k3d cluster create wnaseeve --port "8081:80@loadbalancer"
k3d cluster start wnaseeve

echo -e "${GREEN} ~~  CREATING NAMESPACES ~~ ${RESET}"
kubectl create namespace argocd && kubectl create namespace dev

echo -e "${GREEN} ~~ CREATING ARGOCD ~~ ${RESET}"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo -e "${GREEN} ~~ USE THE CLUSTER wnaseeve ~~ ${RESET}"
kubectl config use-context k3d-wnaseeve

echo -e "${GREEN} ~~ LETS ACCESS THE ARGOCD SERVER ~~ ${RESET}"

echo -e "${PURPLE} ~~ 1) kubectl port-forward svc/argocd-server -n argocd 8080:443 ~~ ${RESET}"
echo -e "${PURPLE} ~~ 2) kubectl get secret argocd-initial-admin-secret -n argocd -o yaml | grep "password" | awk '{ print $2 }' | base64 --decode ~~ ${RESET}"
echo -e "${PURPLE} ~~ 3) (Username is 'admin') argocd login localhost:8080 ~~ ${RESET}"
