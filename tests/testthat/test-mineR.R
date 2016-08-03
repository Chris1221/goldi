context("Test the main function")
library(mineR)
#declare test variables

assign("terms", system.file("extdata", "pdf_chunk_1.txt", package = "mineR"), envir = .GlobalEnv)

assign("doc", system.file("extdata", "parkinson_mitochondria.pdf", package = "mineR"), envir = .GlobalEnv)


test_that("testing main function", {
	expect_equal(suppressMessages(mineR(doc = pdf2, terms = chunk, local = FALSE, length = length, output = "test.txt", syn = TRUE, lims = test_lim, syn.list =syn.list, log = log, return.as.list = TRUE)), out)
})

