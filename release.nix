{ nixpkgs ? ../nixpkgs
, hydraConfig ? ../hydraconfig
, webdslsSrc ? {outPath = ./.; rev = 1234;}
, officialRelease ? false
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
      { system ? "i686-linux" }:

      let pkgs = import nixpkgs {inherit system;};
      in with pkgs;
      releaseTools.nixBuild {
        name = "webdsl";
        src = tarball;
        buildInputs = [
          pkgconfig 
        ] ++ strPkgs pkgs 
          ++ lib.optional stdenv.isLinux apacheAnt
          ++ lib.optional stdenv.isDarwin antDarwin
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
      { strcJava }:

      let pkgs = import nixpkgs { system = "i686-linux"; };
      in with pkgs;
      releaseTools.nixBuild {
        name = "webdsl-java";
        src = tarball;
        buildInputs = [pkgconfig ecj apacheAnt strcJava which fastjar jdk] ++ strPkgs pkgs;

        configureFlags = ["--enable-java-backend"] ;

        doCheck = true;
        phases = "unpackPhase patchPhase configurePhase buildPhase installPhase checkPhase fixupPhase distPhase finalPhase";
      };
  };

  
in jobs
