help:
	@echo "Available targets:"
	@echo "  test		-> Run all tests"
	@echo "  install	-> Install plugin to ~/.vim/pack/twcarbone/vim-pathlib"
	@exit 0

.DEFAULT:
	@echo "ERROR: target '$@' not recognized."
	@echo "Run 'make help' for a list of available targets."
	@echo ""
	@exit 1

.PHONY: test

test:
	@cd test && $(MAKE) --no-print-directory 

install:
	@rm -rf ~/.vim/pack/twcarbone/vim-pathlib
	@mkdir -p ~/.vim/pack/twcarbone
	@ln -s $$(pwd) ~/.vim/pack/twcarbone/vim-pathlib
