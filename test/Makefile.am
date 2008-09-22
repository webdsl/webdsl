TESTSSUCCEEDALL = $(wildcard succeed/*.app) $(wildcard succeed/*/*.app) 
TESTSFAIL =$(wildcard fail/*.app) $(wildcard fail/*/*.app)
# http://www.chemie.fu-berlin.de/chemnet/use/info/make/make_8.html#SEC73
TESTS = $(patsubst %.app,%,$(TESTSSUCCEEDALL)) $(patsubst %.app,%,$(TESTSFAIL))

EXTRA_DIST = $(TESTSFAIL) $(TESTSSUCCEEDALL) succeed/module/module/goto.app $(wildcard *.sh) run
	
$(TESTSSUCCEEDALL:.app=): run-test-succeed-all.sh
	@$(LN_S) $$(pwd)/$< ./$@

$(TESTSFAIL:.app=): run-test-fail.sh
	@$(LN_S) $$(pwd)/$< ./$@

clean:
	@echo "Removing all symbolic links to tests";
	-@rm -f $(TESTS);
	@echo "Removing all .out-files";
	-@rm -f fail/*.out fail/*/*.out succeed/*.out succeed/*/*.out
