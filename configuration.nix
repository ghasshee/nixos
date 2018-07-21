# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ];

    hardware = {
        opengl.driSupport32Bit  = true;
        pulseaudio.support32Bit = true;
        bluetooth.enable        = true;
    };

    boot = {
        initrd.luks.devices = [
            {
                name = "root";
                device = "/dev/nvme0n1p2";
                preLVM = true;
            }];
        loader = {
            grub = {
                enable = true;
                device = "/dev/nvme0n1";
                extraConfig = 
                "GRUB_CMDLINE_LINUX_DEFAULT=\"resume=/dev/nvme0n1p2\"";
#               efiSupport = true;
#               forceInstall = true;
            };
#           systemd-boot.enable = true;     # Formerly  gummiboot.enable
#           efi.canTouchEfiVariables = true;
        };
        consoleLogLevel = 5;
        kernelParams = [ "resume=/dev/nvme0n1p2" ];
        blacklistedKernelModules = ["nouveau"];
        initrd.checkJournalingFS = false;
    };

    networking = {
        hostName    = "ghasshee";
        networkmanager.enable = true;
        nameservers = [ "8.8.8.8" "8.8.4.4" ];
        firewall = {
            allowPing = true;
#           allowedTCPPorts = [ 8080 ];
#           allowedUDPPorts = [ ... ];
#           enable = false;
        };
    };

    i18n = {
        consoleFont = "Lat2-Terminus16";
        consoleKeyMap = "us";
        defaultLocale = "en_US.UTF-8";
        inputMethod = {
            enabled = "ibus";
            ibus.engines = with pkgs.ibus-engines; [ anthy m17n ];
            };
    };
    
    time.timeZone = "Asia/Tokyo";
    
    nix.binaryCaches = [http://cache.nixos.org http://hydra.nixos.org];
    nixpkgs.config = {
        allowUnfree = true;
        allowBroken = true;
        firefox.icedtea = true;
    };

    environment.etc."fuse.conf".text = ''
        user_allow_other
    '';
        
    # List packages installed in system profile. To search by name, run
    # $ nix-env -qaP | grep wget

    environment.systemPackages = with pkgs; [
nix-repl
networkmanager
acpi

# base
zsh
tree
vim
tmux
git
curl
wget
gnused 
xsel
less
jq
htop
psutils
w3m
mlocate
unzip
xz
sl 
lolcat
figlet
sshfs

# Dictionary 
sdcv 

# man 
man-db

# cipher 
openssl
openssh
gnupg

# network
irssi
iptables
nettools

# X 
xcalib
xorg.xmodmap
xlibs.xmodmap
xlibs.xbacklight
xterm
tty-clock

# tk/tcl 
tk 
tcl
    
# 
mesa
freeglut

# Analysis Tools
fzf
tcpdump
#linuxPackages.perf               # for a kernel package
config.boot.kernelPackages.perf   # for a current kernel package, 

# Dropbox
dropbox     xfce.thunar-dropbox-plugin

# Music/Sound/Video
pulseaudioLight     # pulseaudioFull
dvdplusrwtools
dvdauthor
espeak              # festival festival-english festival-us
ffmpeg
mplayer
sox
gnome3.totem vlc    # kde4.dragon kde4.kmix 

# Virtualization and Containers
docker python27Packages.docker_compose

# Browser 
chromium
firefoxWrapper

# Mail 
thunderbird

# PDF
kdeApplications.okular
mupdf

# ICON
numix-icon-theme-circle
numix-gtk-theme

# Languages
stdenv 
binutils.bintools
makeWrapper gnumake automake autoconf
libudev0-shim
gcc glibc 
gdb
nodejs
ruby
stack 
coq

# Rust
rustup

# Python
python27Full python3
python34Packages.pip
pythonPackages.ipython
pypyPackages.virtualenv
    
# Haskell
haskellPackages.cabal-install haskellPackages.ghc

ocaml
ocamlPackages.utop
ocamlPackages.camlp4
opam

# Applications
qrencode
vokoscreen
gimp
youtube-dl
skype 
evince      # Document viewer  
gnome3.eog  # image viewer
tesseract   # OCR

# Game
minecraft
    ];



    services = {
        
        acpid.enable = true;
        
        redshift = {
            enable = true;
            latitude = "40";
            longitude = "135";
        };
        
        openssh.enable = true;

        xserver = {
            enable = true;
            layout = "us";
            xkbOptions = "eurosign:e";

            displayManager.slim.enable = true;
            desktopManager.xfce.enable = true;
#           desktopManager.kde4.enable = true;
       
            synaptics = {
                enable = true;
#               tapButtons = true;
                twoFingerScroll = true;
                horizontalScroll = true;
                vertEdgeScroll = false;
                accelFactor = "0.015";
                buttonsMap = [1 3 2];
                fingersMap = [1 3 2];

                additionalOptions = ''
                    Option "VertScrollDelta" "50"
                    Option "HorizScrollDelta" "-20"
                '';
            };
        };

        printing = {
            enable = true; # enable CUPS Printing 
            drivers = [pkgs.gutenprint pkgs.hplipWithPlugin ];
        };
      
#       multitouch.enable = true;
#       multitouch.invertScroll = true;
    };

    # Shells
    programs.zsh.enable = true;
    # User ( Do not forget to set with `passwd`
    users.extraUsers.ghasshee = {
	    isNormalUser    = true;
	    home            = "/home/ghasshee";
	    extraGroups     = ["wheel" "networkmanager"];
      	shell           = "/run/current-system/sw/bin/zsh";
        uid = 1000;
    };

    system.stateVersion = "18.03";

}



