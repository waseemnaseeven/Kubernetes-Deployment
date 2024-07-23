#!/bin/bash

sudo yum -y install net-tools
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd


if curl -sfL https://get.k3s.io | sh -s -; then
    echo -e "${PURPLE}K3s MASTER installation SUCCEEDED${RESET}"
else
    echo -e "${RED}K3s MASTER installation FAILED${RESET}"
fi

if export INSTALL_K3S_EXEC="--write-kubeconfig-mode=0644 --tls-san wnaseeveS --node-ip 192.168.56.110 --bind-address=192.168.56.110 --advertise-address=192.168.56.110 --cluster-init "; then
    echo -e "${PURPLE}export INSTALL_K3S_EXEC SUCCEEDED${RESET}"
else
    echo -e "${RED}export INSTALL_K3S_EXEC FAILED${RESET}"
fi

sudo echo "alias k=/usr/local/bin/kubectl" >> /home/vagrant/.bashrc

sudo systemctl start k3s

if sudo cat /var/lib/rancher/k3s/server/token >> /vagrant/token.env; then
    echo -e "${PURPLE}TOKEN SUCCESSFULLY SAVED${RESET}"
else
    echo -e "${RED}TOKEN SAVING FAILED${RESET}"
fi
