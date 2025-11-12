help:
	@echo "Available targets:"
	@echo "  test		-> Run all tests"
	@exit 0

.DEFAULT:
	@echo "ERROR: target '$@' not recognized."
	@echo "Run 'make help' for a list of available targets."
	@echo ""
	@exit 1

.PHONY: test

test:
	@cd test && $(MAKE) --no-print-directory 
