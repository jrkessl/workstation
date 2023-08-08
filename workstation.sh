#!/bin/bash
set -e
apt-get update
apt-get upgrade -y 

# manual configs:
# - keyboard
#   - layout, add, portuguese brazil, remove the other.
# - konsole
#   - configure keyboard shortcuts
#     - ctrl + c for copy, ctrl + v for paste
#   - font size
#     - make new profile, make default
#     - font size 11 (24 inch monitor)
#   - toolbars: hide both
# - adjust task bar
#   - move to the left
#   - panel width 68
# - system settings
#   - workspace behavior
#     - general behavior
#       - clicking files or folders: selects them
#       - clickin in scroll track: scrolls to the clicked location
# - dolphin
#   - configure
#     - configure dolphin
#       - view modes 
#         - details
#           - previes icon size: minimal
# - global theme: breeze dark

# jq
sudo apt install jq -y

# curl
sudo apt install curl -y

# filezilla
sudo apt-get install filezilla -y

# keepassxc
sudo apt-get install keepassxc -y
# https://keepassxc.org/download/#linux

# Snowflake (ftp and scp client)
# https://github.com/subhra74/snowflake
# Dowwnload file (manually, with curl does not work, not sure why) then: 
# sudo apt install ./snowflake-1.0.4-setup-amd64.deb -y

# visual studio code
# manually through https://code.visualstudio.com/docs/setup/linux

# chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# teams
# manual from: https://www.microsoft.com/en-ww/microsoft-teams/download-app#desktopAppDownloadregion

# install virtualbox?
# sudo apt-get install virtualbox (untested, but this was the command). 

# google-drive-ocamlfuse
sudo add-apt-repository ppa:alessandro-strada/ppa
sudo apt-get update
sudo apt-get install google-drive-ocamlfuse
mkdir ~/googledrive
google-drive-ocamlfuse ~/googledrive

# helm3
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# helm2 (need to manually check for a newer version)
curl https://get.helm.sh/helm-v2.17.0-linux-amd64.tar.gz -o /tmp/helm-v2.17.0-linux-amd64.tar.gz
tar -xzvf /tmp/helm-v2.17.0-linux-amd64.tar.gz -C /tmp/
sudo cp /tmp/linux-amd64/helm /usr/bin/helm2

# nano 
echo "set linenumbers" > /home/juliano/.nanorc
chown juliano:juliano /home/juliano/.nanorc
chmod 744 /home/juliano/.nanorc

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
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
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
sudo apt install tree

# zoom
# manualmente em https://gtl.zoom.us/download

# multipass
# sudo snap install multipass

# aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
sudo apt install unzip -y
unzip /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install

# kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.15/2023-01-11/bin/linux/amd64/kubectl
sudo mv kubectl /usr/bin/
sudo chmod +x /usr/bin/kubectl

# lens
curl -fsSL https://downloads.k8slens.dev/keys/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/lens-archive-keyring.gpg > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/lens-archive-keyring.gpg] https://downloads.k8slens.dev/apt/debian stable main" | sudo tee /etc/apt/sources.list.d/lens.list > /dev/null
sudo apt update
sudo apt install lens -y

# shortcuts
google-drive-ocamlfuse ~/googledrive
ln -s /home/juliano/googledrive/dinheiro/BairesDev/ViaPath/docs /home/juliano/Documents/docs
ln -s /home/juliano/googledrive/dinheiro/BairesDev/ViaPath/docs d
ln -s /home/juliano/Documents/gitlab-viapath/ gl
ln -s /home/juliano/Documents/github/ gh

# spotify
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client -y

# task switcher
# type "task switcher" in the start menu and:
# /home/juliano/googledrive/estudo-ti/kde-atalhos-janelas/taask-switcher.png

# window shortcuts
# type "task switcher" in the start menu, go to 'window rules' and import file:
# /home/juliano/googledrive/estudo-ti/kde-atalhos-janelas/kwin-rules-todas(2023-02-16).kwinrule

# notifications position
# start menu > type "notifications - system settings" > Popup > choose custom position.

# shortcuts from .bashrc
# there's a backup in: /home/juliano/googledrive/estudo-ti/kde-atalhos-janelas/.bashrc	
  # to make the backup from the workstation:
  # cp /home/juliano/.bashrc /home/juliano/googledrive/estudo-ti/kde-atalhos-janelas/.bashrc
    # todo: automate this backup.

# aws credentials and profiles:
# ~/.aws/config
# ~/.aws/
tar -xzvf /home/juliano/googledrive/estudo-ti/kde-atalhos-janelas/aws-creds -C ~/
# then, add the keys in file "credentials"

# company vpn
cp /home/juliano/googledrive/dinheiro/BairesDev/ViaPath/cisco-anyconnect/anyconnect-linux64-4.10.04071-predeploy-k9.tar.gz /tmp
cd /tmp
tar -xzvf anyconnect-linux64-4.10.04071-predeploy-k9.tar.gz
cd anyconnect-linux64-4.10.04071/
cd vpn
sudo ./vpn_install.sh
# servers:
# anydal.gtl.us
# anyhdc.gtl.us

# install spectacle
