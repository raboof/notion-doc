# Settings
######################################

# Requires at least GNU Make 3.81

TOPDIR=../notion

include $(TOPDIR)/build/system-inc.mk

L2H=latex2html -show_section_numbers -short_index -local_icons -noaddress \
    -up_url https://notionwm.net -up_title "Notion homepage" -nofootnode\
    -style notion.css -html_version 4.0,math,table


# Function documentation to build
######################################

DOCS=notionconf notionnotes notionconf-onepage notionnotes-onepage

FNTEXES=ioncore.exports mod_tiling.exports \
	mod_query.exports de.exports mod_menu.exports \
	mod_dock.exports mod_sp.exports mod_statusbar.exports

TEXSOURCES=conf-bindings.tex confintro.tex conf-menus.tex \
	conf-stdisp.tex conf-dock.tex conf-statusbar.tex conf.tex conf-winprops.tex cstyle.tex designnotes.tex \
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
	rm -rf $*
	$(RUBBER_DVI) $*

%-ps: $(TEXSOURCES)
	rm -rf $*
	$(RUBBER_PS) $*

%-pdf: $(TEXSOURCES)
	rm -rf $*
	$(RUBBER_PDF) $*

# Install
######################################

install:
	$(INSTALLDIR) $(DOCDIR); \
	for d in $(DOCS); do \
	    # Skipping dvi and ps because of #2
	    for e in pdf; do \
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

notionconf-html-onepage: $(FNTEXES) $(TEXSOURCES)
	rm -rf notionconf-onepage
	mkdir notionconf-onepage
	$(L2H) -split 0 -dir notionconf-onepage notionconf
	cp notion.css notionconf-onepage

# notionnotes rules
######################################

notionnotes-html: $(FNTEXES) $(TEXSOURCES)
	$(L2H) -split 4 notionnotes
	cp notion.css notionnotes

notionnotes-html-onepage: $(FNTEXES) $(TEXSOURCES)
	rm -rf notionnotes-onepage
	mkdir notionnotes-onepage
	$(L2H) -split 0 -dir notionnotes-onepage notionnotes
	cp notion.css notionnotes-onepage

# More generic rules
######################################

.PHONY: all all-dvi all-ps all-pdf all-html all-html-onepage

all: all-pdf all-html all-html-onepage

all-dvi: $(patsubst %,%-dvi,$(TARGETS))

all-ps: $(patsubst %, %-ps, $(TARGETS))

all-pdf: $(patsubst %, %-pdf, $(TARGETS))

all-html: $(patsubst %, %-html, $(TARGETS))

all-html-onepage: $(patsubst %, %-html-onepage, $(TARGETS))

# Clean
######################################

clean:
	rm -f $(FNTEXES) fnlist.tex
	rm -f *.aux *.toc *.log *.out
	rm -f *.idx *.ild *.ilg *.ind
	rm -rf notionnotes notionnotes-onepage notionconf notionconf-onepage
	@echo ""
	@echo "Successfully cleaned intermediate files. To also remove deliverables, use 'make realclean'"
        
realclean: clean
	rm -f *.ps *.pdf *.dvi
	rm -rf $(DOCS)


# Function reference rules
######################################

include $(TOPDIR)/libmainloop/rx.mk

# GNU Make 3.82 only supports glob expressions in pattern dependency lines
# on second expansion, so we force that :(
# See also http://savannah.gnu.org/bugs/?31248
.SECONDEXPANSION:
TRIGGER=$$(TRIGGER_SECOND_EXPANSION)

# glob expressions in pattern dependency lines requires at least GNU Make 3.81
$(TOPDIR)/%/exports.tex: $(TOPDIR)/%/*.c $(TRIGGER)
	$(MAKE) -C $$(dirname $@) _exports_doc

%.exports: $(TOPDIR)/%/exports.tex
	cp $< $@

# Function list
######################################

fnlist.tex: $(FNTEXES)
	grep hyperlabel $+ | \
	sed 's/.*fn:\([^}]*\).*/\\fnlisti{\1}/;'|sort -d -f \
	> $@
