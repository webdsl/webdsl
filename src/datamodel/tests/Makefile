
JAVAFRONT = ${HOME}/.nix-profile

all : wiki.adm wiki.ajava wiki.java

%.appa : %.app
	sglri -p ../syn/DataModel.tbl -i $< | pp-aterm -o $@

%.ajava : %.appa
	../gen/datamodel-to-hbm -i $< | pp-aterm -o $@

%.ajava.check : %.ajava
	format-check --rtg ${JAVAFRONT}/share/java-front/Java-15.rtg -i $< -o $@

%.java : %.ajava
	pp-java -i $< -o $@

clean : 
	rm -f *.adm *.ajava *.java
