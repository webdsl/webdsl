#!/bin/bash

FILE=$1
WEBDSL=${2:-bash /usr/local/bin/webdsl}
TESTARG=${3:-test}

$WEBDSL clean > /dev/null 2> /dev/null
$WEBDSL $TESTARG $FILE 2>&1 | cat > $FILE.out
#cat $FILE.out

echo "checking"
exec 3<&0
exec 0<"$FILE"
#printf '%s\n' "$FILE.out" |
#while read -rd $'\r' line; do
while read -r line; do
  echo $line
  if echo "$line" | grep -q "^//"; then
    pattern=`echo "$line" | sed 's/^[/]*//'`
    echo $pattern | grep -q "^\^"
    negate=$?
    echo $pattern | grep -q "^#"
    count=$?
    if [[ $negate == 0 ]]; then
      echo "error must not be shown"
      if grep -q "${pattern:1}" $FILE.out; then
        echo "Error should not be present: ${pattern:1}"
        is_error=1
      fi
    elif [[ $count == 0 ]]; then
      echo "error must be shown X times"
      occurrences=`echo $pattern | perl -pe 's/^#([0-9]+) .*$/\1/'`
      echo "X = $occurrences"
      pattern=`echo $pattern | perl -pe 's/^#[0-9]+ (.*)$/\1/'`
      echo "error = $pattern"
      foundlines=`grep "$pattern" $FILE.out | wc -l`
      echo "found X = $foundlines"
      if [ $foundlines -ne $occurrences ]; then
        echo "Error should be reported $occurrences times: $pattern"
        is_error=1
      fi      
    else
      echo "error must be shown"
      if ! grep -q "$pattern" $FILE.out; then
        echo "Error should be present: $pattern"
        is_error=1
      fi
    fi
  else
    break
  fi
done
exec 0<&3

if [[ $is_error ]]; then
  echo "-------------- TEST FAILED --------------"
  exit 1
fi

echo "-------------- TEST SUCCEEDED --------------"
exit 0
