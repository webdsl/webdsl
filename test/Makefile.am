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
  $(wildcard succeed/search/*.app)
#  $(wildcard succeed/generics/*.app) 

TESTSFAIL = \
  $(wildcard fail/*.app) \
  $(wildcard fail/*/*.app)
  
TESTSSUCCEEDWEBALL = \
  $(wildcard succeed-web/*.app) \
  $(wildcard succeed-web/data-validation/*.app) \
  $(wildcard succeed-web/data-validation/withstylesheet*.app) \
  $(wildcard succeed-web/ac/*.app) \
  $(wildcard succeed-web/types/*.app) \
  $(wildcard succeed-web/manual/*.app) \
  $(wildcard succeed-web/manual/ajax-form-validation/*.app) \
  $(wildcard succeed-web/manual/tutorial-splash/v1/v1.app) \
  $(wildcard succeed-web/manual/tutorial-splash/v2/v2.app) \
  $(wildcard succeed-web/manual/tutorial-splash/v3/v3.app) \
  $(wildcard succeed-web/manual/tutorial-splash/v4/v4.app) \
  $(wildcard succeed-web/search/*.app)

NATIVEJAVAFILESUSEDINTESTS = \
  $(wildcard succeed/nativejava/*.java)
  
TBLANDCTREEUSEDINSTRATEGOTEST = \
  $(wildcard succeed/stratego/*.tbl) \
  $(wildcard succeed/stratego/*.ctree)

# http://www.chemie.fu-berlin.de/chemnet/use/info/make/make_8.html#SEC73
TESTS = $(patsubst %.app,%.sh,$(TESTSSUCCEEDALL)) $(patsubst %.app,%.sh,$(TESTSFAIL)) 

EXTRA_DIST = $(TESTSFAIL) $(TESTSSUCCEEDALL) $(TESTSSUCCEEDWEBALL) succeed/module/module/goto.app $(wildcard *.sh) run $(NATIVEJAVAFILESUSEDINTESTS) $(TBLANDCTREEUSEDINSTRATEGOTEST)

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
