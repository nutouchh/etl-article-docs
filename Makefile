# One command builds the PDF from every Markdown chapter.
PANDOC ?= pandoc
PDF_ENGINE ?= xelatex

SOURCES := \
  docs/00-frontmatter.md \
  docs/01-introduction.md \
  docs/02-architecture.md \
  docs/03-transformer.md \
  docs/04-algorithm.md \
  docs/05-conclusion.md \
  docs/06-references.md \
  docs/07-formula-appendix.md

OTHER_INPUTS := assets/etl-architecture.png tex/preamble.tex filters/table_labels.lua
OUTPUT := build/article.pdf

.PHONY: all pdf check clean rebuild
all: pdf
pdf: $(OUTPUT)

$(OUTPUT): $(SOURCES) $(OTHER_INPUTS) Makefile
	mkdir -p build
	$(PANDOC) $(SOURCES) \
	  --from=markdown+raw_tex \
	  --standalone \
	  --metadata=lang:ru-RU \
	  --metadata=geometry:margin=2.2cm \
	  --variable=documentclass:extarticle \
	  --variable=fontsize:14pt \
	  --pdf-engine=$(PDF_ENGINE) \
	  --include-in-header=tex/preamble.tex \
	  --lua-filter=filters/table_labels.lua \
	  --resource-path=. \
	  --output=$(OUTPUT)

check: pdf
	python3 scripts/check_pdf.py $(OUTPUT)

rebuild: clean pdf

clean:
	rm -rf build
