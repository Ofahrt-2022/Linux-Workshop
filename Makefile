OUT_DIR := build/
DEBUG_DIR := debug/
FILES := $(filter-out readme.md, $(wildcard *.md))

all: debug compile

# $1: input file
# $2: output directory
# $3: environment variables
define compile_pandoc
	$(3) pandoc -t beamer --template=template.tex --pdf-engine lualatex --slide-level 2 --metadata-file=metadata.yaml "$(1)" -o $(2)
endef

# $1: input file
# $2: output file
# $3: environment variables
define build_pandoc
	$(eval ODIR := $(dir $(2)))
	@mkdir -p $(ODIR)
	$(eval DIR := $(dir $(1)))
	$(eval FILE := $(notdir $(1)))
	@echo "Compiling $(FILE) in $(DIR)..."
	$(call compile_pandoc,$(1),$(2),$(3))
endef

$(FILES:.md=.md.regular):
	$(eval FILE := $(patsubst %.md.regular,%.md,$@))
	$(eval NOTDIRFILE := $(notdir $(FILE)))
	$(call build_pandoc,$(FILE),$(OUT_DIR)$(NOTDIRFILE:.md=.pdf),)

$(FILES:.md=.md.darkmode):
	$(eval FILE := $(patsubst %.md.darkmode,%.md,$@))
	$(eval NOTDIRFILE := $(notdir $(FILE)))
	$(call build_pandoc,$(FILE),$(OUT_DIR)$(NOTDIRFILE:.md=-darkmode.pdf),DARK_MODE=1)

$(FILES:.md=.md.debug.regular):
	$(eval FILE := $(patsubst %.md.debug.regular,%.md,$@))
	$(eval NOTDIRFILE := $(notdir $(FILE)))
	$(call build_pandoc,$(FILE),$(DEBUG_DIR)$(NOTDIRFILE:.md=.tex),)

$(FILES:.md=.md.debug.darkmode):
	$(eval FILE := $(patsubst %.md.debug.darkmode,%.md,$@))
	$(eval NOTDIRFILE := $(notdir $(FILE)))
	$(call build_pandoc,$(FILE),$(DEBUG_DIR)$(NOTDIRFILE:.md=-darkmode.tex),DARK_MODE=1)

compile: $(FILES:.md=.md.regular) $(FILES:.md=.md.darkmode)
	@echo "PDFs can be found in $(OUT_DIR)"

debug: $(FILES:.md=.md.debug.regular) $(FILES:.md=.md.debug.darkmode)
	@echo "Debug files can be found in $(DEBUG_DIR)"

clean:
	rm -f *.pdf

cleanBuild:
	@echo "Cleaning build..."
	@rm -rf build

cleanDebug:
	@echo "Cleaning debug..."
	@rm -rf debug

cleanAll: clean cleanBuild cleanDebug
