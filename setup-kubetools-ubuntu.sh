#!/bin/bash
# kubeadm installation instructions as on
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

#disable firewall
ufw disable

#disable AppArmor
/etc/init.d/apparmor stop
/etc/init.d/apparmor teardown

# disable swap  swapoff/swapon
swapoff -a  

#install kubeadm kubelet kubectl
apt-get update 
apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

systemctl enable --now kubelet

# As a requirement for your Linux Node's iptables to correctly see bridged traffic, 
# you should ensure net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config, e.g.
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# Configure cgroup driver used by kubelet on control-plane node
# When using Docker, kubeadm will automatically detect the cgroup driver for the kubelet and set it in the /var/lib/kubelet/config.yaml file during runtime.
# If you are using a different CRI, you must pass your cgroupDriver value to kubeadm init, like so:

#apiVersion: kubelet.config.k8s.io/v1beta1
#kind: KubeletConfiguration
#cgroupDriver: <value>

#systemctl daemon-reload
#systemctl restart kubelet


# setup bash completion
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.
alias k=kubectl
complete -F __start_kubectl k