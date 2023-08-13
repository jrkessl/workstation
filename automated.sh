#!/bin/bash

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
# Note: KDE will ask for the default graphics provider. Select sddm. Consider automating this.
# DEBIAN_FRONTEND=noninteractive This does not do any good. 
if [[ $(apt list --installed | grep kde-plasma-desktop | wc -l) > 0 ]]; then # If KDE plasma is already installed
    echo "KDE is already installed. Proceeding to file 'automated2.sh'."
    # Triggering file 'automated2.sh'
    if [[ ! -e "$(pwd)/automated2.sh" ]]; then
        echo "Error: script file 'automated2.sh' not found in current directory. It was going to be triggered now. Please fix this script or trigger 'automated2.sh' manually."
        echo "Exitting..."
        exit 1
    fi
    $"$(pwd)/automated2.sh"
    pwd
    exit 0
else
    apt-get install kde-full -y
    echo "Installed KDE. Now please reboot and resume with file 'automated2.sh'."
fi

