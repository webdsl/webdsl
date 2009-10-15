# Makefile for invoking code generator
# should eventually be integrated in ant build.xml file
# and be invocable from Eclipse

dsltoseam = @@DSLTOSEAM@@

apps = $(wildcard *.app)

all :
	$(dsltoseam) --servlet -i ../@@APPNAME@@.app @@SESSIONTIMEOUTOPTION@@ @@STATISTICSOPTION@@ @@FASTPPOPTION@@ @@VERBOSEOPTION@@ @@DEBUGOPTION@@

java :
	java -cp strategoxt.jar -jar webdsl.jar --servlet -i ../@@APPNAME@@.app @@SESSIONTIMEOUTOPTION@@ @@STATISTICSOPTION@@ @@FASTPPOPTION@@ @@VERBOSEOPTION@@ @@DEBUGOPTION@@

dump :
	mysqldump --user=@@DBUSER@@ --password=@@DBPASSWORD@@ @@DBNAME@@ > db.sql

clean :
	rm $(wildcard *.appc)

