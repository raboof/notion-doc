TOPDIR=/home/tuomov/coding/ion/
include $(TOPDIR)/system-inc.mk

FNTEXES=ioncore-exports.tex ionws-exports.tex \
	floatws-exports.tex query-exports.tex \
	querylib-fns.tex ioncorelib-fns.tex


DOC=objects_and_extending

latex: 
	latex $(DOC)

latex-full:
	latex $(DOC)
	latex $(DOC)
	latex $(DOC)
	makeindex $(DOC).idx
	latex $(DOC)

ps:
	dvips $(DOC)

pdf:
	dvipdfm -p a4 $(DOC)

html:
	latex2html -split 4 -show_section_numbers -short_index \
	-local_icons -noaddress -up_url http://www.iki.fi/tuomov/ion/ \
	-up_title "Ion homepage" $(DOC)

all: fntexes latex html

fntexes: $(FNTEXES)

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
