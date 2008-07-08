#!/bin/bash

name=$0.app
show_result=$1
dsl-to-seam -i $name --stop-after 1 > /dev/null 2> $name.out
result=$?
if test 0 -eq $result; then
  echo "SUCCESSFULLY COMPILED: $name"
  rm $name.out
else
  if [ "$show_result" == "show" ]; then
    echo "FAILED to compile: $name"
    cat $name.out
  else
    echo "FAILED to compile: $name (output in $name.out)"
  fi
fi
exit $result
