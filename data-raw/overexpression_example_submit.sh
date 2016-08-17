#!/bin/bash
#$ -S /bin/bash
#$ -q abaqus.q
#$ -l qname=abaqus.q
#$ -cwd
#$ -V
#$ -j y
#$ -o /home/hpc2862/repos/mineR/data-raw/$JOB_NAME.txt

Rscript ~/repos/mineR/data-raw/overexpression_example_script.R
