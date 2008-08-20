#!/bin/sh

cd `dirname $0`
FILE=`basename $0`
webdsl test $FILE > /dev/null 2> $FILE.out

result=$?
if test 0 -ne $result; then
  cat $FILE.out
fi
rm -f $FILE.out
exit $result
