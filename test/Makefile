TESTS = test_components test_modifiers
TESTS_RES = test_components.res test_modifiers.res
CLEANUP_FILES = test.log messages

.PHONY: all clean tests report

# If invoked using 'make'
all: clean tests report

clean:
	@-rm -f *.res $(CLEANUP_FILES)

tests: $(TESTS_RES)

%.res:
	@vim --clean -S runtest.vim $*.vim

report:
	@echo 'Test results:'
	@/bin/sh -c 'if test -f test.log; \
		then cat test.log; echo -e "\nTEST FAILURE\n"; exit 1; \
		else echo -e "\nALL DONE\n"; \
		fi'

# If invoked using 'make <test_xxx>'
$(TESTS):
	@rm -f $@.res $(CLEANUP_FILES)
	$(MAKE) --no-print-directory -f Makefile $@.res
	@cat messages
	@if test -f test.log; then \
		exit 1; \
	fi
