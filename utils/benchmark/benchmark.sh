#!/bin/bash

if [[ $1 == "" ]]; then
  echo "No configuration file specified"
  exit 0
fi
echo "Loading default.cfg"
source default.cfg
echo "Loading $1"
source $1
echo "Configuration complete"

GCLOGPATH=`pwd`/gc.log # The garbage collection log that is will be used to estimate the total memory that has been used
# Start and max memory is intentionally the same, to prevent memory allocation from having an impact on response time
export JAVA_HOME=$JAVA_HOME
export JRE_HOME=$JAVA_HOME
export JAVA_OPTS="-Xloggc:$GCLOGPATH -XX:+PrintGCDetails -XX:+UseParallelGC -XX:+UseCompressedOops -XX:PermSize=${PERMSIZE} -XX:MaxPermSize=${PERMSIZE} -Xmx${HEAPSIZE} -Xms${HEAPSIZE}"

# Tomcat options
export CATALINA_HOME=$CATALINA_HOME
CATALINA_PATH=$CATALINA_HOME/bin/catalina.sh
WEBAPP_PATH="$CATALINA_HOME/webapps"

# global variables that are use for cleanup
pid=0
removefile=""
removedir=""

logln() {
  local now=`date "+%Y-%m-%d %H:%M:%S.%N"`
  local nowlen=$((${#now}-6))
  echo -e "${now:0:$nowlen}:  $1"
  echo -e "${now:0:$nowlen}:  $1" >> ./$benchname/log
}

log() {
  local now=`date "+%Y-%m-%d %H:%M:%S.%N"`
  local nowlen=$((${#now}-6))
  echo -e -n "${now:0:$nowlen}:  $1"
  echo -e -n "${now:0:$nowlen}:  $1" >> ./$benchname/log
}

logln_continue() {
  echo -e "$1"
  echo -e "$1" >> ./$benchname/log
}

log_continue() {
  echo -e -n "$1"
  echo -e -n "$1" >> ./$benchname/log
}

control_c() {
  logln_continue ""
  logln ""
  if [ $pid -ne 0 ]; then
    logln "Terminating tomcat (pid=$pid)"
    kill $pid
  fi
  wait
  if [ -f $removefile ]; then
    logln "Removing file $removefile"
    rm "$removefile"
    removefile=""
  fi
  if [ -d $removedir ]; then
    logln "Removing directory $removedir"
    rm -r "$removedir"
    removedir=""
  fi
  logln_continue ""
  exit $?
}

trap control_c SIGINT

init_benchmark() {
  benchname=`date +%Y%m%d-%H-%M-%S`
  mkdir $benchname

  logln "Results are written to $benchname"
  echo "$benchname" > $CONTINUE_PATH

  echo -e "WARMUP\t$WARMUP" > ./$benchname/settings
  echo -e "ITERATIONS\t$ITERATIONS" >> ./$benchname/settings
  echo -e "JAVA_OPTS\t$JAVA_OPTS" >> ./$benchname/settings
  echo -e "PERMSIZE\t$PERMSIZE" >> ./$benchname/settings
  echo -e "HEAPSIZE\t$HEAPSIZE" >> ./$benchname/settings

  for war in $WARS
  do
    warname=$(basename $war .war)
    for sql in $SQLS
    do
      sqlname=$(basename $sql .sql.gz)
      echo -e "Name\tMin\tMean\t[+/-sd]\tMedian\tMax\t80%\t90%\tQueries\tEntities\tDuplicates\tCollections\tYoungGC\tFullGC\tGCUser\tGCSys\tGCReal\tYoung\tOld\tHeap\tPerm\tHeapPerReq\tYoungT\tOldT\tHeapT\tPermT\tAvgSql\tAvgEnt\tAvgDup\tAvgCol\tCntMaxEnt\tMaxEntPer" > ./$benchname/${warname}_${sqlname}.log
    done
  done

  if [[ `type -t manual_test_cases` == "function" ]]; then
    manual_test_cases
  fi
  for sql in $SQLS
  do
    for page in $PAGES
    do
      for war in $WARS
      do
        if [[ `type -t test_case_filter` == "function" ]]; then
          test_case_filter "$sql" "$page" "$war"
        else
          append_test_case "$sql" "$page" "$war"
        fi
      done
    done
  done
}

append_test_case() {
  echo -e "$1\t$2\t$3" >> $CONTINUE_PATH
}

continue_benchmark() {
  local remain=`cat "$CONTINUE_PATH" | awk 'FNR>1' | wc -l`
  while [ $remain -gt 0 ];
  do
    local sql=`cat "$CONTINUE_PATH" | awk 'FNR==2' | cut -f1`
    local page=`cat "$CONTINUE_PATH" | awk 'FNR==2' | cut -f2`
    local war=`cat "$CONTINUE_PATH" | awk 'FNR==2' | cut -f3`
    run_benchmark "$sql" "$page" "$war"

    # Remove the test case that was just completed from the continue file
    cat "$CONTINUE_PATH" | awk 'FNR!=2' > "$CONTINUE_PATH.new"
    rm "$CONTINUE_PATH"
    mv "$CONTINUE_PATH.new" "$CONTINUE_PATH"
    remain=`cat "$CONTINUE_PATH" | awk 'FNR>1' | wc -l`
  done
}

run_benchmark() {
  local stime=$(date '+%s.%N')
  local sql="$1"
  local page="$2"
  local war="$3"

  local sqlname=$(basename $sql .sql.gz)
  local sanitized_page=`echo "$page" | sed 's/[:\/<>|"?]/_/g'`
  local warname=$(basename $war .war)

  logln ""
  logln "Testing: database=$sqlname app=$warname url=$page"
  removefile="$WEBAPP_PATH/$warname.war" 
  removedir="$WEBAPP_PATH/$warname"
  cp "$war" "$removefile" 
  logln "Starting Tomcat"
  $CATALINA_PATH run >> /dev/null 2>&1 &
  pid=$!

  logln "Drop-Create database"
  echo "DROP DATABASE $dbname;" | mysql -u$dbuser -p$dbpass -h $dbserver
  echo "CREATE DATABASE $dbname;" | mysql -u$dbuser -p$dbpass -h $dbserver

  # Using initialization scripts for speed
  log "Restore Db: $sqlname"
  gendbtime=$( { time cat "$sql" | gzip -d | mysql -u$dbuser -p$dbpass -h $dbserver -N $dbname >/dev/null; } 2>&1 )
  gendbtime2=`echo "$gendbtime" | tr '\n' ',' | tr '\t' '=' | sed 's/^,//;s/,$//'`
  logln_continue " (restored in $gendbtime2)" | sed 's/\([[:digit:]]s\) /\1, /g'

  local now=`date +"%Y-%m-%d %H:%M:%S"`
  echo "UPDATE _SessionManager SET _lastUse='$now';" | mysql -u$dbuser -p$dbpass -h $dbserver -N $dbname
  local WEBDSLSESSIONID=`echo "SELECT id FROM _SessionManager;" | mysql -N -u$dbuser -p$dbpass -h $dbserver -N $dbname`
  logln "WebDSLSessionId: $WEBDSLSESSIONID"

  logln "Sending initial requests with logging enabled"
  local maxsql=0
  local sumsql="0"
  local maxents=0
  local suments="0"
  local cntmaxents=0
  local maxdups=0
  local sumdups="0"
  local maxcols=0
  local sumcols="0"
  local sqls=""
  local sqlents=""
  local sqldups=""
  local sqlcols=""

  local sqlline=""
  while [[ $sqlline == "" ]];
  do
    sqlline=`wget -qO- --header "Cookie: WEBDSLSESSIONID=$WEBDSLSESSIONID" "http://localhost:8080/$warname/$page?logsql" | grep -o "SQLs = <span id=\"sqllogcount\">[[:digit:]]\+</span>, Time = <span id=\"sqllogtime\">[[:digit:]]\+ ms</span>, Entities = <span id=\"sqllogentities\">[[:digit:]]\+</span>, Duplicates = <span id=\"sqllogduplicates\">[[:digit:]]\+</span>, Collections = <span id=\"sqllogcollections\">[[:digit:]]\+</span>"`
    if [[ $sqlline == "" ]]; then
      logln "Request failed, retrying in 5 seconds"
      sleep 5
    fi
  done
  local minsql=`echo "$sqlline" | grep -o "<span id=\"sqllogcount\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
  local minents=`echo "$sqlline" | grep -o "<span id=\"sqllogentities\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
  local mindups=`echo "$sqlline" | grep -o "<span id=\"sqllogduplicates\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
  local mincols=`echo "$sqlline" | grep -o "<span id=\"sqllogcollections\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
  logln "First Request: SQLs = $minsql, Entities = $minents, Duplicates = $mindups, Collections = $mincols"

  for i in $(seq 1 $WARMUP)
  do
    sqlline=`wget -qO- --header "Cookie: WEBDSLSESSIONID=$WEBDSLSESSIONID" "http://localhost:8080/$warname/$page?logsql" | grep -o "SQLs = <span id=\"sqllogcount\">[[:digit:]]\+</span>, Time = <span id=\"sqllogtime\">[[:digit:]]\+ ms</span>, Entities = <span id=\"sqllogentities\">[[:digit:]]\+</span>, Duplicates = <span id=\"sqllogduplicates\">[[:digit:]]\+</span>, Collections = <span id=\"sqllogcollections\">[[:digit:]]\+</span>"`
    sqls=`echo "$sqlline" | grep -o "<span id=\"sqllogcount\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
    sqlents=`echo "$sqlline" | grep -o "<span id=\"sqllogentities\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
    sqldups=`echo "$sqlline" | grep -o "<span id=\"sqllogduplicates\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
    sqlcols=`echo "$sqlline" | grep -o "<span id=\"sqllogcollections\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
    sumsql="$sumsql+$sqls"
    suments="$suments+$sqlents"
    sumdups="$sumdups+$sqldups"
    sumcols="$sumcols+$sqlcols"
    if [ "$sqls" -gt "$maxsql" ]; then
      maxsql=$sqls
    fi
    if [ "$sqls" -lt "$minsql" ]; then
      minsql=$sqls
    fi
    if [ "$sqlents" -eq "$maxents" ]; then
      cntmaxents=$(($cntmaxents+1))
    fi
    if [ "$sqlents" -gt "$maxents" ]; then
      maxents=$sqlents
      cntmaxents=1
    fi
    if [ "$sqlents" -lt "$minents" ]; then
      minents=$sqlents
    fi
    if [ "$sqldups" -gt "$maxdups" ]; then
      maxdups=$sqldups
    fi
    if [ "$sqldups" -lt "$mindups" ]; then
      mindups=$sqldups
    fi
    if [ "$sqlcols" -gt "$maxcols" ]; then
      maxcols=$sqlcols
    fi
    if [ "$sqlcols" -lt "$mincols" ]; then
      mincols=$sqlcols
    fi
  done

  local avgsql=`echo "scale=2;($sumsql)/$WARMUP" | bc`
  local avgents=`echo "scale=2;($suments)/$WARMUP" | bc`
  local avgdups=`echo "scale=2;($sumdups)/$WARMUP" | bc`
  local avgcols=`echo "scale=2;($sumcols)/$WARMUP" | bc`
  local maxentsper=`echo "scale=2;$cntmaxents/($WARMUP/100)" | bc | sed 's/0\+$//;s/\.$//'`

  local sqlstr="$minsql-$maxsql"
  local avgdspsql=" ($avgsql)"
  local avgdspents=" ($avgents, $maxentsper% max)"
  local avgdspdups=" ($avgdups)"
  local avgdspcols=" ($avgcols)"
  if [ "$minsql" -eq "$maxsql" ]; then
    sqlstr="$minsql"
    avgdspsql=""
  fi
  entstr="$minents-$maxents"
  if [ "$minents" -eq "$maxents" ]; then
    entstr="$minents"
    avgdspents=""
  fi
  dupstr="$mindups-$maxdups"
  if [ "$mindups" -eq "$maxdups" ]; then
    dupstr="$mindups"
    avgdspdups=""
  fi
  colstr="$mincols-$maxcols"
  if [ "$mincols" -eq "$maxcols" ]; then
    colstr="$mincols"
    avgdspcols=""
  fi
  logln "Results initial test: SQLs = $sqlstr$avgdspsql, Entities = $entstr$avgdspents, Duplicates = $dupstr$avgdspdups, Collections = $colstr$avgdspcols"

  $JAVA_HOME/bin/jmap -histo:live $pid >/dev/null # this forces a full gc

  #JDK6
  #cat "$GCLOGPATH" | sed "s/\([[:digit:]]\+\)K->\([[:digit:]]\+\)K([[:digit:]]\+K)/\1-\2/g;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \[PSOldGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\) \[PSPermGen: \([[:digit:]]\+-[[:digit:]]\+\)\].*/\1;\2;\3;\4;/;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\),.*/\1;0;\2;0;/" | grep -o "\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);" > proc.tmp
  #JDK7
  cat "$GCLOGPATH" | sed "s/\([[:digit:]]\+\)K->\([[:digit:]]\+\)K([[:digit:]]\+K)/\1-\2/g;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \[ParOldGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\) \[PSPermGen: \([[:digit:]]\+-[[:digit:]]\+\)\].*/\1;\2;\3;\4;/;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\),.*/\1;0;\2;0;/" | grep -o "\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);" > proc.tmp
  local gctimes=`cat "$GCLOGPATH"| grep -o "Times: user=[[:digit:]]\+\.[[:digit:]]\+ sys=[[:digit:]]\+\.[[:digit:]]\+, real=[[:digit:]]\+\.[[:digit:]]\+ secs" | sed 's/Times: user=\([[:digit:]]\+\.[[:digit:]]\+\) sys=\([[:digit:]]\+\.[[:digit:]]\+\), real=\([[:digit:]]\+\.[[:digit:]]\+\) secs/\1\t\2\t\3/' | awk '{user+=$1; sys+=$2; real+=$3} END {print user, sys, real}' | sed 's/[[:space:]]\+/\t/g'`
  local ygc_start=`cat "$GCLOGPATH" | grep "^[[:digit:]]\+\.[[:digit:]]\+: \[GC" | wc -l`
  local fgc_start=`cat "$GCLOGPATH" | grep "^[[:digit:]]\+\.[[:digit:]]\+: \[Full GC" | wc -l`
  local gcstart_usertime=`echo -e "$gctimes" | cut -f 1`
  local gcstart_systime=`echo -e "$gctimes" | cut -f 2`
  local gcstart_realtime=`echo -e "$gctimes" | cut -f 3`

  cat proc.tmp | bc | sed "N;N;N;s/\n/\t/g" > res.tmp
  local memstart=`cat res.tmp | awk '{ Young += $1; Old += $2; Heap += $3; Perm += $4} END { print Young / 1024 "\t" Old / 1024 "\t" Heap / 1024 "\t" Perm / 1024 }'`
  local memstartYoung=`echo -e "$memstart" | cut -f 1`
  local memstartOld=`echo -e "$memstart" | cut -f 2`
  local memstartHeap=`echo -e "$memstart" | cut -f 3`
  local memstartPerm=`echo -e "$memstart" | cut -f 4`
  rm proc.tmp
  rm res.tmp
  logln "gc:   Young = $memstartYoung MB, Old = $memstartOld MB, Heap = $memstartHeap MB, Perm = $memstartPerm MB" # Old may be negative here, which means that objects from Young took up more space than was collected from Old
  logln "gc:   YGC = $ygc_start, FGC = $fgc_start, user = $gcstart_usertime s, sys = $gcstart_systime s, real = $gcstart_realtime s"

  logln "Benchmarking"

  ab -n $ITERATIONS -C WEBDSLSESSIONID=$WEBDSLSESSIONID -g ./$benchname/${warname}_${sqlname}_${sanitized_page}.dta http://localhost:8080/$warname/$page >./$benchname/${warname}_${sqlname}_${sanitized_page}.log

  log "Forcing GC: "
  $JAVA_HOME/bin/jmap -histo:live $pid >/dev/null # this forces a full gc

  # Here we calculate the memory that was collected during the requests send by ab
  #JDK6
  #cat "$GCLOGPATH" | sed "s/\([[:digit:]]\+\)K->\([[:digit:]]\+\)K([[:digit:]]\+K)/\1-\2/g;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \[PSOldGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\) \[PSPermGen: \([[:digit:]]\+-[[:digit:]]\+\)\].*/\1;\2;\3;\4;/;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\),.*/\1;0;\2;0;/" | grep -o "\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);" > proc.tmp
  #JDK7
  cat "$GCLOGPATH" | sed "s/\([[:digit:]]\+\)K->\([[:digit:]]\+\)K([[:digit:]]\+K)/\1-\2/g;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \[ParOldGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\) \[PSPermGen: \([[:digit:]]\+-[[:digit:]]\+\)\].*/\1;\2;\3;\4;/;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\),.*/\1;0;\2;0;/" | grep -o "\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);" > proc.tmp
  gctimes=`cat "$GCLOGPATH"| grep -o "Times: user=[[:digit:]]\+\.[[:digit:]]\+ sys=[[:digit:]]\+\.[[:digit:]]\+, real=[[:digit:]]\+\.[[:digit:]]\+ secs" | sed 's/Times: user=\([[:digit:]]\+\.[[:digit:]]\+\) sys=\([[:digit:]]\+\.[[:digit:]]\+\), real=\([[:digit:]]\+\.[[:digit:]]\+\) secs/\1\t\2\t\3/' | awk '{user+=$1; sys+=$2; real+=$3} END {print user, sys, real}' | sed 's/[[:space:]]\+/\t/g'`
  local ygc_end=`cat "$GCLOGPATH" | grep "^[[:digit:]]\+\.[[:digit:]]\+: \[GC" | wc -l`
  local fgc_end=`cat "$GCLOGPATH" | grep "^[[:digit:]]\+\.[[:digit:]]\+: \[Full GC" | wc -l`
  local gcend_usertime=`echo -e "$gctimes" | cut -f 1`
  local gcend_systime=`echo -e "$gctimes" | cut -f 2`
  local gcend_realtime=`echo -e "$gctimes" | cut -f 3`
  local gcyoung=$((ygc_end-ygc_start))
  local gcfull=$((fgc_end-fgc_start))
  local gc_usertime=`echo "scale=2; $gcend_usertime - $gcstart_usertime" | bc`
  local gc_systime=`echo "scale=2; $gcend_systime - $gcstart_systime" | bc`
  local gc_realtime=`echo "scale=2; $gcend_realtime - $gcstart_realtime" | bc`

  cat proc.tmp | bc | sed "N;N;N;s/\n/\t/g" > res.tmp
  local memend=`cat res.tmp | awk '{ Young += $1; Old += $2; Heap += $3; Perm += $4} END { print Young / 1024 "\t" Old / 1024 "\t" Heap / 1024 "\t" Perm / 1024 }'`
  local memendYoung=`echo -e "$memend" | cut -f 1`
  local memendOld=`echo -e "$memend" | cut -f 2`
  local memendHeap=`echo -e "$memend" | cut -f 3`
  local memendPerm=`echo -e "$memend" | cut -f 4`
  local memYoung=`echo "scale=2;$memendYoung-$memstartYoung;" | sed 's/--/+/' | bc`
  local memOld=`echo "scale=2;$memendOld-$memstartOld;" | sed 's/--/+/' | bc`
  local memHeap=`echo "scale=2;$memendHeap-$memstartHeap;" | sed 's/--/+/' | bc`
  local memPerm=`echo "scale=2;$memendPerm-$memstartPerm;" | sed 's/--/+/' | bc`
  local memHeapPerReq=`echo "scale=2;($memendHeap-$memstartHeap)/$ITERATIONS;" | sed 's/--/+/' | bc`

  kill $pid
  wait # wait for catalina to terminate
  pid=0

  logln_continue "Benchmarking complete"

  log "gc results: "
  cp "$GCLOGPATH" ./$benchname/${warname}_${sqlname}_${sanitized_page}_gc.dta
  #JDK6
  #cat "$GCLOGPATH" | sed "s/\([[:digit:]]\+\)K->\([[:digit:]]\+\)K([[:digit:]]\+K)/\1-\2/g;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \[PSOldGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\) \[PSPermGen: \([[:digit:]]\+-[[:digit:]]\+\)\].*/\1;\2;\3;\4;/;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\),.*/\1;0;\2;0;/" | grep -o "\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);" > proc.tmp
  #cat "$GCLOGPATH" | tail -9 | sed 's/[[:space:]]\+total[[:space:]]\+[[:digit:]]\+K,[[:space:]]\+used[[:space:]]\+\([[:digit:]]\+\)K.*/\1/' | grep -o "\(PSYoungGen\|PSOldGen\|PSPermGen\)[[:digit:]]\+" | sed 'N;N;s/PSYoungGen\([[:digit:]]\+\)\nPSOldGen\([[:digit:]]\+\)\nPSPermGen\([[:digit:]]\+\)/\1;\2;\1+\2;\3;/' >> proc.tmp
  #JDK7
  cat "$GCLOGPATH" | sed "s/\([[:digit:]]\+\)K->\([[:digit:]]\+\)K([[:digit:]]\+K)/\1-\2/g;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \[ParOldGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\) \[PSPermGen: \([[:digit:]]\+-[[:digit:]]\+\)\].*/\1;\2;\3;\4;/;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\),.*/\1;0;\2;0;/" | grep -o "\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);" > proc.tmp
  cat "$GCLOGPATH" | tail -9 | sed 's/[[:space:]]\+total[[:space:]]\+[[:digit:]]\+K,[[:space:]]\+used[[:space:]]\+\([[:digit:]]\+\)K.*/\1/' | grep -o "\(PSYoungGen\|ParOldGen\|PSPermGen\)[[:digit:]]\+" | sed 'N;N;s/PSYoungGen\([[:digit:]]\+\)\nParOldGen\([[:digit:]]\+\)\nPSPermGen\([[:digit:]]\+\)/\1;\2;\1+\2;\3;/' >> proc.tmp

  cat proc.tmp | bc | sed "N;N;N;s/\n/\t/g" > res.tmp
  memend=`cat res.tmp | awk '{ Young += $1; Old += $2; Heap += $3; Perm += $4} END { print Young / 1024 "\t" Old / 1024 "\t" Heap / 1024 "\t" Perm / 1024 }'`
  memendYoung=`echo -e "$memend" | cut -f 1`
  memendOld=`echo -e "$memend" | cut -f 2`
  memendHeap=`echo -e "$memend" | cut -f 3`
  memendPerm=`echo -e "$memend" | cut -f 4`
  memYoungTotal=`echo "scale=2;$memendYoung-$memstartYoung;" | sed 's/--/+/' | bc`
  memOldTotal=`echo "scale=2;$memendOld-$memstartOld;" | sed 's/--/+/' | bc`
  memHeapTotal=`echo "scale=2;$memendHeap-$memstartHeap;" | sed 's/--/+/' | bc`
  memPermTotal=`echo "scale=2;$memendPerm-$memstartPerm;" | sed 's/--/+/' | bc`
  logln_continue "Young = $memYoung MB, Old = $memOld MB, Heap = $memHeap MB, Perm = $memPerm MB, Heap/Req= $memHeapPerReq MB"
  logln "gc:         YGC = $gcyoung, FGC = $gcfull, user = $gc_usertime s, sys = $gc_systime s, real = $gc_realtime s"
  logln "Total mem:  Young = $memYoungTotal MB, Old = $memOldTotal MB, Heap = $memHeapTotal MB, Perm = $memPermTotal MB" 

  log "ab results: "
  abtotals=`cat ./$benchname/${warname}_${sqlname}_${sanitized_page}.log | grep "Total:" | sed "s/Total:/${sanitized_page}/" | sed "s/[[:space:]]\+/\t/g"`
  ab80perc=`cat ./$benchname/${warname}_${sqlname}_${sanitized_page}.log | grep "80%" | sed "s/[[:space:]]*[[:digit:]]\+%[[:space:]]*//"`
  ab90perc=`cat ./$benchname/${warname}_${sqlname}_${sanitized_page}.log | grep "90%" | sed "s/[[:space:]]*[[:digit:]]\+%[[:space:]]*//"`
  ab90perc=`cat ./$benchname/${warname}_${sqlname}_${sanitized_page}.log | grep "90%" | sed "s/[[:space:]]*[[:digit:]]\+%[[:space:]]*//"`
  mintime=`echo -e "$abtotals" | cut -f 2`
  avgtime=`echo -e "$abtotals" | cut -f 3`
  maxtime=`echo -e "$abtotals" | cut -f 6`
  logln_continue "Min = $mintime ms, Avg = $avgtime ms, Max = $maxtime ms"
  echo -e "$abtotals\t$ab80perc\t$ab90perc\t$sqlstr\t$entstr\t$dupstr\t$colstr\t$gcyoung\t$gcfull\t$gc_usertime\t$gc_systime\t$gc_realtime\t$memYoung\t$memOld\t$memHeap\t$memPerm\t$memHeapPerReq\t$memYoungTotal\t$memOldTotal\t$memHeapTotal\t$memPermTotal\t$avgsql\t$avgents\t$avgdups\t$avgcols\t$cntmaxents\t$maxentsper" >>./$benchname/${warname}_${sqlname}.log

  logln "Cleaning up"
  rm "$GCLOGPATH"
  rm proc.tmp
  rm res.tmp

  rm "$removefile"
  removefile=""
  rm -r "$removedir"
  removedir=""

  local etime=$(date '+%s.%N')
  local dt=`echo "$etime-$stime" | bc`
  local ms=`echo "scale=0; i=$dt/1; scale=3; $dt/1-i" | bc`
  local ds=`echo "scale=0;($dt/1)%60" | bc`
  local dm=`echo "scale=0;(($dt/1)/60)%60" | bc`
  local dh=`echo "scale=0;($dt/1)/3600" | bc`
  logln "Completed test in $dh:$(printf %02d $dm):$(printf %02d $ds)$ms"
}

finalize_benchmark(){
  rm $CONTINUE_PATH
  for war in $WARS
  do
    warname=$(basename $war .war)
    for sql in $SQLS
    do
      sqlname=$(basename $sql .sql.gz)
      cat ./$benchname/${warname}_${sqlname}.log | column -t > ./$benchname/${warname}_${sqlname}.txt
    done
  done
}

if [ -f $CONTINUE_PATH ]; then
  benchname=`cat $CONTINUE_PATH | awk 'FNR==1'`
  remaining=`cat $CONTINUE_PATH | awk 'FNR>1' | wc -l`
  logln "Continuing $remaining cases, results are written to $benchname"
else
  init_benchmark
fi
continue_benchmark
finalize_benchmark

