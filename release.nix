{ nixpkgs ? ../../nixpkgs
, hydraConfig ? ../../hydraconfig
}:

let
  strPkgs = pkgs: [
    strategoPackages018.aterm 
    strategoPackages018.sdf
    strategoPackages018.strategoxt 
    strategoPackages018.javafront 
  ];

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
          libtool_1_5 
          automake110x 
          autoconf
          ant 
        ] ++ strPkgs pkgs ;
      };


    build =
      { tarball ? jobs.tarball {}
      , system ? "i686-linux"
      }:

      let pkgs = import nixpkgs {inherit system;};
      in with pkgs;
      releaseTools.nixBuild {
        name = "webdsl";
        src = tarball;
        buildInputs = [
          pkgconfig 
        ] ++ strPkgs pkgs ++ lib.optional stdenv.isLinux apacheAnt;
        
        doCheck = if stdenv.isLinux then true else false;
      };

    buildJava =
      { tarball ? jobs.tarball {}
      , strcJava 
      }:

      let pkgs = import nixpkgs { system = "i686-linux"; };
      in with pkgs;
      releaseTools.nixBuild {
        name = "webdsl-java";
        src = tarball;
        buildInputs = [pkgconfig ecj apacheAnt strcJava which fastjar jdk] ++ strPkgs pkgs;

        configureFlags = ["--enable-java-backend"] ;

        doCheck = true;
      };

/*
   docs = 
     { webdslsSrc ? {outPath = pkgs.lib.cleanSource ./.; rev = 1234;} 
     , xdoc
     , build ? jobs.build {}
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
       xdocIncludes = ["${build}/share/sdf/webdsl"];
       stratego = true ;
       sdf = false ;
       stats = false;
     } ;
*/

  };

  
in jobs
