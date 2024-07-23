#!/bin/bash

PURPLE="\033[35m"
RED="\033[31m"
RESET="\033[0m"

apt-get update 
apt-get install -y net-tools
sudo ufw disable

if export INSTALL_K3S_EXEC="--write-kubeconfig-mode=0644 --tls-san wnaseeveS --node-ip 192.168.56.110 --bind-address=192.168.56.110 --advertise-address=192.168.56.110 "; then
    echo -e "${PURPLE}export INSTALL_K3S_EXEC SUCCEEDED${RESET}"
else
    echo -e "${RED}export INSTALL_K3S_EXEC FAILED${RESET}"
fi

if curl -sfL https://get.k3s.io | sh -; then
    echo -e "${PURPLE}K3s MASTER installation SUCCEEDED${RESET}"
else
    echo -e "${RED}K3s MASTER installation FAILED${RESET}"
fi

if sudo ip link add eth1 type dummy && sudo ip addr add 192.168.56.110/24 dev eth1 && sudo ip link set eth1 up; then
        echo -e "${PURPLE}adding IP address on interface eth1 SUCCEEDED${RESET}"
else
        echo -e "${RED}adding IP address on interface eth1 FAILED${RESET}"
fi

echo -e "${PURPLE} dont forget to add host with the script${RESET}"

echo -e "${PURPLE} Go to a browser, and then, 192.168.56.110:80, wait at least 4mins ${RESET}"
