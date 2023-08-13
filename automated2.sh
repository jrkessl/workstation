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

echo -e ${results}
