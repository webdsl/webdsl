include $(top_srcdir)/Makefile.xt
include $(wildcard *.dep)
include $(wildcard org/webdsl/dsl/*/*.dep)

### distribution

# HACK: This project is almost unbuildable with -O2, the default in many configurations
CFLAGS += -O0

CLEANFILES = \
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
    $(wildcard org/webdsl/dsl/*/*/*/*.meta) \
    META-INF/MANIFEST.MF

### syntax definitions

syntax 		= org/webdsl/dsl/syntax/WebDSL
hql 		= org/webdsl/dsl/syntax/HQL
mixhql 		= org/webdsl/dsl/syntax/MixHQL
css 		= org/webdsl/dsl/syntax/CSS
mixcss 		= org/webdsl/dsl/syntax/StrategoCSS
metasyntax 	= org/webdsl/dsl/syntax/StrategoWebDSL
mixmetasyntax 	= org/webdsl/dsl/syntax/Stratego-WebDSL-Java-XML

SYNTAXDEFS = $(syntax).def					  \
	     $(mixcss).def $(metasyntax).def $(mixmetasyntax).def \
	     $(hql).def $(css).def  # used for mixing		  

TBLS   = $(syntax).tbl $(metasyntax).tbl $(mixmetasyntax).tbl $(mixcss).tbl 

SIGS   = $(hql).rtg $(hql).str $(css).rtg $(css).str $(syntax).rtg $(syntax).str

PPTBLS = $(hql)-pretty.pp.af $(css)-pretty.pp.af $(syntax)-pretty.pp.af

syntax : $(TBLS)

sdfdata_DATA = $(SYNTAXDEFS) $(TBLS) $(SIGS) $(PPTBLS)

PGEN_FLAGS = -m `basename $*`

PPTABLES = \
	$(syntax)-pretty.pp.af \
	$(syntax).tbl \
	$(hql)-pretty.pp.af \
	$(css).tbl \
	$(css)-pretty.pp.af

org/webdsl/dsl/syntax/WebDSL.def: $(wildcard org/webdsl/dsl/syntax/*.sdf) \
                                  org/webdsl/dsl/syntax/MixHQL.sdf

# .str dependencies
                 
FRONTSTRFILES =  $(wildcard ./org/webdsl/dsl/syntax/*.str) \
                 $(wildcard ./org/webdsl/dsl/utils/*.str)
                 
JAVASTRFILES =   $(wildcard ./org/webdsl/dsl/to-java-servlet/*.str) \
                 $(wildcard ./org/webdsl/dsl/to-java-servlet/*/*.str)
            
GENSTRFILES =    $(wildcard ./org/webdsl/dsl/analysis/*.str) \
                 $(wildcard ./org/webdsl/dsl/generation/*.str) \
                 $(wildcard ./org/webdsl/dsl/languages/*.str) \
                 $(wildcard ./org/webdsl/dsl/languages/*/*.str) \
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
	-la stratego-aterm \
	-la stratego-tool-doc \
	-la stratego-sglr \
	-la $(JAVA_FRONT_LIBS) \
	--format-check 0 -O 1 \
	--verbose 3

XTC_IMPORT = $(JAVA_FRONT_XTC)

SDF2RTG_FLAGS = --main `basename $*` --ignore-missing-cons

Mix%.sdf : %.def
	gen-sdf-mix -i $< --main `basename $*` --name Mix`basename $*` -o $@

SCFLAGS = --main $*-main	

if XT_ENABLE_JAVA_BACKEND
  bin_PROGRAMS = webdsl.jar
  webdsl_jar_SOURCES = 
else
  bin_PROGRAMS = webdslc

webdslc_SOURCES = webdslc.c
webdslc_CFLAGS   = $(AM_CFLAGS) -O0  $(STRATEGO_LIB_CFLAGS)
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
                   libwebdsl-front.la libwebdsl-generator.la libto-java-servlet.la libwrite-files.la libjava-pp.la libjava-transformations.la

webdslc.c : libwebdsl-front.la libwebdsl-generator.la libto-java-servlet.la libwrite-files.la webdslc.str libjava-transformations.la

endif


ctrees : webdsl-front.ctree webdsl-generator.ctree to-java-servlet.ctree write-files.ctree java-transformations.ctree


if XT_ENABLE_JAVA_BACKEND

STRATEGOXT_JAR=$(STRC_JAVA)/share/strc-java/strategoxt.jar
STRJ=$(STRC_JAVA)/bin/strj
STRJFLAGS=-O 3 --verbose 3 -la stratego-lib -la stratego-rtg -la stratego-sglr -la stratego-gpp -la stratego-xtc -la stratego-aterm -la stratego-tool-doc -la java-front -I $(JAVA_FRONT)/share -clean -I org/webdsl/dsl/syntax/
JAVAC=`if which ecj >/dev/null; then echo ecj; else echo javac; fi` -J-Xmx512m -J-Xms100m -J-server -J-XX:+UseParallelGC -source 5 -target 5 -nowarn
JAR=`if which fastjar >/dev/null; then echo fastjar; else echo jar; fi`

JAVAS= \
  src-gen/org/webdsl/webdsl_front/Main.java \
  src-gen/org/webdsl/webdsl_generator/Main.java \
  src-gen/org/webdsl/java_transformations/Main.java \
  src-gen/org/webdsl/java_pp_fake/Main.java \
  src-gen/org/webdsl/write_files/Main.java \
  src-gen/org/webdsl/to_java_servlet/Main.java \
  src-gen/org/webdsl/webdslc/Main.java

mkdirs :
	mkdir -p src-gen/org/webdsl/webdsl_front
	mkdir -p src-gen/org/webdsl/webdsl_generator
	mkdir -p src-gen/org/webdsl/java_transformations
	mkdir -p src-gen/org/webdsl/java_pp_fake
	mkdir -p src-gen/org/webdsl/write_files
	mkdir -p src-gen/org/webdsl/to_java_servlet
	mkdir -p src-gen/org/webdsl/webdslc


class : $(JAVAS)
	$(JAVAC) -cp $(STRATEGOXT_JAR):src-gen:. src-gen/org/webdsl/webdslc/Main.java -d bin

webdsl.jar : class
	$(JAR) cfm webdsl.jar META-INF/MANIFEST.MF -C bin/ .  `find src-gen -type f | grep -E '(\.tbl|\.af)' | sed 's!src-gen/!-C src-gen/ !'`

src-gen/org/webdsl/webdsl_front/Main.java : webdsl-front.ctree mkdirs
	@if ! which ecj >/dev/null; then \
	  echo "WARNING: ecj is not installed; using the (much) slower javac compiler instead" >&2; \
	fi
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.webdsl_front -i $< -o $@ 

src-gen/org/webdsl/webdsl_generator/Main.java : webdsl-generator.ctree
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.webdsl_generator -i $< -o $@ -la org.webdsl.webdsl-front

src-gen/org/webdsl/java_transformations/Main.java : java-transformations.ctree
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.java_transformations -i $< -o $@ -la org.webdsl.webdsl-generator -la org.webdsl.to-java-servlet -la org.webdsl.webdsl-front

src-gen/org/webdsl/write_files/Main.java : write-files.ctree
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.write_files -i write-files.ctree -o $@ -la org.webdsl.webdsl-front -la org.webdsl.java_pp_fake

src-gen/org/webdsl/to_java_servlet/Main.java : to-java-servlet.ctree
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.to_java_servlet -i $< -o $@ -la org.webdsl.webdsl-front -la org.webdsl.webdsl-generator

src-gen/org/webdsl/java_pp_fake/Main.java : java-pp-fake.str
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.java_pp_fake -i $< -o $@

src-gen/org/webdsl/webdslc/Main.java : webdslc.str
	$(STRJ) $(STRJFLAGS) -m webdslc-main -i $< -o $@ -p org.webdsl.webdslc -la org.webdsl.webdsl-generator -la org.webdsl.to-java-servlet -la org.webdsl.webdsl-front -la org.webdsl.java-transformations -la org.webdsl.write-files
endif

### libraries

nobase_data_DATA = libwebdsl-front.rtree 
if !XT_ENABLE_JAVA_BACKEND
  lib_LTLIBRARIES  = libwebdsl-front.la 

libwebdsl_front_la_SOURCES = libwebdsl-front.c
libwebdsl_front_la_CFLAGS   = $(AM_CFLAGS) -O0 $(STRATEGO_LIB_CFLAGS)
libwebdsl_front_la_LDFLAGS  = $(AM_LDFLAGS)
libwebdsl_front_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS) \
                              $(STRATEGO_GPP_CFLAGS) \
                              $(STRATEGO_SGLR_CFLAGS) \
                              $(STRATEGO_ATERM_CFLAGS) \
                              $(STRATEGO_TOOL_DOC_CFLAGS) \
                              $(STRATEGO_CFLAGS)
libwebdsl_front_la_LIBADD   = $(STRATEGO_XTC_LIBS) \
			                  $(STRATEGO_GPP_LIBS) \
			                  $(STRATEGO_SGLR_LIBS) \
			                  $(STRATEGO_ATERM_LIBS) \
                              $(STRATEGO_TOOL_DOC_LIBS) \
			                  $(STRATEGO_LIBS)
endif

libwebdsl-front.rtree libwebdsl-front.c : $(TBLS) $(SIGS) $(PPTABLES) $(PPTBLS) $(SYNTAXDEFS) $(FRONTSTRFILES:.str=.rtree)
	$(STRC)/bin/strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/syntax/webdsl-front.str -o libwebdsl-front.rtree \
		--verbose 1 $(STRCFLAGS) 
	rm libwebdsl-front.str

webdsl-front.ctree : libwebdsl-front.rtree
	$(STRC)/bin/strc $(STRINCLUDES) -c --library -O 1 -F -i $(srcdir)/org/webdsl/dsl/syntax/webdsl-front.str -o webdsl-front.ctree \
		--verbose 1 $(STRCFLAGS) 

## generator

nobase_data_DATA += libwebdsl-generator.rtree 
if !XT_ENABLE_JAVA_BACKEND
  lib_LTLIBRARIES  += libwebdsl-generator.la 

libwebdsl_generator_la_SOURCES = libwebdsl-generator.c
libwebdsl_generator_la_CFLAGS   = $(AM_CFLAGS) -O0 $(STRATEGO_LIB_CFLAGS)
libwebdsl_generator_la_LDFLAGS  = $(AM_LDFLAGS)
libwebdsl_generator_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS) \
                              $(STRATEGO_GPP_CFLAGS) \
                              $(JAVA_FRONT_CFLAGS) \
                              $(STRATEGO_CFLAGS)
libwebdsl_generator_la_LIBADD   = $(STRATEGO_XTC_LIBS) \
			      $(STRATEGO_GPP_LIBS) \
                              $(JAVA_FRONT_LIBS) \
			      $(STRATEGO_LIBS)
endif


libwebdsl-generator.rtree libwebdsl-generator.c : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(GENSTRFILES:.str=.rtree) libwebdsl-front.rtree
	strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/generation/webdsl-generator.str -o libwebdsl-generator.rtree \
		--verbose 1 $(STRCFLAGS) 
	rm libwebdsl-generator.str

webdsl-generator.ctree : libwebdsl-generator.rtree  
	strc $(STRINCLUDES) -c --library -O 1 -F -i $(srcdir)/org/webdsl/dsl/generation/webdsl-generator.str -o webdsl-generator.ctree \
		--verbose 1 $(STRCFLAGS) 

### java transformations

nobase_data_DATA += libjava-transformations.rtree 
if !XT_ENABLE_JAVA_BACKEND
  lib_LTLIBRARIES  += libjava-transformations.la 

libjava_transformations_la_SOURCES = libjava-transformations.c
libjava_transformations_la_CFLAGS   = $(AM_CFLAGS) -O0  $(STRATEGO_LIB_CFLAGS)
libjava_transformations_la_LDFLAGS  = $(AM_LDFLAGS)
libjava_transformations_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)
libjava_transformations_la_LIBADD   = $(STRATEGO_XTC_LIBS) \
			      $(STRATEGO_GPP_LIBS) \
			      $(STRATEGO_LIBS)
endif

libjava-transformations.rtree libjava-transformations.c : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(JAVASTRFILES:.str=.rtree) libwebdsl-generator.rtree libto-java-servlet.rtree libwebdsl-front.rtree
	$(STRC)/bin/strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/java-transformations/java-transformations.str -o libjava-transformations.rtree \
		--verbose 1 $(STRCFLAGS)
	rm libjava-transformations.str

java-transformations.ctree : libjava-transformations.rtree
	$(STRC)/bin/strc $(STRINCLUDES) -c --library -O 1 -F -i $(srcdir)/org/webdsl/dsl/java-transformations/java-transformations.str -o java-transformations.ctree \
		--verbose 1 $(STRCFLAGS)

### java servlet back-end

nobase_data_DATA += libto-java-servlet.rtree 
if !XT_ENABLE_JAVA_BACKEND
  lib_LTLIBRARIES  += libto-java-servlet.la 

libto_java_servlet_la_SOURCES = libto-java-servlet.c
libto_java_servlet_la_CFLAGS   = $(AM_CFLAGS) -O0  $(STRATEGO_LIB_CFLAGS)
libto_java_servlet_la_LDFLAGS  = $(AM_LDFLAGS)
libto_java_servlet_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS)\
                              $(STRATEGO_GPP_CFLAGS) \
                              $(JAVA_FRONT_CFLAGS) \
                              $(STRATEGO_CFLAGS)
libto_java_servlet_la_LIBADD   = $(STRATEGO_XTC_LIBS) \
			      $(STRATEGO_GPP_LIBS) \
                              $(JAVA_FRONT_LIBS) \
			      $(STRATEGO_LIBS)
endif


libto-java-servlet.rtree libto-java-servlet.c : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(JAVASTRFILES:.str=.rtree) libwebdsl-front.rtree libwebdsl-generator.rtree
	$(STRC)/bin/strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/to-java-servlet/to-java-servlet.str -o libto-java-servlet.rtree \
		--verbose 1 $(STRCFLAGS) 
	rm libto-java-servlet.str

to-java-servlet.ctree : libto-java-servlet.rtree
	$(STRC)/bin/strc $(STRINCLUDES) -c --library -O 1 -F -i $(srcdir)/org/webdsl/dsl/to-java-servlet/to-java-servlet.str -o to-java-servlet.ctree \
		--verbose 1 $(STRCFLAGS) 

## fast pretty-printer

if !XT_ENABLE_JAVA_BACKEND
  lib_LTLIBRARIES  += libjava-pp.la 

libjava_pp_la_SOURCES = java-pp.c
libjava_pp_la_LIBADD  = $(STRATEGO_XTC_LIBS)   $(STRATEGO_LIB_LIBS)   $(STRATEGO_RUNTIME_LIBS)   $(ATERM_LIBS)
libjava_pp_la_CFLAGS  = $(STRATEGO_XTC_CFLAGS) $(STRATEGO_LIB_CFLAGS) $(STRATEGO_RUNTIME_CFLAGS) $(ATERM_CFLAGS) $(AM_CFLAGS)
libjava_pp_la_LDFLAGS = -avoid-version -no-undefined $(AM_LDFLAGS)

endif

### rtg

Java-EBlock.rtg.af : $(JAVA_FRONT)/share/java-front/Java-EBlock.rtg
	parse-rtg -i $< -o $@

xml-doc.rtg.af : $(GPP)/share/xml-front/xml-doc.rtg
	parse-rtg -i $< -o $@

### write files

nobase_data_DATA += libwrite-files.rtree 
if !XT_ENABLE_JAVA_BACKEND
  lib_LTLIBRARIES  += libwrite-files.la 

libwrite_files_la_SOURCES = libwrite-files.c
libwrite_files_la_CFLAGS   = $(AM_CFLAGS) -O0  $(STRATEGO_LIB_CFLAGS)
libwrite_files_la_LDFLAGS  = $(AM_LDFLAGS)
libwrite_files_la_CPPFLAGS = $(STRATEGO_XTC_CFLAGS) \
                              $(STRATEGO_GPP_CFLAGS) \
                              $(JAVA_FRONT_CFLAGS) \
                              $(STRATEGO_CFLAGS)
libwrite_files_la_LIBADD   = $(STRATEGO_XTC_LIBS) \
			      $(STRATEGO_GPP_LIBS) \
                              $(JAVA_FRONT_LIBS) \
			      $(STRATEGO_LIBS)
endif

libwrite-files.rtree libwrite-files.c : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) libwebdsl-front.rtree Java-EBlock.rtg.af xml-doc.rtg.af
	$(STRC)/bin/strc $(STRINCLUDES) -c --library -i $(srcdir)/org/webdsl/dsl/write-files/write-files.str -o libwrite-files.rtree \
		--verbose 1 $(STRCFLAGS) 
	rm libwrite-files.str

write-files.ctree : libwrite-files.rtree
	$(STRC)/bin/strc $(STRINCLUDES) -c --library -O 1 -F -i $(srcdir)/org/webdsl/dsl/write-files/write-files.str -o write-files.ctree \
		--verbose 1 $(STRCFLAGS) 

