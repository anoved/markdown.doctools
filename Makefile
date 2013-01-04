.PHONY: all

all: Readme.html

# Regenerate the Markdown readme if the Doctools readme or module have changed
Readme.markdown: Readme.doctools markdown.doctools.tcl
	./dt2md.tcl <Readme.doctools >Readme.markdown

Readme.html: Readme.markdown
	echo "<html><head><link rel="stylesheet" href="test.css" /></head><body>" >Readme.html
	/usr/bin/markdown Readme.markdown >>Readme.html
	echo "</body></html>" >>Readme.html
