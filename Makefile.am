include $(top_srcdir)/Makefile.xt

# remove the default tar -o option to allow long path names
am__tar = ${AMTAR} chf - "$$tardir" 

SUBDIRS = src src/org/webdsl/dsl/project test

cleaner : fullclean # alias

fullclean :
	./cleanall.sh
	$(MAKE) -C src cleaner

syntax :
	$(MAKE) -C src syntax

ctrees : 
	$(MAKE) -C src ctrees

java : 
	$(MAKE) -C src java

jar : 
	$(MAKE) -C src jar

class : 
	$(MAKE) -C src class
	
editorlibs :
	$(MAKE) -C src copy-rtrees-to-lib-dir-for-editor-support

#src/org/webdsl/dsl/generation

BOOTCLEAN_SUBDIRS = $(SUBDIRS)
DIST_SUBDIRS      = $(SUBDIRS)
EXTRA_DIST        = Makefile.xt bootstrap autoxt.m4 java-front.m4 webdsls.pc \
  precompile-built-ins/application.ini \
  precompile-built-ins/basic.app \
  precompile-built-ins/build.xml
CLEANFILES        = XTC

ACLOCAL_AMFLAGS = -I.

pkgconfig_DATA = webdsls.pc webdsl.m4
