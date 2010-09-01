 APP=`echo $1 | sed 's/.app$//'`
 echo $APP
 make $APP.sh && $APP.sh