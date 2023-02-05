#!/bin/bash
apt get update
apt get upgrade -y 

# manual configs:
# - konsole
#  -- ctrl + c for copy, ctrl + v for paste
#  -- font size
# - adjust task switcher
# - adjust task bar

# curl
sudo apt install curl

# filezilla
apt get install filezilla -y

# keepassxc
sudo apt install keepassxc
# https://keepassxc.org/download/#linux

# Snowflake (ftp and scp client)
# https://github.com/subhra74/snowflake
# Dowwnload file (manually, with curl does not work, not sure why) then: 
# sudo apt install ./snowflake-1.0.4-setup-amd64.deb

# visual studio code
# manually through https://code.visualstudio.com/docs/setup/linux

# chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# install virtualbox?
# sudo apt-get install virtualbox (untested, but this was the command). 
