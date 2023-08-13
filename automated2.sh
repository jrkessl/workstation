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

