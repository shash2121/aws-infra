#!/bin/bash

echo "*********** Initializing ***********"

echo "***************** apt-get update *****************"
sudo apt-get update
sudo apt-get upgrade -y
sleep 5

echo "***************** Installing jdk *****************"
sudo apt install default-jdk -y

echo "***************** Install AWS tools agent *****************"
sudo apt-get install ec2-api-tools wget xmlstarlet moreutils jq apt-transport-https software-properties-common \
   ca-certificates dos2unix \
   curl \
   gnupg \
   lsb-release -y

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

# Install nginx
echo "***************** Install nginx *****************"
sudo apt-get install nginx -y
sudo systemctl enable nginx
sleep 5

  sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
  sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
  sudo apt update && sudo apt install jenkins -y

  sudo systemctl enable jenkins
  sudo systemctl restart jenkins
  sleep 10
