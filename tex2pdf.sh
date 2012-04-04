#!/bin/bash

TEXLIVE_BIN=/media/depot/workspace/texlive/2011/bin/x86_64-linux

IN=$1

if [ -z "$IN" ]; then
  echo "$0: input.tex"
  exit 1
fi

PATH=$TEXLIVE_BIN:$PATH

#latex $IN
#dvips ${IN%.tex}.dvi
#dvipdf ${IN%.tex}.dvi
pdflatex $IN

exit 0
