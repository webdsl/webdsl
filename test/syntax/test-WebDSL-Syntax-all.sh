#!/bin/sh

for i in `find . -name "test-WebDSL-*.sdf"`; do
  VAR=`basename $i | sed 's/\..\{3\}$//'`
  echo $VAR
  ./test-WebDSL-Syntax.sh $VAR
done