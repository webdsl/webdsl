#!/bin/sh

name=$1
show_result=$2
OLDDIR=`pwd`
cd `dirname $1`
FILE=`echo $name | sed 's/\.app//'`
webdsl test `basename $FILE` 2> /dev/null > /dev/null
result=$?
if test 0 -eq $result; then
  #echo "SUCCESSFULLY COMPILED: $name"
  :
else
  :
    #echo "FAILED to compile: $name"
fi
cd $OLDDIR
exit $result
