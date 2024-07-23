#!/bin/bash

PURPLE="\033[35m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

NODE_IP=$(kubectl get nodes -o wide | awk '/master/ {print $6}')
PORT_ARGOCD=30443

NAMESPACES_ARGOCD="argocd"
NAMESPACES_DEV="dev"

echo -e "${PURPLE} ~~  K3S CONTAINER CLUSTER CREATION WITH K3D ~~ ${RESET}"

k3d cluster create wnaseeve --port "8081:80@loadbalancer"
k3d cluster start wnaseeve


# ---- CREAT NAMESPACES ---- #

echo -e "${PURPLE} ~~  CREATING NAMESPACES ~~ ${RESET}"
kubectl create namespace $NAMESPACES_ARGOCD 
kubectl create namespace $NAMESPACES_DEV


# ---- LUNCH ARGOCD ---- #

echo -e "${PURPLE} ~~ CREATING ARGOCD ~~ ${RESET}"
kubectl apply -n $NAMESPACES_ARGOCD -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f ../confs/argocd_nodeport.yaml

echo -e "${PURPLE} ~~ USE THE CLUSTER wnaseeve ~~ ${RESET}"
kubectl config use-context k3d-wnaseeve

echo -e "${PURPLE} ~~ LETS ACCESS THE ARGOCD SERVER ~~ ${RESET}"

sleep 20

until kubectl get secret argocd-initial-admin-secret -n $NAMESPACES_ARGOCD -o yaml | grep 'password' | awk '{ print $2 }' | base64 --decode; do
  sleep 2
done

ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n $NAMESPACES_ARGOCD -o yaml | grep 'password' | awk '{ print $2 }' | base64 --decode)
echo $ARGOCD_PASSWORD > .secret_pass

sleep 10

until argocd login $NODE_IP:$PORT_ARGOCD --username admin --password $ARGOCD_PASSWORD --insecure; do
  sleep 2
done


# ---- LUNCH DEV ---- #

echo -e "${RED} ~~ LETS START SYNC OUR APP AND GITHUB REPO WITH OUR CLUSTER KUBERNETES ~~ ${RESET}"

kubectl config set-context --current --namespace=argocd

argocd app create wil-playground --repo https://github.com/waseemnaseeven/wnaseeve-configk8s.git --path wil_app --dest-server https://kubernetes.default.svc --dest-namespace dev

argocd app sync wil-playground

echo -e "${GREEN} ~~ sync policies ~~ ${RESET}"
argocd app set wil-playground --sync-policy automated
argocd app set wil-playground --auto-prune
argocd app set wil-playground --self-heal

sleep 20

echo -e "${GREEN} ~~ display application infos ~~ ${RESET}"
argocd app get wil-playground


# echo -e "${PURPLE} ~~ 1) kubectl port-forward svc/argocd-server -n argocd 7447:443 ~~ ${RESET}"
# echo -e "${PURPLE} ~~ 2) kubectl get secret argocd-initial-admin-secret -n argocd -o yaml | grep "password" | awk '{ print $2 }' | base64 --decode ~~ ${RESET}"
# echo -e "${PURPLE} ~~ 3) (Username is 'admin') argocd login localhost:7447 ~~ ${RESET}"
