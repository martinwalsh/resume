#!/bin/bash
set -e

TEXLIVE_BIN=/media/depot/workspace/texlive/2011/bin/x86_64-linux

IN=$1
LABEL=${IN%.tex}

if [ -z "$IN" ]; then
  echo "$0: input.tex"
  exit 1
fi

PATH=$TEXLIVE_BIN:$PATH

# latex2html settings
LATEX=$TEXLIVE_BIN/latex

# The long way 'round
#latex $IN
#dvips $LABEL.dvi
#dvipdf $LABEL.dvi

pdflatex $IN

### latex2html (scrapped)
### 1 html file, no 'about this document' section
## latex2html -split +0 -info 0 -no_navigation $IN

### convert to txt
## lynx -dump "$LABEL/index.html" > $LABEL.txt

## rm -r $LABEL/

# plain text version
latex $IN
catdvi -e 1 -U $LABEL.dvi | sed -re "s/\[U\+22C6\]/*/g" | sed -re "s/([^^[:space:]])\s+/\1 /g" |  sed -re "s/\[U\+2709\]/                                                                                  /g" | sed -re "s/\[U\+00E9\]/e/g"  > $LABEL.txt

# reorder/organize output
pdftk $LABEL.pdf cat 2-1 output MartinWalsh.pdf
pdftk MartinWalsh.pdf cat 1 output MartinWalshCoverLetter.pdf
pdftk MartinWalsh.pdf cat 2 output MartinWalshResume.pdf

exit 0
