#' Construct Constraint Limits for Fuzzy Identification
#'
#' @param i interactive (TRUE) or specified list (FALSE)
#' @param list preconstructed list if i is FALSE
#' @param length number of parameters you wish to enter. Defaults to 5.

make.lim <- function(i=TRUE, list=NULL, length=5) {

	lims <- list()

	if(i){

		cat(" \t \t Welcome to mineR! \n ")
		cat("")
		cat(" \t To correctly match your terms, please provide the program with")
		cat("some information.  For a term of n size, please enter how many wods")
		cat("must be succesfully identified in a one sentence segment of the document")
		cat("which you are trying to mine. Enter -9 at any time to stop entering numbers")
		cat("or specify the l = n flag in the function to limit your input to a certain")
		cat("number of inputs.")

		for(i in 1:length){

			lims[[i]] <- as.integer(readline(prompt = paste0("For terms with ", i, " words, type how many matches are required: ")))
			if(is.na(lims[[i]])) stop("Please enter a number.")
			if(lims[[i]] == -9) {
				lims[[i]] <- NULL
				break
			}

		}

		cat("Thanks! Your input has been saved under lims, which will be used by mineR by default.")

	} else if(!i){
		lims <- list
		cat("Your list of constraints has been changed and saved under lims")
	}

	assign("lims", lims, env = .GlobalEnv)


} 