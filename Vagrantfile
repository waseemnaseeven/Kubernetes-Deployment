# -*- mode: ruby -*-
# vi: set ft=ruby :

LOCAL_USER = ENV['USER']
print "Local user: #{LOCAL_USER}\n"
ENV['VAGRANT_HOME'] = "/mnt/nfs/homes/#{LOCAL_USER}/sgoinfre"

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"

    config.vm.provider "virtualbox" do |vb|
      vb.name = "#{LOCAL_USER}"
      vb.gui = true
      vb.customize ["modifyvm", :id, "--name", "#{LOCAL_USER}"]
      vb.customize ["setproperty", "machinefolder", "/mnt/nfs/homes/#{LOCAL_USER}/sgoinfre/#{LOCAL_USER}"] # a changer pour plus tard
      vb.memory = "12096"
      vb.cpus = "18"
    end

    config.vm.provision "shell", privileged: true, inline: <<-SHELL
        apt-get update
        apt-get upgrade -y
        apt install -y sudo
        apt-get install -y git vim wget curl openssh-server ufw virtualbox
        apt-get install -y build-essential
        DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-desktop
        apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
        curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh    
    SHELL

    config.vm.provision "shell", privileged: true, inline: <<-SHELL
        apt-get install -y software-properties-common
        apt-add-repository -y ppa:hashicorp/vagrant
        apt-get update
        apt-get install -y vagrant
    SHELL

    config.vm.provision "shell", privileged: true, inline: <<-SHELL
        usermod -aG sudo vagrant
        usermod -aG docker vagrant
        usermod -aG vagrant vagrant
        hostnamectl set-hostname $USERNAME

        echo "vagrant ALL=(ALL) ALL" | sudo tee -a /etc/sudoers

        sudo ufw allow OpenSSH
        sudo ufw allow 443
        ufw --force enable

        shutdown -r now
    SHELL
end