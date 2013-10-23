set -x #echo on

echo "Downloading Spoofax Sunshine jar for running JSGLR"
wget https://github.com/metaborg/spoofax-sunshine/releases/download/v0.5.2/spoofax-sunshine.jar
echo "Compiling JSGLR runner Java class"
javac Jsglr.java -cp spoofax-sunshine.jar 
