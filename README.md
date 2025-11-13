# pathlib.vim

Miscellaneous filesystem utilities. Heavily inspired by Python's pathlib module.

## Contents

See `:h pathlib.txt` after installing.

## Installation

### Method 1 - manual

Manually copy the files to ~/.vim/pack/twcarbone/start and generate the documentation.

```
$ mkdir -p ~/.vim/pack/twcarbone/start
$ cd ~/.vim/pack/twcarbone/start
$ git clone git@github.com:twcarbone/vim-pathlib.git
$ cd vim-pathlib
$ vim --clean -c 'helptags doc' -c 'q'
```

### Method 2 - make

Use `make install` to generate the documentation and install to ~/.vim/pack/twcarbone/start.

```
$ cd /anywhere/you/like
$ git clone git@github.com:twcarbone/vim-pathlib.git
$ cd vim-pathlib
$ make install
```

## Testing

Testing uses `make`. The framework mimics that of vim itself. If everything is alright,
the final message will be ALL DONE. If not, you see TEST FAILURE.

Run the full test suite:

```
$ make test  # from the project root
```

Or run just a specific test file from the `test` directory:

```
$ cd test
$ make test_components  # Note: no .vim extension
```

## Credits

- Majority of nomenclature and concepts are taken from Python's [pathlib](https://docs.python.org/3/library/pathlib.html) module
- README and doc/ inspired by [tpope's vim plugins](https://github.com/tpope)
- The test framework mimics [vim's own](https://github.com/vim/vim)
- Makefile stuff initially learned from [the Makefile cookbook](https://makefiletutorial.com/)
