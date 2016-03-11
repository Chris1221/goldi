#' Set up for tests
#'
#' @export

test_mineR <- function(length = 10){

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

	lims <- list(1L, 2L, 3L, 4L, 5L, 6L, 7L, 8L, 9L)
  syn.list = list(c("abba", "research"))

	mineR(doc = pdf2, terms = chunk, local = FALSE, length = length, output = "test.txt", syn = TRUE, lims = lims, syn.list =syn.list)

}
