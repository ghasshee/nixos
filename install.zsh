

sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration-old.nix
sudo ln -s $HOME/ghasshee/nixos/configuration.nix /etc/nixos/configuration.nix
if [[ -d ~/.config ]] ; then mv ~/.config ~/.config-old ; fi
ln -s $HOME/ghasshee/nixos/.config/ ~/.config
