#!/bin/bash

PURPLE="\033[35m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${RED} ~~ LETS START SYNC OUR APP AND GITHUB REPO WITH OUR CLUSTER KUBERNETES ~~ ${RESET}"

kubectl config set-context --current --namespace=argocd

argocd app create wil-playground --repo https://github.com/waseemnaseeven/wnaseeve-configk8s.git --path wil_app --dest-server https://kubernetes.default.svc --dest-namespace dev

argocd app sync wil-playground

echo -e "${GREEN} ~~ sync policies ~~ ${RESET}"
argocd app set wil-playground --sync-policy automated
argocd app set wil-playground --auto-prune
argocd app set wil-playground --self-heal

sleep 60

echo -e "${GREEN} ~~ display application infos ~~ ${RESET}"
argocd app get wil-playground
