include $(top_srcdir)/config/Transformers.mk
include $(wildcard org/webdsl/dsl/syntax/*.dep)
include $(wildcard org/webdsl/dsl/generation/*.dep)

syntax = org/webdsl/dsl/syntax/WebDSL

hql = org/webdsl/dsl/syntax/HQL

mixhql = org/webdsl/dsl/syntax/MixHQL

css = org/webdsl/dsl/syntax/CSS

mixcss = org/webdsl/dsl/syntax/StrategoCSS

metasyntax = org/webdsl/dsl/syntax/StrategoWebDSL

mixmetasyntax = org/webdsl/dsl/syntax/Stratego-WebDSL-Java-XML

generator = org/webdsl/dsl/generation/dsl-to-seam

CLEANFILES = \
    $(wildcard org/webdsl/dsl/*/*.def) \
    $(wildcard org/webdsl/dsl/*/*.tbl) \
    $(wildcard org/webdsl/dsl/*/*.rtg) \
    $(wildcard org/webdsl/dsl/*/*.c) \
    $(wildcard org/webdsl/dsl/*/*.o) \
    $(wildcard org/webdsl/dsl/*/*.dep) \
    $(wildcard org/webdsl/dsl/*/*.pp.af)

EXTRA_DIST = \
    $(wildcard org/webdsl/dsl/*/*.dep) \
    $(wildcard org/webdsl/dsl/*/*.meta) \
    $(wildcard org/webdsl/dsl/*/*/*.meta) \
    $(wildcard org/webdsl/dsl/*/*.str) \
    $(wildcard org/webdsl/dsl/*/*/*.str) \
    $(wildcard org/webdsl/dsl/*/*.sdf) \
    $(wildcard org/webdsl/dsl/*/*.pp)

STRSOURCES = \
	$(wildcard org/webdsl/dsl/*/*.str) \
	$(wildcard org/webdsl/dsl/*/*/*.str) \
	$(syntax)-pretty.pp.af \
	$(syntax).tbl \
	$(hql)-pretty.pp.af \
	$(css).tbl \
	$(css)-pretty.pp.af

SDF_ATTRIBUTE_INCLUDES =					\
	-I $(JAVA_FRONT)/share/java-front			\
	-I $(JAVA_FRONT)/share/java-front/languages/java/eblock	\
	-I $(JAVA_FRONT)/share/java-front-syntax		\
	-I org/webdsl/dsl/syntax

STRINCLUDES = \
	-I . \
	-I $(GPP)/share/sdf/gpp \
	-I $(XML_FRONT)/share/sdf/xml-front \
	$(SDF_ATTRIBUTE_INCLUDES) \
        $(STR_LAZY_INCLUDES)

# UNDONE: $(JAVA_FRONT_STRCFLAGS) --verbose 1

STRCFLAGS = \
	-la stratego-xtc \
	-la stratego-lib \
	-la stratego-gpp \
	-la stratego-tool-doc \
	-la stratego-sglr \
	-la $(JAVA_FRONT_LIBS)

PGEN_FLAGS      = -m `basename $*`
SDF2RTG_FLAGS   = -m `basename $*`
SCFLAGS         = --verbose 0 -O 2

# 
AG_GRM 		= WebDSL.ag
SDFS		= $(wildcard org/webdsl/dsl/syntax/*.esdf)

all : syntax # $(generator)

syntax : $(hql).def $(hql).tbl $(hql).rtg $(hql).str \
         $(hql)-pretty.pp.af $(mixhql).sdf \
         $(css).def $(css).tbl $(css).rtg $(css).str \
         $(css)-pretty.pp.af $(mixcss).def $(mixcss).tbl \
         $(syntax).def $(syntax).tbl $(syntax).rtg $(syntax).str \
         $(syntax)-pretty.pp.af \
         $(metasyntax).def $(metasyntax).tbl \
         $(mixmetasyntax).def $(mixmetasyntax).tbl

#%.def : %.sdf $(wildcard org/webdsl/dsl/syntax/*.sdf)
#	pack-sdf -i $< -o $@ $(STRINCLUDES)

Mix%.sdf : %.def
	gen-sdf-mix -i $< --main `basename $*` --name Mix`basename $*` -o $@

%.str-pp : %.str
	parse-stratego $(STRINCLUDES) -i $< | pp-aterm -o $@

% : %.str $(STRSOURCES)
	echo $(STRCFLAGS)
	strc -i $< -o $@ $(STRCFLAGS) $(STRINCLUDES) -m `basename $@`-main

%.str.pp : %.str
	pp-stratego -i $< -o $@ $(STRINCLUDES)
