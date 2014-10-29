#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  export DATECOMMAND=gdate
  export SEDCOMMAND=gsed
else
  export DATECOMMAND=date
  export SEDCOMMAND=sed
fi

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
if [[ $SQLS == "existing" && $REDUCE_DEPLOYS == "1" ]] ; then
  export JAVA_OPTS="-XX:+UseParallelGC -XX:+UseCompressedOops -XX:PermSize=${PERMSIZE} -XX:MaxPermSize=${PERMSIZE} -Xmx${HEAPSIZE} -Xms${HEAPSIZE} $EXTRA_JAVA_OPTS"
else
  export JAVA_OPTS="-Xloggc:$GCLOGPATH -XX:+PrintGCDetails -XX:+UseParallelGC -XX:+UseCompressedOops -XX:PermSize=${PERMSIZE} -XX:MaxPermSize=${PERMSIZE} -Xmx${HEAPSIZE} -Xms${HEAPSIZE} $EXTRA_JAVA_OPTS"
fi

# Tomcat options
export CATALINA_HOME=$CATALINA_HOME
CATALINA_PATH=$CATALINA_HOME/bin/catalina.sh
WEBAPP_PATH="$CATALINA_HOME/webapps"
RETRY=10

# global variables that are use for cleanup
pid=0
removefile=""
removedir=""

logln() {
  local now=`$DATECOMMAND "+%Y-%m-%d %H:%M:%S.%N"`
  local nowlen=$((${#now}-6))
  echo -e "${now:0:$nowlen}:  $1"
  echo -e "${now:0:$nowlen}:  $1" >> ./$benchname/log
}

log() {
  local now=`$DATECOMMAND "+%Y-%m-%d %H:%M:%S.%N"`
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
    wait
  fi
  if [ -f $removefile ]; then
    if [[ $removefile != "" ]]; then
      logln "Removing file $removefile"
      rm "$removefile"
      removefile=""
    fi
  fi
  if [ -d $removedir ]; then
    if [[ $removedir != "" ]]; then
      logln "Removing directory $removedir"
      rm -r "$removedir"
      removedir=""
    fi
  fi
  logln_continue ""
  exit $?
}

trap control_c SIGINT

init_benchmark() {
  benchname=`$DATECOMMAND +%Y%m%d-%H-%M-%S`
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
    local warfile=`echo "$war" | $SEDCOMMAND 's/\?.*//'`
    local querystring=`echo "$war" | grep -o '\?.*' | $SEDCOMMAND 's/^\?//'`
    local sanitized_querystring=`echo "$querystring" | $SEDCOMMAND 's/[:\/<>|"?]/_/g'`
    warname=$(basename $warfile .war)
    if [[ $querystring != "" ]]; then
      warname="${warname}_${sanitized_querystring}"
    fi
    for sql in $SQLS
    do
      sqlname=$(basename $sql .sql.gz)
      local memcols=""
      if [[ $RUNNINGTOMCAT != 1 && $REDUCE_DEPLOYS != 1 ]] ; then
        memcols="\tYoungGC\tFullGC\tGCUser\tGCSys\tGCReal\tYoung\tOld\tHeap\tPerm\tHeapPerReq\tYoungT\tOldT\tHeapT\tPermT"
      fi
      echo -e "Name\tMin\tMean\t[+/-sd]\tMedian\tMax\t80%\t90%\tQueries\tEntities\tDuplicates\tCollections$memcols\tAvgSql\tAvgEnt\tAvgDup\tAvgCol\tCntMaxEnt\tMaxEntPer" > ./$benchname/${warname}_${sqlname}.log
    done
  done

  if [[ `type -t manual_test_cases` == "function" ]]; then
    manual_test_cases
  fi
  if [[ $SQLS == "existing" && $REDUCE_DEPLOYS == "1" ]] ; then
    for war in $WARS
    do
      for page in $PAGES
      do
        if [[ `type -t test_case_filter` == "function" ]]; then
          test_case_filter "existing" "$page" "$war"
        else
          append_test_case "existing" "$page" "$war"
        fi
      done
    done
  else
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
  fi
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
  local stime=$($DATECOMMAND '+%s.%N')
  local sql="$1"
  local page="$2"
  local war="$3"

  local sqlname=$(basename $sql .sql.gz)
  local sanitized_page=`echo "$page" | $SEDCOMMAND 's/[:\/<>|"?]/_/g'`

  local warfile=`echo "$war" | $SEDCOMMAND 's/\?.*//'`
  local querystring=`echo "$war" | grep -o '\?.*' | $SEDCOMMAND 's/^\?//'`
  local sanitized_querystring=`echo "$querystring" | $SEDCOMMAND 's/[:\/<>|"?]/_/g'`
  local warbase=$(basename $warfile .war)
  local warname="$warbase"
  local logsqlsuffix="?logsql"
  local normalsuffix=""
  if [[ $querystring != "" ]]; then
    warname="${warname}_${sanitized_querystring}"
    logsqlsuffix="${logsqlsuffix}&${querystring}"
    normalsuffix="${normalsuffix}?${querystring}"
  fi

  local remain=`cat "$CONTINUE_PATH" | awk 'FNR>1' | wc -l`
  local currentcase=$(($remaining-$remain+1))

  local measure_mem=0

  logln ""
  logln "Testing: database=$sqlname app=$warbase url=$page$normalsuffix ($currentcase of $remaining)"
  if [[ $REDUCE_DEPLOYS == 1 ]] ; then
    if [[ $removefile != "$WEBAPP_PATH/$warbase.war" ]] ; then
      if [[ $removefile != "" && $pid != 0 ]] ; then
        kill $pid
        wait # wait for catalina to terminate
        pid=0
        logln "Cleaning up"
        rm "$removefile"
        removefile=""
        rm -r "$removedir"
        removedir=""
      fi
      removefile="$WEBAPP_PATH/$warbase.war"
      removedir="$WEBAPP_PATH/$warbase"
      cp "$war" "$removefile"
      logln "Starting Tomcat"
      $CATALINA_PATH run >> /dev/null 2>&1 &
      pid=$!
    else
      logln "Using currently deployed war"
    fi
  else
    if [[ $RUNNINGTOMCAT == 1 ]] ; then
      pid=0
    else
      removefile="$WEBAPP_PATH/$warbase.war"
      removedir="$WEBAPP_PATH/$warbase"
      cp "$war" "$removefile"
      logln "Starting Tomcat"
      $CATALINA_PATH run >> /dev/null 2>&1 &
      pid=$!
      measure_mem=1
    fi
  fi

  if [[ $sqlname == "existing" ]] ; then
    logln "Using existing db"
  else
    # Using initialization scripts for speed
    logln "Drop-Create database"
    echo "DROP DATABASE $dbname;" | mysql -u$dbuser -p$dbpass -h $dbserver
    echo "CREATE DATABASE $dbname;" | mysql -u$dbuser -p$dbpass -h $dbserver

    log "Restore Db: $sqlname"
    gendbtime=$( { time cat "$sql" | gzip -d | mysql -u$dbuser -p$dbpass -h $dbserver -N $dbname >/dev/null; } 2>&1 )
    gendbtime2=`echo "$gendbtime" | tr '\n' ',' | tr '\t' '=' | $SEDCOMMAND 's/^,//;s/,$//'`
    logln_continue " (restored in $gendbtime2)" | $SEDCOMMAND 's/\([[:digit:]]s\) /\1, /g'
  fi

  local WEBDSLSESSIONID=`echo "$SESSIONSQL" | mysql -N -u$dbuser -p$dbpass -h $dbserver $dbname`
  local now=`$DATECOMMAND +"%Y-%m-%d %H:%M:%S"`
  echo "UPDATE _SessionManager SET _lastUse='$now' WHERE id='$WEBDSLSESSIONID';" | mysql -u$dbuser -p$dbpass -h $dbserver -N $dbname
  local WEBDSLSESSIONID_lastUse=`echo "SELECT _lastUse FROM _SessionManager WHERE id='$WEBDSLSESSIONID';" | mysql -N -u$dbuser -p$dbpass -h $dbserver $dbname`
  logln "WebDSLSessionId: $WEBDSLSESSIONID (last use $WEBDSLSESSIONID_lastUse)"

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

  local gctimes=""
  local ygc_start=""
  local fgc_start=""
  local gcstart_usertime=""
  local gcstart_systime=""
  local gcstart_realtime=""

  local memstart=""
  local memstartYoung=""
  local memstartOld=""
  local memstartHeap=""
  local memstartPerm=""

  local ygc_end=""
  local fgc_end=""
  local gcend_usertime=""
  local gcend_systime=""
  local gcend_realtime=""
  local gcyoung=""
  local gcfull=""
  local gc_usertime=""
  local gc_systime=""
  local gc_realtime=""

  local memend=""
  local memendYoung=""
  local memendOld=""
  local memendHeap=""
  local memendPerm=""
  local memYoung=""
  local memOld=""
  local memHeap=""
  local memPerm=""
  local memHeapPerReq=""

  local sqlline=""
  local reqerr=0
  while [[ $sqlline == "" ]];
  do
    curldata=`curl -s -b "WEBDSLSESSIONID=$WEBDSLSESSIONID" -i --retry 0 -m $REQUEST_TIMEOUT "$BASEURL$warbase/$page$logsqlsuffix"`
    curlstatus=$?
    if [[ $curlstatus != 0 ]]; then
      if [[ $curlstatus != 7 ]]; then # not CURLE_COULDNT_CONNECT
        logln "curl error $curlstatus, skipping test"
        echo -e "${sanitized_page}\tSkipping test (curl error $curlstatus)" >>./$benchname/${warname}_${sqlname}.log
        cleanup_benchmark
        return
      fi
      reqerr=$(($reqerr+1))
      if [[ $reqerr == $RETRY ]]; then
        logln "Request failed ($reqerr/$RETRY), skipping test"

        echo -e "${sanitized_page}\tSkipping test (failed $RETRY times, last curl error $curlstatus)" >>./$benchname/${warname}_${sqlname}.log
        cleanup_benchmark
        return
      else
        logln "Request failed ($reqerr/$RETRY), retrying in 5 seconds"
        sleep 5
      fi
    else
      httpstatus=`(awk 'FNR==1' | tr -d '\r' | tr -d '\n') <<< "$curldata"`
      httpstatusgroup=`echo "$httpstatus" | awk '{print substr($2, 1, 1)}'`
      if [[ $httpstatusgroup != "2" ]]; then # Not a successful status code
        logln "Unsuccessful http status code: $httpstatus"
        echo -e "${sanitized_page}\tSkipping test (Unsuccessful, $httpstatus)" >>./$benchname/${warname}_${sqlname}.log
        cleanup_benchmark
        return
      fi
      sqlline=`grep -o "SQLs = <span id=\"sqllogcount\">[[:digit:]]\+</span>, Time = <span id=\"sqllogtime\">[[:digit:]]\+ ms</span>, Entities = <span id=\"sqllogentities\">[[:digit:]]\+</span>, Duplicates = <span id=\"sqllogduplicates\">[[:digit:]]\+</span>, Collections = <span id=\"sqllogcollections\">[[:digit:]]\+</span>" <<< "$curldata"`
      if [[ $sqlline == "" ]]; then
        # no sql log, so probably redirected to access denied
        logln "No sql log in response, skipping test"
        echo -e "${sanitized_page}\tSkipping test (no sql log in response)" >>./$benchname/${warname}_${sqlname}.log
        cleanup_benchmark
        return
      fi
      lines=`wc -l <<< "$sqlline"`
      if [ "$lines" -gt "1" ]; then
        logln "More than one sql log in response, skipping test"
        echo -e "${sanitized_page}\tSkipping test (more than one sql log in response)" >>./$benchname/${warname}_${sqlname}.log
        cleanup_benchmark
        return
      fi
    fi
  done
  local minsql=`echo "$sqlline" | grep -o "<span id=\"sqllogcount\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
  local minents=`echo "$sqlline" | grep -o "<span id=\"sqllogentities\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
  local mindups=`echo "$sqlline" | grep -o "<span id=\"sqllogduplicates\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
  local mincols=`echo "$sqlline" | grep -o "<span id=\"sqllogcollections\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
  logln "First Request: SQLs = $minsql, Entities = $minents, Duplicates = $mindups, Collections = $mincols"

  for i in $(seq 1 $WARMUP)
  do
    sqlline=`curl -s -b "WEBDSLSESSIONID=$WEBDSLSESSIONID" --retry 0 -m $REQUEST_TIMEOUT "$BASEURL$warbase/$page$logsqlsuffix" | grep -o "SQLs = <span id=\"sqllogcount\">[[:digit:]]\+</span>, Time = <span id=\"sqllogtime\">[[:digit:]]\+ ms</span>, Entities = <span id=\"sqllogentities\">[[:digit:]]\+</span>, Duplicates = <span id=\"sqllogduplicates\">[[:digit:]]\+</span>, Collections = <span id=\"sqllogcollections\">[[:digit:]]\+</span>"`
    sqls=`echo "$sqlline" | grep -o "<span id=\"sqllogcount\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
    sqlents=`echo "$sqlline" | grep -o "<span id=\"sqllogentities\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
    sqldups=`echo "$sqlline" | grep -o "<span id=\"sqllogduplicates\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
    sqlcols=`echo "$sqlline" | grep -o "<span id=\"sqllogcollections\">[[:digit:]]\+</span>" | grep -o "[[:digit:]]\+"`
    if [[ "$sqls" == "" || "$sqlents" == "" || "$sqldups" == "" || "$sqlcols" == "" ]]; then
      logln "Sql log information missing, skipping test"
      echo -e "${sanitized_page}\tSkipping test (sql log information missing)" >>./$benchname/${warname}_${sqlname}.log
      cleanup_benchmark
      return
    fi
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
  local maxentsper=`echo "scale=2;$cntmaxents/($WARMUP/100)" | bc | $SEDCOMMAND 's/0\+$//;s/\.$//'`

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

  if [ $pid -ne 0 ]; then
    logln "Forcing GC"
    $JAVA_HOME/bin/jmap -histo:live $pid >/dev/null # this forces a full gc
  fi
  if [ $measure_mem -ne 0 ]; then
    #JDK6
    #cat "$GCLOGPATH" | $SEDCOMMAND "s/\([[:digit:]]\+\)K->\([[:digit:]]\+\)K([[:digit:]]\+K)/\1-\2/g;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \[PSOldGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\) \[PSPermGen: \([[:digit:]]\+-[[:digit:]]\+\)\].*/\1;\2;\3;\4;/;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\),.*/\1;0;\2;0;/" | grep -o "\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);" > proc.tmp
    #JDK7
    cat "$GCLOGPATH" | $SEDCOMMAND "s/\([[:digit:]]\+\)K->\([[:digit:]]\+\)K([[:digit:]]\+K)/\1-\2/g;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \[ParOldGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\) \[PSPermGen: \([[:digit:]]\+-[[:digit:]]\+\)\].*/\1;\2;\3;\4;/;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\),.*/\1;0;\2;0;/" | grep -o "\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);" > proc.tmp
    gctimes=`cat "$GCLOGPATH"| grep -o "Times: user=[[:digit:]]\+\.[[:digit:]]\+ sys=[[:digit:]]\+\.[[:digit:]]\+, real=[[:digit:]]\+\.[[:digit:]]\+ secs" | $SEDCOMMAND 's/Times: user=\([[:digit:]]\+\.[[:digit:]]\+\) sys=\([[:digit:]]\+\.[[:digit:]]\+\), real=\([[:digit:]]\+\.[[:digit:]]\+\) secs/\1\t\2\t\3/' | awk '{user+=$1; sys+=$2; real+=$3} END {printf "%d %d %d", user, sys, real}' | $SEDCOMMAND 's/[[:space:]]\+/\t/g'`
    ygc_start=`cat "$GCLOGPATH" | grep "^[[:digit:]]\+\.[[:digit:]]\+: \[GC" | wc -l`
    fgc_start=`cat "$GCLOGPATH" | grep "^[[:digit:]]\+\.[[:digit:]]\+: \[Full GC" | wc -l`
    gcstart_usertime=`echo -e "$gctimes" | cut -f 1`
    gcstart_systime=`echo -e "$gctimes" | cut -f 2`
    gcstart_realtime=`echo -e "$gctimes" | cut -f 3`

    cat proc.tmp | bc | $SEDCOMMAND "N;N;N;s/\n/\t/g" > res.tmp
    memstart=`cat res.tmp | awk '{ Young += $1; Old += $2; Heap += $3; Perm += $4} END { printf "%d\t%d\t%d\t%d\n", Young / 1024, Old / 1024, Heap / 1024, Perm / 1024 }'`
    memstartYoung=`echo -e "$memstart" | cut -f 1`
    memstartOld=`echo -e "$memstart" | cut -f 2`
    memstartHeap=`echo -e "$memstart" | cut -f 3`
    memstartPerm=`echo -e "$memstart" | cut -f 4`
    rm proc.tmp
    rm res.tmp
    logln "gc:   Young = $memstartYoung MB, Old = $memstartOld MB, Heap = $memstartHeap MB, Perm = $memstartPerm MB" # Old may be negative here, which means that objects from Young took up more space than was collected from Old
    logln "gc:   YGC = $ygc_start, FGC = $fgc_start, user = $gcstart_usertime s, sys = $gcstart_systime s, real = $gcstart_realtime s"
  fi

  logln "Benchmarking"

  ab -t $REQUEST_TIMEOUT -n $ITERATIONS -C WEBDSLSESSIONID=$WEBDSLSESSIONID -g ./$benchname/${warname}_${sqlname}_${sanitized_page}.dta $BASEURL$warbase/$page$normalsuffix >./$benchname/${warname}_${sqlname}_${sanitized_page}.log

  if [ $pid -ne 0 ]; then
    logln "Forcing GC"
    $JAVA_HOME/bin/jmap -histo:live $pid >/dev/null # this forces a full gc
  fi

  if [ $measure_mem -ne 0 ]; then
    # Here we calculate the memory that was collected during the requests send by ab
    #JDK6
    #cat "$GCLOGPATH" | $SEDCOMMAND "s/\([[:digit:]]\+\)K->\([[:digit:]]\+\)K([[:digit:]]\+K)/\1-\2/g;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \[PSOldGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\) \[PSPermGen: \([[:digit:]]\+-[[:digit:]]\+\)\].*/\1;\2;\3;\4;/;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\),.*/\1;0;\2;0;/" | grep -o "\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);" > proc.tmp
    #JDK7
    cat "$GCLOGPATH" | $SEDCOMMAND "s/\([[:digit:]]\+\)K->\([[:digit:]]\+\)K([[:digit:]]\+K)/\1-\2/g;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \[ParOldGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\) \[PSPermGen: \([[:digit:]]\+-[[:digit:]]\+\)\].*/\1;\2;\3;\4;/;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\),.*/\1;0;\2;0;/" | grep -o "\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);" > proc.tmp
    gctimes=`cat "$GCLOGPATH"| grep -o "Times: user=[[:digit:]]\+\.[[:digit:]]\+ sys=[[:digit:]]\+\.[[:digit:]]\+, real=[[:digit:]]\+\.[[:digit:]]\+ secs" | $SEDCOMMAND 's/Times: user=\([[:digit:]]\+\.[[:digit:]]\+\) sys=\([[:digit:]]\+\.[[:digit:]]\+\), real=\([[:digit:]]\+\.[[:digit:]]\+\) secs/\1\t\2\t\3/' | awk '{user+=$1; sys+=$2; real+=$3} END {print user, sys, real}' | $SEDCOMMAND 's/[[:space:]]\+/\t/g'`
    ygc_end=`cat "$GCLOGPATH" | grep "^[[:digit:]]\+\.[[:digit:]]\+: \[GC" | wc -l`
    fgc_end=`cat "$GCLOGPATH" | grep "^[[:digit:]]\+\.[[:digit:]]\+: \[Full GC" | wc -l`
    gcend_usertime=`echo -e "$gctimes" | cut -f 1`
    gcend_systime=`echo -e "$gctimes" | cut -f 2`
    gcend_realtime=`echo -e "$gctimes" | cut -f 3`
    gcyoung=$((ygc_end-ygc_start))
    gcfull=$((fgc_end-fgc_start))
    gc_usertime=`echo "scale=2; $gcend_usertime - $gcstart_usertime" | bc`
    gc_systime=`echo "scale=2; $gcend_systime - $gcstart_systime" | bc`
    gc_realtime=`echo "scale=2; $gcend_realtime - $gcstart_realtime" | bc`

    cat proc.tmp | bc | $SEDCOMMAND "N;N;N;s/\n/\t/g" > res.tmp
    memend=`cat res.tmp | awk '{ Young += $1; Old += $2; Heap += $3; Perm += $4} END { printf "%d\t%d\t%d\t%d\n", Young / 1024, Old / 1024, Heap / 1024, Perm / 1024 }'`
    memendYoung=`echo -e "$memend" | cut -f 1`
    memendOld=`echo -e "$memend" | cut -f 2`
    memendHeap=`echo -e "$memend" | cut -f 3`
    memendPerm=`echo -e "$memend" | cut -f 4`
    memYoung=`echo "scale=2;$memendYoung-$memstartYoung;" | $SEDCOMMAND 's/--/+/' | bc`
    memOld=`echo "scale=2;$memendOld-$memstartOld;" | $SEDCOMMAND 's/--/+/' | bc`
    memHeap=`echo "scale=2;$memendHeap-$memstartHeap;" | $SEDCOMMAND 's/--/+/' | bc`
    memPerm=`echo "scale=2;$memendPerm-$memstartPerm;" | $SEDCOMMAND 's/--/+/' | bc`
    memHeapPerReq=`echo "scale=2;($memendHeap-$memstartHeap)/$ITERATIONS;" | $SEDCOMMAND 's/--/+/' | bc`

    kill $pid
    wait # wait for catalina to terminate
    pid=0
  fi

  logln "Benchmarking complete"

  memcols=""
  if [ $measure_mem -ne 0 ]; then
    log "gc results: "
    cp "$GCLOGPATH" ./$benchname/${warname}_${sqlname}_${sanitized_page}_gc.dta
    #JDK6
    #cat "$GCLOGPATH" | $SEDCOMMAND "s/\([[:digit:]]\+\)K->\([[:digit:]]\+\)K([[:digit:]]\+K)/\1-\2/g;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \[PSOldGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\) \[PSPermGen: \([[:digit:]]\+-[[:digit:]]\+\)\].*/\1;\2;\3;\4;/;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\),.*/\1;0;\2;0;/" | grep -o "\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);" > proc.tmp
    #cat "$GCLOGPATH" | tail -9 | $SEDCOMMAND 's/[[:space:]]\+total[[:space:]]\+[[:digit:]]\+K,[[:space:]]\+used[[:space:]]\+\([[:digit:]]\+\)K.*/\1/' | grep -o "\(PSYoungGen\|PSOldGen\|PSPermGen\)[[:digit:]]\+" | $SEDCOMMAND 'N;N;s/PSYoungGen\([[:digit:]]\+\)\nPSOldGen\([[:digit:]]\+\)\nPSPermGen\([[:digit:]]\+\)/\1;\2;\1+\2;\3;/' >> proc.tmp
    #JDK7
    cat "$GCLOGPATH" | $SEDCOMMAND "s/\([[:digit:]]\+\)K->\([[:digit:]]\+\)K([[:digit:]]\+K)/\1-\2/g;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \[ParOldGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\) \[PSPermGen: \([[:digit:]]\+-[[:digit:]]\+\)\].*/\1;\2;\3;\4;/;s/.*\[PSYoungGen: \([[:digit:]]\+-[[:digit:]]\+\)\] \([[:digit:]]\+-[[:digit:]]\+\),.*/\1;0;\2;0;/" | grep -o "\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);\([[:digit:]]\+\(-[[:digit:]]\+\)\?\);" > proc.tmp
    cat "$GCLOGPATH" | tail -9 | $SEDCOMMAND 's/[[:space:]]\+total[[:space:]]\+[[:digit:]]\+K,[[:space:]]\+used[[:space:]]\+\([[:digit:]]\+\)K.*/\1/' | grep -o "\(PSYoungGen\|ParOldGen\|PSPermGen\)[[:digit:]]\+" | $SEDCOMMAND 'N;N;s/PSYoungGen\([[:digit:]]\+\)\nParOldGen\([[:digit:]]\+\)\nPSPermGen\([[:digit:]]\+\)/\1;\2;\1+\2;\3;/' >> proc.tmp

    cat proc.tmp | bc | $SEDCOMMAND "N;N;N;s/\n/\t/g" > res.tmp
    memend=`cat res.tmp | awk '{ Young += $1; Old += $2; Heap += $3; Perm += $4} END { printf "%d\t%d\t%d\t%d\n", Young / 1024, Old / 1024, Heap / 1024, Perm / 1024 }'`
    memendYoung=`echo -e "$memend" | cut -f 1`
    memendOld=`echo -e "$memend" | cut -f 2`
    memendHeap=`echo -e "$memend" | cut -f 3`
    memendPerm=`echo -e "$memend" | cut -f 4`
    memYoungTotal=`echo "scale=2;$memendYoung-$memstartYoung;" | $SEDCOMMAND 's/--/+/' | bc`
    memOldTotal=`echo "scale=2;$memendOld-$memstartOld;" | $SEDCOMMAND 's/--/+/' | bc`
    memHeapTotal=`echo "scale=2;$memendHeap-$memstartHeap;" | $SEDCOMMAND 's/--/+/' | bc`
    memPermTotal=`echo "scale=2;$memendPerm-$memstartPerm;" | $SEDCOMMAND 's/--/+/' | bc`
    logln_continue "Young = $memYoung MB, Old = $memOld MB, Heap = $memHeap MB, Perm = $memPerm MB, Heap/Req= $memHeapPerReq MB"
    logln "gc:         YGC = $gcyoung, FGC = $gcfull, user = $gc_usertime s, sys = $gc_systime s, real = $gc_realtime s"
    logln "Total mem:  Young = $memYoungTotal MB, Old = $memOldTotal MB, Heap = $memHeapTotal MB, Perm = $memPermTotal MB"
    memcols="\t$gcyoung\t$gcfull\t$gc_usertime\t$gc_systime\t$gc_realtime\t$memYoung\t$memOld\t$memHeap\t$memPerm\t$memHeapPerReq\t$memYoungTotal\t$memOldTotal\t$memHeapTotal\t$memPermTotal"
  fi

  log "ab results: "
  abtotals=`cat ./$benchname/${warname}_${sqlname}_${sanitized_page}.log | grep "Total:" | $SEDCOMMAND "s/Total:/${sanitized_page}/" | $SEDCOMMAND "s/[[:space:]]\+/\t/g"`
  ab80perc=`cat ./$benchname/${warname}_${sqlname}_${sanitized_page}.log | grep "80%" | $SEDCOMMAND "s/[[:space:]]*[[:digit:]]\+%[[:space:]]*//"`
  ab90perc=`cat ./$benchname/${warname}_${sqlname}_${sanitized_page}.log | grep "90%" | $SEDCOMMAND "s/[[:space:]]*[[:digit:]]\+%[[:space:]]*//"`
  ab90perc=`cat ./$benchname/${warname}_${sqlname}_${sanitized_page}.log | grep "90%" | $SEDCOMMAND "s/[[:space:]]*[[:digit:]]\+%[[:space:]]*//"`
  mintime=`echo -e "$abtotals" | cut -f 2`
  avgtime=`echo -e "$abtotals" | cut -f 3`
  maxtime=`echo -e "$abtotals" | cut -f 6`
  logln_continue "Min = $mintime ms, Avg = $avgtime ms, Max = $maxtime ms"
  echo -e "$abtotals\t$ab80perc\t$ab90perc\t$sqlstr\t$entstr\t$dupstr\t$colstr$memcols\t$avgsql\t$avgents\t$avgdups\t$avgcols\t$cntmaxents\t$maxentsper" >>./$benchname/${warname}_${sqlname}.log

  if [ $measure_mem -ne 0 ]; then
    logln "Cleaning up"
    rm "$GCLOGPATH"
    rm proc.tmp
    rm res.tmp

    rm "$removefile"
    removefile=""
    rm -r "$removedir"
    removedir=""
  fi

  local etime=$($DATECOMMAND '+%s.%N')
  local dt=`echo "$etime-$stime" | bc`
  local ms=`echo "scale=0; i=$dt/1; scale=3; $dt/1-i" | bc`
  local ds=`echo "scale=0;($dt/1)%60" | bc`
  local dm=`echo "scale=0;(($dt/1)/60)%60" | bc`
  local dh=`echo "scale=0;($dt/1)/3600" | bc`
  logln "Completed test in $dh:$(printf %02d $dm):$(printf %02d $ds)$ms"
}

cleanup_benchmark(){
  if [[ $REDUCE_DEPLOYS == 0 ]] ; then
    if [ $pid -ne 0 ]; then
      kill $pid
      wait
    fi
    pid=0
    if [ -f $removefile ]; then
      if [[ $removefile != "" ]]; then
        rm "$removefile"
        removefile=""
      fi
    fi
    if [ -d $removedir ]; then
      if [[ $removedir != "" ]]; then
        rm -r "$removedir"
        removedir=""
      fi
    fi
  fi
}

finalize_benchmark(){
  rm $CONTINUE_PATH
  for war in $WARS
  do
    local warfile=`echo "$war" | $SEDCOMMAND 's/\?.*//'`
    local querystring=`echo "$war" | grep -o '\?.*' | $SEDCOMMAND 's/^\?//'`
    local sanitized_querystring=`echo "$querystring" | $SEDCOMMAND 's/[:\/<>|"?]/_/g'`
    warname=$(basename $warfile .war)
    if [[ $querystring != "" ]]; then
      warname="${warname}_${sanitized_querystring}"
    fi
    for sql in $SQLS
    do
      sqlname=$(basename $sql .sql.gz)
      cat ./$benchname/${warname}_${sqlname}.log | column -t > ./$benchname/${warname}_${sqlname}.txt
    done
  done

  if [[ $REDUCE_DEPLOYS == 1 ]] ; then
    if [ $pid -ne 0 ]; then
      kill $pid
      wait
    fi
    pid=0
    if [ -f $removefile ]; then
      if [[ $removefile != "" ]]; then
        rm "$removefile"
        removefile=""
      fi
    fi
    if [ -d $removedir ]; then
      if [[ $removedir != "" ]]; then
        rm -r "$removedir"
        removedir=""
      fi
    fi
  fi
}

if [ -f $CONTINUE_PATH ]; then
  benchname=`cat $CONTINUE_PATH | awk 'FNR==1'`
  remaining=`cat $CONTINUE_PATH | awk 'FNR>1' | wc -l`
  logln "Continuing $remaining cases, results are written to $benchname"
else
  init_benchmark
  remaining=`cat $CONTINUE_PATH | awk 'FNR>1' | wc -l`
fi
continue_benchmark
finalize_benchmark

