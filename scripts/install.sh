#!/bin/bash
set -x

TERRAFORM_VERSION="0.11.11"
PACKER_VERSION="0.10.2"
# create new ssh key
[[ ! -f /home/ubuntu/.ssh/mykey ]] \
&& mkdir -p /home/ubuntu/.ssh \
&& ssh-keygen -f /home/ubuntu/.ssh/mykey -N '' \
&& chown -R ubuntu:ubuntu /home/ubuntu/.ssh
# install packages
sudo apt-get -y update
sudo apt-get -y install docker.io ansible unzip
# add docker privileges
usermod -G docker ubuntu
# install pip
sudo pip install -U pip && pip3 install -U pip
if [[ $? == 127 ]]; then
    wget -q https://bootstrap.pypa.io/get-pip.py
    python get-pip.py
    python3 get-pip.py
fi
# install awscli and ebcli
sudo pip install -U awscli
sudo pip install -U awsebcli
# Install necessary dependencies
sudo apt-get -y -q install curl wget git tmux vim
sudo apt-get -y install zsh
#terraform
T_VERSION=$(terraform -v | head -1 | cut -d ' ' -f 2 | tail -c +2)
T_RETVAL=${PIPESTATUS[0]}

[[ $T_VERSION != $TERRAFORM_VERSION ]] || [[ $T_RETVAL != 0 ]] \
&& wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
&& unzip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# packer
P_VERSION=$(packer -v)
P_RETVAL=$?

[[ $P_VERSION != $PACKER_VERSION ]] || [[ $P_RETVAL != 1 ]] \
&& wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip \
&& unzip -o packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin \
&& rm packer_${PACKER_VERSION}_linux_amd64.zip

#kuctl
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install software-properties-common
sudo apt-get -y install -y kubectl
sudo apt update && sudo apt dist-upgrade
sudo apt-get -y install update-manager-core

# Install net-tools
sudo apt-get -y install net-tools
sudo apt-get -y install nmap

# Install Scanning & Monitoring Tools
sudo apt-get install lynis -y

# Color
sudo apt-get -y install ccze
sudo add-apt-repository ppa:dawidd0811/neofetch
sudo apt-get -y install neofetch
sudo apt-get -y install sysvbanner
sudo apt-get -y install linuxlogo

# Install Python3 and Boto
sudo apt-get -y install python3-pip -y
sudo python -m pip install boto3
sudo pip install --upgrade pip

# Install necessary libraries for guest additions and Vagrant NFS Share
sudo apt-get -y -q install linux-headers-$(uname -r) build-essential dkms nfs-common

# Using APT you can install the tools with the following RPM packages
sudo apt-get -y install lsof*
sudo apt-get -y install iotop*
sudo apt-get -y install htop*
sudo apt-get -y install sysstat

# Install CLI tools
sudo apt-get -y install binutils*

# clean up
sudo apt-get clean
