#!/bin/bash
set -e 

export myuser=juliano    # This is the user for which we will install stuff.
export time=0            # This is how long to wait after some outputs so I can read them. 
export results           # This is to summarize results at the end of the script.
export transfuse_backup=juliano_transfusion_20230814_2206.tar.gz # This is the KDE config backup file taken with transfuse from another workstation.
export results_file="./output.txt"

echo "" | tee $results_file

# Check if we are running as root
current_user=$(whoami)
echo "The current user is $current_user" | tee -a $results_file
if [[ $current_user != "root" ]]; then
    echo "Must be root user. Try 'su -'" | tee -a $results_file
    exit 1
fi

# Install KDE
echo ""
echo "Step 1 - install KDE"
sleep $time
# Note: KDE will ask for the default graphics provider. Select sddm. Consider automating this.
# DEBIAN_FRONTEND=noninteractive This does not do any good. 
if [[ $(apt list --installed | grep kde-plasma-desktop | wc -l) > 0 ]]; then # If KDE plasma is already installed
    echo "KDE.......................... already installed" | tee -a $results_file
else
    apt-get install kde-full -y
    echo "Installed KDE. Now please reboot and run this script again." | tee -a $results_file
    exit 0 
fi

# jq
echo ""
echo "Step 2 - install jq"
sleep $time
sudo apt install jq -y
echo "jq........................... installed or reinstalled with apt" | tee -a $results_file

# curl
echo ""
echo "Step 3 - install curl"
sleep $time
sudo apt install curl -y
echo "curl......................... installed or reinstalled with apt" | tee -a $results_file

# filezilla
echo ""
echo "Step 4 - install filezilla"
sleep $time
sudo apt-get install filezilla -y
echo "filezilla.................... installed or reinstalled with apt" | tee -a $results_file

# keepassxc
echo ""
echo "Step 5 - install keepassxc"
sleep $time
sudo apt-get install keepassxc -y
echo "keepassxc.................... installed or reinstalled with apt" | tee -a $results_file

echo ""
echo "Step 6 - install Chrome"
sleep $time
if [[ $(apt list --installed | grep google-chrome-stable | wc -l) > 0 ]]; then # Is chrome already installed?
    echo "Chrome....................... already installed" | tee -a $results_file
else
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
    echo "Chrome....................... installed now" | tee -a $results_file
fi

# google-drive-ocamlfuse
echo ""
echo "Step 7 - install google-drive-ocamlfuse"
sleep $time
if [[ $(apt list --installed | grep google-drive-ocamlfuse | wc -l) > 0 ]]; then # Is it already installed?
    echo "google-drive-ocamlfuse....... already installed" | tee -a $results_file
else
    add-apt-repository ppa:alessandro-strada/ppa -y
    apt-get update
    apt-get install google-drive-ocamlfuse
    mkdir "/home/${myuser}/googledrive"
    chown -R ${myuser}:${myuser} "/home/${myuser}/googledrive"
    chmod -R 700 "/home/${myuser}/googledrive"
    echo "google-drive-ocamlfuse....... installed now" | tee -a $results_file
fi
# then, as juliano (or whatever user), to mount: $ google-drive-ocamlfuse /home/juliano/googledrive

# helm 3
echo ""
echo "Step 8 - install helm (latest)"
sleep $time
if [[ ! -e "/usr/local/bin/helm" ]]; then # Check if helm binary does not exist
    mkdir -p /usr/local/bin
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo "Helm......................... installed now" | tee -a $results_file
else
    echo "Helm......................... already installed." | tee -a $results_file
fi

# Fix up nano
echo ""
echo "Step 9 - fix up nano"
if [[ $(cat /home/${myuser}/.nanorc | grep "set linenumbers" | wc -l) = 0 ]]; then
    echo "set linenumbers" > /home/${myuser}/.nanorc
    chown juliano:juliano /home/juliano/.nanorc
    chmod 744 /home/juliano/.nanorc
    echo "Nano......................... configured now" | tee -a $results_file
else
    echo "Nano......................... already configured" | tee -a $results_file
fi

# docker
echo ""
echo "Step 10 - install docker"
sleep $time
apt install docker.io -y
echo "Docker....................... installed or reinstalled with apt" | tee -a $results_file
gpasswd -a ${myuser} docker

# nmap
echo ""
echo "Step 11 - install nmap"
sleep $time
sudo apt install nmap -y
echo "Nmap......................... installed or reinstalled with apt" | tee -a $results_file

echo ""
echo "Step 12 - install postgres client"
sleep $time
sudo apt install postgresql-client-14 -y
echo "Postgresql-client-14......... installed or reinstalled with apt" | tee -a $results_file

echo ""
echo "Step 13 - install mysql-client-8.0"
sleep $time
sudo apt install mysql-client-8.0 -y
echo "Mysql-client-8.0............. installed or reinstalled with apt" | tee -a $results_file

echo ""
echo "Step 14 - install tree"
sleep $time
sudo apt install tree -y
echo "Tree......................... installed or reinstalled with apt" | tee -a $results_file

# terraform
echo ""
echo "Step 15 - install terraform"
sleep $time
if [[ $(apt list --installed | grep terraform | wc -l) > 0 ]]; then # Is it already installed?
    echo "Terraform.................... already installed" | tee -a $results_file
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
    echo "Terraform.................... installed now" | tee -a $results_file
fi

# aws cli
echo ""
echo "Step 16 - install aws cli"
sleep $time
if [[ -e "/usr/local/bin/aws" ]]; then # Check if the application binary exists
    echo "Aws cli...................... already installed" | tee -a $results_file
else
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    apt install unzip -y
    unzip /tmp/awscliv2.zip -d /tmp
    /tmp/aws/install
    echo "Aws cli...................... installed now" | tee -a $results_file
fi

echo ""
echo "Step 17 - kubectl (1.23)"
sleep $time
if [[ -e "/usr/bin/kubectl" ]]; then # Check if the application binary exists
    echo "Kubectl...................... already installed" | tee -a $results_file
else
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.15/2023-01-11/bin/linux/amd64/kubectl
    mv kubectl /usr/bin/
    chmod +x /usr/bin/kubectl
    echo "Kubectl...................... installed now" | tee -a $results_file
fi

echo ""
echo "Step 18 - install lens"
sleep $time
if [[ $(apt list --installed | grep lens | wc -l) > 0 ]]; then # Is it already installed?
    echo "Lens......................... already installed" | tee -a $results_file
else
    curl -fsSL https://downloads.k8slens.dev/keys/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/lens-archive-keyring.gpg > /dev/null
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/lens-archive-keyring.gpg] https://downloads.k8slens.dev/apt/debian stable main" | tee /etc/apt/sources.list.d/lens.list > /dev/null
    apt update
    apt install lens -y
    echo "Lens......................... installed now" | tee -a $results_file
fi

echo ""
echo "Step 19 - KDE configs with transfuse"
sleep $time
if [[ -e "./transfuse" ]]; then # Check if transfuse project is already here
    echo "KDE configs with transfuse... already installed" | tee -a $results_file
else
    git clone https://gitlab.com/cscs/transfuse.git
    cp ./${transfuse_backup} ./transfuse/ || transfuse_error=1
    if [[ $transfuse_error == 1 ]]; then 
        echo ""
        echo ""
        echo "Error in step 19. Failed command 'cp workstation/${transfuse_backup} transfuse/'." | tee -a $results_file
        echo "pwd=" | tee -a $results_file
        pwd | tee -a $results_file
        exit 1
    fi 
    cd ./transfuse
    echo ""
    echo "***********************************" | tee -a $results_file
    echo "***** Attention! Please read. *****" | tee -a $results_file
    echo "***********************************" | tee -a $results_file
    echo "Running transfuse." | tee -a $results_file
    echo "Choose the Restore option;" | tee -a $results_file
    echo "Type username '${myuser}'" | tee -a $results_file
    echo "Choose the backup file, that will be sugested." | tee -a $results_file
    echo "Or choose to quit and do nothing." | tee -a $results_file
    echo "If you see error 'Application plasmashell could not be found...' reboot the workstation and the updated configs will be there." | tee -a $results_file
    echo ""
    su juliano -c "./transfuse.sh"
    echo ""
    echo "Done with transfuse." | tee -a $results_file
    cd $olddir
    echo "KDE configs with transfuse... installed now" | tee -a $results_file
fi
# also consider: Plasma Customization Server ; https://store.kde.org/p/1298955/
# also consider: https://github.com/Prayag2/konsave

echo ""
echo "Step 20 - Visual Studio Code"
sleep $time
if [[ $(apt list --installed | grep -E -- "^(code/now)|(code/stable)" | wc -l) > 0 ]]; then # Is it already installed?
    echo "Visual Studio Code........... already installed" | tee -a $results_file
else
    curl https://az764295.vo.msecnd.net/stable/6c3e3dba23e8fadc360aed75ce363ba185c49794/code_1.81.1-1691620686_amd64.deb -o /tmp/code_1.81.1-1691620686_amd64.deb
    apt install /tmp/code_1.81.1-1691620686_amd64.deb
    echo "Visual Studio Code........... installed now" | tee -a $results_file
fi

echo ""
echo "Step 21 - add ${myuser} to sudoers"
sleep $time
if [[ -e "/etc/sudoers.d/${myuser}" ]]; then # Check if sudoers file already exist
    echo "Add ${myuser} to sudoers....... already done" | tee -a $results_file
else
    echo "${myuser}  ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers.d/${myuser}
    echo "Add ${myuser} to sudoers....... done now" | tee -a $results_file
fi

echo ""
echo "Step 22 - setup portuguese keyboard layout"
sleep $time
if [[ ! -e "/home/${myuser}/.config/kxkbrc" ]]; then # Check if the file in which the keyboard layout it set exists
    echo "Error: looks like file /home/${myuser}/.config/kxkbrc does not exist." | tee -a $results_file
    # log results
    echo "Setup keyboard language...... skipped, file missing" | tee -a $results_file
else
    # if the file exists, we do it. 
    if [[ $(cat /home/${myuser}/.config/kxkbrc | grep LayoutList=br | wc -l) > 0 ]]; then
        echo "Looks like file /home/${myuser}/.config/kxkbrc already has the keyboard configuration. Skipping."
        # log results
        echo "Setup keyboard language...... already done" | tee -a $results_file
    else
        echo "Adding keyboard language layout config to file /home/${myuser}/.config/kxkbrc ..."
        echo "" | tee -a /home/${myuser}/.config/kxkbrc
        echo "[Layout]" | tee -a /home/${myuser}/.config/kxkbrc
        echo "LayoutList=br" | tee -a /home/${myuser}/.config/kxkbrc
        echo "Use=true" | tee -a /home/${myuser}/.config/kxkbrc
        # log results
        echo "Setup keyboard language...... done now" | tee -a $results_file
    fi
fi

echo ""
echo "Step 23 - konsole keyboard shortcuts"
sleep $time
file="/home/${myuser}/.local/share/kxmlgui5/konsole/sessionui.rc"
if [[ ! -e "$file"  ]]; then # Check if the konsole config file in which shortcuts go exists; looks like it does not get created until konsole is first opened, or maybe first configured. 
    error=0
    cp ./sessionui.rc "/home/${myuser}/.local/share/kxmlgui5/konsole/" || error=1
    if [[ $error -eq 1 ]]; then
        # for some reason, could not save copy file sessionui.rc to its destination
        # log results
        echo "Konsole keyboard shortcuts... Error, could not copy into $file" | tee -a $results_file
    else
        # success
        # log results
        echo "Konsole keyboard shortcuts... done now" | tee -a $results_file
    fi
else
    # file already exists. Skipping.
    # log results
    echo "Konsole keyboard shortcuts... skipping, file exists" | tee -a $results_file
fi

echo ""
echo "Step 24 - Systems settings - workspace behavior"
sleep $time
# changing first file
# here, in file $file, we find 'gtk-primary-button-warps-slider=false' and replace the 'false' with 'true'.
file="/home/${myuser}/.config/gtk-3.0/settings.ini"
count=0
count=$(cat $file | grep gtk-primary-button-warps-slider | wc -l)
if [[ $count -eq 0 ]]; then
    # error: line is not in the file (maybe consider adding the line?)
    # log result
    echo "settings.ini ................ error, line missing; not changed" | tee -a $results_file
elif [[ $count -eq 1 ]]; then 
    # see if the value is true or false
    if [[ $(cat $file | grep gtk-primary-button-warps-slider=false | wc -l) -eq 1 ]]; then
        # value is false; replace with true
        sed -i 's/gtk-primary-button-warps-slider=false/gtk-primary-button-warps-slider=true/' $file
        # log result
        echo "settings.ini ................ value updated" | tee -a $results_file
    elif [[ $(cat $file | grep gtk-primary-button-warps-slider=true | wc -l) -eq 1 ]]; then
        # value is true already; do nothing 
        # log result
        echo "settings.ini ................ already done" | tee -a $results_file
    else
        # unexpected result
        # log result
        echo "settings.ini ................ error - unexpected result while assessing state" | tee -a $results_file
    fi
fi
# changing second file 
# here, in file $file, we find 'gtk-primary-button-warps-slider=false' and replace the 'false' with 'true'.
file="/home/${myuser}/.config/gtk-4.0/settings.ini"
count=0
count=$(cat $file | grep gtk-primary-button-warps-slider | wc -l)
if [[ $count -eq 0 ]]; then
    # error: line is not in the file (maybe consider adding the line?)
    # log result
    echo "settings.ini ................ error, line missing; not changed" | tee -a $results_file
elif [[ $count -eq 1 ]]; then 
    # see if the value is true or false
    if [[ $(cat $file | grep gtk-primary-button-warps-slider=false | wc -l) -eq 1 ]]; then
        # value is false; replace with true
        sed -i 's/gtk-primary-button-warps-slider=false/gtk-primary-button-warps-slider=true/' $file
        # log result
        echo "settings.ini ................ value updated" | tee -a $results_file
    elif [[ $(cat $file | grep gtk-primary-button-warps-slider=true | wc -l) -eq 1 ]]; then
        # value is true already; do nothing 
        # log result
        echo "settings.ini ................ already done" | tee -a $results_file
    else
        # unexpected result
        # log result
        echo "settings.ini ................ error - unexpected result while assessing state" | tee -a $results_file
    fi
fi
# changing third file
# here, if we have string "LookAndFeelPackage=org.kde.breezedark.desktop" in file "~/.config/kdeglobals" we put, under it, these lines:
# "ScrollbarLeftClickNavigatesByPage=false
# SingleClick=false"
# So let's do it. 
file="/home/${myuser}/.config/kdeglobals"
positionstring="LookAndFeelPackage=org.kde.breezedark.desktop"
# 1) First we see if the value even is in the file. 
if [[ $(cat $file  | grep ${positionstring} | wc -l ) -eq 0 ]]; then
    echo "Unexpected condition updating file ${file}: position string not found"
    # save results
    echo "kdeglobals .................. skipped - unexpected condition, positional string not found in file ${file}" | tee -a $results_file
else
    # 3) Then we see if we didn't do it already. 
    already1=$(cat $file | grep ScrollbarLeftClickNavigatesByPage | wc -l)
    already2=$(cat $file | grep SingleClick | wc -l)
    if [[ $already1 -gt 0 || $already2 -gt 0 ]]; then
        # Looks like the values are there already. They could be true. But we were expecting the values to not be there at all. 
        # save results
        echo "kdeglobals .................. skipped - values are already present (but they could be true)" | tee -a $results_file
    else
        # Then we add the line, by splitting the file in two, then gluing the first bit, then the line, then the second bit.
        # 2) Cut the first bit of the file. 
        tempfile=$(mktemp) # create temp file 
        position=$(awk "/${positionstring}/{ print NR; exit }" $file) # find where the positional string is 
        head $file -n $position > $tempfile # cut file 
        # 3) Cut the rest of the file. 
        totalsize=$(cat $file | wc -l) # get total size of file 
        rest=$((totalsize-position))
        tempfile2=$(mktemp)
        tail $file -n $rest > $tempfile2
        # 4) Glue the final product 
        cp $file /tmp/kdeglobals-backup # save backup first 
        tempfile4=$(mktemp) # create temp file
        cp $tempfile $tempfile4 # Add the first half 
        echo "ScrollbarLeftClickNavigatesByPage=false" >> $tempfile4 # Add the lines we want 
        echo "SingleClick=false" >> $tempfile4
        cat $tempfile2 >> $tempfile4 # Add the second half 
        cp $tempfile4 $file # Save the glued file where is has to be. 
        # save results
        echo "kdeglobals .................. updated now" | tee -a $results_file
    fi
fi
# Changing fourth file
file="/home/${myuser}/.config/xsettingsd/xsettingsd.conf"
# What are we doing here? 
# In the mentioned file, replace: 
# This string: "Gtk/PrimaryButtonWarpsSlider 0"
# With this:   "Gtk/PrimaryButtonWarpsSlider 1"
count=0
count=$(cat $file | grep "Gtk/PrimaryButtonWarpsSlider" | wc -l)
if [[ $count -eq 0 ]]; then
    # error: line is not in the file (maybe consider adding the line?)
    # log result
    echo "xsettingsd.conf ............. error, line missing; not changed" | tee -a $results_file
elif [[ $count -eq 1 ]]; then 
    # see if the value is true or false
    if [[ $(cat $file | grep "Gtk/PrimaryButtonWarpsSlider 0" | wc -l) -eq 1 ]]; then
        # value is 0; replace with 1
        sed -i 's/Gtk\/PrimaryButtonWarpsSlider 0/Gtk\/PrimaryButtonWarpsSlider 1/' $file
        # log result
        echo "xsettingsd.conf.............. value updated" | tee -a $results_file
    elif [[ $(cat $file | grep "Gtk/PrimaryButtonWarpsSlider 1" | wc -l) -eq 1 ]]; then
        # value is 1 already; do nothing 
        # log result
        echo "xsettingsd.conf.............. already done" | tee -a $results_file
    else
        # unexpected result
        # log result
        echo "xsettingsd.conf.............. error - unexpected result while assessing state" | tee -a $results_file
    fi
fi
# Fifth file
file="/home/${myuser}/.gtkrc-2.0"
# What are we doing here? 
# In the mentioned file, replace: 
# This string: "gtk-primary-button-warps-slider=0"
# With this:   "gtk-primary-button-warps-slider=1"
count=0
count=$(cat $file | grep "gtk-primary-button-warps-slider" | wc -l)
if [[ $count -eq 0 ]]; then
    # error: line is not in the file (maybe consider adding the line?)
    # log result
    echo ".gtkrc-2.0 .................. error, line missing; not changed" | tee -a $results_file
    
elif [[ $count -eq 1 ]]; then 
    # see if the value is true or false
    if [[ $(cat $file | grep "gtk-primary-button-warps-slider=0" | wc -l) -eq 1 ]]; then
        # value is 0; replace with 1
        sed -i 's/gtk-primary-button-warps-slider=0/gtk-primary-button-warps-slider=1/' $file
        # log result
        echo ".gtkrc-2.0 .................. value updated" | tee -a $results_file
    elif [[ $(cat $file | grep "gtk-primary-button-warps-slider=1" | wc -l) -eq 1 ]]; then
        # value is 1 already; do nothing 
        # log result
        echo ".gtkrc-2.0 .................. already done" | tee -a $results_file
    else
        # unexpected result
        # log result
        echo ".gtkrc-2.0 .................. error - unexpected result while assessing state" | tee -a $results_file
    fi
fi

echo ""
echo "Step 25 - Bash shortcuts, alias and other .bashrc items"
sleep $time
# changing first file
# here, in file $file, we find 'gtk-primary-button-warps-slider=false' and replace the 'false' with 'true'.
file="/home/${myuser}/.bashrc"
# count=0
if [[ $(cat $file  | grep juliano-bashrc-config-done | wc -l ) -gt 0 ]]; then
    # already done
    echo ".bashrc ..................... already done" | tee -a $results_file
else
    # not yet done. So let's do it now
    failed=0
    ln -s /home/juliano/googledrive/dinheiro/BairesDev/ViaPath/docs /home/juliano/Documents/docs                                || { ((++failed)) ; echo "failed shortcut 1" ; }
    ln -s /home/juliano/googledrive/dinheiro/BairesDev/ViaPath/docs /home/juliano/d                                             || { ((++failed)) ; echo "failed shortcut 2" ; }
    ln -s /home/juliano/Documents/gitlab-viapath/ /home/juliano/gl                                                              || { ((++failed)) ; echo "failed shortcut 3" ; }
    ln -s /home/juliano/Documents/github/ /home/juliano/gh                                                                      || { ((++failed)) ; echo "failed shortcut 4" ; }
    tee -a $file < ./bashrc-append || { ((++failed)) ; echo "failed tee to $file" ; }

    if [[ $failed -eq 0 ]]; then
        # all good
        echo ".bashrc ..................... done now" | tee -a $results_file
    else
        # at least some failed
        echo ".bashrc ..................... done, but $failed opertations failed. Check log." | tee -a $results_file
    fi
fi

echo ""
echo "Step 26 - AWS credential emptied files"
sleep $time
# file="/home/${myuser}/.local/share/kxmlgui5/konsole/sessionui.rc"
echo "pwd = $(pwd)"
if [[ ! -e "/home/${myuser}/.aws/config" && ! -e "/home/${myuser}/.aws/credentials" ]]; then # Check if the file does not exist yet 
    #if [[ $(pwd) != "/home/juliano/workstation" ]]; then
    #    echo "whoops! we are not in the right folder"
    #fi
    cp -r ./.aws /home/${myuser}/
    chown -R ${myuser}:${myuser} ./.aws
    chmod -R 700 ./.aws
    echo "AWS emptied credentials...... Done now" | tee -a $results_file
else    
    echo "AWS emptied credentials...... already done" | tee -a $results_file
fi    

echo ""
echo "Step 27 - ssh key"
sleep $time
if [[ ! -e "/home/${myuser}/.ssh/id_rsa" ]]; then # Check if the file does not exist yet 
    mkdir -p "/home/${myuser}/.ssh"
    ssh-keygen -N "" -f "/home/${myuser}/.ssh/id_rsa"
    chown -R ${myuser}:${myuser} "/home/${myuser}/.ssh"
    chmod -R 700 "/home/${myuser}/.ssh"
    echo "ssh key ..................... Done now" | tee -a $results_file
else    
    echo "ssh key ..................... already done" | tee -a $results_file
fi    

# now we print the result to standard output, to a file, then end. 
cat <<EOF  | tee -a $results_file

Looks like we are done!
EOF

cat <<EOF  | tee -a $results_file

Take note of steps that can't/won't be automated:
 - add local machine public key to github/gitlab account
 - configure local git username & email
 - sync accounts in Visual Studio Code, Google Chrome, Firefox

If you want Cisco company VPN installed, check here: 
https://github.com/jrkessl/workstation/blob/d953a5b9b940c827582ce404a2aa06e008a18cb7/workstation.sh#L182

Reboot for all settings to take place.

EOF

echo ""
echo "Read the summary of this run in file ${results_file}."

# consider:
# adding "git recentb" command. Source: https://stackoverflow.com/questions/5188320/how-can-i-get-a-list-of-git-branches-ordered-by-most-recent-commit

# consider: 
# installing piper and configuring ctrl + page up, ctrl + page down for the side buttons.

# consider:
# enabling numlock on in boot in plasma keyboard configurations.

# alias gs="git status"
# alias ga="git add ."

