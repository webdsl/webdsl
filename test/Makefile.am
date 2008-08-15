TESTSSUCCEED =  $(wildcard succeed/*.app) $(wildcard succeed/*/*.app)
TESTSSUCCEEDALL = $(wildcard succeed/*.app) $(wildcard succeed/*/*.app)
TESTSFAIL =$(wildcard fail/*.app) $(wildcard fail/*/*.app)
# http://www.chemie.fu-berlin.de/chemnet/use/info/make/make_8.html#SEC73
TESTS = $(patsubst %.app,%,$(TESTSSUCCEED)) $(patsubst %.app,%,$(TESTSFAIL))

EXTRA_DIST = $(TESTSSUCCEED) $(TESTSFAIL) $(TESTSSUCCEEDALL) $(wildcard *.sh) run

LN_S = ln -s

echo-TESTS-F: ; echo TESTTOFAIL=$(TESTSTOFAIL)
echo-TESTS-S: ; echo TESTSUCCEED=$(TESTSSUCCEED)
echo-TESTS: echo-TESTS-S echo-TESTS-F ; echo TESTS=$(TESTS)

$(TESTSSUCCEED:.app=): run-test-succeed.sh
	@$(LN_S) $$(pwd)/$< ./$@
	@chmod +x ./$@

$(TESTSFAIL:.app=): run-test-fail.sh
	@$(LN_S) $$(pwd)/$< ./$@
	@chmod +x ./$@

clean:
	@echo "Removing all symbolic links to tests";
	-@rm -f $(TESTS);
	@echo "Removing all .out-files";
	-@rm -f fail/*.out fail/*/*.out succeed/*.out succeed/*/*.out
