#!/bin/bash
set -e

cd /home/ubuntu

# curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
# chmod +x openvpn-install.sh

# ./openvpn-install.sh

echo "***************** apt-get update *****************"
sudo apt-get update
sudo apt-get upgrade -y
sleep 5

# echo "***************** Install AWS tools agent *****************"
# sudo apt-get install ec2-api-tools wget xmlstarlet moreutils jq apt-transport-https software-properties-common \
#    ca-certificates dos2unix \
#    curl \
#    gnupg \
#    lsb-release -y

# install unzip
echo "***************** Install unzip *****************"
sudo apt-get install unzip zip -y
sleep 5

# Install AWSCLI
echo "***************** Install AWS CLI *****************"
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sleep 5

aws sts get-caller-identity

aws eks --region ${REGION} update-kubeconfig --name ${ENV}-eks-cluster

sudo snap install kubectl --classic

# aws eks update-kubeconfig \
#     --region ${REGION} \
#     --name ${ENV}-eks-cluster \
#     --role-arn arn:aws:iam::821069297469:role/devopsthehardway-eks-iam-role


#export AWS_DEFAULT_PROFILE=    