## mineR clean version 0.1

mineR <- function(doc = character(), terms = character(), local = FALSE, lims = list(), output = character(), wd = getwd()){

	# error check input for missingness

	if(is.null(doc)){
		stop("Please input a file path (local = FALSE) or R object (local = TRUE) as your input object.")
	} else if(is.null(terms)){
		stop("Please input a file path (local = FALSE) or R object (local = TRUE) as your list of terms.")
	} else if(is.null(local)){
		stop("Please indicate whether you will specify file paths (FALSE) or R objects (TRUE)")
	} else if(is.null(lims)){
		stop("Please specify limits as a list or use the inbuilt function for limit construction")
	} else if(is.null(output)){
		stop("Please specify output file path")
	}


	# system calls to format pdf 
	# assume if its in R then its already formatted


	if(local == TRUE){
		system(paste0("pdftotext ", doc, " ", doc, ".txt")
		system()
	}

}