#!/bin/bash

PURPLE="\033[35m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${RED} ~~ LETS START SYNC GITLAB REPO AND ARGO IN OUR CLUSTER KUBERNETES ~~ ${RESET}"

kubectl config set-context --current --namespace=argocd

echo -e "${GREEN} ~~ apply yaml file ~~ ${RESET}"

echo -e "${PURPLE} go to /bonus and /confs and kubectl apply -f deployment.yaml ${RESET}"
kubectl apply -f ../confs/deployment.yaml
sleep 30

echo -e "${GREEN} ~~ display application infos ~~ ${RESET}"
argocd app get bonus
