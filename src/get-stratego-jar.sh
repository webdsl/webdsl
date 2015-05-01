if [ ! -f share/strategoxt/strategoxt/strategoxt.jar ]; then
  wget http://artifacts.metaborg.org/service/local/repositories/releases/content/org/metaborg/strategoxt-distrib/1.4.0/strategoxt-distrib-1.4.0-bin.tar
  tar -xf strategoxt-distrib-1.4.0-bin.tar
fi
cp share/strategoxt/strategoxt/strategoxt.jar .