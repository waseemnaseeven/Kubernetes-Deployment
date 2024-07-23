#!/bin/bash

PURPLE="\033[35m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${GREEN} ~~ INSTALLING HELM ~~ ${RESET}"

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 755 get_helm.sh
./get_helm.sh
rm get_helm.sh

echo -e "${GREEN} ~~ CREATING GITLAB NAMESPACE AND CHANGING CONTEXT ~~ ${RESET}"

kubectl create namespace gitlab
kubectl config set-context --current --namespace=gitlab

# helm install gitlab gitlab/gitlab \
#   --set global.hosts.domain=gitlab.wnaseeve.fr \
#   --set certmanager-issuer.email=wnaseeve@student.42.fr \
#   --set global.hosts.https="false" \
#   --set global.ingress.configureCertmanager="false" \
#   --set gitlab-runner.install="false" \
#   --set nginx-ingress.controller.hostNetwork=true \
#   --set nginx-ingress.controller.kind=DaemonSet \
#   --namespace=gitlab

helm upgrade --install gitlab gitlab/gitlab \
	--namespace gitlab \
	--timeout 600s \
	--values https://gitlab.com/gitlab-org/charts/gitlab/-/raw/master/examples/values-minikube-minimum.yaml?ref_type=heads \
	--set global.hosts.domain=localgitlab.com \
	--set global.hosts.externalIP=0.0.0.0 \
	--set global.hosts.https=false

kubectl get secret --namespace=gitlab gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo

# or classic passwd

echo -e "${RED} ~~ LETS CONNECT TO MY LOCAL GITLAB ~~ ${RESET}"

echo -e "${PURPLE} kubectl port-forward svc/gitlab-webservice-default -n gitlab 8081:8181 ${RESET}"