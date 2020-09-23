#!/bin/sh

[[ `uname` == 'Linux'  ]] && NIX=/run/current-system/sw/bin/nix
[[ `uname` == 'Darwin' ]] && NIX=~/.nix-profile/bin/nix


backup_config(){
cp -r ~/.config/dconf   ~/ghasshee/nixos/.config
cp -r ~/.config/gtk-2.0 ~/ghasshee/nixos/.config
cp -r ~/.config/ibus    ~/ghasshee/nixos/.config
cp -r ~/.config/Thunar  ~/ghasshee/nixos/.config
cp -r ~/.config/xfce4   ~/ghasshee/nixos/.config
}

backup(){
cp /etc/nixos/configuration.nix ~/ghasshee/nixos
cp /etc/nixos/packages.nix      ~/ghasshee/nixos
}

install_config(){

SRCFILE=~/.config;
TGTFILE="${SRCFILE}_"
while true ; do  
    if [[ -d $SRCFILE ]] 
    then 
        if [[ -d $TGTFILE ]]
        then 
            TGTFILE="${TGTFILE}_"; continue
        else 
            mv $SRCFILE $TGTFILE ; break
        fi 
    fi  
done    
cp -r $HOME/ghasshee/nixos/.config/ ~/.config
}

install(){
if [[ -e /etc/nixos/configuration.nix ]] 
then
    sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration-old.nix
fi
if [[ -e /etc/nixos/packages.nix ]] 
then
    sudo mv /etc/nixos/packages.nix /etc/nixos/packages-old.nix
fi
sudo cp $HOME/ghasshee/nixos/configuration.nix /etc/nixos/configuration.nix 
sudo cp $HOME/ghasshee/nixos/packages.nix /etc/nixos/packages.nix 
}

if      [[ $1 == "backup"   ]] ; then 
    backup_config;
    backup
elif    [[ $1 == "install"  ]] ; then
    install_config;
    install
elif    [[ $1 == "help" || $1 == "--help" || $1 == "-h" ]] ; then 
    echo "
Usage:"
    echo -en "\033[32m"
    echo "
    $ nix backup        ## backup  nix-files: /etc/nixos/configuration.nix .. && ~/.config
    $ nix install       ## install nix-files
    $ nix help          ## show this help menu " 
    echo -e "\033[0m"
    $NIX --help
elif    [[ $1 == "push" ]] ; then 
    cd $NIX; git add --all; git commit -m "Update"; git push 
elif    [[ $1 == "pull" ]] ; then 
    cd $NIX; git pull
else
    $NIX $@
fi


