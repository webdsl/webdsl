SYNTAX     = WebDSL
SOURCE     = ../src/org/webdsl/dsl/syntax/$(SYNTAX).def
CTREE      = ...

SDF2IMP    = $(IMP)/org.strategoxt.imp.metatooling/sdf2imp
ESVS       = ${wildcard src/*.esv}

all : bin/$(SYNTAX).packed.esv

	# : $(CTREE)
	# cp $(CTREE) bin

clean :
	rm -f src/parser/$(SYNTAX)ParseController.java bin/$(SYNTAX).packed.esv
	rm -rf src/parser/ast
	# ...

bin/$(SYNTAX).packed.esv : $(SYNTAX).def $(SYNTAX).tbl $(SDF2IMP) Makefile $(ESVS)
	$(SDF2IMP) -i $< -p $(SYNTAX).tbl -m $(SYNTAX) --verbose 2 # -e app -s Unit -m WebDSL

$(SYNTAX).def : $(SOURCE)
	ln -s $< $@

$(SYNTAX).tbl : $(SYNTAX).def
	sdf2table -i $< -o $@ -m $(SYNTAX)
