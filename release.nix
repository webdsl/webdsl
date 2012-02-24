{ nixpkgs ? ../nixpkgs
}:

let
  strPkgs = pkgs: [
    pkgs.strategoPackages018.aterm 
    pkgs.strategoPackages018.sdf
    pkgs.strategoPackages018.strategoxt 
    pkgs.strategoPackages018.javafront 
    pkgs.perl
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
          cpio
        ] ++ strPkgs pkgs 
          ++ lib.optional stdenv.isLinux apacheAnt
          ++ lib.optional stdenv.isDarwin antDarwinNative
          ;

        configureFlags = "--enable-web-check=no";
        doCheck = if stdenv.isLinux || stdenv.isDarwin then true else false;
        phases = "unpackPhase patchPhase configurePhase buildPhase installPhase checkPhase fixupPhase distPhase finalPhase";
        preConfigure = lib.optionalString (stdenv.system != "i686-cygwin") ''
          ulimit -s ${if stdenv.isDarwin then "64000" else "unlimited"}
        '';
      };

    buildJavaZip = 
      { tarball ? jobs.tarball {}
      , strcJava ? { outPath = ./. ;}
      }:
      pkgs.stdenv.mkDerivation {
        name = "webdsl-java.zip"; 
        buildInputs = [pkgs.zip]; 
        buildCommand = ''
          ensureDir $out 
          ensureDir $out/nix-support

          mkdir webdsl 
          cp -R ${buildJava { inherit strcJava tarball; } }/* webdsl/
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

  };

  
in jobs
