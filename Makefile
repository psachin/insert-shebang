# Makefile for insert-shebang
EMACS = emacs
FILE = $(wildcard insert-shebang.el)

.PHONY: all clean

all:	*.el
	$(EMACS) --batch -Q --no-site-file --eval '(byte-compile-file "$(FILE)")'

clean:
	rm -f *~
	rm -f \#*\#
	rm -f *.elc
