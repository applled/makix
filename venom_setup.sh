#!/bin/bash

update_packages() {
yes|pkg upgrade
apt update -y
apt upgrade -y
}


install_pkgs() {
clear
echo -e "Installing required apt packages"
yes|apt install wget python3 git neofetch curl ffmpeg mediainfo
echo "Done"
}


fix_resolve() {
clear
echo -e "Fixing Python issue."
wget -q https://raw.githubusercontent.com/ux-termux/venomx/main/resolver.py
python -c """
import os
from sys import version_info as ver
termux_check = os.environ.get('TERMUX_APK_RELEASE')
if termux_check == 'F_DROID':
    if ver[1] == 11:
        respath =f'/data/data/com.termux/files/usr/lib/python3.11/site-packages/dns/'
        resname = 'resolver.py'
        full_path = respath + resname
        os.remove(str(full_path))
        os.system(f'mv {resname} {respath}')
        os.system('echo nameserver 8.8.8.8 > /data/data/com.termux/files/usr/etc/resolv.conf')
        if os.path.isfile(resname):
            os.remove(resname)
        print("Done")
    else:
        print("Update Python version to 3.11")
"""
}


bot() {
clear
echo "Clonning Bot Repository."
git clone -q https://github.com/ashwinstr/VenomX
cd VenomX
echo "Installing Pypi Requirments"
pip install -r requirements.txt
clear
mv config.env.sample config.env
echo -e 'Entering Config editor\nEnclose Alphanumeric variables in " " quotes.'
sleep 5
nano config.env
}


check_termux() {
 if [[ $TERMUX_APK_RELEASE == "F_DROID" ]]; then
    update_packages
    install_pkgs
    fix_resolve
    bot
    echo -e "Now run ' cd VenomX ' and then ' bash run ' to start bot."
else
    echo -e "Play Store Termux not supported,\nDownload it from F-Droid"
fi
}


check_termux
