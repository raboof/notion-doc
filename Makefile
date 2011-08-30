# Settings
######################################

TOPDIR=../notion

include $(TOPDIR)/build/system-inc.mk

L2H=latex2html -show_section_numbers -short_index -local_icons -noaddress \
    -up_url http://notion.sourceforge.net -up_title "Notion homepage" -nofootnode\
    -style notion.css


# Function documentation to build
######################################

DOCS=notionconf notionnotes

FNTEXES=ioncore.exports mod_tiling.exports \
	mod_query.exports de.exports mod_menu.exports \
	mod_dock.exports mod_sp.exports mod_statusbar.exports

TEXSOURCES=conf-bindings.tex confintro.tex conf-menus.tex \
	conf-statusbar.tex conf.tex conf-winprops.tex cstyle.tex designnotes.tex \
	de.tex fdl.tex fnref.tex fullhierarchy.tex hookref.tex luaif.tex \
	macros.tex miscref.tex notionconf.tex notionnotes.tex objectsimpl.tex objects.tex \
	prelim.tex statusd.tex tricks.tex

RUBBER_DVI=rubber
RUBBER_PS=rubber -p
RUBBER_PDF=rubber -d

TARGETS = notionconf notionnotes

# Generic rules
######################################

nothing:
	@ echo "Please read the README first."

%-dvi: $(TEXSOURCES)
	$(RUBBER_DVI) $*
	touch $@

%-ps: $(TEXSOURCES)
	$(RUBBER_PS) $*
	touch $@

%-pdf: $(TEXSOURCES)
	$(RUBBER_PDF) $*
	touch $@

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
	    rm -f $(DOCDIR)/$$d/*.log; \
	    rm -f $(DOCDIR)/$$d/WARNINGS; \
	    rm -f $(DOCDIR)/$$d/*.aux; \
	    rm -f $(DOCDIR)/$$d/*.idx; \
	    rm -f $(DOCDIR)/$$d/*.tex; \
	    rm -f $(DOCDIR)/$$d/*.pl; \
	done

# notionconf rules
######################################

notionconf-dvi: fnlist.tex $(TEXSOURCES)
notionconf-ps: fnlist.tex $(TEXSOURCES)
notionconf-pdf: fnlist.tex $(TEXSOURCES)

notionconf-html: $(FNTEXES) $(TEXSOURCES)
	$(L2H) -split 3 notionconf
	cp notion.css notionconf
	touch $@

# notionnotes rules
######################################

notionnotes-html: $(TEXSOURCES)
	$(L2H) -split 4 notionnotes
	cp notion.css notionnotes
	touch $@

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
	rm -f *.aux *.toc *.log *.out
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
