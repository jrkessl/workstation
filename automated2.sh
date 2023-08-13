#!/bin/bash
echo "hello world from permissions2"

# jq
echo ""
echo "Step 2 - install jq"
sleep 1
sudo apt install jq -y

# curl
echo ""
echo "Step 3 - install curl"
sleep 1
sudo apt install curl -y

# filezilla
echo ""
echo "Step 4 - install filezilla"
sleep 1
sudo apt-get install filezilla -y

# keepassxc
echo ""
echo "Step 5 - install keepassxc"
sleep 1
sudo apt-get install keepassxc -y

echo ""
echo "Step 6 - install Chrome"
if [[ $(apt list --installed | grep google-chrome-stable | wc -l) > 0 ]]; then # Is chrome already installed?
    echo "Chrome is already installed. "
else
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
    echo "Done installing Chrome."
fi

# google-drive-ocamlfuse
echo ""
echo "Step 7 - install google-drive-ocamlfuse"
if [[ $(apt list --installed | grep google-drive-ocamlfuse | wc -l) > 0 ]]; then # Is it already installed?
    echo "google-drive-ocamlfuse is already installed. Skipping."
else
    add-apt-repository ppa:alessandro-strada/ppa -y
    apt-get update
    apt-get install google-drive-ocamlfuse
    mkdir "/home/${myuser}/googledrive"
    echo "alias map-googledrive=\"google-drive-ocamlfuse /home/juliano/googledrive\"" >> "/home/${myuser}/.bashrc"
fi
# then, as juliano (or whatever user), to mount: $ google-drive-ocamlfuse /home/juliano/googledrive
