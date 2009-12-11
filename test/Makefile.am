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
  $(wildcard succeed/property-events/*.app)
#  $(wildcard succeed/generics/*.app) 

TESTSFAIL = \
  $(wildcard fail/*.app) \
  $(wildcard fail/*/*.app)
  
TESTSSUCCEEDWEBALL = \
  $(wildcard succeed-web/*.app) \
  $(wildcard succeed-web/data-validation/*.app) \
  $(wildcard succeed-web/ac/*.app)

NATIVEJAVAFILESUSEDINTESTS = \
  $(wildcard succeed/nativejava/*.java)
  
TBLANDCTREEUSEDINSTRATEGOTEST = \
  $(wildcard succeed/stratego/*.tbl) \
  $(wildcard succeed/stratego/*.ctree)

# http://www.chemie.fu-berlin.de/chemnet/use/info/make/make_8.html#SEC73
TESTS = $(patsubst %.app,%.sh,$(TESTSSUCCEEDALL)) $(patsubst %.app,%.sh,$(TESTSFAIL)) $(patsubst %.app,%.sh,$(TESTSSUCCEEDWEBALL))

EXTRA_DIST = $(TESTSFAIL) $(TESTSSUCCEEDALL) $(TESTSSUCCEEDWEBALL) succeed/module/module/goto.app $(wildcard *.sh) run $(NATIVEJAVAFILESUSEDINTESTS) $(TBLANDCTREEUSEDINSTRATEGOTEST)
	
$(TESTSSUCCEEDALL:.app=.sh): run-test-succeed-all.sh
	@$(LN_S) -f $$(pwd)/$< ./$@
	
$(TESTSSUCCEEDWEBALL:.app=.sh): run-test-succeed-web-all.sh
	@$(LN_S) -f $$(pwd)/$< ./$@

$(TESTSFAIL:.app=.sh): run-test-fail.sh
	@$(LN_S) -f $$(pwd)/$< ./$@

clean:
	@echo "Removing all symbolic links to tests";
	-@rm -f $(TESTS);
	@echo "Removing all .out-files";
	-@rm -f fail/*.out fail/*/*.out succeed/*.out succeed/*/*.out
