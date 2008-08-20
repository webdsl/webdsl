#!/bin/sh

cd `dirname $0`
webdsl test `basename $0` # > /dev/null 2> $name.out

result=$?
if test 0 -eq $result; then
  #echo "SUCCESSFULLY COMPILED: $name"
  rm $name.out
else
  cat $name.out
fi
exit $result
