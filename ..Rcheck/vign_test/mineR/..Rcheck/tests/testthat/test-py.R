context("Testing the py pdfmine functionality")
library(mineR)
#declare test variables


lim <- list()
	for(i in 1:10){
	lim[[i]] <- i
}

assign("chunk", system.file("extdata", "pdf_chunk_1.txt", package = "mineR"), envir = .GlobalEnv)

assign("pdf2", system.file("extdata", "parkinson_mitochondria.pdf", package = "mineR"), envir = .GlobalEnv)

assign("lim", lim, env = .GlobalEnv)
doc <- pdf2
terms <- chunk
local = FALSE
output = "test.txt"
length = 10

out <- c("lactase_activity 34", "mannosyltransferase_activity 34", "acyl_binding 1",
"peptidyltransferase_activity 34", "tRNA_binding 1", "SNARE_binding 1",
"recombinase_activity 34", "nucleotide_binding 2", "3'_5'_exoribonuclease_activity 34",
"rDNA_binding 1", "protein_binding 20", "nitrilase_activity 34",
"GTPase_activity 35", "endopolyphosphatase_activity 34", "base_pairing 2",
"legumain_activity 34", "lipopolysaccharide_binding 1", "galactoside_binding 1")


lims <- list(1L, 1L, 3L, 4L, 5L, 6L, 7L, 8L, 9L)
#syn.list = list(c("abba", "research"))
return.as.list <- TRUE

test_that("testing main function", {
	expect_equal(suppressMessages(mineR(doc = pdf2, terms = chunk, local = FALSE, length = length, output = "test.txt", syn = TRUE, lims = lims, syn.list =syn.list, return.as.list = TRUE, pdf_read="Py")), out)
})

