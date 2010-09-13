#!/bin/sh


echo pack-sdf -I ../../src/org/webdsl/dsl/syntax -i $1.sdf -o $1.def
     pack-sdf -I ../../src/org/webdsl/dsl/syntax -i $1.sdf -o $1.def
echo sdf2table -i $1.def -o $1.tbl -m $1 
     sdf2table -i $1.def -o $1.tbl -m $1 
     
     
for i in `find . -name "$1*.txt"`; do

VAR=`basename $i`
echo $VAR
echo sglri -p $1.tbl -i $VAR -o __test-$VAR
sglri -p $1.tbl -i $VAR -o __test-$VAR
cat __test-$VAR | pp-aterm

sglri -A -p $1.tbl -i $VAR -o __ignore
RET=$?
if [ $RET == 1 ]
then
  sglr -p $1.tbl -i $VAR | pp-aterm
fi

#echo parse-pp-table -i ../../src/org/webdsl/dsl/syntax/WebDSL-pretty.pp -o __WebDSL-pretty.pp.af
#     parse-pp-table -i ../../src/org/webdsl/dsl/syntax/WebDSL-pretty.pp -o __WebDSL-pretty.pp.af
echo ast2text -p ../../src/org/webdsl/dsl/syntax/HQL-pretty.pp -p ../../src/org/webdsl/dsl/syntax/WebDSL-pretty.pp -i __test-$VAR -o __pretty-$VAR
     ast2text -p ../../src/org/webdsl/dsl/syntax/HQL-pretty.pp -p ../../src/org/webdsl/dsl/syntax/WebDSL-pretty.pp -i __test-$VAR -o __pretty-$VAR
cat __pretty-$VAR

done

rm __*
rm *.tbl
rm *.def