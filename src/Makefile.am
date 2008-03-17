include $(top_srcdir)/Makefile.xt
include $(*.dep)
include $(wildcard org/webdsl/dsl/syntax/*.dep)
include $(wildcard org/webdsl/dsl/generation/*.dep)

### syntax

syntax 		= org/webdsl/dsl/syntax/WebDSL
hql 		= org/webdsl/dsl/syntax/HQL
mixhql 		= org/webdsl/dsl/syntax/MixHQL
css 		= org/webdsl/dsl/syntax/CSS
mixcss 		= org/webdsl/dsl/syntax/StrategoCSS
metasyntax 	= org/webdsl/dsl/syntax/StrategoWebDSL
mixmetasyntax 	= org/webdsl/dsl/syntax/Stratego-WebDSL-Java-XML

generator = org/webdsl/dsl/generation/dsl-to-seam

#syntax : $(hql).def $(hql).tbl $(hql).rtg $(hql).str \
#
#         $(hql)-pretty.pp.af $(mixhql).sdf \
#
#         $(css).def $(css).tbl $(css).rtg $(css).str \
#
#         $(css)-pretty.pp.af $(mixcss).def $(mixcss).tbl \
#
#         $(syntax).def $(syntax).tbl $(syntax).rtg $(syntax).str \
#         $(syntax)-pretty.pp.af \
#         $(metasyntax).def $(metasyntax).tbl \
#         $(mixmetasyntax).def $(mixmetasyntax).tbl

MIXES 	= $(mixhql).sdf

SYNTAXDEFS = $(syntax).def \
	  $(mixcss).def $(metasyntax).def $(mixmetasyntax).def

# $(hql).def $(css).def 

TBLS 	= $(syntax).tbl   \
	  $(metasyntax).tbl $(mixmetasyntax).tbl $(mixcss).tbl

# $(hql).tbl $(css).tbl

SIGS 	= $(hql).rtg    $(hql).str \
	  $(css).rtg    $(css).str \
	  $(syntax).rtg $(syntax).str

PPTBLS = $(hql)-pretty.pp.af $(css)-pretty.pp.af $(syntax)-pretty.pp.af

sdfdata_DATA = $(SYNTAXDEFS) $(TBLS) $(SIGS) $(PPTBLS)

PGEN_FLAGS = -m `basename $*`

CLEANFILES = \
    $(wildcard *.c) \
    $(wildcard *.dep) \
    $(wildcard org/webdsl/dsl/*/*.def) \
    $(wildcard org/webdsl/dsl/*/*.tbl) \
    $(wildcard org/webdsl/dsl/*/*.rtg) \
    $(wildcard org/webdsl/dsl/*/*.c) \
    $(wildcard org/webdsl/dsl/*/*.o) \
    $(wildcard org/webdsl/dsl/*/*.dep) \
    $(wildcard org/webdsl/dsl/*/*.pp.af) \
    $(wildcard org/webdsl/dsl/*/*.rtree) 

EXTRA_DIST = \
    $(wildcard *.str) \
    $(wildcard org/webdsl/dsl/*/*.dep) \
    $(wildcard org/webdsl/dsl/*/*.meta) \
    $(wildcard org/webdsl/dsl/*/*/*.meta) \
    $(wildcard org/webdsl/dsl/*/*.str) \
    $(wildcard org/webdsl/dsl/*/*/*.str) \
    $(wildcard org/webdsl/dsl/*/*.sdf) \
    $(wildcard org/webdsl/dsl/*/*.pp)

PPTABLES = \
	$(syntax)-pretty.pp.af \
	$(syntax).tbl \
	$(hql)-pretty.pp.af \
	$(css).tbl \
	$(css)-pretty.pp.af

STRINCLUDES = \
	-I . \
	-I $(JAVA_FRONT)/share/java-front \
	-I $(JAVA_FRONT)/share/java-front/languages/java/eblock \
	-I $(JAVA_FRONT)/share/java-front-syntax \
	-I $(GPP)/share/sdf/gpp \
	-I $(XML_FRONT)/share/sdf/xml-front \
	-I org/webdsl/dsl/syntax \
	-I org/webdsl/dsl/modules \
	# UNDONE: $(JAVA_FRONT_STRCFLAGS) --verbose 1

SDFINCLUDES = $(STRINCLUDES)

STRCFLAGS = \
	-la stratego-xtc \
	-la stratego-lib \
	-la stratego-gpp \
	-la stratego-tool-doc \
	-la stratego-sglr \
	-la $(JAVA_FRONT_LIBS) \
	--format-check 0

SDF2RTG_FLAGS = --main `basename $*`

org/webdsl/dsl/syntax/WebDSL.def: org/webdsl/dsl/syntax/MixHQL.sdf

#all : syntax $(generator)


#%.str : %.rtg
#	rtg2sig -i $< -o $@

#%.def : %.sdf $(wildcard org/webdsl/dsl/syntax/*.sdf) $(wildcard org/webdsl/dsl/modules/*.sdf)
#	pack-sdf -i $< -o $@ $(STRINCLUDES)

Mix%.sdf : %.def
	gen-sdf-mix -i $< --main `basename $*` --name Mix`basename $*` -o $@

#.pp.def :
#	ppgen -i $< -o $@

#%.pp.af : %.pp
#	parse-pp-table -i $< -o $@

#.tbl.def : 
#	sdf2table -i $< -o $@ -m `basename $*`

#.rtg.def :
#	sdf2rtg -i $< -o $@ -m `basename $*`

#%.str-pp : %.str
#	parse-stratego $(STRINCLUDES) -i $< | pp-aterm -o $@

#% : %.str $(STRSOURCES:.str=.rtree)
#	echo $(STRCFLAGS)
#	strc -i $< -o $@ $(STRCFLAGS) $(STRINCLUDES) -m `basename $@`-main --verbose 2 \
#		-la webdsl-utils -la webdsl-syntax

#%.str.pp : %.str
#	pp-stratego -i $< -o $@ $(STRINCLUDES)

#.rtree.str : syntax

SCFLAGS = --main $*-main

bin_PROGRAMS = dsl-to-seam
dsl_to_seam_LDADD = $(LDADD) $(JAVA_FRONT_LIBS) $(STRATEGO_GPP_LIBS) $(STRATEGO_SGLR_LIBS) $(STRATEGO_TOOL_DOC_LIBS) \
                    libwebdsl-syntax.la libwebdsl-utils.la

STRSOURCES = \
	$(wildcard org/webdsl/dsl/*/*.str) \
	$(wildcard org/webdsl/dsl/*/*/*.str)

dsl-to-seam.c : dsl-to-seam.str $(STRSOURCES:.str=.rtree)

BOOTCLEANFILES = dsl-to-seam.c

CFLAGS = -O0 -pipe -g

#dsl_to_seam_SOURCES = dsl-to-seam.c



#.str.rtree :
#	sglri $(STRINCLUDES) --amb off -p $(STRATEGOTBL_UNINSTALLED) -i $< -o $@

########################################################
# libraries

nobase_data_DATA = libwebdsl-utils.rtree libwebdsl-syntax.rtree 
lib_LTLIBRARIES  = libwebdsl-utils.la libwebdsl-syntax.la 

######## libwebdsl-syntax

EXTRA_DIST += $(webdslsyntaxlib) $(webdslsyntaxlib:.str=.rtree) libwebdsl-syntax.rtree
BOOTCLEANFILES += libwebdsl-syntax.rtree libwebdsl-syntax.c $(webdslsyntaxlib:.str=.rtree)

webdslsyntaxlib = org/webdsl/dsl/syntax/webdsl-syntax.str $(wildcard org/webdsl/dsl/syntax/*.str)

libwebdsl_syntax_la_SOURCES = libwebdsl-syntax.c
libwebdsl_syntax_la_CFLAGS   = $(AM_CFLAGS)
libwebdsl_syntax_la_LDFLAGS  = -avoid-version -no-undefined $(AM_LDFLAGS)
libwebdsl_syntax_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
libwebdsl_syntax_la_LIBADD   =  $(STRATEGO_XTC_UNINSTALLED_LIBS) $(STRATEGO_GPP_UNINSTALLED_LIBS) $(STRATEGO_UNINSTALLED_LIBS)

libwebdsl-syntax.rtree libwebdsl-syntax.c : $(webdslsyntaxlib:.str=.rtree) $(TBLS) $(PPTABLES)
	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/syntax/webdsl-syntax.str -o libwebdsl-syntax.rtree --verbose 1 $(STRCFLAGS)
	rm libwebdsl-syntax.str

######## libwebdsl-utils

EXTRA_DIST += $(webdslutilslib) $(webdslutilslib:.str=.rtree) libwebdsl-utils.rtree
BOOTCLEANFILES += libwebdsl-utils.rtree libwebdsl-utils.c $(webdslutilslib:.str=.rtree)

webdslutilslib = org/webdsl/dsl/utils/webdsl-utils.str $(wildcard org/webdsl/dsl/utils/*.str)

libwebdsl_utils_la_SOURCES = libwebdsl-utils.c
libwebdsl_utils_la_CFLAGS   = $(AM_CFLAGS)
libwebdsl_utils_la_LDFLAGS  = -avoid-version -no-undefined $(AM_LDFLAGS)
libwebdsl_utils_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
libwebdsl_utils_la_LIBADD   =  $(STRATEGO_XTC_UNINSTALLED_LIBS) $(STRATEGO_GPP_UNINSTALLED_LIBS) $(STRATEGO_UNINSTALLED_LIBS)

libwebdsl-utils.rtree libwebdsl-utils.c : $(webdslutilslib:.str=.rtree) #$(PPTABLES)
	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/utils/webdsl-utils.str -o libwebdsl-utils.rtree --verbose 2 $(STRCFLAGS)
	rm libwebdsl-utils.str

