TESTSSUCCEEDALL = \
  $(wildcard succeed/*.app) \
  $(wildcard succeed/ac/*.app) \
  $(wildcard succeed/data-validation/*.app) \
  $(wildcard succeed/email/*.app) \
  $(wildcard succeed/entity-events/*.app) \
  $(wildcard succeed/module/*.app) \
  $(wildcard succeed/nativejava/*.app) \
  $(wildcard succeed/overloading/*.app) \
  $(wildcard succeed/property-events/*.app)
#  $(wildcard succeed/generics/*.app) 

TESTSFAIL = \
  $(wildcard fail/*.app) \
  $(wildcard fail/*/*.app)

# http://www.chemie.fu-berlin.de/chemnet/use/info/make/make_8.html#SEC73
TESTS = $(patsubst %.app,%.sh,$(TESTSSUCCEEDALL)) $(patsubst %.app,%.sh,$(TESTSFAIL))

EXTRA_DIST = $(TESTSFAIL) $(TESTSSUCCEEDALL) succeed/module/module/goto.app $(wildcard *.sh) run
	
$(TESTSSUCCEEDALL:.app=.sh): run-test-succeed-all.sh
	@$(LN_S) $$(pwd)/$< ./$@

$(TESTSFAIL:.app=.sh): run-test-fail.sh
	@$(LN_S) $$(pwd)/$< ./$@

clean:
	@echo "Removing all symbolic links to tests";
	-@rm -f $(TESTS);
	@echo "Removing all .out-files";
	-@rm -f fail/*.out fail/*/*.out succeed/*.out succeed/*/*.out
