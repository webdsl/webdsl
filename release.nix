{ nixpkgs ? ../../nixpkgs
, hydraConfig ? ../../hydraconfig
}:

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

    buildJava =
      { tarball ? jobs.tarball {}
      , strcJava 
      }:

      with import nixpkgs { system = "i686-linux"; };

      releaseTools.nixBuild {
        name = "webdsl-java";
        src = tarball;
        buildInputs = [
          pkgconfig strategoPackages.aterm strategoPackages.sdf
          strategoPackages.strategoxt strategoPackages.javafront
          ecj apacheAnt strcJava which fastjar jdk];

        configureFlags = ["--enable-java-backend"] ;

        doCheck = true;
      };

   docs = 
     { webdslsSrc ? {outPath = pkgs.lib.cleanSource ./.; rev = 1234;} 
     , xdoc
     } :
     let
       builder = import "${hydraConfig}/build.nix" {
                   pkgsDefault = import nixpkgs { system = "i686-linux"; }; 
                   baseline = import "${hydraConfig}/baseline.nix" ;
                   inherit hydraConfig nixpkgs xdoc;
                 };
     in builder.easyDocsTarball {
       title = "WebDSL xdoc documentation";
       checkout = webdslsSrc; 
       packageName = "webdsl";
     } ;

  };

  
in jobs
