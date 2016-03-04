#' Construct synonym matrix for internal or external use
#'
#' @param return Return value (T) or stout (F). Defaults to T. 
#'
#' @export

make.syn <- function(return = TRUE) {
	
	# c is continue, i is number of synononyms
	c <- TRUE; i <- 1 # set up initials
	syn <- list()

	#enter into loop
	while(c){ #while continue is still true
		syn[[i]] <- as.character(readline(prompt = paste0("Enter the word you would like to add a synonym too: ")))
		
		# check for breaks 
		if(is.na(syn[[i]]) || is.null(syn[[i]])) {
			
			#stop if null or na
			stop("Incorrect input, please enter a character string.")
		} else if(syn[[i]] == "stop" || syn[[i]] == "Stop" || syn[[i]] == "-9"){
			#stop if user directed stop
			break
		} 

		# enter into synonym loop, this adds synonyms as elemetns of the list at syn[[i]]
		cc <- TRUE; j <- 1
		while(cc){

			syn2 <- as.character(readline(prompt = paste0("Please enter synonym ", j, " for ", syn[[i]][1], ":")))
			
			#check for breaks, else append to synonyms
			if(syn2 == "stop" || syn2 == "Stop" || syn2 == "exit" || syn2 == "-9" || syn2 == "next"){
				cc <- FALSE
			} else { 

				syn[[i]] <- c(syn[[i]], syn2)

			}
		}

		i = i+1
	}

}
