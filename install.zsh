if [[ -d /etc/nixos/configuration.nix ]] 
then
    sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration-old.nix
fi
if [[ -d /etc/nixos/packages.nix ]] 
then
    sudo mv /etc/nixos/packages.nix /etc/nixos/packages-old.nix
fi
sudo cp $HOME/ghasshee/nixos/configuration.nix /etc/nixos/configuration.nix 
sudo cp $HOME/ghasshee/nixos/packages.nix /etc/nixos/packages.nix 
