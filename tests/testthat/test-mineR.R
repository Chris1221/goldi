context("Test the main function")
library(mineR)
#declare test variables

assign("terms", system.file("extdata", "pdf_chunk_1.txt", package = "mineR"), envir = .GlobalEnv)

assign("doc", system.file("extdata", "parkinson_mitochondria.pdf", package = "mineR"), envir = .GlobalEnv)

length = 10

lims <- list(1L, 1L, 3L, 4L, 5L, 6L, 7L, 8L, 9L)

log = "/dev/null"

test_that("testing main function", {
	expect_equal(suppressMessages(mineR(doc = doc, terms = terms, local = FALSE, length = length, output = "test.txt", lims = lims, log = log, return.as.list = TRUE, pdf_read = "R")), out)
})

