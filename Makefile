# Settings
######################################

TOPDIR=../ion

LUA=lua

L2H=latex2html -show_section_numbers -short_index -local_icons -noaddress \
    -up_url http://iki.fi/tuomov/ion/ -up_title "Ion homepage" -nofootnode

FNTEXES=ioncore-exports.tex ionws-exports.tex floatws-exports.tex \
	query-exports.tex querylib-fns.tex ioncorelib-fns.tex \
	delib-fns.tex de-exports.tex menu-exports.tex \
	menulib-fns.tex

MKFNTEX=$(LUA) $(TOPDIR)/mkexports.lua

# Generic rules
######################################

nothing:
	@ echo "Please read the README first."

%.ps: %.dvi
	dvips $<

%.pdf: %.dvi
	dvipdfm -p a4 $<

%.dvi: %.tex
	latex $<

# ionconf rules
######################################
ionconf-dvi-full:
	latex ionconf
	latex ionconf
	latex ionconf
	makeindex ionconf.idx
	latex ionconf

ionconf-html: 
	$(L2H) -split 3 ionconf

fntexes: $(FNTEXES)

ionconf-all: fntexes fnlist.tex ionconf-dvi-full ionconf-html

# ionnotes rules
######################################

ionnotes-dvi-full:
	latex ionnotes
	latex ionnotes
	latex ionnotes
	makeindex ionnotes.idx
	latex ionnotes

ionnotes-html: 
	$(L2H) -split 4 ionnotes

ionnotes-all: ionnotes-dvi-full ionnotes-html

# More generic rules
######################################

all: ionconf-all ionnotes-all

all-ps: ionconf.ps ionnotes.ps

all-pdf: ionconf.pdf ionnotes.pdf


# Clean
######################################

clean:
	rm -f $(FNTEXES) fnlist.tex
	rm -f *.aux *.toc *.log
	rm -f *.idx *.ild *.ilg *.ind
	rm -f *.ps *.pdf *.dvi
	rm -rf ionconf ionnotes


# Function reference rules
######################################

ioncore-exports.tex: $(TOPDIR)/ioncore/*.c $(TOPDIR)/luaextl/*.c
	$(MKFNTEX) -module ioncore -mkdoc -o $@ $+

ionws-exports.tex: $(TOPDIR)/ionws/*.c
	$(MKFNTEX) -module ionws -mkdoc -o $@ $+

floatws-exports.tex: $(TOPDIR)/floatws/*.c
	$(MKFNTEX) -module floatws -mkdoc -o $@ $+

de-exports.tex: $(TOPDIR)/de/*.c
	$(MKFNTEX) -module de -mkdoc -o $@ $+

menu-exports.tex: $(TOPDIR)/menu/*.c
	$(MKFNTEX) -module menu -mkdoc -o $@ $+

query-exports.tex: $(TOPDIR)/query/*.c
	$(MKFNTEX) -module query -mkdoc -o $@ $+

querylib-fns.tex: $(TOPDIR)/query/querylib.lua
	$(MKFNTEX) -module query -luadoc -o $@ $+

delib-fns.tex: $(TOPDIR)/de/delib.lua
	$(MKFNTEX) -module de -luadoc -o $@ $+

menulib-fns.tex: $(TOPDIR)/menu/menulib.lua
	$(MKFNTEX) -module menu -luadoc -o $@ $+

ioncorelib-fns.tex: $(TOPDIR)/share/ioncorelib.lua \
$(TOPDIR)/share/ioncorelib-mplexfns.lua
	$(MKFNTEX) -module ioncore -luadoc -o $@ $+

# Function list
######################################

fnlist.tex: $(FNTEXES)
	grep hyperlabel $+ | \
	sed 's/.*fn:\([^}]*\).*/\\fnlisti{\1}/'|sort -d -f \
	> $@
