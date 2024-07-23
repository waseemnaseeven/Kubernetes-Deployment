#!/bin/bash
PURPLE="\033[35m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${PURPLE} if it stuck : kubectl get namespace [your-namespace] -o json > tmp.json ${RESET}"
echo -e "${PURPLE} vim tmp.json, then, delete spec finalizers ${RESET}"
echo -e "${PURPLE} In an another terminal, kubectl proxy ${RESET}"
echo -e "${PURPLE} curl -k -H "Content-Type: application/json" -X PUT --data-binary @tmp.json http://127.0.0.1:8001/api/v1/namespaces/[your-namespace]/finalize ${RESET}"
echo -e "${PURPLE} kubectl get ns ${RESET}"

kubectl delete all --all -n dev
kubectl delete all --all -n gitlab
kubectl delete all --all -n argocd

kubectl delete namespace dev
kubectl delete namespace gitlab
kubectl delete namespace argocd

k3d cluster stop wnaseeve
k3d cluster delete wnaseeve
