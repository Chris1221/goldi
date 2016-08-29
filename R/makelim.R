#' Construct Constraint Limits for Fuzzy Identification
#'
#' @param int interactive (TRUE) or specified list (FALSE)
#' @param list preconstructed list if i is FALSE
#' @param length number of parameters you wish to enter. Defaults to 5.
#'
#' @export

make.lim <- function(int=TRUE, list=NULL, length=10) {

	lims <- list()

	if(int){

		message("Please provide some information, see http://chrisbcole.me/mineR for details. Enter -9 to stop entering at any time.")

		i = 1

		#using while loop becuase can't change the index of a for loop
		while(i < length){

			lims[[i]] <- as.integer(readline(prompt = paste0("For terms with ", i, " words, type how many matches are required: ")))

			if(is.na(lims[[i]])) stop("Please enter a number.")

			if(lims[[i]] == -9) {
				lims[[i]] <- NULL
				break
			}

			if(lims[[i]] > i) {
				message(" \n Number of terms to match exceeds number of words in term. Please try again or -9 to exit. \n")
				i = i-1
			}

			i = i+1

		}

		message("Thanks! Your input has been saved under lims, which will be used by mineR by default.")

	} else if(!int){
		lims <- list
		message("Your list of constraints has been changed and saved under lims")
	}

	return(lims)


}