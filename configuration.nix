# HELP          =>  $ man configuration.nix  
# SEARCH PKGs   =>  $ nix-env -qaP | grep wget

{ config, pkgs, ... }:
with pkgs; 
let 
	dev 	    = "/dev/nvme0n1"; 
	dev1	 	= "${dev}p1";
    dev2	 	= "${dev}p2";
	p		    = (import ./packages.nix) pkgs;
    #vim_        = vim_configurable.customize{
    #                  name = "vim-with-plugins";
    #                  vimrcConfig.packages.myVimPackages = with pkgs.vimPlugins; {
    #                      start = [ vimproc ];
    #                  };
    #              };`L
    vim_          = vim_configurable.override {python = python3; };
in
{
    imports                     =   [ ./hardware-configuration.nix ];
    hardware                    =   {
        opengl.driSupport32Bit      = true;
        pulseaudio.enable           = true;
        bluetooth.enable            = true; 
        };
    boot                        =   {
        kernelPackages              = linuxPackages_latest;
        consoleLogLevel             = 5 ;
        kernelParams                = ["resume=${dev2}" ];
        blacklistedKernelModules    = ["nouveau"];
        /*extraModulePackages         = with config.boot.kernelPackages; [ wireguard ];*/
        initrd                      = {
            checkJournalingFS   = false;   
            luks.devices        = {
                root            = {
                    device              = "${dev2}";
                    preLVM              = true;  
                }; 
            }; 
        };
        loader                  = {
            grub                    = {
                enable                  = true;
                # device                  = dev;
                device                  = "nodev";
                extraConfig             = "GRUB_CMDLINE_LINUX_DEFAULT=\"resume=${dev2}\""; };};
        };
    time.timeZone               =   "Asia/Tokyo";
    networking                  =   {
        hostName                    = "ghasshee";
        networkmanager.enable       = true;
        nameservers             = [ "8.8.8.8" "8.8.4.4" ];
        firewall                = {
            enable                  = false;
            allowPing               = false;
            allowedTCPPorts         = [ 8080 ];
            allowedUDPPorts         = [ ]; };
        };
    console                     =   { 
        font                        = "Lat2-terminus16"; 
        keyMap                      = "us"; 
    };
    i18n                        =   {
        # consoleFont                 = "Lat2-Terminus16";
        # consoleKeyMap               = "us";
        defaultLocale               = "en_US.UTF-8";
        inputMethod                 = {
            enabled                     = "ibus";
            ibus.engines                = with ibus-engines; [ anthy m17n ]; };
        };
    nix.binaryCaches            = [http://cache.nixos.org];
    nixpkgs.config              = {
        allowUnfree                 = true;
        allowBroken                 = true;
        ## firefox.icedtea             = true;
        };
    environment                 = 
        {
          etc."fuse.conf".text = ''user_allow_other'';
          pathsToLink    = [
              "/share/agda"
          ];
          systemPackages = [
                neovim vim_  ## vim
                zsh bvi tmux w3m git curl wget gnused xsel rename tree less rlwrap rename 
                jq mlocate unzip xz sl lolcat figlet man-db manpages sdcv bc acpi
                openssl.dev openssh gnupg sshfs stunnel 
                networkmanager iptables nettools irssi tcpdump
                ntfsprogs ## Windows File System
                nkf 

                at lsof psutils htop fzf psmisc 
                config.boot.kernelPackages.perf         ## linuxPackages.perf

                xorg.xlibsWrapper xlibs.xmodmap acpilight xterm tty-clock xcalib tk tcl freeglut
                numix-icon-theme-circle numix-gtk-theme
                xfce.thunar-dropbox-plugin
                xfce.xfce4-battery-plugin
                xfce.xfce4-clipman-plugin
                plasma-workspace

                pulseaudioLight 
                alsaUtils 
                dvdplusrwtools dvdauthor 
                espeak ffmpeg-full mplayer sox timidity 
                gnome3.totem vlc

                chromium firefoxWrapper thunderbird kdeApplications.okular mupdf evince vivaldi
                jdk11 
                skype 

                AgdaStdlib
            ] ++ p;
        };

    location = {
        longitude = 135.0;
        latitude   = 40.0;
    };
    services            = {
        locate                  = {
            enable                  = true;
            interval                = "00 05 * * *"; };
        acpid.enable            = true;
        redshift                = {
            enable                  = true;
            /*latitude                = "40";
            longitude               = "135";    */
          };
        openssh.enable          = true;
        xserver                 = {
            enable                  = true;
            layout                  = "us";
            xkbOptions              = "eurosign:e";
            displayManager.lightdm     = {
                enable                  = true;
                autoLogin.user          = "ghasshee";
                autoLogin.enable        = true;     
              };
            desktopManager          = {
                xfce.enable = false;
                plasma5.enable = true; 
              };
            libinput                = {
                enable                  = false;
                naturalScrolling        = true;
                accelSpeed              = "250";
                accelProfile            = "flat";
              };
            synaptics               = {
                enable                  = true;
                tapButtons              = false;
                twoFingerScroll         = true;
                horizontalScroll        = true;
                vertEdgeScroll          = false;
                accelFactor             = "0.015";
                buttonsMap              = [1 3 2];
                fingersMap              = [1 3 2];
                additionalOptions       = ''
                    Option "VertScrollDelta" "-50"
                    Option "HorizScrollDelta" "-20"
                    ''; };
        };
        #picom = {
        #    enable  = true;
        #    fade    = true;
        #    inactiveOpacity = "0.9";
        #    shadow  = true;
        #    fadeDelta = 4;
        #};
        printing                = {
            enable                  = true; # enable CUPS Printing 
            drivers                 = [ gutenprint hplipWithPlugin cups-bjnp cups-dymo ];};
        };
    # Shells
    programs            = {
        zsh                 = {
            enable                  = true;
            promptInit              = "";
            interactiveShellInit    = ""; };
    };
    virtualisation.docker.enable = true;
#########  User ( Do not forget to set with `passwd` ) 
    users                   = {
        users               = {};
        extraUsers          = {
            ghasshee            = {
	            isNormalUser        = true;
	            home                = "/home/ghasshee";
	            extraGroups         = ["wheel" "networkmanager" "adbusers" "docker" "mlocate"];
      	        shell               = "/run/current-system/sw/bin/zsh";
                uid                 = 1000;     };};
        };
    system.stateVersion = "19.03";
}

