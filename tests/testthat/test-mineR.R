context("Test the main function")
library(mineR)
#declare test variables

assign("terms", system.file("extdata", "pdf_chunk_1.txt", package = "mineR"), envir = .GlobalEnv)

assign("doc", system.file("extdata", "parkinson_mitochondria.pdf", package = "mineR"), envir = .GlobalEnv)

load("../../R/sysdata.rda")

test_that("testing main function", {
	expect_equal(suppressMessages(mineR(doc = doc, terms = terms, local = FALSE, length = length, output = "test.txt", lims = lims, log = log, return.as.list = TRUE, pdf_read = "R")), out)
})

