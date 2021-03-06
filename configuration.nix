# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = ["resume=/dev/sda2"];

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.nameservers = ["8.8.8.8"];

  # Select internationalisation properties.
  #i18n = {
    #consoleFont = "Lat2-Terminus16";
    #consoleKeyMap = "us";
    #defaultLocale = "en_US.UTF-8";
  #};
  i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ anthy m17n ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  nix.binaryCaches = [ http://cache.nixos.org http://http://hydra.nixos.org ];

  nixpkgs.config = {
      allowUnfree = true;

      firefox.icedtea = true;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    networkmanager
    
    # base
    zsh
    tree
    vim
    tmux
    git
    curl
    wget

    w3m
    mlocate
    
    # man 
    man-db

    # network
    irssi

    # X 
    xcalib
    xorg.xmodmap
    xlibs.xmodmap
    xlibs.xbacklight

    python
    python3

    openssl
    openssh

    thunderbird

    jq
    htop
    fzf
    gnupg
    gcc
    gdb
    #linuxPackages.perf                  ## for a kernel package
    tcpdump
    config.boot.kernelPackages.perf    ## for a current kernel package, 
                                        ## thanking @gchristensen  
    acpi

    dropbox
    busybox
    # Use dropbox via nix-env -i dropbox
    # dropbox-cli 
    # xfce.thunar-dropbox-plugin
    firefoxWrapper

    # Music/Sound/Video
    ffmpeg

    # PDF
    kdeApplications.okular
    mupdf

  ];

  hardware.bluetooth.enable = true;
  

  #systemd.user.services.dropbox = {
  #    restartIfChanged = true;
  #    enable = true;
  #    serviceConfig = {
  #        ExecStart = "${pkgs.dropbox}/bin/dropbox";
  #        PassEnvironment = "DISPLAY";
  #    };
  #};



  services.redshift = {
      enable = true;
      latitude = "40";
      longitude = "135";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  #services.xserver.layout = "us";
  #services.xserver.xkbOptions = "eurosign:e";

  # Enable the KDE Desktop Environment.
  #services.xserver.displayManager.slim.enable = true;
  #services.xserver.desktopManager.xfce.enable = true;
  #services.xserver.synaptics.enable = true;
  
  services.xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";

      displayManager.slim.enable = true;
      desktopManager.xfce.enable = true;

      synaptics = {
          enable = true;
          #tapButtons = true;
          twoFingerScroll = true;
          horizontalScroll = true;
          #vertEdgeScroll = false;
          accelFactor = "0.015";
          buttonsMap = [1 3 2];
          fingersMap = [1 3 2];

          additionalOptions = ''
            Option "VertScrollDelta" "50"
            Option "HorizScrollDelta" "-20"
          '';
      };
      
      #multitouch.enable = true;
      #multitouch.invertScroll = true;
  };

  # Shells
  programs.zsh.enable = true;
  users.extraUsers.ghasshee = {
	isNormalUser = true;
	home = "/home/ghasshee";
	extraGroups = ["wheel" "networkmanager"];
      	shell = pkgs.zsh;
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # The NixOS release to be compatible with for stateful data such as databases.
  # system.stateVersion = "18.03";

}



