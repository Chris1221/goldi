#' @title Identify terms present in document.
#'
#' @description This function takes as input a document which the user wishes to mine, a list of terms which they wish to identify, and an acceptance function for deciding on associations. This is the main function of the package; all others are helper functions, exported for your convenience. For full instructions on this function's usage, please see the documentation at github.com/Chris1221/goldi, or read the associated publication.  We recommend it as background regardless.
#'
#'
#' @keywords Text Mining, Gene Ontology, Databases
#'
#' @author Christopher B. Cole <chris.c.1221@@gmail.com>
#'
#' @references See ArXiv prepubliation.
#'
#' @param doc Either a file path to a document which will be read in, or a string already read into R. See \code{"reader"} for more details. Depending on the \code{"reader"} selected, there are four options for document input.
#' @param terms Either a character vector of terms, with each element being a separate term, or a file path to a newline seperated text document which may be parsed into terms.
#' @param lims Number of identical (or synonymous) words which must be present in a sentence in order for it to be accepted as a match for the term. "interactive" is default and allows you to interavtively build your own list, but a list or vector of n elements can be supplied where n is the largest term you wish to search for.
#' @param output path to output file
#' @param syn If you would like to use synonyms, set \code{"syn = TRUE"} with \code{"syn.list"} left as default to launch the interactive generator (\code{"goldi::make.syn()"}), or give a list if synonyms are already formatted.
#' @param syn.list LIST of synonyms to be used. First element of each list item is the word that will counted if any of the other elements of that list item are present.
#' @param object Return as an R object?
#' @param log If specified, the path to the log you wish to keep.
#' @param term_tdm If using a precompiled TDM.
#' @param log.level Logging level. See \code{?flog.threshold} for details.
#' @param reader Option for how to read in the text files. See details.
#' @import tm
#' @import dplyr
#' @import SnowballC
#' @import futile.logger
#' @importFrom magrittr %<>%
#' @importFrom Rcpp sourceCpp
#' @importFrom utils capture.output packageVersion
#' @importFrom stats p.adjust
#'
#' @useDynLib goldi
#'
#' @examples
#' \dontrun{
#'
#' # Give the free form text
#' doc <- "In this sentence we will talk about ribosomal chaperone activity."
#'
#' # Load in the included term document matrix for the terms
#' data("TDM.go.df")
#'
#' # Pipe output and log to /dev/null
#' output = "/dev/null"
#' log = "/dev/null"
#'
#' # Run the function
#' goldi(doc = doc,
#'       term_tdm = TDM.go.df,
#'       output = output,
#'       log = log,
#'       object = TRUE)
#'
#' }
#'
#' @return A data frame of terms and their context within the document.
#'
#' @export

goldi <- function(doc,
		  terms = "You must put your terms here if not using a precomputed TDM.",
		  lims = c(1,2,3,3,4,5,6,6,7,8,8),
		  output,
		  syn = FALSE,
		  syn.list = NULL,
		  object = FALSE,
		  log = NULL,
		  reader = "local",
		  term_tdm = NULL,
		  log.level = "warn"){

	# Start timer
	ptm <- proc.time()

	# Creating header for log file.
	pv <- packageVersion("goldi")

	header <- paste0(

"@------------------------------------------------------@
|     goldi     |     v",pv,"     |   3/Aug/2016   |
| ---------------------------------------------------- |
|         (C) Christopher B. Cole, MIT License         |
| ---------------------------------------------------- |
|  For documentation, citation, bug reports, and more: |
|          http://github.com/Chris1221/goldi           |
@ ---------------------------------------------------- @

For your reference, here is a list of your input options:

	terms:", capture.output(dput(terms)), "
	local:", capture.output(dput(local)), "
	lims:", capture.output(dput(lims)), "
	output:", capture.output(dput(output)), "
	syn:", capture.output(dput(syn)), "
	syn.list:", capture.output(dput(syn.list)), "
	return.as.list:", capture.output(dput(return.as.list)), "
	log:", capture.output(dput(log)), "
	reader:", capture.output(dput(reader)),"

To recreate this exact run at a later date, you may reinput these options.

Note that any interactively created lists may be saved and inputed.

")



	# --------------------- BEGIN FUNCTION -------------------------------------- #

	# 	Start by defining the logging appender, if provided.
	# 		If the logger is a character, this indicates that the user
	# 		has provided a file path. Write to it.

	if(log.level == "info"){
	    flog.threshold(INFO)
	} else if(log.level == "warn"){
	  flog.threshold(WARN)
	} else if(log.level == "fatal"){
	  flog.threshold(FATAL)
	}


	if(typeof(log) == "character") {
		cat(header, file = log, append = TRUE)
		futile.logger::appender.file(log)
		flog.info("Logging has been enabled. Logging to file `%s`", log)
	}


	#	Decide on thresholds (limits) to be used as cut off.
	#		If the user has left the section blank, or has specified interaction
	#		then allow them to build it interactively using the make.lim() function.
	#
	#		If the user has provided a character string for the lims, they have misunderstood
	#		the input format, and must enter it as a vector or a list.
	#
	#		Try to coerce into list anyway if given as vector or a vector of doubled.
	#
	#		If the user has correctly entered the limits as a list, log the list and
	#

	if(lims == "interactive" || lims == "i"){
		lims <- make.lim()
	} else if(typeof(lims) == "character"){

		stop()
		flog.fatal("Improper limit input. Please see the documentation and try again.")

	} else if(typeof(lims) == "vector" || typeof(lims) == "double"){

		lims <- as.list(lims)

		flog.debug("Trying to coerce limits to list format.")
		flog.info("Printing your lims to log file. You can use this to recreate your list later:")

		flog.info("%s", capture.output(dput(lims)))

	#	Print to log if it is being used
	#		For some strange reason there is no append option in dput
	#		So for now just sink it.
	#	if(typeof(log) == "character") {
	#		sink(log, append = TRUE)
	#		dput(lims, file = log)
	#		sink()
	#	}
	#	Else if print to std out.
	#	if(typeof(log) != "character"){
	#		dput(lims)
	#	}


	} else if(typeof(lims) == "list"){

		flog.info("Using custom list.")
		flog.info("Printing out your list now. You can use this later")

		flog.info("%s", capture.output(dput(lims)))
	#       Print to log if it is being used
        #               For some strange reason there is no append option in dput
        #               So for now just sink it.
        #        if(typeof(log) == "character") {
        #                sink(log, append = TRUE)
        #                dput(lims, file = log)
        #                sink()
        #        }
        #       Else if print to std out.
        #        if(typeof(log) != "character"){
        #                dput(lims)
        #        }
	}


	# ---------------------- READING IN INPUT ----------------------------------- #
	#
	# 	Read the PDF in R through pdftools::pdf_text (this is probably fastest but does not handle 2 columns)
	# 		If need two column, need to use "py".
	if(reader == "R") {

	  raw <- pdftools::pdf_text(doc); flog.info("Reading in input through pdftools::pdf_text. If you get any warnings, see their documentation.")
	  }
	#	If the PDF is already converted, just read the txt
	#		This is best for power users who want to convert beforehand
	#		and check QC.
	if(reader == "txt") raw <- readLines(doc); flog.info("Reading in input through base::readLines.")

	# 	If the PDF has two columns / is more complex, resort to external python calls
	# 		Note that submodule will have to be init if the repo is cloned from github
	# 		tarball should have it already Init, but check this to make sure.
	if(reader == "Py") {

		flog.info("Reading in input through pdfminer. This might not work; you might have to download it yourself, then read in input through txt options.")

	#	Try to find the pdf2txt python program
	#		Also try to find the directory for trouble shooting.
		py <- system.file(package = "goldi", "pdf2txt.py")
		#py_dir <- system.file(package = "goldi", "pdfminer")

	# 	Error Chcecking
		#if(nchar(py) == 0) {

			#flog.warn("pdfminer is either missing or incorrectly configured.  Attempting to fix the issue but no promises.")

			#if(system("git --version 2>&1 >/dev/null; echo $?", intern = TRUE, ignore.stderr = FALSE, ignore.stdout=FALSE) != "0") warning("git might not be properly installed either, but I'm going to try to use it anyway. You need it to initialize the subdirectory for the pythong pdfminer.")

			# Is the directory empty? If so, git init the submodules

			#if(length(list.files(py_dir)) == 0) system(paste0("git -C ", py_dir, " submodule init"))

			# Check to see if it worked

			#if(length(list.files(py_dir)) == 0) stop(); flog.fatal("I was unable to fix the problem. Please either initialize the submodule yourself or raise an issue on Github to discuss the problem")
		#}

	#	Abandon this for now.
	#		Maybe try to fix later.

		#} else if(length(list.files(py_dir)) != 0 & nchar(py) == 0) {

		#warning("You seem to have the directory initialized but the pdf2txt.py is not present. I'm going to try to set up the python package for you.")

		#status <- system(paste0("python ", py_dir, "/setup.py install 2>&1 >/dev/null; echo $?"), intern = TRUE)

		#if(status == "0") message("Set up of python pdfminer was successful!")
		#if(status != "0") stop("Set up not succesful, please see online documentation or raise an issue on github.")

		#}

	# Read in through PDFminer
		raw <- system(paste(py, doc), intern = TRUE)

	}

	if(reader == "local") raw <- doc


	# Perform Quality control on input and create term document matrix.
	raw <- unlist(strsplit(raw, split = ".", fixed = TRUE))


	doc.vec <- VectorSource(raw)
	doc.corpus <- Corpus(doc.vec)
	
	## June 23 2017: For some reason this no longer works 
	#sentences <- unlist(doc.vec[5][[1]])

	#	This might not be a totally perfect solution 
	#	but maybe it will work for now?

	sentences <- unlist(doc.vec$content)

	# Maybe try to test more cases later
# * 
# !
# *



	flog.info("Quality control and constructing TDM...")

	doc.corpus <- tm_map(doc.corpus, content_transformer(tolower))
	doc.corpus <- tm_map(doc.corpus, content_transformer(replaceExpressions))
	doc.corpus <- tm_map(doc.corpus, removePunctuation)
	doc.corpus <- tm_map(doc.corpus, removeNumbers)
	doc.corpus <- tm_map(doc.corpus, removeWords, stopwords("english"))
	doc.corpus <- tm_map(doc.corpus, stemDocument)
	doc.corpus <- tm_map(doc.corpus, stripWhitespace)


	TermDocumentMatrix(doc.corpus) %>% as.matrix() %>% as.data.frame() -> TDM.df

	TDM.df$words <- row.names(TDM.df)
	TDM.df$counts <- 0

	n <- ncol(TDM.df) - 2

	for(i in 1:nrow(TDM.df)){
	  TDM.df[i,n+2] <- sum(TDM.df[i,1:n])
	}

	TDM.df %>% select_("words","counts") -> freq.table

	flog.info("Constuction of PDF TDM succesful.")

	flog.info("Reading in term list and formatting.")
	flog.info("Note that we are only currently supporting text input for the term list.")

	#	Read in the terms through R
	#		Note that later, we should make this more flexible.

	if(is.null(term_tdm)){

		  raw_go <- readLines(paste0(terms), skipNul = T)

		#	Perform the same quality control on the terms that was done on the PDF.

		flog.info("Reading in of term list successful")
		flog.info("Performing quality control for term list")

		raw_go <- iconv(raw_go,"WINDOWS-1252","UTF-8") #this might not be a silver bullet, check the encoding
		raw_go <- raw_go[which(raw_go!="")]

		doc.vec <- VectorSource(raw_go)
		doc.corpus <- Corpus(doc.vec)
		raw.corpus <- doc.corpus # for use later

		flog.info("Constructing TDM for term list")

		doc.corpus <- tm_map(doc.corpus, content_transformer(tolower))
		doc.corpus <- tm_map(doc.corpus, content_transformer(replaceExpressions))
		doc.corpus <- tm_map(doc.corpus, removePunctuation)
		doc.corpus <- tm_map(doc.corpus, removeNumbers)
		doc.corpus <- tm_map(doc.corpus, removeWords, stopwords("english"))
		doc.corpus <- tm_map(doc.corpus, stemDocument)
		doc.corpus <- tm_map(doc.corpus, stripWhitespace)

		TermDocumentMatrix(doc.corpus) %>% as.matrix() %>% as.data.frame() -> TDM.go.df

		#	Make the headers of the data frame the same as the terms

		sub <- gsub(" ", "_", x = raw_go)
		sub <- gsub("-", "_", x = sub)

		colnames(TDM.go.df) <- sub
	} else if(!is.null(term_tdm)){
		TDM.go.df <- term_tdm
	}

	#	 When subsetting, picking up terms with numbers AND actual sentences, so changing col names to be easily subsetable

	TDM.df$words <- NULL
	TDM.df$counts <- NULL
	colnames(TDM.df) <- paste0("PDF_Sentence_", 1:ncol(TDM.df))

		# maybe put this after the synonyms
	# merge(x = TDM.go.df, y = TDM.df, by = 'row.names') -> out
	# out[out == 1 | out == 2 | out == 3 | out == 4 | out == 5] <- 1
	# terms <- list()

	flog.info("Term TDM construction successful")

	# ---------------------- Synonym recognition here --------------------- #

	#	Looking for synonyms from the synonym list
	#		This should really be done in cpp, given enough time.

	flog.info("Incorporating synonyms")

	#	If the user has provided syn == TRUE, then enter into the synonym cycle.
	#		If not, bypass it entirely.
	if(syn){

	#	If the user has not provided a syn list (i.e. it defaulted to NULL)
	#		but has set syn to TRUE, allow them to construct a list
	#		using the inbuilt function.

		if(is.null(syn.list)){

			flog.info("Please follow the instructions to create your synonym list.")
			syn.list <- make.syn(T)

		} else if(!is.null(syn.list)){

	#	If the syn list is already a list, assume that it is properly formated
	#		and accept it as the synonym list.

			if(typeof(syn.list) == "list"){

				flog.info("Using already existing synonym list.")

			} else {
				flog.fatal("You have provided a synonym list, but it is not formated as a base::list(). Please reformat it correctly, or see the documentation for examples.")
				stop()
			}
		}

	#	Read in synonyms as corpus.
	#		Performing the same QC as performed on the other two sections

		flog.info("Performing QC on synonyms")

		syn.corp <- VectorSource(syn.list)
		syn.corp <- Corpus(syn.corp)

		syn.corp <- tm_map(syn.corp, content_transformer(tolower))
		syn.corp <- tm_map(syn.corp, content_transformer(replaceExpressions))
		syn.corp <- tm_map(syn.corp, removePunctuation)
		syn.corp <- tm_map(syn.corp, removeNumbers)
		syn.corp <- tm_map(syn.corp, removeWords, stopwords("english"))
		syn.corp <- tm_map(syn.corp, stemDocument)
		syn.corp <- tm_map(syn.corp, stripWhitespace)


	# 	Find the first synonym.
	#		This should REALLY be implimented in CPP.

		flog.info("Matching synonyms.")

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

	#	If there is more than one of a word in a sentence, set it just to one.

		out[out == 1 | out == 2 | out == 3 | out == 4 | out == 5] <- 1

		terms <- list()

	} else if(!syn){

		flog.info("No synonyms selected")

	#	No change in this
		merge(x = TDM.go.df, y = TDM.df, by = 'row.names') -> out

	# 	Ff word happens more than once jsut count it as once
	# 		Just for simplicity
		out[out == 1 | out == 2 | out == 3 | out == 4 | out == 5] <- 1

		#terms <- list()

	}

	flog.info("Matching terms")


	# ------------------------ MATCHING TERMS --------------------------- #
	#
	#	In this section, we take the terms and the PDF, find their intersection
	#		and identify how many of the terms cooccur in a given sentence.
	#
	#	This is the slowest portion of the program, and is being rewritten in
	#		c++11 to improve performance.

	#   Return the vector of where each term is in the OUT data frame
	#     by column.
  term_vector <- which(colnames(out) %in% colnames(TDM.go.df))
  #term_vector <- term_vector - 1

  pdf_index <- which(grepl("PDF_Sentence", colnames(out))) - 1

  # Clean this up after, it's really messy right now

  suppressWarnings( out %>% as.data.frame %>% data.matrix ) -> input_pdf_tdm
  colnames(input_pdf_tdm) <- NULL
  row.names(input_pdf_tdm) <- NULL

  input_term_tdm <- as.matrix(TDM.go.df)
  input_term_tdm %<>% as.data.frame %>% data.matrix %>% suppressWarnings()
  colnames(input_term_tdm) <- NULL
  row.names(input_term_tdm) <- NULL

  terms <- colnames(TDM.go.df)

  # This is earlier in the code, but just to remember this is what it is
# sentences <- unlist(doc.vec[5][[1]])



  #################### OLD TERM MATCHING ########################

	#	For each column, grab all PDF sentence and put in out.test
  # Flush terms before using it again.
  #terms <- list()
	#for(name in colnames(TDM.go.df)){

	#	out %>% filter(get(name, envir=as.environment(out)) == 1) %>% select(starts_with("PDF_Sentence_")) -> out.test

	#	Get row sums of this term per PDF sentence

	#	row <- sum(TDM.go.df[,name] != 0)
	#	sums <- colSums(out.test)


	 #   for(i in 1:length(lims)){
	  #  	if(row == i){
	   # 		if(any(sums == lims[[i]])){
	    #			terms <- c(terms, paste(name, sum(sums == lims[[i]], na.rm = TRUE)))
	    #		}
	    #	}
	    #}

	#}


  terms <- match(term_vector = term_vector, pdf_tdm = input_pdf_tdm, term_tdm = input_term_tdm, thresholds = unlist(lims), pdf_index, terms, sentences)

	flog.info("Writing output to %s", output)

	time <- proc.time() - ptm
	flog.info("This run took approximately %s seconds.", round(as.double(time[3]), 3))

	flog.info("Everything was successful. Ending logging now. Have a nice day.")

	colnames(terms) <- c("Identified Terms", "Context")

	if(!object){

		flog.info("Returning as List, either for internal use or for testing.")
		writeLines(as.character(terms), output, sep = "\n")
	}


	if(object) return(terms)


}
