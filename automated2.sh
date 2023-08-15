#!/bin/bash
set -e

# jq
echo ""
echo "Step 2 - install jq"
sleep $time
sudo apt install jq -y
results="${results}\njq........................... installed or reinstalled with apt"

# curl
echo ""
echo "Step 3 - install curl"
sleep $time
sudo apt install curl -y
results="${results}\ncurl......................... installed or reinstalled with apt"

# filezilla
echo ""
echo "Step 4 - install filezilla"
sleep $time
sudo apt-get install filezilla -y
results="${results}\nfilezilla.................... installed or reinstalled with apt"

# keepassxc
echo ""
echo "Step 5 - install keepassxc"
sleep $time
sudo apt-get install keepassxc -y
results="${results}\nkeepassxc.................... installed or reinstalled with apt"

echo ""
echo "Step 6 - install Chrome"
sleep $time
if [[ $(apt list --installed | grep google-chrome-stable | wc -l) > 0 ]]; then # Is chrome already installed?
    echo "Chrome is already installed. "
    results="${results}\nchrome....................... already installed"
else
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
    echo "Done installing Chrome."
    results="${results}\nchrome....................... installed now"
fi

# google-drive-ocamlfuse
echo ""
echo "Step 7 - install google-drive-ocamlfuse"
sleep $time
if [[ $(apt list --installed | grep google-drive-ocamlfuse | wc -l) > 0 ]]; then # Is it already installed?
    echo "google-drive-ocamlfuse is already installed. Skipping."
    results="${results}\ngoogle-drive-ocamlfuse....... already installed"
else
    add-apt-repository ppa:alessandro-strada/ppa -y
    apt-get update
    apt-get install google-drive-ocamlfuse
    mkdir "/home/${myuser}/googledrive"
    echo "alias map-googledrive=\"google-drive-ocamlfuse /home/juliano/googledrive\"" >> "/home/${myuser}/.bashrc"
    results="${results}\ngoogle-drive-ocamlfuse....... installed now"
fi
# then, as juliano (or whatever user), to mount: $ google-drive-ocamlfuse /home/juliano/googledrive

# helm 3
echo ""
echo "Step 8 - install helm (latest)"
sleep $time
if [[ ! -e "/usr/local/bin/helm" ]]; then # Check if helm binary does not exist
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo "Done installing Helm"
    results="${results}\nhelm......................... installed now"
else
    echo "Helm skipped - seems like it's installed already"
    results="${results}\nhelm......................... already installed."
fi

# Fix up nano
echo ""
echo "Step 9 - fix up nano"
if [[ $(cat /home/${myuser}/.nanorc | grep "set linenumbers" | wc -l) = 0 ]]; then
    echo "set linenumbers" > /home/${myuser}/.nanorc
    chown juliano:juliano /home/juliano/.nanorc
    chmod 744 /home/juliano/.nanorc
    echo "nano - configured now"
    results="${results}\nnano......................... configured now"
else
    echo "nano - already configured"
    results="${results}\nhelm......................... already configured"
fi

# docker
echo ""
echo "Step 10 - install docker"
sleep $time
apt install docker.io -y
results="${results}\ndocker....................... installed or reinstalled with apt"
gpasswd -a ${myuser} docker

# nmap
echo ""
echo "Step 11 - install nmap"
sleep $time
sudo apt install nmap -y
results="${results}\nnmap......................... installed or reinstalled with apt"

echo ""
echo "Step 12 - install postgres client"
sleep $time
sudo apt install postgresql-client-14 -y
results="${results}\npostgresql-client-14......... installed or reinstalled with apt"

echo ""
echo "Step 13 - install mysql-client-8.0"
sleep $time
sudo apt install mysql-client-8.0 -y
results="${results}\nmysql-client-8.0............. installed or reinstalled with apt"

echo ""
echo "Step 14 - install tree"
sleep $time
sudo apt install tree -y
results="${results}\ntree......................... installed or reinstalled with apt"

# to install more apps with apt: 
# # X
# echo ""
# echo "Step X - install X"
# sleep $time
# sudo apt install X -y
# results="${results}\nX............................ installed or reinstalled with apt"

# terraform
echo ""
echo "Step 15 - install terraform"
sleep $time
if [[ $(apt list --installed | grep terraform | wc -l) > 0 ]]; then # Is it already installed?
    echo "terraform is already installed. Skipping."
    results="${results}\nterraform.................... already installed"
else
    apt-get update
    apt-get install -y gnupg software-properties-common
    apt update
    apt install gpg
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
# tem que bater com: 798A EC65 4E5C 1542 8C8E 42EE AA16 FCBC A621 E701
# todo: automatizar verificação de que o comando gpg retorne a key acima.
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    apt update
    apt install terraform -y
    echo "terraform installed now."
    results="${results}\nterraform.................... installed now"
fi

# aws cli
echo ""
echo "Step 16 - install aws cli"
sleep $time
if [[ -e "/usr/local/bin/aws" ]]; then # Check if the application binary exists
    echo "aws cli already installed."
    results="${results}\naws cli...................... already installed"
else
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    apt install unzip -y
    unzip /tmp/awscliv2.zip -d /tmp
    /tmp/aws/install
    echo "terraform installed now."
    results="${results}\naws cli...................... installed now"
fi

echo ""
echo "Step 17 - kubectl (1.23)"
sleep $time
if [[ -e "/usr/bin/kubectl" ]]; then # Check if the application binary exists
    echo "kubectl already installed."
    results="${results}\nkubectl...................... already installed"
else
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.15/2023-01-11/bin/linux/amd64/kubectl
    mv kubectl /usr/bin/
    chmod +x /usr/bin/kubectl
    echo "kubectl installed now."
    results="${results}\nkubectl...................... installed now"
fi

echo ""
echo "Step 18 - install lens"
sleep $time
if [[ $(apt list --installed | grep lens | wc -l) > 0 ]]; then # Is it already installed?
    echo "lens is already installed. Skipping."
    results="${results}\nlens......................... already installed"
else
    curl -fsSL https://downloads.k8slens.dev/keys/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/lens-archive-keyring.gpg > /dev/null
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/lens-archive-keyring.gpg] https://downloads.k8slens.dev/apt/debian stable main" | tee /etc/apt/sources.list.d/lens.list > /dev/null
    apt update
    apt install lens -y
    echo "lens installed now"
    results="${results}\nlens......................... installed now"
fi

echo ""
echo "Step 19 - KDE configs with transfuse"
sleep $time
if [[ -e "/home/${myuser}/transfuse" ]]; then # Check if transfuse project is already here
    echo "KDE configs skipped."
    results="${results}\nKDE configs with transfuse... already installed"
else
    olddir=$(pwd)
    cd /home/${myuser}/
    git clone https://gitlab.com/cscs/transfuse.git
    cp workstation/${transfuse_backup} transfuse/
    cd transfuse
    echo ""
    echo "Running transfuse."
    echo "Choose the Restore option;"
    echo "Type username '${myuser}'"
    echo "Choose the backup file, that will be sugested."
    echo "Or choose to quit and do nothing."
    echo ""
    su juliano -c "./transfuse.sh"
    echo ""
    echo "Done with transfuse."
    cd $pwd
fi
# also consider: Plasma Customization Server ; https://store.kde.org/p/1298955/
# also consider: https://github.com/Prayag2/konsave


echo -e ${results}

echo ""
echo "todo:"
echo "user juliano cannot run docker commands without sudo"
echo ""
echo "Steps that cannot be automated:"
echo "add local machine public key to github account"
echo "configure local git username & email"


