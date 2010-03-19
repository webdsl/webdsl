#!/bin/bash

for FILE in *.app
do
  echo "$FILE"
  echo "webdsl test-web $FILE"
  webdsl test-web $FILE &> $FILE.out
  result=$?
  if test 0 -ne $result; then
    cat $FILE.out
  fi
  rm -f $FILE.out
done