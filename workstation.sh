#!/bin/bash
apt get update
apt get upgrade -y 

# manual configs:
# - konsole
#  -- ctrl + c for copy, ctrl + v for paste
#  -- font size
# - adjust task switcher
# - adjust task bar

# curl
sudo apt install curl

# filezilla
apt get install filezilla -y

# keepassxc
sudo apt install keepassxc
# https://keepassxc.org/download/#linux

# Snowflake (ftp and scp client)
# https://github.com/subhra74/snowflake
# Dowwnload file (manually, with curl does not work, not sure why) then: 
# sudo apt install ./snowflake-1.0.4-setup-amd64.deb

# visual studio code
# manually through https://code.visualstudio.com/docs/setup/linux

# chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# teams
# manual from: https://www.microsoft.com/en-ww/microsoft-teams/download-app#desktopAppDownloadregion

# install virtualbox?
# sudo apt-get install virtualbox (untested, but this was the command). 

# helm3
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# helm2 (need to manually check for a newer version)
curl https://get.helm.sh/helm-v2.17.0-linux-amd64.tar.gz -o /tmp/helm-v2.17.0-linux-amd64.tar.gz
tar -xzvf /tmp/helm-v2.17.0-linux-amd64.tar.gz -C /tmp/
sudo cp /tmp/linux-amd64/helm /usr/bin/helm2

# nano 
echo "set linenumbers" > /home/ubuntu/.nanorc
chown ubuntu:ubuntu /home/ubuntu/.nanorc
chmod 744 /home/ubuntu/.nanorc

# docker
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# se der erro de que o repo não tem release file, ir no arquivo /etc/apt/sources.list.d/docker.list e substituir "linux/debian jammy" por "linux/ubuntu jammy"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo gpasswd -a juliano docker

# nmap
sudo apt  install nmap -y

# postgresql client
sudo apt-get install postgresql-client-14 -y

# mysql client
sudo apt-get install mysql-client-8.0 -y

# terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
sudo apt update && sudo apt install gpg
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
# tem que bater com: 798A EC65 4E5C 1542 8C8E 42EE AA16 FCBC A621 E701
# todo: automatizar verificação de que o comando gpg retorne a key acima.
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y


# tree
sudo apt  install tree

# zoom
# manualmente em https://gtl.zoom.us/download

# multipass
sudo snap install multipass

# aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
sudo apt install unzip -y
unzip /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install
