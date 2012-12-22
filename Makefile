# Regenerate the Markdown readme if the Doctools readme or module have changed
Readme.markdown: Readme.doctools markdown.doctools.tcl
	@./dt2md.tcl <Readme.doctools >Readme.markdown
	@more Readme.markdown
