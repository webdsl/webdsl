#!/bin/sh

for i in `find . -name "*.sdf"`; do
  VAR=`basename $i | sed 's/\..\{3\}$//'`
  echo $VAR
  ./run.sh $VAR
done