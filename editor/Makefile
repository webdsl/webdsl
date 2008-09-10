SYNTAX     = WebDSL
SOURCE     = ../src/org/webdsl/dsl/syntax/$(SYNTAX).def
PPTABLES   = ../src/org/webdsl/dsl/syntax/WebDSL-pretty.pp.af \
             ../src/org/webdsl/dsl/syntax/HQL-pretty.pp.af

ESVS       = ${wildcard src/*.esv}

all : ctrees bin/$(SYNTAX).packed.esv

clean :
	rm -f src/parser/$(SYNTAX)ParseController.java bin/$(SYNTAX).packed.esv
	rm -rf src/parser/ast
	# ...

ctrees : feedback.ctree
	$(MAKE) -C .. ctrees
	cp ../src/*.ctree .
	cp  $(PPTABLES) .

feedback.ctree : src/feedback.str
	strc -F --library -I ../src -I ../src/org/webdsl/dsl/syntax -i $< -o $@

feedback : src/feedback.str
	strc              -I ../src -I ../src/org/webdsl/dsl/syntax -i $< -o $@ \
                      -la ../src/libwebdsl-front.la \
                      -la ../src/libwebdsl-generator.la \
                      -la ${HOME}/.nix-profile/lib/libjava-front.la \
                      -la stratego-sglr -la stratego-lib -la stratego-sglr -la stratego-tool-doc

bin/$(SYNTAX).packed.esv : $(SYNTAX).def $(SYNTAX).tbl $(SDF2IMP) Makefile $(ESVS)
	sdf2imp -i $< -p $(SYNTAX).tbl -m $(SYNTAX) --verbose 2 # -e app -s Unit -m WebDSL

$(SYNTAX).def : $(SOURCE)
	ln -s $< $@

$(SYNTAX).tbl : $(SYNTAX).def
	sdf2table -i $< -o $@ -m $(SYNTAX)
