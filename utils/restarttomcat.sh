kill -3 `ps axU tomcat | grep /data/tomcat/temp | grep  org.apache.catalina.startup.Bootstrap | awk '{print $1}'`
kill -9 `ps axU tomcat | grep /data/tomcat/temp | grep  org.apache.catalina.startup.Bootstrap | awk '{print $1}'`
NOW=$(date +"%y-%m-%d-%T")
LOGFILE="log-$NOW.log"
tail -n 10000 /data/tomcat/logs/catalina.out > $LOGFILE
initctl stop tomcat
initctl start tomcat
