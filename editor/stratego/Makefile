SYNTAX     = Stratego-WebDSL-Java-XML
EXTENSIONS = str,strw
PACKAGE    = org.strategoxt.imp.editors.strategowebdsl
SOURCE     = ../../src/org/webdsl/dsl/syntax/$(SYNTAX).def
START      = Module[StrategoHost]

ESVS       = ${wildcard *.esv}

all : eclipse-deps

clean :
	rm -f plugin.xml
	# ...

eclipse-deps : plugin.xml # and others

plugin.xml : $(SYNTAX).def $(SYNTAX).tbl Makefile $(ESVS)
	sdf2imp --verbose 2 -i $< -p $(SYNTAX).tbl -e $(EXTENSIONS) -s $(START) -m $(SYNTAX) -n $(PACKAGE)

$(SYNTAX).def : $(SOURCE)
	ln -s $< $@

$(SYNTAX).tbl : $(SYNTAX).def
	sdf2table -i $< -o $@ -m $(SYNTAX)
