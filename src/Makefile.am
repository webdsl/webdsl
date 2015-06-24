include $(top_srcdir)/Makefile.xt
include $(wildcard *.dep)
include $(wildcard org/webdsl/dsl/*/*.dep)

### distribution

CLEANFILES = \
    $(wildcard lib*.c) \
    $(wildcard *.dep) \
    $(wildcard *.rtree) \
    $(wildcard */*.rtree) \
    $(wildcard */*/*.rtree) \
    $(wildcard */*/*/*.rtree) \
    $(wildcard */*/*/*/*.rtree) \
    $(wildcard */*/*/*/*/*.rtree) \
    $(wildcard */*/*/*/*/*/*.rtree) \
    $(wildcard *.ctree) \
    $(wildcard org/webdsl/dsl/*/*.c) \
    $(wildcard org/webdsl/dsl/*/*.o) \
    $(wildcard org/webdsl/dsl/*/*.dep)

FULLCLEANFILES = \
    $(wildcard org/webdsl/dsl/*/*.def) \
    $(wildcard org/webdsl/dsl/*/*/*.def) \
    $(wildcard org/webdsl/dsl/*/*.pp.af) \
    $(wildcard org/webdsl/dsl/*/*.rtg) \
	$(wildcard org/webdsl/dsl/*/*.tbl)\ 
	$(wildcard org/webdsl/dsl/*/*/*.tbl)

# "make clean" leaves syntax intact; use fullclean/distclean

distclean : fullclean

cleaner : fullclean # alias

fullclean :
	$(MAKE) clean
	rm -rf $(FULLCLEANFILES)
	rm -rf src-gen

EXTRA_DIST = \
    $(wildcard *.str) \
    $(wildcard org/webdsl/dsl/*/*.dep) \
    $(wildcard org/webdsl/dsl/*/*.meta) \
    $(wildcard org/webdsl/dsl/*/*.str) \
    $(wildcard org/webdsl/dsl/*/*.sdf) \
    $(wildcard org/webdsl/dsl/*/*/*.sdf) \
    $(wildcard org/webdsl/dsl/*/*/*/*.sdf) \
    $(wildcard org/webdsl/dsl/*/*.pp) \
    $(wildcard org/webdsl/dsl/*/*/*.str) \
    $(wildcard org/webdsl/dsl/*/*/*.meta) \
    $(wildcard org/webdsl/dsl/*/*/*/*.str) \
    $(wildcard org/webdsl/dsl/*/*/*/*.meta) \
    META-INF/MANIFEST.MF

### developer targets

copy-rtrees-to-lib-dir-for-editor-support :
	rm -rf ../lib
	mkdir ../lib
	cp *.rtree ../lib

only-backend-trans :
	make libback-end-transformations.la
	touch libto-java-servlet.rtree
	touch libto-java-servlet.c
	touch .libs/libto-java-servlet.la
	touch .libs/libto_java_servlet_la-libto-java-servlet.o
	touch .libs/libto_java_servlet_la-libto-java-servlet.lo
	touch .libs/libjava-transformations.la
	touch .libs/libjava-transformations.so
	touch libjava-transformations.str
	touch libjava-transformations.rtree libjava-transformations.c
	make webdslc
	
only-gen :
	make libwebdsl-generator.la
	touch .libs/libto-java-servlet.la
	touch .libs/libback-end-transformations.la
	touch libto-java-servlet.c
	touch libto-java-servlet.rtree
	touch .libs/libto-java-servlet.la
	touch libjava-transformations.c
	touch libjava-transformations.rtree
	touch .libs/libjava-transformations.la
	touch .libs/libwrite-files.la
	touch .libs/libfast-java-pp.la     
	make webdslc
	make install

### syntax definitions

syntax 		= org/webdsl/dsl/syntax/WebDSL
hql 		= org/webdsl/dsl/syntax/HQL
mixhql 		= org/webdsl/dsl/syntax/MixHQL
metasyntax 	= org/webdsl/dsl/syntax/StrategoWebDSL
mixmetasyntax 	= org/webdsl/dsl/syntax/Stratego-WebDSL-Java
mixmoblsyntax 	= org/webdsl/dsl/syntax/mobl/Stratego-MoBL
moblsyntax 		= org/webdsl/dsl/syntax/mobl/MoBL
mixmobljssyntax = org/webdsl/dsl/syntax/mobl/Stratego-Javascript

SYNTAXDEFS = $(syntax).def \
	     $(metasyntax).def \
	     $(mixmetasyntax).def \
	     $(hql).def \
	     ${mixmoblsyntax}.def ${mixmobljssyntax}.def # used for mixing		  

TBLS   = $(syntax).tbl $(metasyntax).tbl $(mixmetasyntax).tbl ${mixmoblsyntax}.tbl ${mixmobljssyntax}.tbl

SIGS   = $(hql).rtg $(hql).str $(syntax).rtg $(syntax).str $(moblsyntax).rtg $(moblsyntax).str 

PPTBLS = $(hql)-pretty.pp.af $(syntax)-pretty.pp.af

syntax : $(TBLS)

sdfdata_DATA = $(SYNTAXDEFS) $(TBLS) $(SIGS) $(PPTBLS)

PGEN_FLAGS = -m `basename $*`

PPTABLES = \
	$(syntax)-pretty.pp.af \
	$(syntax).tbl \
	$(hql)-pretty.pp.af

webdslversionterm.trm :
	echo \"@PACKAGE_VERSION@\" > webdslversionterm.trm 

org/webdsl/dsl/syntax/WebDSL.def: $(wildcard org/webdsl/dsl/syntax/*.sdf) \ 
								  $(wildcard org/webdsl/dsl/syntax/mobl/*.sdf)\
								  $(wildcard org/webdsl/dsl/syntax/mobl/js/*.sdf)\
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
                 $(wildcard ./org/webdsl/dsl/languages/*/*/*.str) \
                 $(wildcard ./org/webdsl/dsl/modules/*.str) \
                 $(wildcard ./org/webdsl/dsl/modules/*/*.str) \
                 $(wildcard ./org/webdsl/dsl/modules/*/*/*.str) \
                 $(wildcard ./org/webdsl/dsl/transformation/*.str) \
                 $(wildcard ./org/webdsl/dsl/typechecker/*.str)
                 
BACKEND_TRANS_FILES = \
				 $(wildcard ./org/webdsl/dsl/back-end-transformations/*.str) \
				 $(wildcard ./org/webdsl/dsl/back-end-transformations/*/*.str) 


# imports StrategoWebDSL.tbl and Stratego-Java-15.tbl
STRINCLUDES = -I .\
  -I org/webdsl/dsl/syntax \
  -I share/strategoxt/java_front/languages/stratego-java

SDF2RTG_FLAGS = --main `basename $*` --ignore-missing-cons

Mix%.sdf : %.def
	gen-sdf-mix -i $< --main `basename $*` --name Mix`basename $*` -o $@

SCFLAGS = --main $*-main	

bin_PROGRAMS = webdsl.jar strategoxt.jar
webdsl_jar_SOURCES =
strategoxt_jar_SOURCES = 

ctrees : webdsl-front.ctree webdsl-generator.ctree to-java-servlet.ctree write-files.ctree java-transformations.ctree back-end-transformations.ctree

###

STRATEGOXT_JAR=strategoxt.jar
STRJ=java -Xss8m -Xmx2G -jar $(STRATEGOXT_JAR)
STRJFLAGS=-I . \
  --verbose 3 \
  -la stratego-lib \
  -la stratego-rtg \
  -la stratego-sglr \
  -la stratego-gpp \
  -la stratego-xtc \
  -la stratego-aterm \
  -la stratego-tool-doc \
  -la java-front \
  -clean \
  -I org/webdsl/dsl/syntax/ \
  -D PACKAGE_VERSION_TERM=\"`git rev-parse HEAD`\"
  
JAVAC=`if which ecj >/dev/null; then echo ecj; else echo javac; fi` -J-Xmx512m -J-Xms100m -J-server -J-XX:+UseParallelGC -source 5 -target 5 -nowarn
JAR=`if which fastjar >/dev/null; then echo fastjar; else echo jar; fi`

JAVAS= \
  src-gen/org/webdsl/webdsl_front/Main.java \
  src-gen/org/webdsl/webdsl_generator/Main.java \
  src-gen/org/webdsl/java_transformations/Main.java \
  src-gen/org/webdsl/write_files/Main.java \
  src-gen/org/webdsl/back_end_transformations/Main.java \
  src-gen/org/webdsl/to_java_servlet/Main.java \
  src-gen/org/webdsl/webdslc/Main.java

strategoxt.jar:
	./get-stratego-jar.sh

webdsl.jar : strategoxt.jar $(JAVAS)
	mkdir -p bin
	$(JAVAC) -cp $(STRATEGOXT_JAR):src-gen:. src-gen/org/webdsl/webdslc/Main.java -d bin
	$(JAR) cfm webdsl.jar META-INF/MANIFEST.MF -C bin/ .  `find src-gen -type f | grep -E '(\.tbl|\.af)' | sed 's!src-gen/!-C src-gen/ !'`

src-gen/org/webdsl/webdsl_front/Main.java : $(TBLS) $(SIGS) $(PPTABLES) $(PPTBLS) $(SYNTAXDEFS) $(FRONTSTRFILES)
	mkdir -p src-gen/org/webdsl/webdsl_front
	@if ! which ecj >/dev/null; then \
	  echo "WARNING: ecj is not installed; using the (much) slower javac compiler instead" >&2; \
	fi
	$(STRJ) $(STRJFLAGS) $(STRINCLUDES) --library -p org.webdsl.webdsl_front -i $(srcdir)/org/webdsl/dsl/syntax/webdsl-front.str -o src-gen/org/webdsl/webdsl_front/Main.java
	cp src-gen/org/webdsl/webdsl_front/Main.rtree libwebdsl-front.rtree

src-gen/org/webdsl/webdsl_generator/Main.java : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(GENSTRFILES) libwebdsl-front.rtree
	mkdir -p src-gen/org/webdsl/webdsl_generator
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.webdsl_generator -i $(srcdir)/org/webdsl/dsl/generation/webdsl-generator.str -o src-gen/org/webdsl/webdsl_generator/Main.java -la org.webdsl.webdsl-front
	cp src-gen/org/webdsl/webdsl_generator/Main.rtree libwebdsl-generator.rtree

src-gen/org/webdsl/java_transformations/Main.java : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) libwebdsl-front.rtree
	mkdir -p src-gen/org/webdsl/java_transformations
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.java_transformations -i $(srcdir)/org/webdsl/dsl/java-transformations/java-transformations.str -o src-gen/org/webdsl/java_transformations/Main.java -la org.webdsl.webdsl-generator -la org.webdsl.to-java-servlet -la org.webdsl.webdsl-front
	cp src-gen/org/webdsl/java_transformations/Main.rtree libjava-transformations.rtree

src-gen/org/webdsl/write_files/Main.java : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) libwebdsl-front.rtree libjava-transformations.rtree
	mkdir -p src-gen/org/webdsl/write_files
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.write_files -i $(srcdir)/org/webdsl/dsl/write-files/write-files.str -o src-gen/org/webdsl/write_files/Main.java -la org.webdsl.webdsl-front -la org.webdsl.java_transformations
	cp src-gen/org/webdsl/write_files/Main.rtree libwrite-files.rtree

src-gen/org/webdsl/back_end_transformations/Main.java : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(BACKEND_TRANS_FILES) libwebdsl-front.rtree libwrite-files.rtree 
	mkdir -p src-gen/org/webdsl/back_end_transformations
	$(STRJ) $(STRJFLAGS) --library -p org.webdsl.back_end_transformations -i $(srcdir)/org/webdsl/dsl/back-end-transformations/back-end-transformations.str -o src-gen/org/webdsl/back_end_transformations/Main.java -la org.webdsl.webdsl-front -la org.webdsl.write-files
	cp src-gen/org/webdsl/back_end_transformations/Main.rtree libback-end-transformations.rtree

src-gen/org/webdsl/to_java_servlet/Main.java : $(TBLS) $(SIGS) $(PPTABLES) $(SYNTAXDEFS) $(JAVASTRFILES) libwebdsl-front.rtree libjava-transformations.rtree libwrite-files.rtree libjava-transformations.rtree
	mkdir -p src-gen/org/webdsl/to_java_servlet
	$(STRJ) $(STRJFLAGS) $(STRINCLUDES) --library -p org.webdsl.to_java_servlet -i $(srcdir)/org/webdsl/dsl/to-java-servlet/to-java-servlet.str -o src-gen/org/webdsl/to_java_servlet/Main.java -la org.webdsl.webdsl-front -la org.webdsl.back-end-transformations -la org.webdsl.java_transformations -la org.webdsl.write_files
	cp src-gen/org/webdsl/to_java_servlet/Main.rtree libto-java-servlet.rtree

src-gen/org/webdsl/webdslc/Main.java : webdslc.str libwebdsl-front.rtree libwebdsl-generator.rtree libjava-transformations.rtree libwrite-files.rtree libback-end-transformations.rtree libto-java-servlet.rtree
	mkdir -p src-gen/org/webdsl/webdslc
	$(STRJ) $(STRJFLAGS) -m webdslc-main -i $< -o $@ -p org.webdsl.webdslc -la org.webdsl.webdsl-generator -la org.webdsl.to-java-servlet -la org.webdsl.webdsl-front -la org.webdsl.java-transformations -la org.webdsl.write-files -la org.webdsl.back-end-transformations


# extra files needed to be able to build the Eclipse plugin directly from compiler build output (e.g. using http://hydra.nixos.org/job/webdsl/trunk/buildJavaZip)          
install-data-hook:
	mkdir -p $(pkgdatadir)/plugin-build-deps/webdsl-sources
	find . -name "*.str" -o -name "*.meta" -o -name "*.tbl" -o -name "*.sdf" -o -name "*.pp" -o -name "*.rtree" -type f | cpio -pd $(pkgdatadir)/plugin-build-deps/webdsl-sources/
