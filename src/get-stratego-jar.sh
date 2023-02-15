if [ ! -f share/strategoxt/strategoxt/strategoxt.jar ]; then
  wget http://artifacts.metaborg.org/service/local/repositories/releases/content/org/metaborg/strategoxt-distrib/1.5.0/strategoxt-distrib-1.5.0-bin.tar
  tar -xf strategoxt-distrib-1.5.0-bin.tar
fi
if [ ! -f strategoxt.jar ]; then
  cp share/strategoxt/strategoxt/strategoxt.jar .
fi
if [ ! -f Java-EBlock.rtg.af ]; then
  cp share/strategoxt/java_front/languages/java/Java-EBlock.rtg.af .
fi

# In order to be compatible with recent macOS versions that no longer support running 32-bit binaries:
# Patch the native 32-bit tools `sdf2table` and `implodePT` by renaming the binaries in the macosx folder and
# copying the x64-macosx-docker_{sdf2table,implodePT} scripts. These wrapper scripts will try to invoke the tools
# from the host OS or, when this fails, invoke the tools from a docker container with linux that is able to run
# 32 bit binaries.
# Credits to https://github.com/Virtlink for creating the wrapper scripts. These are copied from:
# https://github.com/metaborg/spoofax/tree/31ea48889ab10104e8729aed7bc8842d45096f7b/org.metaborg.spoofax.nativebundle/src/main/resources/org/metaborg/spoofax/nativebundle/native/macosx
# 
if [ ! -f share/strategoxt/macosx/sdf2table-macosx ]; then
  mv share/strategoxt/macosx/sdf2table share/strategoxt/macosx/sdf2table-macosx
  cp share/strategoxt/linux/sdf2table share/strategoxt/macosx/sdf2table-linux
  cp ./x64-macosx-docker_sdf2table share/strategoxt/macosx/sdf2table
  chmod +x share/strategoxt/macosx/sdf2table
fi
if [ ! -f share/strategoxt/macosx/implodePT-macosx ]; then
  mv share/strategoxt/macosx/implodePT share/strategoxt/macosx/implodePT-macosx
  cp share/strategoxt/linux/implodePT share/strategoxt/macosx/implodePT-linux
  cp ./x64-macosx-docker_implodePT share/strategoxt/macosx/implodePT
  chmod +x share/strategoxt/macosx/implodePT
fi