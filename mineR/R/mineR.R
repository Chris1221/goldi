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

	# library calls quietly


	install.packages("Rcpp", repos = "http://cran.utstat.utoronto.ca/", quiet = T, verbose = F);library(Rcpp, quietly = T, verbose = F, warn.conflicts = F)
	install.packages("dplyr", repos = "http://cran.utstat.utoronto.ca/", quiet = T, verbose = F);library(dplyr, quietly = T, verbose = F, warn.conflicts = F)
	install.packages("tm", repos = "http://cran.utstat.utoronto.ca/", quiet = T, verbose = F, type = "source");library(tm, quietly = T, verbose = F, warn.conflicts = F)
	install.packages("SnowballC", repos = "http://cran.utstat.utoronto.ca/", quiet = T, verbose = F);library(SnowballC, quietly = T, verbose = F, warn.conflicts = F)



	# system calls to format pdf 
	# assume if its in R then its already formatted
	# assume iconv and sed are installed, mention this in the docs. 

	if(!local){
		system(paste0("pdftotext ", doc, " ", doc, ".txt")
		system(paste0("iconv -f WINDOWS-1252 -t UTF-8 ", doc, ".txt > ", doc, ".temp.txt"))
		system(paste0("sed -e $'s/\\\./\\\n/g' ", doc, ".temp.txt > ", doc, "txt"))
		system(paste0("rm ", doc, ".temp.txt"))


	} else if(local) {
		stop("Unhandled exception, see documentation.")
	} else {
		stop("Uhandled exception, see documentation.")
	}

	# after formating, bring in to R
	## note: need to chunk to handle larger documents

	# def format call seperately
	# combine types into one file (replaceExpressions.R)

	# read in


	
	if(!local){
		text <- paste0(wd, "/", doc, ".txt")
		raw <- readLines(text)
		raw <- iconv(raw,"WINDOWS-1252","UTF-8") #this might not be a silver bullet, check the encoding
	} else if(local){
		stop("unhandled excepton")
	}

	raw <- unlist(strsplit(raw, split = ".", fixed = TRUE))


	doc.vec <- VectorSource(raw)
	doc.corpus <- Corpus(doc.vec)

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

	if(!local){

	  raw_go <- readLines(paste0(wd, "/", terms), skipNul = T)

	} if(local){
		stop("Unhandled excpetion, see documentation.")
	}

  raw_go <- iconv(raw_go,"WINDOWS-1252","UTF-8") #this might not be a silver bullet, check the encoding
  raw_go <- raw_go[which(raw_go!="")]

  doc.vec <- VectorSource(raw_go)
  doc.corpus <- Corpus(doc.vec)
  raw.corpus <- doc.corpus # for use later

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

  #error, not picking up ER as a word, figure this out.

  ## when subsetting, picking up terms with numbers AND actual sentences, so changing col names to be easily subsetable

  TDM.df$words <- NULL
  TDM.df$counts <- NULL
  colnames(TDM.df) <- paste0("PDF_Sentence_", 1:ncol(TDM.df))

  merge(x = TDM.go.df, y = TDM.df, by = 'row.names') -> out

  out[out == 1 | out == 2 | out == 3 | out == 4 | out == 5] <- 1

  terms <- list()

  for(name in colnames(TDM.go.df)){

   out %>% filter(get(name, envir=as.environment(out)) == 1) %>% select(matches("PDF_Sentence_*")) -> out.test

    row <- sum(TDM.go.df[,name] != 0)
    sums <- colSums(out.test)

    for(i in 1:length(lims)){
    	if(row == i){
    		if(any(sums == lims[[i]])){
    			terms <- c(terms, paste(name, sum(sums == lims[[i]], na.rm = TRUE)))
    		}
    	}
    }

  if(!local){
		writeLines(as.character(terms), ouput), sep = "\n")
	}

	# clean up 
	system(paste0("cat .tmp/terms_all*.txt > results/", doc, "_out.txt"))
	system("rm -rf .tmp/")
	system(paste0("rm ", doc, ".txt ", basename(doc), ".temp.txt"))


}