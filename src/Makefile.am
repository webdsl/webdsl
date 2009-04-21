include $(top_srcdir)/Makefile.xt
include $(wildcard *.dep)
include $(wildcard org/webdsl/dsl/*/*.dep)

### distribution

# HACK: This project is almost unbuildable with -O2, the default in many configurations
CFLAGS=-O0

CLEANFILES = \
    rtrees \
    $(wildcard lib*.c) \
    $(wildcard *.dep) \
    $(wildcard *.rtree) \
    $(wildcard *.ctree) \
    $(wildcard org/webdsl/dsl/*/*.c) \
    $(wildcard org/webdsl/dsl/*/*.o) \
    $(wildcard org/webdsl/dsl/*/*.dep) \
    $(wildcard org/webdsl/dsl/*/*.rtree) \
    $(wildcard org/webdsl/dsl/*/*/*.rtree)

FULLCLEANFILES = \
    $(wildcard org/webdsl/dsl/*/*.def) \
    $(wildcard org/webdsl/dsl/*/*.pp.af) \
    $(wildcard org/webdsl/dsl/*/*.rtg) \
	$(wildcard org/webdsl/dsl/*/*.tbl)

# "make clean" leaves syntax intact; use fullclean/distclean

distclean : fullclean

cleaner : fullclean # alias

fullclean :
	$(MAKE) clean
	rm -rf $(FULLCLEANFILES)

EXTRA_DIST = \
    $(wildcard *.str) \
    $(wildcard org/webdsl/dsl/*/*.dep) \
    $(wildcard org/webdsl/dsl/*/*.meta) \
    $(wildcard org/webdsl/dsl/*/*.str) \
    $(wildcard org/webdsl/dsl/*/*.sdf) \
    $(wildcard org/webdsl/dsl/*/*.pp) \
    $(wildcard org/webdsl/dsl/*/*/*.str) \
    $(wildcard org/webdsl/dsl/*/*/*.meta) \
    $(wildcard org/webdsl/dsl/*/*/*/*.str) \
    $(wildcard org/webdsl/dsl/*/*/*/*.meta)

### syntax definitions

syntax 		= org/webdsl/dsl/syntax/WebDSL
hql 		= org/webdsl/dsl/syntax/HQL
mixhql 		= org/webdsl/dsl/syntax/MixHQL
css 		= org/webdsl/dsl/syntax/CSS
python 		= org/webdsl/dsl/syntax/Python
mixpython 	= org/webdsl/dsl/syntax/MixPython
mixcss 		= org/webdsl/dsl/syntax/StrategoCSS
metasyntax 	= org/webdsl/dsl/syntax/StrategoWebDSL
mixmetasyntax 	= org/webdsl/dsl/syntax/Stratego-WebDSL-Java-XML
mixmetapysyntax 	= org/webdsl/dsl/syntax/Stratego-WebDSL-Python

SYNTAXDEFS = $(syntax).def					  \
	     $(mixcss).def $(metasyntax).def $(mixmetapysyntax).def $(mixmetasyntax).def \
	     $(hql).def $(python).def $(css).def  # used for mixing		  

TBLS   = $(syntax).tbl $(metasyntax).tbl $(mixmetasyntax).tbl $(mixmetapysyntax).tbl $(mixpython).tbl $(mixcss).tbl 

SIGS   = $(hql).rtg $(hql).str $(css).rtg $(python).str $(css).str $(syntax).rtg $(syntax).str

PPTBLS = $(hql)-pretty.pp.af $(python)-pretty.pp.af $(css)-pretty.pp.af $(syntax)-pretty.pp.af

syntax : $(TBLS)

sdfdata_DATA = $(SYNTAXDEFS) $(TBLS) $(SIGS) $(PPTBLS)

PGEN_FLAGS = -m `basename $*`

PPTABLES = \
	$(syntax)-pretty.pp.af \
	$(syntax).tbl \
	$(hql)-pretty.pp.af \
	$(css).tbl \
	$(python).tbl \
	$(css)-pretty.pp.af \
	$(python)-pretty.pp.af

org/webdsl/dsl/syntax/WebDSL.def: $(wildcard org/webdsl/dsl/syntax/*.sdf) \
                                  org/webdsl/dsl/syntax/MixHQL.sdf \
                                  org/webdsl/dsl/syntax/MixPython.sdf

# .str dependencies

PYTHONSTRFILES = $(wildcard ./org/webdsl/dsl/to-py-gae/*.str) \
                 $(wildcard ./org/webdsl/dsl/to-py-gae/*/*.str)
                 
FRONTSTRFILES =  $(wildcard ./org/webdsl/dsl/syntax/*.str) \
                 $(wildcard ./org/webdsl/dsl/utils/*.str)
                 
JAVASTRFILES =   $(wildcard ./org/webdsl/dsl/to-java-servlet/*.str) \
                 $(wildcard ./org/webdsl/dsl/to-java-servlet/*/*.str)
            
GENSTRFILES =    $(wildcard ./org/webdsl/dsl/analysis/*.str) \
                 $(wildcard ./org/webdsl/dsl/generation/*.str) \
                 $(wildcard ./org/webdsl/dsl/modules/*.str) \
                 $(wildcard ./org/webdsl/dsl/modules/*/*.str) \
                 $(wildcard ./org/webdsl/dsl/modules/*/*/*.str) \
                 $(wildcard ./org/webdsl/dsl/transformation/*.str) \
                 $(wildcard ./org/webdsl/dsl/typechecker/*.str) 
                    
### pre-parsing Stratego modules

STRFILES = ./webdslc.str \
           $(wildcard ./org/webdsl/dsl/*/*.str) \
           $(wildcard ./org/webdsl/dsl/*/*/*.str) \
           $(wildcard ./org/webdsl/dsl/*/*/*/*.str)

# bogus dependency to force pre-parsing of .str files
rtrees : $(STRFILES:.str=.rtree) 
	touch rtrees

STRINCLUDES = \
	-I . \
	-I $(JAVA_FRONT)/share/java-front \
	-I $(JAVA_FRONT)/share/java-front/languages/java/eblock \
	-I $(JAVA_FRONT)/share/java-front-syntax \
	-I $(GPP)/share/sdf/gpp \
	-I $(XML_FRONT)/share/sdf/xml-front \
	-I org/webdsl/dsl/syntax \
	--verbose 2

# UNDONE: $(JAVA_FRONT_STRCFLAGS) --verbose 1

SDFINCLUDES = $(STRINCLUDES)

STRCFLAGS = \
	-la stratego-xtc \
	-la stratego-lib \
	-la stratego-gpp \
	-la stratego-tool-doc \
	-la stratego-sglr \
	-la $(JAVA_FRONT_LIBS) \
	--format-check 0 -O 1

XTC_IMPORT = $(JAVA_FRONT_XTC)

# Disable some of the bogus warnings:
# - multiple external references are the unfortunate effect of librarification and is out of our control right now
# - nullary constructor warnings are not interesting unless they're lowercase imho, like 'top'
#   specifically, you don't want warnings for nullary constructor builds, especially for overlays (e.g., |[ e_UTILS.isInstance(...) ]|)
#
SCLIMITWARNS = 2>&1 | grep -vE 'warning ] Nullary constructor .*[A-Z]|warning ] multiple external| \[ExtSDef\("' \
               >&2

SDF2RTG_FLAGS = --main `basename $*` --ignore-missing-cons

Mix%.sdf : %.def
	gen-sdf-mix -i $< --main `basename $*` --name Mix`basename $*` -o $@

SCFLAGS = --main $*-main	

bin_PROGRAMS = webdslc

webdslc_LDADD = $(LDADD) $(JAVA_FRONT_LIBS) $(STRATEGO_GPP_LIBS) $(STRATEGO_SGLR_LIBS) $(STRATEGO_TOOL_DOC_LIBS) \
                    libwebdsl-front.la libwebdsl-generator.la libto-java-servlet.la libto-py-gae.la libwrite-files.la libjava-pp.la libjava-transformations.la

webdslc.c : libwebdsl-front.la libwebdsl-generator.la libto-java-servlet.la libto-py-gae.la libwrite-files.la webdslc.str

ctrees : webdsl-front.ctree webdsl-generator.ctree to-java-servlet.ctree to-py-gae.ctree

### libraries

nobase_data_DATA = libwebdsl-front.rtree 
lib_LTLIBRARIES  = libwebdsl-front.la 

libwebdsl_front_la_SOURCES = libwebdsl-front.c
libwebdsl_front_la_CFLAGS   = $(AM_CFLAGS) -O0
libwebdsl_front_la_LDFLAGS  = $(AM_LDFLAGS)
libwebdsl_front_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
libwebdsl_front_la_LIBADD   = $(STRATEGO_XTC_UNINSTALLED_LIBS) \
			      $(STRATEGO_GPP_UNINSTALLED_LIBS) \
			      $(STRATEGO_UNINSTALLED_LIBS)

libwebdsl-front.rtree libwebdsl-front.c : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(FRONTSTRFILES:.str=.rtree)
	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/syntax/webdsl-front.str -o libwebdsl-front.rtree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)
	rm libwebdsl-front.str

webdsl-front.ctree : libwebdsl-front.rtree
	strc $(STRINCLUDES) -c --library -O 1 -F -i $(srcdir)/org/webdsl/dsl/syntax/webdsl-front.str -o webdsl-front.ctree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)

## generator

nobase_data_DATA += libwebdsl-generator.rtree 
lib_LTLIBRARIES  += libwebdsl-generator.la 

libwebdsl_generator_la_SOURCES = libwebdsl-generator.c
libwebdsl_generator_la_CFLAGS   = $(AM_CFLAGS) -O0
libwebdsl_generator_la_LDFLAGS  = $(AM_LDFLAGS)
libwebdsl_generator_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
libwebdsl_generator_la_LIBADD   = $(STRATEGO_XTC_UNINSTALLED_LIBS) \
			      $(STRATEGO_GPP_UNINSTALLED_LIBS) \
			      $(STRATEGO_UNINSTALLED_LIBS)

libwebdsl-generator.rtree libwebdsl-generator.c : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(GENERATORSTRFILES:.str=.rtree) libwebdsl-front.la
	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/generation/webdsl-generator.str -o libwebdsl-generator.rtree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)
	rm libwebdsl-generator.str
	
webdsl-generator.ctree : libwebdsl-generator.rtree  
	strc $(STRINCLUDES) -c --library -O 1 -F -i $(srcdir)/org/webdsl/dsl/generation/webdsl-generator.str -o webdsl-generator.ctree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)

### java transformations

nobase_data_DATA += libjava-transformations.rtree 
lib_LTLIBRARIES  += libjava-transformations.la 

libjava_transformations_la_SOURCES = libjava-transformations.c
libjava_transformations_la_CFLAGS   = $(AM_CFLAGS) -O0
libjava_transformations_la_LDFLAGS  = $(AM_LDFLAGS)
libjava_transformations_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
libjava_transformations_la_LIBADD   = $(STRATEGO_XTC_UNINSTALLED_LIBS) \
			      $(STRATEGO_GPP_UNINSTALLED_LIBS) \
			      $(STRATEGO_UNINSTALLED_LIBS)

libjava-transformations.rtree libjava-transformations.c : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(JAVASTRFILES:.str=.rtree) libwebdsl-generator.la libto-java-servlet.la libwebdsl-front.la
	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/java-transformations/java-transformations.str -o libjava-transformations.rtree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)
	rm libjava-transformations.str

java-transformations.ctree : libjava-transformations.rtree
	strc $(STRINCLUDES) -c --library -O 1 -F -i $(srcdir)/org/webdsl/dsl/java-transformations/java-transformations.str -o java-transformations.ctree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)

### java servlet back-end

nobase_data_DATA += libto-java-servlet.rtree 
lib_LTLIBRARIES  += libto-java-servlet.la 

libto_java_servlet_la_SOURCES = libto-java-servlet.c
libto_java_servlet_la_CFLAGS   = $(AM_CFLAGS) -O0
libto_java_servlet_la_LDFLAGS  = $(AM_LDFLAGS)
libto_java_servlet_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
libto_java_servlet_la_LIBADD   = $(STRATEGO_XTC_UNINSTALLED_LIBS) \
			      $(STRATEGO_GPP_UNINSTALLED_LIBS) \
			      $(STRATEGO_UNINSTALLED_LIBS)

libto-java-servlet.rtree libto-java-servlet.c : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(JAVASTRFILES:.str=.rtree) libwebdsl-front.la libwebdsl-generator.la
	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/to-java-servlet/to-java-servlet.str -o libto-java-servlet.rtree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)
	rm libto-java-servlet.str

to-java-servlet.ctree : libto-java-servlet.rtree
	strc $(STRINCLUDES) -c --library -O 1 -F -i $(srcdir)/org/webdsl/dsl/to-java-servlet/to-java-servlet.str -o to-java-servlet.ctree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)

### python gae back-end

nobase_data_DATA += libto-py-gae.rtree 
lib_LTLIBRARIES  += libto-py-gae.la 

libto_py_gae_la_SOURCES = libto-py-gae.c
libto_py_gae_la_CFLAGS   = $(AM_CFLAGS) -O0
libto_py_gae_la_LDFLAGS  = $(AM_LDFLAGS)
libto_py_gae_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
libto_py_gae_la_LIBADD   = $(STRATEGO_XTC_UNINSTALLED_LIBS) \
			      $(STRATEGO_GPP_UNINSTALLED_LIBS) \
			      $(STRATEGO_UNINSTALLED_LIBS)

libto-py-gae.rtree libto-py-gae.c : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(PYTHONSTRFILES:.str=.rtree) libwebdsl-front.la libwebdsl-generator.la
	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/to-py-gae/to-py-gae.str -o libto-py-gae.rtree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)
	rm libto-py-gae.str

to-py-gae.ctree : libto-py-gae.rtree
	strc $(STRINCLUDES) -c --library -O 1 -F -i $(srcdir)/org/webdsl/dsl/to-py-gae/to-py-gae.str -o to-py-gae.ctree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)
		
## fast pretty-printer

lib_LTLIBRARIES  += libjava-pp.la 
		
libjava_pp_la_SOURCES = java-pp.c
libjava_pp_la_LIBADD  = $(STRATEGO_XTC_LIBS)   $(STRATEGO_LIB_LIBS)   $(STRATEGO_RUNTIME_LIBS)   $(ATERM_LIBS)
libjava_pp_la_CFLAGS  = $(STRATEGO_XTC_CFLAGS) $(STRATEGO_LIB_CFLAGS) $(STRATEGO_RUNTIME_CFLAGS) $(ATERM_CFLAGS) $(AM_CFLAGS)
libjava_pp_la_LDFLAGS = -avoid-version -no-undefined $(AM_LDFLAGS)

### write files

nobase_data_DATA += libwrite-files.rtree 
lib_LTLIBRARIES  += libwrite-files.la 

libwrite_files_la_SOURCES = libwrite-files.c
libwrite_files_la_CFLAGS   = $(AM_CFLAGS) -O0
libwrite_files_la_LDFLAGS  = $(AM_LDFLAGS)
libwrite_files_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
libwrite_files_la_LIBADD   = $(STRATEGO_XTC_UNINSTALLED_LIBS) \
			      $(STRATEGO_GPP_UNINSTALLED_LIBS) \
			      $(STRATEGO_UNINSTALLED_LIBS)

libwrite-files.rtree libwrite-files.c : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(PYTHONSTRFILES:.str=.rtree) libwebdsl-front.la libjava-pp.la
	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/write-files/write-files.str -o libwrite-files.rtree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)
	rm libwrite-files.str

write-files.ctree : libwrite-files.rtree
	strc $(STRINCLUDES) -c --library -O 1 -F -i $(srcdir)/org/webdsl/dsl/write-files/write-files.str -o write-files.ctree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)

