#!/bin/sh

cd `dirname $1`
FILE=`basename $1`
webdsl test $FILE servlet > /dev/null 2> $FILE.out

result=$?
if test 0 -ne $result; then
  #cat $FILE.out
  echo "$FILE failed"
else
  echo "$FILE succeeded"
fi
rm -f $FILE.out
exit $result
