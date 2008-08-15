#!/bin/sh

name=$0.app
show_result=$1
dsl-to-seam -i $name --stop-after 1 > /dev/null 2> $name.out
grep "$(cat $name | head -n 1 | sed 's/^[/]*//')" $name.out > /dev/null
result=$?
if test 0 -eq $result; then
  #echo "SUCCEEDED in finding error: $name"
  rm $name.out
else
  if [ "$show_result" == "show" ]; then
    #echo "FAILED in finding error: $name output:"
    cat $name.out
  else
    :
    #echo "FAILED in finding error: $name (output in $name.out)"
  fi
fi
test 0 -eq $result
