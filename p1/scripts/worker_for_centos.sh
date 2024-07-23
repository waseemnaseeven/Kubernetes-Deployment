#!/bin/bash

sudo yum -y install net-tools telnet
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

if curl -sfL https://get.k3s.io ; then
	echo -e "${PURPLE}K3s WORKER installation SUCCEEDED${RESET}"
else
	echo -e "${RED}K3s WORKER installation FAILED${RESET}"
fi

if export INSTALL_K3S_EXEC="agent -s https://192.168.56.110:6443 -t $(cat /vagrant/token.env) --node-ip=192.168.56.111"; then
        echo -e "${PURPLE}export INSTALL_K3S_EXEC SUCCEEDED${RESET}"
else
        echo -e "${RED}export INSTALL_K3S_EXEC FAILED${RESET}"
fi 