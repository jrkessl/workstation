#!/bin/bash

export myuser=juliano    # This is the user for which we will install stuff.
export time=0.1          # This is how long to wait after some outputs so I can read them. 
export results           # This is to summarize results at the end of the script.
export transfuse_backup=juliano_transfusion_20230814_2206.tar.gz # This is the KDE config backup file taken with transfuse from another workstation.

# Check if we are running as root
current_user=$(whoami)
echo "The current user is $current_user"
if [[ $current_user != "root" ]]; then
    echo "Must be root user. Try 'su -'"
    exit 1
fi


# Install KDE
echo ""
echo "Step 1 - install KDE"
sleep $time
# Note: KDE will ask for the default graphics provider. Select sddm. Consider automating this.
# DEBIAN_FRONTEND=noninteractive This does not do any good. 
if [[ $(apt list --installed | grep kde-plasma-desktop | wc -l) > 0 ]]; then # If KDE plasma is already installed
    echo "KDE is already installed. Proceeding to file 'automated2.sh'."
    results="KDE.......................... already installed"
    # Triggering file 'automated2.sh'
    if [[ ! -e "$(pwd)/automated2.sh" ]]; then
        echo "Error: script file 'automated2.sh' not found in current directory. It was going to be triggered now. Please fix this script or trigger 'automated2.sh' manually."
        echo "Exitting..."
        exit 1
    fi
    $"$(pwd)/automated2.sh"
else
    apt-get install kde-full -y
    echo "Installed KDE. Now please reboot and run this script again."
fi

