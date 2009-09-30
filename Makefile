D:=$(shell pwd)
SUBDIRS:=ADS2 algebra analyza-3 komsem topomet analyza-2 lingebra-2 analyza-1 lingebra-1 graforitmy kombagra temno algebra-2 ozd past ali mast zspo polyedr semgraforitmy vycis slozitost
RTDS:=$(wildcard $(addsuffix /*.rtd,$(SUBDIRS))) $(wildcard *.rtd)
RTXS:=$(wildcard $(addsuffix /*.rtx,$(SUBDIRS))) $(wildcard *.rtx)

include build/Makefile.bottom

.PHONY: gen-makes clean-makes clean-tars upload

distclean: clean-makes clean-tars

gen-makes: $(patsubst %,%/Makefile,$(SUBDIRS))

$(patsubst %,%/Makefile,$(SUBDIRS)): %: build/Makefile.dir
	ln $< $@ -f

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
