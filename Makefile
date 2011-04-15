# Settings
######################################

TOPDIR=../notion

include $(TOPDIR)/build/system-inc.mk

L2H=latex2html -show_section_numbers -short_index -local_icons -noaddress \
    -up_url http://notion.sourceforge.net -up_title "Notion homepage" -nofootnode\
    -style notion.css -html_version 4.0,math,table


# Function documentation to build
######################################

DOCS=notionconf notionnotes

FNTEXES=ioncore.exports mod_tiling.exports \
	mod_query.exports de.exports mod_menu.exports \
	mod_dock.exports mod_sp.exports mod_statusbar.exports

RUBBER_DVI=rubber
RUBBER_PS=rubber -p
RUBBER_PDF=rubber -d

TARGETS = notionconf notionnotes

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

# notionconf rules
######################################

notionconf-dvi: fnlist.tex
notionconf-ps: fnlist.tex
notionconf-pdf: fnlist.tex

notionconf-html: $(FNTEXES)
	$(L2H) -split 3 notionconf
	cp notion.css notionconf

notionconf-html-onepage: $(FNTEXES)
	$(L2H) -split 0 -dir notionconf-onepage notionconf
	cp notion.css notionconf-onepage

# notionnotes rules
######################################

notionnotes-html: 
	$(L2H) -split 4 notionnotes
	cp notion.css notionnotes

notionnotes-html-onepage: 
	$(L2H) -split 0 -dir notionnotes-onepage notionnotes
	cp notion.css notionnotes-onepage

# More generic rules
######################################

.PHONY: all all-dvi all-ps all-pdf all-html

all: all-dvi all-ps all-pdf all-html all-html-onepage

all-dvi: $(patsubst %,%-dvi,$(TARGETS))

all-ps: $(patsubst %, %-ps, $(TARGETS))

all-pdf: $(patsubst %, %-pdf, $(TARGETS))

all-html: $(patsubst %, %-html, $(TARGETS))

all-html-onepage: $(patsubst %, %-html-onepage, $(TARGETS))

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
