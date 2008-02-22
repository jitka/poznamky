D:=$(shell pwd)
RTDS:=$(wildcard */*.rtd) $(wildcard *.rtd)
RTXS:=$(wildcard */*.rtx) $(wildcard *.rtx)

include build/Makefile.bottom

.PHONY: gen-makes clean-makes clean-tars upload

distclean: clean-makes clean-tars

SUBDIRS:=ADS2 algebra analyza-3 komsem neproceduralko topomet analyza-2 lingebra-2 analyza-1 lingebra-1 graforitmy mast kombagra temno agra algebra-2 vypr zos dasy

gen-makes: $(patsubst %,%/Makefile,$(SUBDIRS))

$(patsubst %,%/Makefile,$(SUBDIRS)): %: build/Makefile.dir
	ln $< $@

clean-makes:
	rm -f $(patsubst %,%/Makefile,$(SUBDIRS)) $(patsubst %,%/Makefile.rtx.deps,$(SUBDIRS))

DIST_RTDS:=$(wildcard $(patsubst %,%/*.rtd,$(SUBDIRS)))
DIST_PDFS:=$(patsubst %.rtd,%.pdf,$(DIST_RTDS))
pdfs.tar.bz2: $(DIST_PDFS)
	tar c $^ | bzip2 -9 > $@

clean-tars:
	rm -f pdfs.tar.bz2

upload: pdfs.tar.bz2
	scp $^ atrey:~/WWW/
