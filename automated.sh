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

# Everything with apt 
echo ""
echo "Step 2 - install everything with apt"
sleep $time
sudo apt install jq curl nmap postgresql-client-14 mysql-client-8.0 tree docker.io -y
gpasswd -a ${myuser} docker
echo "Everything with apt ..........installed or reinstalled now" | tee -a $results_file

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
if [[ $(cat /home/${myuser}/.nanorc | grep "set linenumbers" | wc -l) == 0 ]]; then
    echo "set linenumbers" > /home/${myuser}/.nanorc
    chown juliano:juliano /home/juliano/.nanorc
    chmod 744 /home/juliano/.nanorc
    echo "Nano......................... configured now" | tee -a $results_file
else
    echo "Nano......................... already configured" | tee -a $results_file
fi

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
echo "Step 17 - kubectl (1.29)"
sleep $time
if [[ -e "/usr/bin/kubectl" ]]; then # Check if the application binary exists
    echo "Kubectl...................... already installed" | tee -a $results_file
else
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/linux/amd64/kubectl
    mv kubectl /usr/bin/
    chmod +x /usr/bin/kubectl
    echo "Kubectl...................... installed now" | tee -a $results_file
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
echo "Step 25 - Bash shortcuts, alias and other .bashrc items, and folders"
sleep $time
mkdir -p /home/${myuser}/Documents/github/
mkdir -p /home/${myuser}/Documents/gitlab-viapath/
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

# consider: adding "git recentb" command. Source: https://stackoverflow.com/questions/5188320/how-can-i-get-a-list-of-git-branches-ordered-by-most-recent-commit
# consider: installing piper and configuring ctrl + page up, ctrl + page down for the side buttons.
# consider: enabling numlock on in boot in plasma keyboard configurations.

# 2024-01-07: looks like konsole copy paste shortcuts are no longer working. 
# 2024-01-07 consider: reducing mouse sensitivity in KDE to level 4.
# 2024-01-07 consider: "configure icons-only task manager" > behavior > group > by program name. 
# 2024-01-09 consider: KDE Settings > Notifications > Popup > Choose custom position > lower right corner. 


# alias gs="git status"
# alias ga="git add ."

