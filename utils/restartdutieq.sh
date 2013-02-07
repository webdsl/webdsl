systemctl stop tomcat
NOW=$(date +"%y-%m-%d-%T")
LOGFILE="log-researchr-$NOW.log"
tail -n 10000 /var/tomcat/logs/catalina.out > $LOGFILE
systemctl start tomcat
