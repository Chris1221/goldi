# Here we generate the molecular function terms used
# as a test case in many examples.
#
# First we begin by reading in the raw files drawn from the GO
# API. They are included in the extdata directory of the package
# so we fetch the path and read them in through data.table. Ensure this
# is installed prior to running the following commands.
#
# Load libraries

library(data.table)
library(dplyr)
library(magrittr)

path_to_terms <- system.file("extdata/MF_terms", package = "mineR")
MF_terms <- data.table::fread(path_to_terms)

# Drop all columns except for the term name and the GO Accession code
# which may be used in more complex analyses and fed back into
# the GO api.

MF_terms %>% select(V2, V4) -> MF_terms_accession

# Drop the second row as it is obsolete. A more complete analysis may be needed
# to get rid of rotten terms.

MF_terms_accession <- MF_terms_accession[-2,]

colnames(MF_terms_accession) <- c("terms", "GO")

save(MF_terms_accession, file = "data/MF_terms_acession.Rda")

# Now drop all the rows except for the term name, format into a vector
# and write back to /data/MF_term_names

MF_terms %<>% select(V2) %>% as.vector
colnames(MF_terms) <- "terms"

save(MF_terms, file = "data/MF_terms.Rda")