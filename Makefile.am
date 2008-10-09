include $(top_srcdir)/Makefile.xt

# remove the default tar -o option to allow long path names
am__tar = ${AMTAR} chf - "$$tardir" 

SUBDIRS = src src/org/webdsl/dsl/project test

fullclean :
	$(MAKE) -C src fullclean

syntax :
	$(MAKE) -C src syntax

ctrees : 
	$(MAKE) -C src ctrees

#src/org/webdsl/dsl/generation

BOOTCLEAN_SUBDIRS = $(SUBDIRS)
DIST_SUBDIRS      = $(SUBDIRS)
EXTRA_DIST        = Makefile.xt bootstrap autoxt.m4 java-front.m4 webdsls.pc
CLEANFILES        = XTC

ACLOCAL_AMFLAGS = -I.

pkgconfig_DATA = webdsls.pc
