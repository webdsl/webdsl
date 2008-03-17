include $(top_srcdir)/Makefile.xt

SUBDIRS = src src/org/webdsl/dsl/project

#src/org/webdsl/dsl/generation 

BOOTCLEAN_SUBDIRS = $(SUBDIRS)
DIST_SUBDIRS      = $(SUBDIRS)
EXTRA_DIST        = Makefile.xt bootstrap autoxt.m4 java-front.m4 webdsls.pc
CLEANFILES        = XTC

XTC_IMPORT = $(STRATEGOXT)/share/strategoxt/XTC

ACLOCAL_AMFLAGS = -I.

pkgconfig_DATA = webdsls.pc
