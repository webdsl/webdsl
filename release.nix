{ nixpkgs ? ../nixpkgs
}:

let
  strPkgs = pkgs: [
    pkgs.strategoPackages018.aterm 
    pkgs.strategoPackages018.sdf
    pkgs.strategoPackages018.strategoxt 
    pkgs.strategoPackages018.javafront 
  ];

  pkgs = import nixpkgs { system = "i686-linux"; };

  jobs = rec {

    tarball = 
      { webdslsSrc ? {outPath = ./.; rev = 1234;}
      , officialRelease ? false
      }:
      with pkgs;
      releaseTools.makeSourceTarball {
        name = "webdsl-tarball";
        src = webdslsSrc;
        inherit officialRelease;
        buildInputs = [
          pkgconfig 
          libtool_1_5
          subversion
          automake
          autoconf
          ant 
        ] ++ strPkgs pkgs ;
      };


    build =
      { system ? "i686-linux" 
      , tarball ? jobs.tarball {}
      }:

      let pkgs = import nixpkgs {inherit system;};
          antDarwinNative = pkgs.stdenv.mkDerivation {
            name = "ant-darwin-native";
            buildCommand = ''
              ensureDir $out/bin
              ln -s /usr/share/ant/bin/ant $out/bin/ant
            '';
          };

      in with pkgs;
      releaseTools.nixBuild {
        name = "webdsl";
        src = tarball;
        buildInputs = [
          pkgconfig 
        ] ++ strPkgs pkgs 
          ++ lib.optional stdenv.isLinux apacheAnt
          ++ lib.optional stdenv.isDarwin antDarwinNative
          ;

        configureFlags = "--enable-web-check=no";
        doCheck = if stdenv.isLinux || stdenv.isDarwin then true else false;
        phases = "unpackPhase patchPhase configurePhase buildPhase installPhase checkPhase fixupPhase distPhase finalPhase";
      };

    buildJavaZip = 
      pkgs.stdenv.mkDerivation {
        name = "webdsl-java.zip"; 
        buildInputs = [pkgs.zip]; 
        buildCommand = ''
          ensureDir $out 
          ensureDir $out/nix-support

          mkdir webdsl 
          cp -R ${buildJava}/* webdsl/
          chmod -R 755 webdsl/
 
          # cleanup
          rm -rf webdsl/nix-support
          rm -rf webdsl/lib/pkgconfig

          # remove nix store deps
          sed "s|${pkgs.bash}||" -i webdsl/bin/webdsl
          sed "s|${pkgs.bash}||" -i webdsl/bin/webdsl-plugins

          zip -r $out/webdsl-java.zip webdsl
          echo "file zip $out/webdsl-java.zip" > $out/nix-support/hydra-build-products
        ''; 
      } ;      

    buildJava =
      { tarball ? jobs.tarball {}
      , strcJava ? { outPath = ./. ;}
      }:
      let pkgs = import nixpkgs { system = "i686-linux"; };
      in with pkgs;
      releaseTools.nixBuild rec {
        name = "webdsl-java";
        src = tarball;
        buildInputs = [pkgconfig ecj apacheAnt strcJava which fastjar jdk] ++ strPkgs pkgs;

        configureFlags = ["--enable-java-backend"] ;

        doCheck = true;
        phases = "unpackPhase patchPhase configurePhase buildPhase installPhase checkPhase fixupPhase distPhase finalPhase";

        finalPhase = ''
          if test -f ${src}/nix-support/hydra-release-name ; then
            cat ${src}/nix-support/hydra-release-name | sed 's|webdsl|webdsl-java|' > $out/nix-support/hydra-release-name
          fi
        '';
      };

    webcheck = 
      { tarball ? jobs.tarball {}
      }:
      let
        services = pkgs.fetchsvn {
          url = https://svn.nixos.org/repos/nix/services/trunk;
          rev = 18826;
          sha256 = "08dblnszh22l31cx88z7767wz0y18qnb93zl3g5naiv9ahahniz1";
        };
        nixos = pkgs.fetchsvn {
          url = https://svn.nixos.org/repos/nix/nixos/trunk;
          rev = 20561;
          sha256 = "0kbqabspz6p03l4b42hb1i48vzppyhd20j3l3yljmr3grqp3xacw";
        };
      in
        with import "${nixos}/lib/testing.nix" {inherit nixpkgs services; system = "i686-linux";} ;
        runInMachineWithX {
          drv = pkgs.lib.overrideDerivation (build { inherit tarball; }) (oldAttrs: { configureFlags = ""; buildInputs = oldAttrs.buildInputs ++ [pkgs.firefox] ; }) ;
        };

  };

  
in jobs
