# Makefile for invoking code generator
# should eventually be integrated in ant build.xml file
# and be invocable from Eclipse

dsltoseam = @@DSLTOSEAM@@

apps = $(wildcard app/*.app)

all : app/@@APPNAME@@.appc

%.appa : %.app $(apps)
	$(dsltoseam) -i $< --no-desugaring --no-pp | pp-aterm -o $@

%.appb : %.app $(apps)
	$(dsltoseam) -i $< --desugar --no-pp | pp-aterm -o $@

%.appbpp : %.app $(apps)
	$(dsltoseam) -i $< --desugar -i $< -o $@
	
%.appc : %.app $(apps)
	$(dsltoseam) -i $< 

%-full.app : %.app $(apps)
	$(dsltoseam) -i $< -o $@ --no-expansion

dump :
	mysqldump --user=@@DBUSER@@ --password=@@DBPASSWORD@@ @@DBNAME@@ > db.sql

clean :
	rm $(wildcard *.appa) $(wildcard *.appb)

