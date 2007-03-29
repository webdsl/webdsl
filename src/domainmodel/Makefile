.PHONY : all test compilestr domainmodel sdf clean

NIXSHARE   = ${HOME}/.nix-profile/share
STRCFLAGS  = -I ./syntax \
	     -I ../         \
             -I $(NIXSHARE)/sdf/java-front \
	     -I $(NIXSHARE)/java-front \
             -I $(NIXSHARE)/sdf/xml-front \
	     -I $(NIXSHARE)/xml-front \
	     `pkg-config --variable=strcxtcflags java-front` \
             -la stratego-xtc \
             -la stratego-tool-doc \
	     -la stratego-lib -la ${HOME}/.nix-profile/lib/libjava-front.la 
DMCOMPILER = dmdsl
SDFMODULE  = DomainModel
SRCS       = ./syntax/$(SDFMODULE).str ./generator/*.str ../*.str

all : domainmodel

test : domainmodel test/test.adm test/test.ajava # test/test.java test/test.ajava.check
test2 : domainmodel test/breakme.adm test/breakme.ajava # test/test.java test/test.ajava.check

domainmodel : sdf compilestr

compilestr : ./generator/$(DMCOMPILER)

./generator/$(DMCOMPILER) : $(SRCS)
	strc -i ./generator/domainmodel-dsl.str -o ./generator/$(DMCOMPILER) $(STRCFLAGS)

sdf : ./syntax/$(SDFMODULE).def ./syntax/$(SDFMODULE).tbl ./syntax/$(SDFMODULE).rtg ./syntax/$(SDFMODULE).str

clean : 
	rm -f   ./generator/$(DMCOMPILER)* ./syntax/$(SDFMODULE).str ./syntax/*.def ./syntax/*.tbl ./syntax/*.rtg ./syntax/*.def \
		./test/*.adm ./test/*.ajava* ./test/*.java && rm -rf ./generated

%.adm : %.dm
	sglri -p ./syntax/$(SDFMODULE).tbl -i $< | pp-aterm -o $@

%.ajava : %.adm
	./generator/$(DMCOMPILER) --prefix org -pn blog -i $<

%.ajava.check : %.ajava
	format-check --rtg ${NIXSHARE}/java-front/Java-15.rtg -i $< -o $@

%.java : %.ajava
	pp-java -i $< -o $@

%.rtg : %.def
	sdf2rtg --ignore-missing-cons -m $(SDFMODULE) -i $< -o $@

./syntax/$(SDFMODULE).str : ./syntax/$(SDFMODULE).rtg
	rtg2sig -i $< -o $@

%.def : %.sdf
	pack-sdf -I $(NIXSHARE)/sdf/java-front -i $< -o $@

%.tbl : %.def
	sdf2table -m $(SDFMODULE) -i $< -o $@
