#!/bin/sh

SRCDIR=$(pwd)/../src
cd `dirname $0`
FILE=`basename $0`
bash $SRCDIR/org/webdsl/dsl/project/webdsl test $FILE > /dev/null 2> $FILE.out
grep "$(cat $FILE.app | head -n 1 | sed 's/^[/]*//')" $FILE.out > /dev/null

result=$?
if test 0 -ne $result; then
  cat $FILE.out
  rm -f $FILE.out
  exit 1
else
  rm -f $FILE.out
  exit 0
fi
