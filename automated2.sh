#!/bin/bash
echo "hello world from permissions2"

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





echo -e ${results}

echo ""
echo "todo:"
echo "user juliano cannot run docker commands without sudo"

