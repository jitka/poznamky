D:=$(shell pwd)
RTDS:=$(wildcard */*.rtd) $(wildcard *.rtd)
RTXS:=$(wildcard */*.rtx) $(wildcard *.rtx)

include build/Makefile.bottom

.PHONY: gen-makes clean-makes

distclean: clean-makes

SUBDIRS:=ADS2 algebra analyza-3 komsem neproceduralko topomet

gen-makes: $(patsubst %,%/Makefile,$(SUBDIRS))

$(patsubst %,%/Makefile,$(SUBDIRS)): %: build/Makefile.dir
	cp $< $@

clean-makes:
	rm -f $(patsubst %,%/Makefile,$(SUBDIRS)) $(patsubst %,%/Makefile.rtx.deps,$(SUBDIRS))
