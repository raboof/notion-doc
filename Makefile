# Settings
######################################

TOPDIR=/home/tuomov/coding/ion/
include $(TOPDIR)/system-inc.mk

L2H=latex2html -show_section_numbers -short_index -local_icons -noaddress \
    -up_url http://iki.fi/tuomov/ion/ -up_title "Ion homepage" -nofootnode

FNTEXES=ioncore-exports.tex ionws-exports.tex \
	floatws-exports.tex query-exports.tex \
	querylib-fns.tex ioncorelib-fns.tex

DOC=ionconf

# Generic rules
######################################

nothing:
	@ echo "Please read the README first."

%.ps: %.dvi
	dvips $<

%.pdf: %.dvi
	dvipdfm -p a4 $<

# ionconf rules
######################################
ionconf-dvi:
	latex ionconf

ionconf-dvi-full:
	latex ionconf
	latex ionconf
	latex ionconf
	makeindex ionconf.idx
	latex ionconf

ionconf-html: 
	$(L2H) -split 3 ionconf

fntexes: $(FNTEXES)

ionconf-all: fntexes ionconf-dvi-full ionconf-html

# ionnotes rules
######################################

ionnotes-dvi:
	latex ionnotes

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

all-all: all all-ps all-pdf

# Function reference rules
######################################

ioncore-exports.tex: $(TOPDIR)/ioncore/*.c
	$(LUA) $(TOPDIR)/mkexports.lua -module ioncore -mkdoc -o $@ $+

ionws-exports.tex: $(TOPDIR)ionws/*.c
	$(LUA) $(TOPDIR)/mkexports.lua -module ionws -mkdoc -o $@ $+

floatws-exports.tex: $(TOPDIR)floatws/*.c
	$(LUA) $(TOPDIR)/mkexports.lua -module floatws -mkdoc -o $@ $+

query-exports.tex: $(TOPDIR)query/*.c
	$(LUA) $(TOPDIR)/mkexports.lua -module query -mkdoc -o $@ $+

querylib-fns.tex: $(TOPDIR)etc/querylib.lua
	$(LUA) $(TOPDIR)/mkexports.lua -module query -luadoc -o $@ $+

ioncorelib-fns.tex: $(TOPDIR)etc/ioncorelib.lua
	$(LUA) $(TOPDIR)/mkexports.lua -module query -luadoc -o $@ $+
