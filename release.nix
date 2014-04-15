{ nixpkgs ? ../nixpkgs
, hydraConfig ? { outPath = ../../hydra-config ; rev = 1234; } 
, webdslsSrc ? {outPath = ./.; rev = 1234;}
, officialRelease ? false
, strcJava ? { outPath = ./. ;}
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
  eclipseFun = (import "${hydraConfig}/eclipse.nix") pkgs ; 

  webtests = pkgs.runCommand "webdsl-tests.nix" { preferLocalBuild = true; } ''
    echo "[" > $out
    for f in $(cd ${webdslsSrc}/test/succeed-web ; find . -name '*.app'  | grep -v tutorial-splash | grep -v templates.app); do
      echo "\"''${f:2}\"" >> $out
    done
    echo "]" >> $out
  '';

  run_test = appname :
      pkgs.stdenv.mkDerivation {
        name = "webdsl-check";
        meta.maxSilent = 300;
        meta.timeout = 900;
        buildInputs = [pkgs.ant pkgs.openjdk pkgs.firefoxPkgs.firefox jobs.buildJavaNoCheck pkgs.xvfb_run];
        buildCommand = ''
        ensureDir $out
        cp -R ${webdslsSrc}/test/succeed-web/ succeed-web/
        chmod u+w -R succeed-web        
        cd succeed-web
        TOPDIR=`pwd`
        FAILED=""
        export HOME=$PWD
        header "Running ${appname}"
        result=""
        cd $TOPDIR/`dirname ${appname}`
        FILE=`basename ${appname} .app`
        echo "Executing 'webdsl test-web $FILE"
        xvfb-run --auto-servernum --server-args="+extension RANDR" webdsl test-web-twice $FILE 2>&1 || export FAILED="1"
        stopNest
        if test -z "$FAILED"; then
                exit 0
        else
            exit 1
        fi
        '';
      };

  jobs = rec {
    tests = pkgs.lib.listToAttrs (map (f: pkgs.lib.nameValuePair (pkgs.lib.replaceChars ["/"] ["_"] f) (run_test f)) (import webtests));

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
      let pkgs = import nixpkgs { system = "i686-linux"; };
      in with pkgs;
      releaseTools.nixBuild rec {
        name = "webdsl-java";
        src = tarball;
        buildInputs = [pkgconfig cpio ecj ant strcJava which fastjar openjdk] ++ strPkgs pkgs;

        configureFlags = ["--enable-java-backend"] ;

        doCheck = true;
        phases = "initPhase unpackPhase patchPhase configurePhase buildPhase installPhase checkPhase fixupPhase distPhase finalPhase";

        finalPhase = ''
          mkdir -p $out/nix-support
          if test -f ${src}/nix-support/hydra-release-name ; then
            cat ${src}/nix-support/hydra-release-name | sed 's|webdsl|webdsl-java|' > $out/nix-support/hydra-release-name
          fi
        '';
      };
      
    buildJavaNoCheck =
      let pkgs = import nixpkgs { system = "i686-linux"; };
      in with pkgs;
      releaseTools.nixBuild rec {
        name = "webdsl-java";
        src = tarball;
        buildInputs = [pkgconfig cpio ecj ant strcJava which fastjar openjdk] ++ strPkgs pkgs;

        configureFlags = ["--enable-java-backend"] ;

        doCheck = true;
        phases = "initPhase unpackPhase patchPhase configurePhase buildPhase installPhase fixupPhase distPhase finalPhase";
		
        finalPhase = ''
          mkdir -p $out/nix-support
          if test -f ${src}/nix-support/hydra-release-name ; then
            cat ${src}/nix-support/hydra-release-name | sed 's|webdsl|webdsl-java|' > $out/nix-support/hydra-release-name
          fi
        '';
      };
      
    buildJavaZipNoCheck = 
      pkgs.stdenv.mkDerivation {
        name = "webdsl-java-no-check.zip"; 
        buildInputs = [pkgs.zip]; 
        buildCommand = ''
          ensureDir $out 
          ensureDir $out/nix-support

          mkdir webdsl 
          cp -R ${buildJavaNoCheck}/* webdsl/
          chmod -R 755 webdsl/
 
          # cleanup
          rm -rf webdsl/nix-support
          rm -rf webdsl/lib/pkgconfig

          # remove nix store deps
          sed "s|${pkgs.bash}||" -i webdsl/bin/webdsl
          sed "s|${pkgs.bash}||" -i webdsl/bin/webdsl-plugins

          zip -r $out/webdsl-java-no-check.zip webdsl
          echo "file zip $out/webdsl-java-no-check.zip" > $out/nix-support/hydra-build-products
        ''; 
      } ;      
      
      
  };

in jobs
