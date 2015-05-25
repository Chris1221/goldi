#!/bin/bash

TEXT=$1
pdftotext $TEXT $TEXT.txt
iconv -f WINDOWS-1252 -t UTF-8 $TEXT.txt > ${TEXT}.temp.txt
sed -e $'s/\\\./\\\n/g' ${TEXT}.temp.txt > ${TEXT}.txt
