{config, pkgs, ... }:
with pkgs;
let 
    my-ghc865     = ( haskellPackages.override (old:{
        overrides = (self: super: { 
            #Euterpea    = self.callHackage "Euterpea" "2.0.6" {};
            #PortMidi    = self.callHackage "PortMidi" "0.1.6.1" {};
            #secp256k1   = self.callHackage "secp256k1-haskell" "0.5.0" {};
            heap        = pkgs.haskell.lib.dontCheck super.heap;
          });
        }) );  
    # patched-ghc     = haskellPackages.override (old:{
    #     overrides = self: super: {
    #         Euterpea    = self.callHackage "Euterpea" "2.0.6" {};
    #         PortMidi    = self.callHackage "PortMidi" "0.1.6.1" {};
    #         heap        = pkgs.haskell.lib.dontCheck super.heap;
    #         #pandoc      = self.callHackage "pandoc" "2.0.5" {};
    #                         };}
    #     );
    eth             = [
        go-ethereum
        parity 
        solc
        evmdis
        ipfs
    ];

    py              = [
        python27Full 
        python27Packages.pygments 
        python27Packages.numpy
        python27Packages.scipy 
        python27Packages.matplotlib 
        
        pypyPackages.virtualenv
        (python37.withPackages (x: with x; [
            python pynvim pip numpy scipy networkx matplotlib toolz pytest 
            ipython jupyter virtualenvwrapper tkinter #tk
            cloudpickle
            ])) 
        ];
    hs              = [ 
        #(haskell.packages.ghc8102Binary.ghcWithPackages (p: with p; [    # unstable 
        (haskell.packages.ghc8104.ghcWithPackages (p: with p;[
            cabal-install 
            alex happy 
            # hakyll 
          ]))
        (haskell.packages.ghc882.ghcWithPackages (p: with p; [           # 20.09
            cabal-install 
            hoogle 
            alex happy #happy_1_20_0 # pappy 
            hakyll # yesod  
            hmatrix GLUT   
            hashtables
            parsec 
            deepseq   # deepseq_1_4_4_0

            # sheaf 
            IntervalMap 
            data-category

            ## Differential 
            NumInstances 
            vector-space
            lens

            ## bitcoin 
            binary 
            network
            network-bsd   #network-bsd_2_8_1_0
            base58-bytestring vector-sized 
            cryptonite 
            murmur3
            mwc-random
            secp256k1-haskell
              entropy
              base16-bytestring
              string-conversions

            # evm 
            basement data-dword ## data-sword
            hashmap 

            #
            Euterpea

            ]))


        (my-ghc865.ghc.withPackages (p: with p; [
            Agda ieee754
            cabal-install hoogle hmatrix megaparsec gnuplot GLUT #hakyll effect-monad 
            Euterpea HSoM 
            base58-bytestring vector-sized mwc-random cryptonite # secp256k1
            alex happy # pappy 
            hashtables 
            # algebra
            ])) 
        ];
    ml              = with ocamlPackages; [
        opam  #opam_1_2 
        findlib
        # dune-release
        # caml opam utop camlp4 findlib batteries 
        #merlin yojson ppx_deriving_yojson menhir #  to build merlin
        ]; 
    sys             = [ 
        patchelf
        zsh bvi tmux w3m git curl wget gnused xsel rename tree less rlwrap rename 
        jq mlocate unzip xz sl lolcat figlet man-db manpages sdcv bc acpi
        openssl.dev openssh gnupg sshfs stunnel 
        networkmanager iptables nettools tcpdump
        ntfsprogs ## Windows File System
        nkf 
        at lsof psutils htop fzf psmisc 
        jid   ## json tool 
        ncurses ## terminal independent updating screen character tool
        gnome2.libgnomecanvas # used for "why" verification tool

    # c library 
        secp256k1 

    # what is this ? 
        autoreconfHook 
    
    # Decentralized 

        m4 bison flex patch gfortran gmm blas liblapack 
        #hdf5      # unstable 
        hdf5_1_8  # 20.09
        hdf5-cpp 
        gsl fftw 
        openmpi freeglut arpack suitesparse valgrind 
        gdb flex file gmp 
        gnum4
        jbuilder
        cowsay
        time
        espeak

    # FreeFEM++
        gmsh     # used in sound FEM python book 
   
   # Developping kernel modules 
        linux.dev fakeroot 
                
   # Languages  
        ##compcert ## formally verified c compiler 
        stdenv  binutils.bintools makeWrapper cmake automake autoconf glibc glibc_multi gdb 
        binutils gcc clang gnumake openssl pkgconfig 
        nodejs ruby jekyll              ## Ruby / Nodejs
        idris vimPlugins.idris-vim      ## Idris
        coq coqPackages.mathcomp coqPackages.ssreflect   ## Coq


        ## RUST 
        rustup cargo                    
        wasm-pack

        clisp                           ## ANSI COMMON LISP 
        mitscheme                       ## MIT Scheme (LISP) 

        llvm_10
        llvmPackages.bintools
        binutils
                 
        smlnj                           # Standard ML of New Jersey
        mlton                           # Standart ML Compiler  

        idris
        idris2
        (idrisPackages.with-packages (with idrisPackages; [contrib pruviloj])) 

        (agda.withPackages (p: with p;[ standard-library ]))

        perl
        perlPackages.IPCSystemSimple

   # OS Development
        ansible iasl 
        qemu nasm 
        binutils # gnu linker


   # Applications

        #plasma5Packages.spectacle plasma5Packages.okular  # unstable 
        kdeApplications.spectacle kdeApplications.okular # 20.09
        chromium firefoxWrapper vivaldi thunderbird mupdf evince vivaldi
        jdk11 
        irssi 
        skype 
        gnuplot
        #sage            # Mathematica Alternative 
        android-file-transfer
        rclone rsync    # rclone is a dropbox tool  
        xorg.libxshmfence  djvu2pdf qrencode  docker gimp youtube-dl
        maim            # command-line screenshot
        flameshot       # screenshot 
        capture         # screenshot 
        gnome3.eog      # image viewer
        tesseract       # OCR
        ltris
        texlive.combined.scheme-full
        atom
        timidity        # MIDI
        ffmpeg-full mplayer sox 
        dvdplusrwtools dvdauthor 
        gnome3.totem vlc
        vokoscreen
        kdenlive        # Video Editor
        wkhtmltopdf 
        mailutils
        libreoffice 
        imagemagick

        ## tridactyl-native

    ];
in sys ++ hs ++ py ++ ml ++ eth
