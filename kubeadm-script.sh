#!/bin/bash 
# disbable SELINUX manually before running this script
yum -y install nano
hostnamectl set-hostname 'k8s-master'
systemctl disable firewalld
systemctl stop firewalld
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
swapoff -a

# update /etc/hosts file on master and worker nodes
echo  "192.168.0.200 k8s-master" >> /etc/hosts
echo  "192.168.0.201 worker-node1" >> /etc/hosts
echo  "192.168.0.202 worker-node2" >> /etc/hosts

## add repo- nano /etc/yum.repos.d/kubernetes.repo
echo "[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" > /etc/yum.repos.d/kubernetes.repo


# Install kubeadm and docker
yum install kubeadm docker -y
systemctl restart docker && systemctl enable docker
systemctl  restart kubelet && systemctl enable kubelet
kubeadm init --apiserver-advertise-address 192.168.0.100 --pod-network-cidr=192.168.0.0/24

# Kubernetes Home directory and config 

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# https://kubernetes.io/docs/concepts/cluster-administration/addons/
# weaven network
# Create weave network

export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"

# Create a dashboard

kubectl apply -f https://gist.githubusercontent.com/initcron/32ff89394c881414ea7ef7f4d3a1d499/raw/4863613585d05f9360321c7141cc32b8aa305605/kube-dashboard.yaml

kubectl describe svc kubernetes-dashboard -n kube-system
# take a note of the port that you get from the above command. and access the dashborad using the  following master-node-ip:31000
#http://192.168.0.100:31000

































