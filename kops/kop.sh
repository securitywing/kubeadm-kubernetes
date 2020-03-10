#!/bin/bash
# Install KOPs script
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#Install Kubectl 
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Create a cluster in AWS using KOPS,specifying the number of master nodes
# Craete a s3 bucket to save the state

kops create cluster --name=kube.yourdomain.com --state=s3://your-s3-buckt-name --zones=eu-west-1a --node-count=2 --node-size=t3.micro --master-size=t3.micro --dns-zone=kube.yourdomain.com


