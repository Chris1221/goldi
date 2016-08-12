context("Test the main function")
library(mineR)
#declare test variables

assign("terms", system.file("extdata", "pdf_chunk_1.txt", package = "mineR"), envir = .GlobalEnv)

assign("doc", system.file("extdata", "parkinson_mitochondria.pdf", package = "mineR"), envir = .GlobalEnv)

length = 10

lims <- c(1,2,3,3,4,5,6,6,7,8,9)

log = "/dev/null"

test_that("testing main function", {
	expect_equal(suppressMessages(mineR(doc = doc, terms = terms, local = FALSE, length = length, output = "test.txt", lims = lims, log = log, object = TRUE, pdf_read = "R")), out)
})

