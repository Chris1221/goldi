#' Text Miner
#'
#' Fuzzy identification of key phrases from natural language
#'
#' @param doc document which will be mined for keywords as a file path (character()).
#' @param terms list of newline seperated key phrases of varying lengths to be identified.
#' @param local currently only F is supported.
#' @param lims Number of identical (or synonymous) words which must be present in a sentence in order for it to be accepted. "interactive" is default and allows you to interavtively build your own list, but a list of n elements can be supplied where n is the largest term you wish to search for.
#' @param output path to output file
#' @param wd working directory if different than getwd()
#' @param length maximum length of term in words that you would like to search for.
#' @param syn TRUE if synonyms are to be used (also see syn.list), FALSE if no synonyms are to be used.
#' @param syn.list LIST of synonyms to be used. First element of each list item is the word that will counted if any of the other elements of that list item are present.
#' @param return.as.list Mostly used for testing, returns output as an R (character) object instead of writing to a file.
#'
#' @import tm
#' @import Rcpp
#' @import dplyr
#' @import SnowballC
#' @import pdftools
#'
#' @return A text document at wd/output if local == FALSE, or an R object if local == TRUE.
#'
#' @export

mineR <- function(doc = NULL, terms = NULL, local = FALSE, lims = "interactive", output = NULL, syn = FALSE, syn.list = NULL, length = 10, wd = getwd(), return.as.list = FALSE){

	# error check input for missingness

  message("Checking format of input variables...")

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


	#decide between interactive or given list
	if(lims == "interactive" | lims == "i"){
		lims <- make.lim()
	} else if(typeof(lims) == "character"){
		stop("Please enter lims as a list or vector")
	} else if(typeof(lims) == "vector" || typeof(lims) == "double"){
		lims <- as.list(lims)
		message("Using alternate format for list...")
	} else if(typeof(lims) == "list"){
	  message("Using custom list...")
	}

	raw <- pdf_text(doc)
	
	raw <- unlist(strsplit(raw, split = ".", fixed = TRUE))


	doc.vec <- VectorSource(raw)
	doc.corpus <- Corpus(doc.vec)

	message("Quality control and constructing TDM...")

	doc.corpus <- tm_map(doc.corpus, content_transformer(tolower), mc.cores = 1)
	doc.corpus <- tm_map(doc.corpus, content_transformer(replaceExpressions), mc.cores = 1)
	doc.corpus <- tm_map(doc.corpus, removePunctuation, mc.cores = 1)
	doc.corpus <- tm_map(doc.corpus, removeNumbers, mc.cores = 1)
	doc.corpus <- tm_map(doc.corpus, removeWords, stopwords("english"), mc.cores = 1)
	doc.corpus <- tm_map(doc.corpus, stemDocument)
	doc.corpus <- tm_map(doc.corpus, stripWhitespace)


	TermDocumentMatrix(doc.corpus) %>% as.matrix() %>% as.data.frame() -> TDM.df

	TDM.df$words <- row.names(TDM.df)
	TDM.df$counts <- 0

	n <- ncol(TDM.df) - 2

	for(i in 1:nrow(TDM.df)){
	  TDM.df[i,n+2] <- sum(TDM.df[i,1:n])
	}

	TDM.df %>% select(words,counts) -> freq.table

	message("Reading in term list and formatting...")

	if(!local){

	  raw_go <- readLines(paste0(terms), skipNul = T)

	} #else if(local){
	#	stop("Unhandled excpetion, see documentation.")
	#}

	raw_go <- iconv(raw_go,"WINDOWS-1252","UTF-8") #this might not be a silver bullet, check the encoding
	raw_go <- raw_go[which(raw_go!="")]

	doc.vec <- VectorSource(raw_go)
	doc.corpus <- Corpus(doc.vec)
	raw.corpus <- doc.corpus # for use later

	message("Quality control and constructing TDM...")

	doc.corpus <- tm_map(doc.corpus, content_transformer(tolower), mc.cores = 1)
	doc.corpus <- tm_map(doc.corpus, content_transformer(replaceExpressions), mc.cores = 1)
	doc.corpus <- tm_map(doc.corpus, removePunctuation, mc.cores = 1)
	doc.corpus <- tm_map(doc.corpus, removeNumbers, mc.cores = 1)
	doc.corpus <- tm_map(doc.corpus, removeWords, stopwords("english"), mc.cores = 1)
	doc.corpus <- tm_map(doc.corpus, stemDocument)
	doc.corpus <- tm_map(doc.corpus, stripWhitespace)

	TermDocumentMatrix(doc.corpus) %>% as.matrix() %>% as.data.frame() -> TDM.go.df

	#make the headers of the data frame the same as the terms
	sub <- gsub(" ", "_", x = raw_go)
	sub <- gsub("-", "_", x = sub)

	colnames(TDM.go.df) <- sub


	## when subsetting, picking up terms with numbers AND actual sentences, so changing col names to be easily subsetable

	TDM.df$words <- NULL
	TDM.df$counts <- NULL
	colnames(TDM.df) <- paste0("PDF_Sentence_", 1:ncol(TDM.df))

		# maybe put this after the synonyms
	# merge(x = TDM.go.df, y = TDM.df, by = 'row.names') -> out
	# out[out == 1 | out == 2 | out == 3 | out == 4 | out == 5] <- 1
	# terms <- list()

	####### Synonym recognition here ########

	### note this isnt incorpoaroated yet, see issue #8

	if(syn){ # if the user wants synonyns

		# check if user provided syn list
		if(is.null(syn.list)){
			syn.list <- make.syn(T)
		} else if(!is.null(syn.list)){
			if(typeof(syn.list) == "list"){
			# syn list stays as is
			} else {
				stop("Please enter syn.list as a list")
			}
		}

		# read in as corpus
		syn.corp <- VectorSource(syn.list)
		syn.corp <- Corpus(syn.corp)

		syn.corp <- tm_map(syn.corp, content_transformer(tolower), mc.cores = 1)
		syn.corp <- tm_map(syn.corp, content_transformer(replaceExpressions), mc.cores = 1)
		syn.corp <- tm_map(syn.corp, removePunctuation, mc.cores = 1)
		syn.corp <- tm_map(syn.corp, removeNumbers, mc.cores = 1)
		syn.corp <- tm_map(syn.corp, removeWords, stopwords("english"), mc.cores = 1)
		syn.corp <- tm_map(syn.corp, stemDocument)
		syn.corp <- tm_map(syn.corp, stripWhitespace)

	#now find the first
		#for long synonym lists this would be REAAAALLLY slow

		for(i in 1:ncol(TDM.df)){
  		for(j in 1:length(syn.corp)){
  			for(k in 2:length(syn.corp[[j]]$content)){

  			  if(syn.corp[[j]]$content[1] %in% row.names(TDM.df) && syn.corp[[j]]$content[k] %in% row.names(TDM.df)){
    			  if(TDM.df[syn.corp[[j]]$content[k], i] != 0){
              TDM.df[syn.corp[[j]]$content[1], i] <- 1

    			  }
  			  }
  			}
  		}
		}

		merge(x = TDM.go.df, y = TDM.df, by = 'row.names') -> out

		out[out == 1 | out == 2 | out == 3 | out == 4 | out == 5] <- 1

		terms <- list()

	} else if(!syn){

		#no change in this
		merge(x = TDM.go.df, y = TDM.df, by = 'row.names') -> out

			# if word happens more than once jsut count it as once
			# jsut for simplicity
		out[out == 1 | out == 2 | out == 3 | out == 4 | out == 5] <- 1

		terms <- list()

	}

	message("Matching terms...")

	for(name in colnames(TDM.go.df)){

		# going to have to add in another step here
		# maybe only have to alter this?????
	  	out %>% filter(get(name, envir=as.environment(out)) == 1) %>% select(matches("PDF_Sentence_*")) -> out.test

		# this shouldnt change
	    row <- sum(TDM.go.df[,name] != 0) # n words in term

		# will need to alter this to add in the syns !!!! #
	    sums <- colSums(out.test) # n words from go.df that match

	    for(i in 1:length(lims)){
	    	if(row == i){
	    		if(any(sums == lims[[i]])){
	    			terms <- c(terms, paste(name, sum(sums == lims[[i]], na.rm = TRUE)))
	    		}
	    	}
	    }

	}


	message(paste0("Writing output to ", output))

	if(!local && !return.as.list){
		writeLines(as.character(terms), output, sep = "\n")
	}


	if(return.as.list) return(as.character(terms))

	# clean up
	# system(paste0("cat .tmp/terms_all*.txt > out.txt"))
	# system("rm -rf .tmp/")
	# system(paste0("rm ", doc, ".txt ", basename(doc), ".temp.txt"))

  #TEMPORARY
	#TDM.df <<- TDM.df
	#out <<- out
	#syn.corp <<- syn.corp

}
