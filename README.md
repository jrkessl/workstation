# Workstation

This is my personal workstation configurator. Often I have to reinstall my Linux machine for several reasons. And this automates (almost) all the stuff I need. From a fresh Ubuntu installation I install the software and make the configurations I became reliant on. It may work with other distros as well, as long as they have apt.
## What it does
 - Installs KDE
 - Applies my prefered configs for KDE, including keyboard layout and window management preferences
 - Installs a bunch of software using apt, and some by downloading and running installers
 - Applies my prefered configurations for nano, creates my bash sortcuts, aliases and bash prompt config. 
## How to use it
 - In a fresh Ubuntu installation, install git and 'git clone' the project. 
 - Run automated.sh as root (it will remind you if you are not root).
 - The prompts should provide sufficient instructions. 
## How it works
 - It is a bash script that applies settings/installs software using apt or by downloading and running binaries. 
 - It's made to check every setting before applying it, so if there was any problem you can re-run the script and the already applied settings will not be applied in duplicity.
 - It's done for a given user. This user is parametized and can be changed in the first lines of the script mentioned above. 
 - Some of the KDE settings are applied with a backup of KDE settings previously made with the [transfuse](https://gitlab.com/cscs/transfuse.git) application. 