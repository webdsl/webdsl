all : wiki.java

%.adm : %.dm
	sglri -p ../syn/DataModel.tbl -i $< -o $@

%.ajava : %.adm
	../gen/datamodel-to-hbm -i $< -o $@

%.java : %.ajava
	pp-java -i $< -o $@

clean : 
	rm -f *.adm *.ajava