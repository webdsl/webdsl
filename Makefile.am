include $(top_srcdir)/config/Transformers.mk

SUBDIRS = src src/org/webdsl/dsl/generation src/org/webdsl/dsl/project

BOOTCLEAN_SUBDIRS = $(SUBDIRS)
DIST_SUBDIRS      = $(SUBDIRS)
EXTRA_DIST	  = bootstrap			\
                    config/Makefile.xt		\
                    config/autoxt.m4		\
                    config/java-front.m4	\
                    config/Transformers.mk	\
                    config/tfm.m4

CLEANFILES        = XTC

XTC_IMPORT = $(STRATEGOXT)/share/strategoxt/XTC	\
	     $(GENERIC_TOOLS_XTC)

ACLOCAL_AMFLAGS = -I config

pkgconfig_DATA = webdsls.pc
