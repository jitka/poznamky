
SUBDIRS:=ADS2 algebra analyza neproceduralko topomet
ALL_DEPS:=$(patsubst %,%-all,$(SUBDIRS))
CLEAN_DEPS:=$(patsubst %,%-clean,$(SUBDIRS))

all: $(ALL_DEPS)
clean: $(CLEAN_DEPS)

.PHONY: all clean $(ALL_DEPS) $(CLEAN_DEPS)

$(ALL_DEPS): %-all:
	$(MAKE) -C $(patsubst %-all,%,$@)

$(CLEAN_DEPS): %-clean:
	$(MAKE) -C $(patsubst %-clean,%,$@) clean
