{nixpkgs ? ../nixpkgs}:

let

  pkgs = import nixpkgs {};


  jobs = rec {


    tarball =
      { webdslsSrc ? {outPath = pkgs.lib.cleanSource ./.; rev = 1234;}
      , officialRelease ? false
      }:

      with pkgs;

      pkgs.releaseTools.makeSourceTarball {
        name = "webdsl-tarball";
        src = webdslsSrc;
        inherit officialRelease;
        buildInputs = [
          pkgconfig 
          strategoPackages.aterm 
          strategoPackages.sdf
          strategoPackages.strategoxt 
          strategoPackages.javafront 
          libtool_1_5 
          automake110x 
          autoconf
          ant 
        ];
      };


    build =
      { tarball ? jobs.tarball {}
      , system ? "i686-linux"
      }:

      with import nixpkgs {inherit system;};

      releaseTools.nixBuild {
        name = "webdsl";
        src = tarball;
        buildInputs = [
          pkgconfig strategoPackages.aterm strategoPackages.sdf
          strategoPackages.strategoxt strategoPackages.javafront
        ] ++ lib.optional stdenv.isLinux apacheAnt;
        
        doCheck = if stdenv.isLinux then true else false;
      };


  };

  
in jobs
