# Makefile for invoking code generator
# should eventually be integrated in ant build.xml file
# and be invocable from Eclipse

dsltoseam = @@DSLTOSEAM@@

apps = $(wildcard *.app)

all : @@APPNAME@@.appc

webdsl-lib:
	pilc -i webdsl.pil --gen-external-classinfos --java -d src
	
%.appc : %.app $(apps)
	$(dsltoseam) --pil -i $< 

dump :
	mysqldump --user=@@DBUSER@@ --password=@@DBPASSWORD@@ @@DBNAME@@ > db.sql

clean :
	rm $(wildcard *.appc)

