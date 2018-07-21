
if [[ -d /etc/nixos/configuration.nix ]] 
then
    sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration-old.nix
fi
sudo cp $HOME/ghasshee/nixos/configuration.nix /etc/nixos/configuration.nix
# if [[ -d ~/.config ]] ; then mv ~/.config ~/.config-old ; fi
# cp -r $HOME/ghasshee/nixos/.config/ ~/.config
