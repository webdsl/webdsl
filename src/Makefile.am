include $(top_srcdir)/Makefile.xt
include $(wildcard *.dep)
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

# MIXES 	= $(mixhql).sdf

SYNTAXDEFS = $(syntax).def					  \
	     $(mixcss).def $(metasyntax).def $(mixmetasyntax).def \
	     $(hql).def $(css).def  # used for mixing		  

TBLS = $(syntax).tbl					       \
	  $(metasyntax).tbl $(mixmetasyntax).tbl $(mixcss).tbl 

# $(hql).tbl $(css).tbl

SIGS = $(hql).rtg $(hql).str			\
	  $(css).rtg    $(css).str		\
	  $(syntax).rtg $(syntax).str		

PPTBLS = $(hql)-pretty.pp.af $(css)-pretty.pp.af $(syntax)-pretty.pp.af

sdfdata_DATA = $(SYNTAXDEFS) $(TBLS) $(SIGS) $(PPTBLS)

PGEN_FLAGS = -m `basename $*`

CLEANFILES = \
    $(wildcard *.c) \
    $(wildcard *.dep) \
    $(wildcard *.rtree) \
    $(wildcard org/webdsl/dsl/*/*.def) \
    $(wildcard org/webdsl/dsl/*/*.tbl) \
    $(wildcard org/webdsl/dsl/*/*.rtg) \
    $(wildcard org/webdsl/dsl/*/*.c) \
    $(wildcard org/webdsl/dsl/*/*.o) \
    $(wildcard org/webdsl/dsl/*/*.dep) \
    $(wildcard org/webdsl/dsl/*/*.pp.af) \
    $(wildcard org/webdsl/dsl/*/*.rtree) \
    $(wildcard org/webdsl/dsl/modules/*/*.rtree) 

EXTRA_DIST = \
    $(wildcard *.str) \
    $(wildcard org/webdsl/dsl/*/*.dep) \
    $(wildcard org/webdsl/dsl/*/*.meta) \
    $(wildcard org/webdsl/dsl/*/*.str) \
    $(wildcard org/webdsl/dsl/*/*.sdf) \
    $(wildcard org/webdsl/dsl/*/*.pp) \
    $(wildcard org/webdsl/dsl/modules/*/*.str) \
    $(wildcard org/webdsl/dsl/modules/*/*.meta)

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

XTC_IMPORT = $(JAVA_FRONT_XTC)

# Disable some of the bogus warnings:
# - multiple external references are the unfortunate effect of librarification and is out of our control right now
# - nullary constructor warnings are not interesting unless they're lowercase imho, like 'top'
#   specifically, you don't want warnings for nullary constructor builds, especially for overlays (e.g., |[ e_UTILS.isInstance(...) ]|)
#
SCLIMITWARNS = 2>&1 | grep -vE 'warning ] Nullary constructor .*[A-Z]|warning ] multiple external| \[ExtSDef\("' \
               >&2

SDF2RTG_FLAGS = --main `basename $*`

org/webdsl/dsl/syntax/WebDSL.def: org/webdsl/dsl/syntax/MixHQL.sdf

Mix%.sdf : %.def
	gen-sdf-mix -i $< --main `basename $*` --name Mix`basename $*` -o $@

SCFLAGS = --main $*-main

bin_PROGRAMS = dsl-to-seam

dsl_to_seam_LDADD = $(LDADD) $(JAVA_FRONT_LIBS) $(STRATEGO_GPP_LIBS) $(STRATEGO_SGLR_LIBS) $(STRATEGO_TOOL_DOC_LIBS) \
                    libwebdsl-front.la

#                    libwebdsl-syntax.la libwebdsl-utils.la libwebdsl-to-seam.la


DSLTOSEAMSOURCES = \
	$(wildcard ./org/webdsl/dsl/modules/*.str) \
	$(wildcard ./org/webdsl/dsl/modules/*/*.str) \
	$(wildcard ./org/webdsl/dsl/to-seam/*.str) \
	$(wildcard ./org/webdsl/dsl/builtins/*.str) \
	$(wildcard ./org/webdsl/dsl/transformation/*.str)


dsl-to-seam.c : dsl-to-seam.str $(DSLTOSEAMSOURCES:.str=.rtree)

BOOTCLEANFILES = dsl-to-seam.c

#dsl_to_seam_SOURCES = dsl-to-seam.c


########################################################
# libraries

#nobase_data_DATA = libwebdsl-front.rtree libwebdsl-to-seam.rtree
#lib_LTLIBRARIES  = libwebdsl-front.la libwebdsl-to-seam.la

nobase_data_DATA = libwebdsl-front.rtree 
lib_LTLIBRARIES  = libwebdsl-front.la 

######## libwebdsl-utils

#EXTRA_DIST += $(webdslutilslib) $(webdslutilslib:.str=.rtree) libwebdsl-utils.rtree
#BOOTCLEANFILES += libwebdsl-utils.rtree libwebdsl-utils.c $(webdslutilslib:.str=.rtree)
#
#webdslutilslib = org/webdsl/dsl/utils/webdsl-utils.str $(wildcard org/webdsl/dsl/utils/*.str)
#
#libwebdsl_utils_la_SOURCES = libwebdsl-utils.c
#libwebdsl_utils_la_CFLAGS   = $(AM_CFLAGS)
#libwebdsl_utils_la_LDFLAGS  = -avoid-version -no-undefined $(AM_LDFLAGS)
#libwebdsl_utils_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
#libwebdsl_utils_la_LIBADD   =  $(STRATEGO_XTC_UNINSTALLED_LIBS) $(STRATEGO_GPP_UNINSTALLED_LIBS) $(STRATEGO_UNINSTALLED_LIBS)
#
#libwebdsl-utils.rtree libwebdsl-utils.c : $(webdslutilslib:.str=.rtree)
#	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/utils/webdsl-utils.str -o libwebdsl-utils.rtree \
#		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)
#	rm libwebdsl-utils.str
#
######## libwebdsl-syntax
#
#EXTRA_DIST += $(webdslsyntaxlib) $(webdslsyntaxlib:.str=.rtree) libwebdsl-syntax.rtree
#BOOTCLEANFILES += libwebdsl-syntax.rtree libwebdsl-syntax.c $(webdslsyntaxlib:.str=.rtree)
#
#webdslsyntaxlib = org/webdsl/dsl/syntax/webdsl-syntax.str $(wildcard org/webdsl/dsl/syntax/*.str)
#
#libwebdsl_syntax_la_SOURCES = libwebdsl-syntax.c
#libwebdsl_syntax_la_CFLAGS   = $(AM_CFLAGS)
#libwebdsl_syntax_la_LDFLAGS  = -avoid-version -no-undefined $(AM_LDFLAGS)
#libwebdsl_syntax_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
#libwebdsl_syntax_la_LIBADD   =  $(STRATEGO_XTC_UNINSTALLED_LIBS) $(STRATEGO_GPP_UNINSTALLED_LIBS) $(STRATEGO_UNINSTALLED_LIBS)
#
#libwebdsl-syntax.rtree libwebdsl-syntax.c : $(webdslsyntaxlib:.str=.rtree) $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) libwebdsl-utils.rtree
#	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/syntax/webdsl-syntax.str -o libwebdsl-syntax.rtree \
#		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)
#	rm libwebdsl-syntax.str

######## libwebdsl-front

EXTRA_DIST += $(webdslfrontlib) $(webdslfrontlib:.str=.rtree) libwebdsl-front.rtree
BOOTCLEANFILES += libwebdsl-front.rtree libwebdsl-front.c $(webdslfrontlib:.str=.rtree)

webdslfrontlib = org/webdsl/dsl/syntax/webdsl-front.str \
		 $(wildcard org/webdsl/dsl/syntax/*.str) \
		 $(wildcard org/webdsl/dsl/utils/*.str)

libwebdsl_front_la_SOURCES = libwebdsl-front.c
libwebdsl_front_la_CFLAGS   = $(AM_CFLAGS)
libwebdsl_front_la_LDFLAGS  = -avoid-version -no-undefined $(AM_LDFLAGS)
libwebdsl_front_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
libwebdsl_front_la_LIBADD   =  $(STRATEGO_XTC_UNINSTALLED_LIBS) $(STRATEGO_GPP_UNINSTALLED_LIBS) $(STRATEGO_UNINSTALLED_LIBS)

libwebdsl-front.rtree libwebdsl-front.c : $(webdslfrontlib:.str=.rtree) $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS)
	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/syntax/webdsl-front.str -o libwebdsl-front.rtree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)
	rm libwebdsl-front.str

######## libwebdsl-to-seam

#EXTRA_DIST += $(webdsltoseamlib) $(webdsltoseamlib:.str=.rtree) libwebdsl-to-seam.rtree
#BOOTCLEANFILES += libwebdsl-to-seam.rtree libwebdsl-to-seam.c $(webdsltoseamlib:.str=.rtree)
#
#webdsltoseamlib = org/webdsl/dsl/generation/dsl-to-seam.str \
#		  $(wildcard org/webdsl/dsl/to-seam/*.str) \
#		  $(wildcard org/webdsl/dsl/builtins/*.str) \
#		  $(wildcard org/webdsl/dsl/modules/*.str) \
#		  $(wildcard org/webdsl/dsl/to-seam/*.str) \
#		  $(wildcard org/webdsl/dsl/transformation/*.str)
#
#libwebdsl_to_seam_la_SOURCES = libwebdsl-to-seam.c
#libwebdsl_to_seam_la_CFLAGS   = $(AM_CFLAGS)
#libwebdsl_to_seam_la_LDFLAGS  = -avoid-version -no-undefined $(AM_LDFLAGS)
#libwebdsl_to_seam_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
#libwebdsl_to_seam_la_LIBADD   =  $(STRATEGO_XTC_UNINSTALLED_LIBS) $(STRATEGO_GPP_UNINSTALLED_LIBS) $(STRATEGO_UNINSTALLED_LIBS)
#
#libwebdsl-to-seam.rtree libwebdsl-to-seam.c : $(webdsltoseamlib:.str=.rtree) libwebdsl-front.rtree
#	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/generation/dsl-to-seam.str -o libwebdsl-to-seam.rtree \
#		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)
#	rm libwebdsl-to-seam.str
