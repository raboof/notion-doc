# Settings
######################################

TOPDIR=../ion-3

include $(TOPDIR)/build/system-inc.mk

L2H=latex2html -show_section_numbers -short_index -local_icons -noaddress \
    -up_url http://iki.fi/tuomov/ion/ -up_title "Ion homepage" -nofootnode\
##    -style greyviolet.css


# Function documentation to build
######################################

DOCS=ionconf ionnotes

FNTEXES=ioncore.exports mod_tiling.exports \
	mod_query.exports de.exports mod_menu.exports \
	mod_dock.exports mod_sp.exports mod_statusbar.exports

RUBBER_DVI=rubber
RUBBER_PS=rubber -p
RUBBER_PDF=rubber -d

TARGETS = ionconf ionnotes

# Generic rules
######################################

nothing:
	@ echo "Please read the README first."

%-dvi:
	$(RUBBER_DVI) $*
	
%-ps:
	$(RUBBER_PS) $*

%-pdf:
	$(RUBBER_PDF) $*

# Install
######################################

install:
	$(INSTALLDIR) $(DOCDIR); \
	for d in $(DOCS); do \
	    for e in ps pdf dvi; do \
	      test -f $$d.$$e && $(INSTALL) -m $(DATA_MODE) $$d.$$e $(DOCDIR); \
            done; \
	    $(INSTALLDIR) $(DOCDIR)/$$d; \
            for i in $$d/*; do \
                $(INSTALL) -m $(DATA_MODE) $$i $(DOCDIR)/$$i; \
	    done; \
        done

# ionconf rules
######################################

ionconf-dvi: fnlist.tex
ionconf-ps: fnlist.tex
ionconf-pdf: fnlist.tex

ionconf-html: $(FNTEXES)
	$(L2H) -split 3 ionconf

# ionnotes rules
######################################

ionnotes-html: 
	$(L2H) -split 4 ionnotes

# More generic rules
######################################

.PHONY: all all-dvi all-ps all-pdf all-html

all: all-dvi all-ps all-pdf all-html

all-dvi: $(patsubst %,%-dvi,$(TARGETS))

all-ps: $(patsubst %, %-ps, $(TARGETS))

all-pdf: $(patsubst %, %-pdf, $(TARGETS))

all-html: $(patsubst %, %-html, $(TARGETS))


# Clean
######################################

clean:
	rm -f $(FNTEXES) fnlist.tex
	rm -f *.aux *.toc *.log
	rm -f *.idx *.ild *.ilg *.ind
        
realclean: clean
	rm -f *.ps *.pdf *.dvi
	rm -rf $(DOCS)


# Function reference rules
######################################

include $(TOPDIR)/libmainloop/rx.mk

$(TOPDIR)/%/exports.tex:
	$(MAKE) -C $$(dirname $@) _exports_doc

%.exports: $(TOPDIR)/%/exports.tex
	cp $< $@

# Function list
######################################

fnlist.tex: $(FNTEXES)
	grep hyperlabel $+ | \
	sed 's/.*fn:\([^}]*\).*/\\fnlisti{\1}/;'|sort -d -f \
	> $@
