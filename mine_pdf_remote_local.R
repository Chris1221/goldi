cat("|----------------------|\n")
cat("|  Text Miner v 1.0.0  |\n")
cat("|     see source on    |\n")
cat("|        github        |\n")
cat("|                      |\n")
cat("|   ©2015 Chris Cole   |\n")
cat("|    CAMH Neurogen     |\n")
cat("|----------------------|\n")

cat("\n\nLoading required packages...\n")


install.packages("dplyr", repos = "http://cran.utstat.utoronto.ca/", quiet = T, verbose = F);library(dplyr, quietly = T, verbose = F, warn.conflicts = F)
install.packages("tm", repos = "http://cran.utstat.utoronto.ca/", quiet = T, verbose = F, type = "source");library(tm, quietly = T, verbose = F, warn.conflicts = F)
install.packages("SnowballC", repos = "http://cran.utstat.utoronto.ca/", quiet = T, verbose = F);library(SnowballC, quietly = T, verbose = F, warn.conflicts = F)
#library(wordcloud)

setwd("/Users/yvesmarcel/Documents/PDF_Mine")
command <- "mkdir .tmp"
system(command)

args<-commandArgs(TRUE)

pdf_name <- "new_paper.pdf"
#pdf_name <- "/Users/yvesmarcel/Desktop/ubiq.pdf"
#text_go <- "head_terms.txt"
#text_go <- "/Users/yvesmarcel/Desktop/GO_terms.txt"

command <- paste0("bash /Users/yvesmarcel/Documents/scripts/R/pdf_mine/format_pdf.sh ", pdf_name)
#system(command)
#command <- paste0("pdftotext ", pdf_name, " ", pdf_name,".txt")
#system(command)
#command <- paste0("iconv -f WINDOWS-1252 -t UTF-8 ", pdf_name, ".txt > ", pdf_name, ".temp.txt")
#system(command)
#command <- paste0("sed -e $'s/\\\./\\\n/g' ", pdf_name, ".temp.txt > ", pdf_name, ".txt")
#system(command)

replaceExpressions <- function(x) UseMethod("replaceExpressions", x)

replaceExpressions.PlainTextDocument <- replaceExpressions.character  <- function(x) {
    x <- gsub("-", " ", x, ignore.case =FALSE, fixed = TRUE)
    x <- gsub(".", "\n", x,ignore.case = FALSE, fixed = TRUE)
    x <- gsub("_", "\n", x,ignore.case = FALSE, fixed = TRUE)
    return(x)
}

text = paste0(getwd(), "/", pdf_name, ".txt")
raw <- readLines(text)
raw <- iconv(raw,"WINDOWS-1252","UTF-8") #this might not be a silver bullet, check the encoding
#raw <- raw[which(raw!="")]
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

#word cloud!!!
#freq.table %>% filter(counts > 3) -> freq.new; wordcloud(freq.new$words, freq.new$counts, colors = c("blue", "red", "green", "black", "purple"))
#word cloud!!!

sink("/dev/null")
pb <- txtProgressBar(min = 0, max = 100, style = 3)
sink()

cat("Text miner is currently running...\n\n")

for(n in 1:100){

  setTxtProgressBar(pb, n)

  text_go <- paste0("chunks/pdf_chunk_", n, ".txt")

  raw_go <- readLines(text_go, skipNul = T)
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

    if(row == 1){

      if(any(sums == 1)){
        terms <- c(terms, paste(name, sum(sums == 1, na.rm = TRUE)))
      }

    } else if(row == 2){

      if(any(sums == 2)){
        terms <- c(terms, paste(name, sum(sums == 2, na.rm = TRUE)))
      }

    } else if(row == 3){

      if(any(sums == 3)){
        terms <- c(terms, paste(name, sum(sums == 3, na.rm = TRUE)))
      }

    } else if(row == 4){

      if(any(sums == 4)){
        terms <- c(terms, paste(name, sum(sums == 3, na.rm = TRUE)))
      }

    } else if(row == 5){

      if(any(sums == 5)){
        terms <- c(terms, paste(name, sum(sums == 3, na.rm = TRUE)))
      }

    } else if(row == 6){

      if(any(sums == 6)){
        terms <- c(terms, paste(name, sum(sums == 4, na.rm = TRUE)))
      }

    } else if(row == 7){

      if(any(sums == 7)){
        terms <- c(terms, paste(name, sum(sums == 4, na.rm = TRUE)))
      }

    } else if(row == 8){

      if(any(sums == 8)){
        terms <- c(terms, paste(name, sum(sums == 5, na.rm = TRUE)))
      }

    } else if(row == 9){

      if(any(sums == 9)){
        terms <- c(terms, paste(name, sum(sums == 6, na.rm = TRUE)))
      }

    } else if(row == 10){

      if(any(sums == 10)){
        terms <- c(terms, paste(name, sum(sums == 7, na.rm = TRUE)))
      }

    } else if(row > 10){

      if(any(sums == 10)){
        terms <- c(terms, paste(name, sum(sums == 10, na.rm = TRUE)))
      }

    }
  }

  writeLines(as.character(terms), paste0(".tmp/terms_all", n, ".txt"), sep = "\n")

}

close(pb)
cat("\n Just cleaning things up...\n")

command <- "cat .tmp/terms_all*.txt > results/out_s.txt"
system(command)

command <- "rm -rf .tmp/"
system(command)

command <- paste0("rm ", pdf_name, ".txt ", pdf_name, ".temp.txt")
system(command)

cat("Text miner has finished. Have a nice day!")
