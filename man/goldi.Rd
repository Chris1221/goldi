% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/goldi.R
\name{goldi}
\alias{goldi}
\title{Identify terms present in document.}
\usage{
goldi(doc,
  terms = "You must put your terms here if not using a precomputed TDM.",
  lims = c(1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 8), output, syn = FALSE,
  syn.list = NULL, object = FALSE, log = NULL, reader = "local",
  term_tdm = NULL, log.level = "warn")
}
\arguments{
\item{doc}{Either a file path to a document which will be read in, or a string already read into R. See \code{"reader"} for more details. Depending on the \code{"reader"} selected, there are four options for document input.}

\item{terms}{Either a character vector of terms, with each element being a separate term, or a file path to a newline seperated text document which may be parsed into terms.}

\item{lims}{Number of identical (or synonymous) words which must be present in a sentence in order for it to be accepted as a match for the term. "interactive" is default and allows you to interavtively build your own list, but a list or vector of n elements can be supplied where n is the largest term you wish to search for.}

\item{output}{path to output file}

\item{syn}{If you would like to use synonyms, set \code{"syn = TRUE"} with \code{"syn.list"} left as default to launch the interactive generator (\code{"goldi::make.syn()"}), or give a list if synonyms are already formatted.}

\item{syn.list}{LIST of synonyms to be used. First element of each list item is the word that will counted if any of the other elements of that list item are present.}

\item{object}{Return as an R object?}

\item{log}{If specified, the path to the log you wish to keep.}

\item{reader}{Option for how to read in the text files. See details.}

\item{term_tdm}{If using a precompiled TDM.}

\item{log.level}{Logging level. See \code{?flog.threshold} for details.}
}
\value{
A data frame of terms and their context within the document.
}
\description{
This function takes as input a document which the user wishes to mine, a list of terms which they wish to identify, and an acceptance function for deciding on associations. This is the main function of the package; all others are helper functions, exported for your convenience. For full instructions on this function's usage, please see the documentation at github.com/Chris1221/goldi, or read the associated publication.  We recommend it as background regardless.
}
\examples{
\dontrun{

# Give the free form text
doc <- "In this sentence we will talk about ribosomal chaperone activity."

# Load in the included term document matrix for the terms
data("TDM.go.df")

# Pipe output and log to /dev/null
output = "/dev/null"
log = "/dev/null"

# Run the function
goldi(doc = doc,
      term_tdm = TDM.go.df,
      output = output,
      log = log,
      object = TRUE)

}

}
\references{
See ArXiv prepubliation.
}
\author{
Christopher B. Cole <chris.c.1221@gmail.com>
}
\keyword{Databases}
\keyword{Gene}
\keyword{Mining,}
\keyword{Ontology,}
\keyword{Text}
