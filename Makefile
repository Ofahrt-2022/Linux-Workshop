
linux-workshop.pdf: linux-workshop.md
	pandoc --pdf-engine lualatex --to beamer -o $@ $<
