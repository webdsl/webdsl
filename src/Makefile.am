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
    $(STRFILES:.str=.rtree)

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
	-I $(GPP)/share/sdf/xml-front \
    -I $(GPP)/share/xml-front \
	-I org/webdsl/dsl/syntax

#	--verbose 2

# UNDONE: $(JAVA_FRONT_STRCFLAGS) --verbose 1

SDFINCLUDES = $(STRINCLUDES)

STRCFLAGS = \
	-la stratego-xtc \
	-la stratego-lib \
	-la stratego-gpp \
	-la stratego-tool-doc \
	-la stratego-sglr \
	-la $(JAVA_FRONT_LIBS) \
	--format-check 0 -O 1 \
	--verbose 3

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

webdslc_SOURCES = webdslc.c
webdslc_CFLAGS   = $(AM_CFLAGS) -O0
webdslc_LDFLAGS  = $(AM_LDFLAGS)
webdslc_CPPFLAGS = $(STRATEGO_XTC_CFLAGS) \
                   $(STRATEGO_GPP_CFLAGS) \
                   $(STRATEGO_SGLR_CFLAGS) \
                   $(STRATEGO_TOOL_DOC_CFLAGS) \
                   $(STRATEGO_CFLAGS) \
                   $(JAVA_FRONT_CFLAGS) 
webdslc_LDADD   = $(LDADD) $(STRATEGO_XTC_LIBS) \
                   $(STRATEGO_GPP_LIBS) \
                   $(STRATEGO_SGLR_LIBS) \
                   $(STRATEGO_TOOL_DOC_LIBS) \
                   $(STRATEGO_LIBS) \
                   $(JAVA_FRONT_LIBS) \
                   libwebdsl-front.la libwebdsl-generator.la libto-java-servlet.la libto-py-gae.la libwrite-files.la libjava-pp.la libjava-transformations.la

#webdslc_LDADD = $(LDADD) $(JAVA_FRONT_LIBS) $(STRATEGO_GPP_LIBS) $(STRATEGO_SGLR_LIBS) $(STRATEGO_TOOL_DOC_LIBS) \
#                    libwebdsl-front.la libwebdsl-generator.la libto-java-servlet.la libto-py-gae.la libwrite-files.la libjava-pp.la libjava-transformations.la

webdslc.c : libwebdsl-front.la libwebdsl-generator.la libto-java-servlet.la libto-py-gae.la libwrite-files.la webdslc.str libjava-transformations.la

ctrees : webdsl-front.ctree webdsl-generator.ctree to-java-servlet.ctree to-py-gae.ctree write-files.ctree java-transformations.ctree

STRJ=`if which strj >/dev/null; then echo strj; else echo java -server -Xss4m -Xmx1024m -XX:+UseParallelGC -jar strategoxt.jar; fi`
STRJFLAGS=-O 3 --verbose 3 -la stratego-lib -la stratego-rtg -la stratego-sglr -la stratego-gpp -la stratego-xtc -la stratego-tool-doc -la org.strategoxt.libjava-front -I $(JAVA_FRONT)/share
JAVAC=`if which ecj >/dev/null; then echo ecj; else echo javac; fi` -J-Xmx256m -J-Xms100m -J-server -J-XX:+UseParallelGC -source 5  -nowarn
JAR=`if which fastjar >/dev/null; then echo fastjar; else echo jar; fi`

JAVAS= \
  bin/org/webdsl/webdsl_front/Main.java \
  bin/org/webdsl/webdsl_generator/Main.java \
  bin/org/webdsl/java_transformations/Main.java \
  bin/org/webdsl/java_pp_fake/Main.java \
  bin/org/webdsl/write_files/Main.java \
  bin/org/webdsl/to_java_servlet/Main.java \
  bin/org/webdsl/to_py_gae/Main.java \
  bin/org/webdsl/webdslc/Main.java

java : strategoxt.jar $(JAVAS)

class : strategoxt.jar $(JAVAS)
	$(JAVAC) -cp strategoxt.jar:bin:. bin/org/webdsl/webdslc/Main.java

jar : webdsl.jar

strategoxt.jar :
	wget -N -nv http://www.st.ewi.tudelft.nl/~kats/strategoxt/18a/strategoxt.jar

webdsl.jar : class
	$(JAR) cfm webdsl.jar META-INF/MANIFEST.MF -C bin/ . # `find bin | grep -Ev '\.java|\.svn' | sed 's!bin/!-C bin/ !'`

bin/org/webdsl/webdsl_front/Main.java : webdsl-front.ctree
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.webdsl_front -i $< -o $@ 

bin/org/webdsl/webdsl_generator/Main.java : webdsl-generator.ctree
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.webdsl_generator -i $< -o $@ -la org.webdsl.webdsl-front

bin/org/webdsl/java_transformations/Main.java : java-transformations.ctree
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.java_transformations -i $< -o $@ -la org.webdsl.webdsl-generator -la org.webdsl.to-java-servlet -la org.webdsl.webdsl-front

bin/org/webdsl/write_files/Main.java : write-files.ctree
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.write_files -i write-files.ctree -o $@ -la org.webdsl.webdsl-front -la org.webdsl.java_pp_fake

bin/org/webdsl/to_java_servlet/Main.java : to-java-servlet.ctree
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.to_java_servlet -i $< -o $@ -la org.webdsl.webdsl-front -la org.webdsl.webdsl-generator

bin/org/webdsl/to_py_gae/Main.java : to-py-gae.ctree
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.to_py_gae -i $< -o $@ -la org.webdsl.webdsl-front -la org.webdsl.webdsl-generator

bin/org/webdsl/java_pp_fake/Main.java : java-pp-fake.str
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.java_pp_fake -i $< -o $@

bin/org/webdsl/webdslc/Main.java : webdslc.str
	$(STRJ) $(STRJFLAGS) -m webdslc-main -i $< -o $@ -p org.webdsl.webdslc -la org.webdsl.webdsl-generator -la org.webdsl.to-java-servlet -la org.webdsl.webdsl-front -la org.webdsl.java-transformations -la org.webdsl.to-py-gae -la org.webdsl.write-files

### libraries

nobase_data_DATA = libwebdsl-front.rtree 
lib_LTLIBRARIES  = libwebdsl-front.la 

libwebdsl_front_la_SOURCES = libwebdsl-front.c
libwebdsl_front_la_CFLAGS   = $(AM_CFLAGS) -O0
libwebdsl_front_la_LDFLAGS  = $(AM_LDFLAGS)
libwebdsl_front_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS) \
                              $(STRATEGO_GPP_CFLAGS) \
                              $(STRATEGO_SGLR_CFLAGS) \
                              $(STRATEGO_TOOL_DOC_CFLAGS) \
                              $(STRATEGO_CFLAGS)
libwebdsl_front_la_LIBADD   = $(STRATEGO_XTC_LIBS) \
			      $(STRATEGO_GPP_LIBS) \
			      $(STRATEGO_SGLR_LIBS) \
                              $(STRATEGO_TOOL_DOC_LIBS) \
			      $(STRATEGO_LIBS)

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
libwebdsl_generator_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS) \
                              $(STRATEGO_GPP_CFLAGS) \
                              $(JAVA_FRONT_CFLAGS) \
                              $(STRATEGO_CFLAGS)
libwebdsl_generator_la_LIBADD   = $(STRATEGO_XTC_LIBS) \
			      $(STRATEGO_GPP_LIBS) \
                              $(JAVA_FRONT_LIBS) \
			      $(STRATEGO_LIBS)

libwebdsl-generator.rtree libwebdsl-generator.c : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(GENSTRFILES:.str=.rtree) libwebdsl-front.la
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
libjava_transformations_la_LIBADD   = $(STRATEGO_XTC_LIBS) \
			      $(STRATEGO_GPP_LIBS) \
			      $(STRATEGO_LIBS)

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
libto_java_servlet_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)\
                              $(STRATEGO_GPP_CFLAGS) \
                              $(JAVA_FRONT_CFLAGS) \
                              $(STRATEGO_CFLAGS)
libto_java_servlet_la_LIBADD   = $(STRATEGO_XTC_LIBS) \
			      $(STRATEGO_GPP_LIBS) \
                              $(JAVA_FRONT_LIBS) \
			      $(STRATEGO_LIBS)

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
libto_py_gae_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS) \
                              $(STRATEGO_GPP_CFLAGS) \
                              $(STRATEGO_CFLAGS)
libto_py_gae_la_LIBADD   = $(STRATEGO_XTC_LIBS) \
			      $(STRATEGO_GPP_LIBS) \
			      $(STRATEGO_LIBS)

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

### rtg

Java-EBlock.rtg.af : $(JAVA_FRONT)/share/java-front/Java-EBlock.rtg
	parse-rtg -i $< -o $@

xml-doc.rtg.af : $(GPP)/share/xml-front/xml-doc.rtg
	parse-rtg -i $< -o $@

### write files

nobase_data_DATA += libwrite-files.rtree 
lib_LTLIBRARIES  += libwrite-files.la 

libwrite_files_la_SOURCES = libwrite-files.c
libwrite_files_la_CFLAGS   = $(AM_CFLAGS) -O0
libwrite_files_la_LDFLAGS  = $(AM_LDFLAGS)
libwrite_files_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS) \
                              $(STRATEGO_GPP_CFLAGS) \
                              $(JAVA_FRONT_CFLAGS) \
                              $(STRATEGO_CFLAGS)
libwrite_files_la_LIBADD   = $(STRATEGO_XTC_LIBS) \
			      $(STRATEGO_GPP_LIBS) \
                              $(JAVA_FRONT_LIBS) \
			      $(STRATEGO_LIBS)

libwrite-files.rtree libwrite-files.c : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(PYTHONSTRFILES:.str=.rtree) libwebdsl-front.la libjava-pp.la Java-EBlock.rtg.af xml-doc.rtg.af
	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/write-files/write-files.str -o libwrite-files.rtree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)
	rm libwrite-files.str

write-files.ctree : libwrite-files.rtree
	strc $(STRINCLUDES) -c --library -O 1 -F -i $(srcdir)/org/webdsl/dsl/write-files/write-files.str -o write-files.ctree \
		--verbose 1 $(STRCFLAGS) $(SCLIMITWARNS)

