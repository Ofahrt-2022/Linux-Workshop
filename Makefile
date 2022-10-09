
linux-workshop.pdf: linux-workshop.md
	pandoc --filter pandoc-latex-fontsize --pdf-engine lualatex --to beamer -o $@ $<
