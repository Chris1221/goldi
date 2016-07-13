#!/usr/bin/Rscript

# ------------------------------------------------- #
#  Step 1: Install package from Github              #
# ------------------------------------------------- #

if(!require(devtools)) install.packages("devtools")
devtools::install_github("Chris1221/mineR", ref = "master")

library(mineR)

# ------------------------------------------------- #
#  Step 2: Take example documents                   #
# ------------------------------------------------- #

terms <- system.file("extdata", "pdf_chunk_1.txt", package = "mineR")
doc <- system.file("extdata", "parkinson_mitochondria.pdf", package = "mineR") 

# ------------------------------------------------- #
#  Step 3: Define acceptance function               #
#                                                   #
#          This can also be done interactively      #
#          if lims is left blank (defaults to NULL) #
# ------------------------------------------------- #

lims <- c(1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L)

# ------------------------------------------------- #
#  Step 4: Run function                             #
# ------------------------------------------------- #

mineR(doc = doc, terms = terms, lims = lims, output = "test.txt")  
