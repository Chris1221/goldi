#' Set up for tests
#'
#' @export

test_mineR <- function(){
	
	lim <- list()
	for(i in 1:10){
    	lim[[i]] <- i
	}

	lim <<- lim

	system.file("extdata", "pdf_chunk_1.txt", package = "mineR") ->> chunk

	system.file("extdata", "parkinson_mitochondria.pdf", package = "mineR") ->> pdf2

}