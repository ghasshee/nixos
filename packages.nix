{config, pkgs, ... }:
with pkgs;
let 
    # patched-ghc     = haskellPackages.override (old:{
    #     overrides = self: super: {
    #         Euterpea    = self.callHackage "Euterpea" "2.0.6" {};
    #         PortMidi    = self.callHackage "PortMidi" "0.1.6.1" {};
    #         heap        = pkgs.haskell.lib.dontCheck super.heap;
    #         #pandoc      = self.callHackage "pandoc" "2.0.5" {};
    #        #secp256k1   = self.callHackage "secp256k1-haskell" "0.5.0" {};
    #                         };}
    #     );

    packageOverrides = self: super: {
        opencv4 = super.opencv4.override {
          enableGtk2    = true;
          gtk2          = gtk2; 
          #enableFfmpeg = true;
          #ffmpeg = ffmpeg-full;
        }; 
      };

    hsOverrides = self: super: {
        opencv3 = super.opencv.override {
          enableGtk3    = true;
       #    gtk2 = gtk2; 
       #   enableFfmpeg = true;
       #   ffmpeg = ffmpeg-full;
        }; 
      };

    python = python3.override {inherit packageOverrides; self = python; }; 


    hspkgs = haskellPackages.override {
      overrides = hsOverrides;
    }; 

    eth             = [
        go-ethereum
        # openethereum #parity 
        solc
        evmdis
        ipfs
    ];

    py              = [
        
        (python.withPackages (x: with x; [
            virtualenv 
            python pynvim pip numpy scipy networkx matplotlib toolz pytest 
            ipython jupyter virtualenvwrapper tkinter #tk
            cloudpickle
            psutil
            pygments
            opencv4
            open-interpreter 
            ])) 
        ];
    hs              = [ 


        #(hspkgs.ghc.withPackages (p: with p; [
        #(haskell.packages.ghc8104.ghcWithPackages (p: with p;[
        (haskell.packages.ghc98.ghcWithPackages (p: with p;[
            cabal-install 
            hoogle 
            alex happy #happy_1_20_0 # pappy 
            hakyll # yesod  
            hmatrix GLUT   
            hashtables
            parsec 
            deepseq   # deepseq_1_4_4_0
            rocksdb-haskell

            # sheaf 
            IntervalMap 
            data-category

            ## Differential 
            NumInstances 
            vector-space
            lens

            ## Deep Learning
            backprop
            hmatrix-backprop
            simple-reflect
            one-liner-instances
            mnist-idx
            mwc-random 
            split
            singletons
            microlens-th


            ## bitcoin 
            binary 
            network
            network-bsd   #network-bsd_2_8_1_0
            base58-bytestring vector-sized 
            cryptonite 
            # cryptonite_0_29
            # murmur3  # 20.09
            mwc-random
            #secp256k1-haskell
              entropy
              base16-bytestring
              string-conversions

            # evm 
            basement data-dword ## data-sword
            hashmap 

            #
            Euterpea

            # packet capture 
            pcap 

            # video capture
            #opencv #opencv-extra


            # matrix 
            matrix 
            ]))


        # (hspkgs.ghc.withPackages (p: with p; [
        #     Agda ieee754
        #     cabal-install hoogle hmatrix megaparsec gnuplot GLUT #hakyll effect-monad 
        #     Euterpea HSoM 
        #     base58-bytestring vector-sized mwc-random cryptonite # secp256k1
        #     alex happy # pappy 
        #     hashtables 
        #     opencv-extra
        #     # opencv

        #     # algebra

        #     ])) 
        ];
    ml              = with ocamlPackages; [
          opam  #opam_1_2 
          findlib
          core
          camlp5 yojson ppx_deriving_yojson
          ocaml 
          batteries cryptokit hex menhir
          rpclib rope 
          merlin 
          lablgtk 
          # labltk 
          gtk2 # for compilation of lablgtk via opam 
          why3 
        # dune-release
        # caml opam utop camlp4 findlib batteries 
        #merlin yojson ppx_deriving_yojson menhir #  to build merlin
        ]; 
    sys             = [ 
       # hardware
        usbutils pciutils
        parted
        gpart 
        qmk         # keyboard firmware burning tool

        nix-tree

        patchelf
        zsh bvi tmux w3m git curl wget gnused xsel rename tree less rlwrap rename 
        jq mlocate unzip xz sl lolcat figlet man-db #manpages 
        oneko
        sdcv bc acpi
        openssl.dev openssh gnupg sshfs stunnel 
        networkmanager iptables nettools tcpdump
        ntfsprogs ## Windows File System
        nkf 
        at lsof psutils htop fzf psmisc 
        jid     ## json tool 
        ncurses ## terminal independent updating screen character tool
        # gnome2.libgnomecanvas # used for "why" verification tool
        sysstat  ## sar, .. 

    # c library 
        secp256k1 

    # what is this ? 
        autoreconfHook 
    
    # Decentralized 
        matrix-commander #matrixcli       # matrix chat client ?? 

        matrix-synapse  # matrix server 
        matterbridge    # irc gitter matrix ... bridge
        element-web     # matrix web client

        m4 bison flex patch gfortran gmm blas liblapack 
        hdf5      # unstable 
        #hdf5_1_8  # 20.09
        hdf5-cpp 
        gsl fftw 
        openmpi freeglut arpack suitesparse valgrind 
        gdb flex file gmp 
        gnum4
        # jbuilder
        cowsay
        time
        espeak

    # opencv 
        opencv gtk2




    # FEM
        gmsh     # used in sound FEM python book 
   
   # Developping kernel modules 
        linux.dev fakeroot 
                
   # Languages  
        ##compcert ## formally verified c compiler 
        stdenv  binutils.bintools 
        makeWrapper cmake automake autoconf glibc glibc_multi gdb 
        binutils gcc 
        clang gnumake openssl pkg-config # pkgconfig
        nodejs ruby jekyll              ## Ruby / Nodejs

        coq coqPackages.mathcomp coqPackages.ssreflect   ## Coq
        (agda.withPackages (p: with p;[ standard-library ])) 

        # LinuxProgramming 
        inotify-tools

        ## RUST 
        rustup cargo                    
        wasm-pack

        clisp                           ## ANSI COMMON LISP 
        mitscheme                       ## MIT Scheme (LISP) 

        # llvm_10
        llvmPackages.bintools
        llvmPackages.llvm
                 
        smlnj                           # Standard ML of New Jersey
        mlton                           # Standart ML Compiler  

        idris idris2
        (idrisPackages.with-packages (with idrisPackages; [contrib pruviloj])) 
        vimPlugins.idris-vim 


        perl
        perlPackages.IPCSystemSimple

   # OS Development
        ansible # iasl 
        qemu nasm 
        binutils # gnu linker


   # Applications

        #plasma5Packages.spectacle plasma5Packages.okular  # unstable 
        #kdeApplications.spectacle kdeApplications.okular # 20.09
        spectacle okular
        chromium firefox #firefoxWrapper 
        vivaldi thunderbird mupdf evince vivaldi
        jdk11 
        irssi 
        #skype 
        skypeforlinux
        #kwallet-pam
        #plasma5Packages.kwallet
        gnuplot
        sage # sagemath      #sage            # Mathematica Alternative 
        jmol tachyon #3D object viewer 
        android-file-transfer
        rclone rsync    # rclone is a dropbox tool  
        xorg.libxshmfence  djvu2pdf qrencode  docker gimp 
        yt-dlp #youtube-dl
        maim            # command-line screenshot
        flameshot       # screenshot 
        capture         # screenshot 
        gnome3.eog      # image viewer
        tesseract       # OCR
        ltris
        texlive.combined.scheme-full
        # pulsar  # atom  ## atom editor alternative
        timidity        # MIDI
        ffmpeg-full mplayer sox 
        dvdplusrwtools dvdauthor 
        gnome3.totem vlc
        vokoscreen
        kdenlive        # Video Editor
        mailutils
        libreoffice 
        imagemagick

        ## tridactyl-native

    ];
in sys ++ hs ++ py ++ ml ++ eth
