#!/bin/sh

SRCDIR=$(pwd)/../src
cd `dirname $1`
FILE=`basename $1 | sed 's/[.][a-zA-Z0-9]*//'` 
bash $SRCDIR/org/webdsl/dsl/project/webdsl cleanall > /dev/null 2> /dev/null
bash $SRCDIR/org/webdsl/dsl/project/webdsl test $FILE servlet> /dev/null 2> $FILE.out
grep "$(cat $FILE.app | head -n 1 | sed 's/^[/]*//')" $FILE.out > /dev/null

result=$?
  
if test 0 -ne $result; then
#  cat $FILE.out
  echo "$FILE failed"
  rm -f $FILE.out
  exit 1
else
   echo "$FILE succeeded"
  rm -f $FILE.out
  exit 0
fi
