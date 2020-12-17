{config, pkgs, ... }:
with pkgs;
let 
    my-ghc865     = ( haskellPackages.override (old:{
        overrides = (self: super: { 
            Euterpea    = self.callHackage "Euterpea" "2.0.6" {};
            PortMidi    = self.callHackage "PortMidi" "0.1.6.1" {};
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
    ];

    py              = [
        python27Full python27Packages.pygments pypyPackages.virtualenv
        (python37.withPackages (x: with x; [
            python pynvim pip numpy scipy networkx matplotlib toolz pytest 
            ipython jupyter virtualenvwrapper tkinter #tk
            ])) 
        ];
    hs              = [ 
        # (haskell.packages.ghc882.ghcWithPackages (p: with p; [
        (haskell.packages.ghc882.ghcWithPackages (p: with p; [
            hoogle alex happy # hakyll 
            hmatrix GLUT   
            base58-bytestring vector-sized mwc-random cryptonite 
            hashtables
            parsec
            deepseq_1_4_4_0
            hashmap 
            ]))

        AgdaStdlib
        (my-ghc865.ghc.withPackages (p: with p; [
            Agda ieee754
            cabal-install hoogle hmatrix megaparsec gnuplot GLUT #hakyll effect-monad 
            Euterpea HSoM 
            base58-bytestring vector-sized mwc-random # cryptonite  # secp256k1-haskell # secp256k1 
            alex happy
            hashtables 
            # algebra
            ])) 
        ];
    ml              = with ocamlPackages; [
      opam 
        # ocaml opam utop camlp4 findlib batteries 
        # merlin yojson ppx_deriving_yojson menhir #  to build merlin
        ]; 
    sys             = [ 
        zsh bvi tmux w3m git curl wget gnused xsel rename tree less rlwrap rename 
        jq mlocate unzip xz sl lolcat figlet man-db manpages sdcv bc acpi
        openssl.dev openssh gnupg sshfs stunnel 
        networkmanager iptables nettools tcpdump
        ntfsprogs ## Windows File System
        nkf 
        at lsof psutils htop fzf psmisc 

    # FreeFEM++
        m4 bison flex patch gfortran gmm blas liblapack hdf5 gsl fftw 
        openmpi freeglut arpack suitesparse valgrind 
        gdb flex file gmp 
        gnum4
        jbuilder
        cowsay
        time
        espeak
   
   # Developping kernel modules 
        linux.dev fakeroot 
                
   # Languages  
        stdenv  binutils.bintools makeWrapper cmake automake autoconf glibc glibc_multi gdb 
        binutils gcc clang gnumake openssl pkgconfig 
        nodejs ruby jekyll              ## Ruby / Nodejs
        idris vimPlugins.idris-vim      ## Idris
        coq coqPackages.mathcomp coqPackages.ssreflect   ## Coq
        rustup cargo                    ## RUST 
        clisp                           ## ANSI COMMON LISP 
                 
   # Applications
        
        kdeApplications.spectacle kdeApplications.okular 
        chromium firefoxWrapper vivaldi thunderbird mupdf evince vivaldi
        jdk11 
        irssi 
        skype 
        sage            # Mathematica Alternative 
        android-file-transfer
        rclone rsync    # rclone is a dropbox tool  
        xorg.libxshmfence  djvu2pdf qrencode  docker gimp youtube-dl
        maim            # command-line screenshot
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
        wkhtmltopdf 
        mailutils

        ## tridactyl-native

    ];
in sys ++ py ++ hs ++ ml ++ eth
