#!/bin/bash
set -e

TEXLIVE_BIN=/media/depot/workspace/texlive/2011/bin/x86_64-linux

IN=$1

if [ -z "$IN" ]; then
  echo "$0: input.tex"
  exit 1
fi

PATH=$TEXLIVE_BIN:$PATH

# The long way 'round
#latex $IN
#dvips ${IN%.tex}.dvi
#dvipdf ${IN%.tex}.dvi

pdflatex $IN

pdftk ${IN%.tex}.pdf cat 2-1 output MartinWalsh.pdf
pdftk MartinWalsh.pdf cat 1 output MartinWalshCoverLetter.pdf
pdftk MartinWalsh.pdf cat 1 output MartinWalshResume.pdf

exit 0
