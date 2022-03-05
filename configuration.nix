# HELP          =>  $ man configuration.nix  
# SEARCH PKGs   =>  $ nix-env -qaP | grep wget

{ config, pkgs, lib, ... }:
with pkgs; 
let 
	dev 	    = "/dev/nvme0n1"; 
	dev1	 	= "${dev}p1";
    dev2	 	= "${dev}p2";
    dev3	 	= "${dev}p3";
	p		    = (import ./packages.nix) pkgs;
    #vim_        = vim_configurable.customize{
    #                  name = "vim-with-plugins";
    #                  vimrcConfig.packages.myVimPackages = with pkgs.vimPlugins; {
    #                      start = [ vimproc ];
    #                  };
    #              };
    vim_          = vim_configurable.override {python = python3; };
    vaapiIntel    = pkgs.vaapiIntel.override { enableHybridCodec = true; };
in
{
    imports                     =   [ ./hardware-configuration.nix ];

    hardware                    =   {
        opengl                      = {
            driSupport32Bit             = true;
            extraPackages               = [ 
                intel-media-driver
                vaapiIntel
                vaapiVdpau
                libvdpau-va-gl
            ];
        };
        pulseaudio.enable           = true;
        bluetooth.enable            = true; 
    };

    boot                        =   {
        #kernelPackages              = linuxPackages_latest;
        consoleLogLevel             = 5 ;
        kernelParams                = ["resume=${dev3}" ];
        blacklistedKernelModules    = ["nouveau"];
        # extraModulePackages         = with config.boot.kernelPackages; [ wireguard ]; 
        initrd                      = {
            checkJournalingFS   = false;   
            luks.devices        = {
                root            = {
                    device              = dev3;
                    preLVM              = true;  
                }; 
            }; 
        };
        loader                  = {
            #grub                    = {
            #    enable                  = true;
            #    device                  = dev;
            #    #device                  = "nodev";
            #    extraConfig             = "GRUB_CMDLINE_LINUX_DEFAULT=\"resume=${dev3}\""; 
            #};
	    efi.canTouchEfiVariables = true;
	    systemd-boot.enable      = true;
        };
    };

    time.timeZone               =   "Asia/Tokyo";
    
    networking                  =   {
        hostName                    = "ghasshee";
        networkmanager.enable       = true;
        nameservers             = [ "8.8.8.8" "8.8.4.4" ];
        firewall                = {
            enable                  = false;
            allowPing               = false;
            allowedTCPPorts         = [ 631 8080 ];
            allowedUDPPorts         = [ 631 ]; 
        };
    };
    
    console                     =   { 
        font                        = "Lat2-Terminus16"; 
        keyMap                      = "us"; 
    };

    fonts.fonts = [
      source-code-pro
      mononoki
    ];
    
    i18n                        =   {
        # consoleFont                 = "Lat2-Terminus16";
        # consoleKeyMap               = "us";
        defaultLocale               = "en_US.UTF-8";
        inputMethod                 = {
            enabled                     = "ibus";
            ibus.engines                = with ibus-engines; [ anthy m17n mozc ]; 
        };
    };

    nix                         =   {
        binaryCaches                = [http://cache.nixos.org];
        useSandbox                  = true;
    };
    
    nixpkgs.config              =   {
        allowUnfree                 = true;
        allowBroken                 = true;
        ## firefox.icedtea             = true;
    };

    # security.pam.services.lightdm.enableKwallet = true;
    
    environment                 =   {
          etc."fuse.conf".text      = ''user_allow_other'';
          pathsToLink               = [
              "/share/agda"
          ];
          systemPackages            = [
                vim_  ## vim
                emacs
                gptfdisk ## gdisk 
                config.boot.kernelPackages.perf         ## linuxPackages.perf
                flamegraph                              ## google perf & flamegraph 
                xorg.xlibsWrapper xlibs.xmodmap acpilight xterm tty-clock xcalib tk tcl freeglut
                numix-icon-theme-circle numix-gtk-theme
                xfce.thunar-dropbox-plugin
                xfce.xfce4-battery-plugin
                xfce.xfce4-clipman-plugin
                xfce.thunar-dropbox-plugin
                plasma-workspace
                ibus-qt
                fuse_exfat
                gnutar
                archiver
                rpm dpkg
                rpm2targz

                avahi


                pulseaudioLight 
                alsaUtils 
            ] ++ p;
        };

    location = {
        longitude               = 135.0;
        latitude                = 40.0;
    };

    services                = {
        locate                  = {
            enable                  = true;
            locate                  = pkgs.mlocate;
            localuser               = null; # needed so mlocate can run as root
            #interval                = "hourly" ; 
            #interval                = "00 05 * * *"; 
        };
        acpid.enable            = true;
        redshift                = {
            enable                  = true;
        };
        openssh.enable          = true;
        xserver                 = {
            enable                  = true;
            layout                  = "us";
            xkbOptions              = "eurosign:e";
            displayManager     = {
                #lightdm.enable          = true; 
                autoLogin.user          = "ghasshee";
                autoLogin.enable        = true;     
            };
            desktopManager          = {
                #xfce.enable             = true;
                plasma5.enable          = true; 
            };
            libinput                = {
                enable                  = false;
                touchpad            = {
                    naturalScrolling        = true;
                    accelSpeed              = "250";
                    accelProfile            = "flat";
                };
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
                    ''; 
            };
        };

        printing                = {
            enable                  = true; # enable CUPS Printing 
            drivers                 = [ gutenprint canon-cups-ufr2 carps-cups cups-bjnp cups-zj-58];
            browsing = true; 
            # listenAddresses = [ "*:631" ]; 
            # allowFrom = [ "all" ]; 
            # defaultShared = true; 
        };

        avahi                   = {
            enable  = true; 
            publish = { 
                enable = true; 
                userServices = true; 
            };
        }; 


    };


    # Shells
    programs            = {
        zsh                 = {
            enable                  = true;
            promptInit              = "";
            interactiveShellInit    = ""; 
        };
    };
    
    virtualisation.docker.enable = true;


#########  User ( Do not forget to set with `passwd` ) 
    users                   = {
        users               = {
            ghasshee            = {
	            isNormalUser        = true;
	            home                = "/home/ghasshee";
	            extraGroups         = ["wheel" "networkmanager" "adbusers" "docker" "mlocate"];
      	        shell               = "/run/current-system/sw/bin/zsh";
                uid                 = 1000;     };};
        };
        #extraUsers          = {};
#    system.stateVersion = "20.03";
  
}

