TESTSSUCCEEDALL = \
  $(wildcard succeed/*.app) \
  $(wildcard succeed/ac/*.app) \
  $(wildcard succeed/data-validation/*.app) \
  $(wildcard succeed/email/*.app) \
  $(wildcard succeed/stratego/*.app) \
  $(wildcard succeed/entity-events/*.app) \
  $(wildcard succeed/module/*.app) \
  $(wildcard succeed/nativejava/*.app) \
  $(wildcard succeed/overloading/*.app) \
  $(wildcard succeed/property-events/*.app) \
  $(wildcard succeed/manual/*.app) \
  $(wildcard succeed/search/*.app) \
  $(wildcard succeed/prefetch/*.app)
#  $(wildcard succeed/generics/*.app) 

TESTSFAIL = \
  $(wildcard fail/*.app) \
  $(wildcard fail/*/*.app)
  
TESTSSUCCEEDWEBALL = \
  $(wildcard succeed-web/*.app) \
  $(wildcard succeed-web/data-validation/*.app) \
  $(wildcard succeed-web/data-validation/withstylesheet/*.app) \
  $(wildcard succeed-web/data-validation/withstylesheet/stylesheets/*.css) \
  $(wildcard succeed-web/ac/*.app) \
  $(wildcard succeed-web/types/*.app) \
  $(wildcard succeed-web/manual/*.app) \
  $(wildcard succeed-web/manual/ajax-form-validation/*.app) \
  $(wildcard succeed-web/manual/ajax-form-validation/templates/*.app) \
  $(wildcard succeed-web/manual/ajax-form-validation/images/*.png) \
  $(wildcard succeed-web/manual/ajax-form-validation/shtylesheets/*.css) \
  $(wildcard succeed-web/manual/tutorial-splash/v1/*.app) \
  $(wildcard succeed-web/manual/tutorial-splash/v2/*.app) \
  $(wildcard succeed-web/manual/tutorial-splash/v2/shtylesheets/*.css) \
  $(wildcard succeed-web/manual/tutorial-splash/v3/*.app) \
  $(wildcard succeed-web/manual/tutorial-splash/v3/shtylesheets/*.css) \
  $(wildcard succeed-web/manual/tutorial-splash/v4/*.app) \
  $(wildcard succeed-web/manual/tutorial-splash/v4/shtylesheets/*.css) \
  $(wildcard succeed-web/search/*.app)\
  $(wildcard succeed-web/search/search/analyzerfiles/*.txt)\
  $(wildcard succeed-web/*.sh)\
  $(wildcard succeed-web/*.nix)
  
NATIVEJAVAFILESUSEDINTESTS = \
  $(wildcard succeed/nativejava/*.java)
  
TBLANDCTREEUSEDINSTRATEGOTEST = \
  $(wildcard succeed/stratego/*.tbl) \
  $(wildcard succeed/stratego/*.ctree) \
  $(wildcard succeed-web/types/*.tbl) \
  $(wildcard succeed-web/types/*.sdf)

# http://www.chemie.fu-berlin.de/chemnet/use/info/make/make_8.html#SEC73
TESTS = $(patsubst %.app,%.sh,$(TESTSSUCCEEDALL)) $(patsubst %.app,%.sh,$(TESTSFAIL)) 

EXTRA_DIST = $(TESTSFAIL) $(TESTSSUCCEEDALL) $(TESTSSUCCEEDWEBALL) succeed/module/module/goto.app succeed/prefetch/module/logutils.app $(wildcard *.sh) run $(NATIVEJAVAFILESUSEDINTESTS) $(TBLANDCTREEUSEDINSTRATEGOTEST)

if XT_ENABLE_WEB_CHECK

TESTS += $(patsubst %.app,%.sh,$(TESTSSUCCEEDWEBALL))

$(TESTSSUCCEEDWEBALL:.app=.sh): run-test-succeed-web-all.sh
	@$(LN_S) -f $$(pwd)/$< ./$@

endif
	
$(TESTSSUCCEEDALL:.app=.sh): run-test-succeed-all.sh
	@$(LN_S) -f $$(pwd)/$< ./$@

$(TESTSFAIL:.app=.sh): run-test-fail.sh
	@$(LN_S) -f $$(pwd)/$< ./$@

clean:
	@echo "Removing all symbolic links to tests";
	-@rm -f $(TESTS);
	@echo "Removing all .out-files";
	-@rm -f fail/*.out fail/*/*.out succeed/*.out succeed/*/*.out


#stratego code tests

TESTS += run-stratego-tests.sh

install-data-hook:
	./generatenix.sh
	mkdir -p $(pkgdatadir)/webdsl-check/test/succeed-web
#copy all succeed-web test files including app, css, txt and sh files. Skip hidden dirs like .servletapp 
	find ../test/succeed-web/ -not \( -regex '.*/\..*' \) \( -name '*.app' -o -name '*.css' -o -name '*.txt' -o -name '*.sh' -o -name '*.nix' -o -name '*.ini' -o -name '*.tbl' -o -name '*.sdf' -o -name '*.png'\) | cpio -pdm $(pkgdatadir)/webdsl-check/test/