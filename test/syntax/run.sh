#!/bin/sh
set -x #echo on

NATIVEPATH="`pwd`/../../src/share/strategoxt/macosx"
STRATEGOXT_JAR="`pwd`/../../src/strategoxt.jar"

STRTOOL="java -Xss8m -cp $STRATEGOXT_JAR run"
# run.java class invokes HybridInterpreter to load and run a strategy class file
# https://github.com/metaborg/strategoxt/blob/master/strategoxt/stratego-libraries/java-backend/java/commandline/run.java

PACKSDF="$STRTOOL org.strategoxt.tools.main-pack-sdf"
SDF2TABLE="$NATIVEPATH/sdf2table"
PPATERM="$STRTOOL org.strategoxt.stratego-aterm.io-pp-aterm"
AST2TEXT="java -Xss8m -cp $STRATEGOXT_JAR:ast2text/bin run syntaxtest.io-ast2text"

# run setup.sh once to download JSGLR
if [ ! -f Jsglr.class ]; then
  echo "Jsglr .class not found - running setup.sh"
  chmod +x setup.sh
  ./setup.sh
fi

# compile ast2text utility class files once
if [ ! -f ast2text/bin/syntaxtest/ast2text_0_0.class ]; then
  cd ast2text
  make
  cd ..
fi

$PACKSDF -I ../../src/org/webdsl/dsl/syntax -i $1.sdf -o $1.def
$SDF2TABLE -i $1.def -o $1.tbl -m $1 

for i in `find . -name "$1*.txt"`; do
  VAR=`basename $i`
  echo $VAR
  #sglri -p $1.tbl -i $VAR -o __test-$VAR
  java -cp spoofax-sunshine.jar Jsglr $1.tbl TestDef $VAR > __test-$VAR
  cat __test-$VAR | $PPATERM

  #sglri -A -p $1.tbl -i $VAR -o __ignore
  #RET=$?
  #if [ $RET == 1 ]
  #then
  #  sglr -p $1.tbl -i $VAR | pp-aterm
  #fi

  #parse-pp-table -i ../../src/org/webdsl/dsl/syntax/WebDSL-pretty.pp -o __WebDSL-pretty.pp.af
  $AST2TEXT -p ../../src/org/webdsl/dsl/syntax/HQL-pretty.pp -p ../../src/org/webdsl/dsl/syntax/WebDSL-pretty.pp -i __test-$VAR -o __pretty-$VAR
  cat __pretty-$VAR
done

rm __*
rm *.tbl
rm *.def