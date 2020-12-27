#!/bin/bash

# script that runs 
# https://docs.docker.com/engine/install/ubuntu/#install-docker-engine

# Update the apt package index and install packages to allow apt to use a repository over HTTPS:
apt update
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common


# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Use the following command to set up the stable repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the apt package index, and install the latest version of Docker Engine and containerd
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io


[ ! -d /etc/docker ] && mkdir /etc/docker

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload
systemctl restart docker
systemctl enable docker

systemctl disable --now firewalld
