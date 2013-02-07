#!/bin/sh
CMD=$1
URL=$2
TEXT=$3
GRACE=$4
FAILS=0

echo "restart command: $CMD"
echo "check url:       $URL"
echo "look for text:   $TEXT"
echo "restart wait:    $GRACE"

while [ 1 ]
do
  RES=`curl -silent --max-time 20 $URL`
  NOW=$(date +"%d-%m-%y %T")
  if [[ "$RES" == *"$TEXT"* ]]
  then
    echo "$NOW ok"
    FAILS=0
  else
    echo "$NOW fail"
    FAILS=$(( FAILS+1 ))
    if [[ $FAILS -gt 3 ]]
    then
      echo "too many failures, running restart script"
      $CMD
      FAILS=0
      sleep $GRACE
    fi
  fi
  sleep 10
done
