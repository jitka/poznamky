RTXS=$(wildcard *.rtx)
RTDS=$(wildcard *.rtd)
RTXPDFS=$(patsubst %.rtd,%.pdf,$(RTDS))

all: $(RTXPDFS)

Makefile.rtx.deps: $(RTXS) $(RTDS)
	rm -f $@
	for F in $^ localhead localtail ; do if [ -f $$F ] ; then grep '\\\(input\|include\){[^{}]*}' $$F | sed -e 's/\\\(input\|include\){\([^{}]*\)}/.'"$$F"'.dep: .\2.dep\
/g;s/\.\(.[-_a-z.]*\)\.\(rt[xd]\)\.dep/.\1.tex.dep/g' >> $@ ; fi ; done

include Makefile.rtx.deps

$(RTXPDFS): %.pdf: %.dvi
	dvipdf $<

RTXDVIS=$(patsubst %.rtd,%.dvi,$(RTDS))

$(RTXDVIS) $(patsubst %.rtx,_test-%.dvi,$(RTXS)): %.dvi: %.tex .%.tex.dep $(patsubst %,.%.dep,$(wildcard localhead) $(wildcard localtail))
	cslatex $<

$(patsubst %.rtd,%.tex,$(RTDS)): %.tex: %.rtd

$(patsubst %.rtx,%.tex,$(RTXS))  $(patsubst %.rtx,_test-%.tex,$(RTXS)): %.tex: %.rtx

$(patsubst %.rtx,%.tex,$(RTXS)) $(patsubst %.rtd,%.tex,$(RTDS)) $(patsubst %.rtx,_test-%.tex,$(RTXS)): %.tex:
	rtx2tex < $< | recode utf8..latin2 | sed -e 's/\\\(input\|include\){\([^{}]*\)\.rtx}/\\\1{\2.tex}/g;s/\\include{\([^{}]*\)\.tex}/\\include{\1}/g' > $@ || ( rm $@; false )

$(patsubst %.rtx,.%.tex.dep,$(RTXS)) $(patsubst %.rtd,.%.tex.dep,$(RTDS)) $(patsubst %.rtx,._test-%.tex.dep,$(RTXS)): .%.dep: %
	touch $@

clean: clean-rtx clean-rtx-depfile

clean-rtx:
	rm -f $(RTXDVIS) $(RTXPDFS) $(patsubst %.rtx,%.tex,$(RTXS)) $(patsubst %.rtd,%.tex,$(RTDS)) $(patsubst %.rtd,%.log,$(RTDS)) $(patsubst %.rtd,%.aux,$(RTDS)) $(patsubst %,.%.dep,$(RTXS) $(RTDS)) $(patsubst %.rtx,_test-%.*,$(RTXS)) $(patsubst %.rtx,%.log,$(RTXS))

distclean: clean

clean-rtx-depfile:
	rm -f Makefile.rtx.deps .*.dep

$(patsubst %,test-%,$(RTDS)): test-%.rtd: %.dvi
	kdvi $<

$(patsubst %,test-%,$(RTXS)): test-%.rtx: _test-%.dvi
	kdvi $<

$(patsubst %,_test-%,$(RTXS)): _test-%: %
	cat localhead > $@ || echo '\documentclass{article}\usepackage[latin2]{inputenc}\begin{document}' > $@
	cat $< >> $@
	cat localtail >> $@ || echo '\end{document}' >> $@

$(patsubst %,print-%,$(RTDS)): print-%.rtd: %.dvi
	dvips $<

.PHONY: all distclean clean-rtx-depfile clean clean-rtx $(patsubst %,test-%,$(RTDS) $(RTXS)) $(patsubst %,print-%,$(RTDS))
