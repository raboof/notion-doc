# rapport3.perl by Tuomo Valkonen, <tuomov at iki.fi>, 2003-05-10
#
# Implementation of the documentclass for latex2html. Just make some
# sectioning commands saner and load report.
#

package main;

#
# Sections should start at H2 instead of the insane default H1.
#

%standard_section_headings =
  ('part' , 'H1' , 'chapter' , 'H1', 'section', 'H2', 'subsection', 'H3'
      , 'subsubsection', 'H4', 'paragraph', 'H4', 'subparagraph', 'H5');

&generate_sectioning_subs;

%section_headings =
  ('partstar' , 'H1' , 'chapterstar' , 'H1', 'sectionstar', 'H2'
      , 'subsectionstar', 'H3', 'subsubsectionstar', 'H4', 'paragraphstar'
      , 'H4', 'subparagraphstar', 'H5', %section_headings);

#
# These should be chapters in a report
#

%section_headings =
  ('tableofcontents', 'H1', 'listoffigures', 'H1', 'listoftables', 'H1'
      , 'bibliography', 'H1', 'textohtmlindex', 'H1'
      , %standard_section_headings
      , %section_headings);


&do_require_package("report");

1;

