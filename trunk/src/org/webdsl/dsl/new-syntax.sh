# temp. file to smooth the transition to the new concrete syntax definition

set -e

FILE=`echo $1 | perl -pe 's/(.*)\.str/$1/'`

echo
echo "=== $FILE ==="

cp $FILE.meta /tmp/before.meta

pp-stratego -I ../syntax -I syntax  -I ~/.nix-profile/share/java-front -i $FILE.str > /tmp/before.txt

echo 'Meta([Syntax("Stratego-WebDSL-Java-XML")])' > $FILE.meta

pp-stratego -I ../syntax -I syntax  -I ~/.nix-profile/share/java-front -i $FILE.str > /tmp/after.txt

diff /tmp/before.txt /tmp/after.txt  || mv /tmp/before.meta $FILE.meta

