DOC=objects_and_extending

latex:
	latex $(DOC)

latex-full:
	latex $(DOC)
	latex $(DOC)
	latex $(DOC)
	makeindex $(DOC).idx
	latex $(DOC)

html:
	latex2html -split 4 -show_section_numbers -short_index \
	-local_icons -noaddress -up_url http://www.iki.fi/tuomov/ion/ \
	-up_title "Ion homepage" $(DOC)

all: latex html
