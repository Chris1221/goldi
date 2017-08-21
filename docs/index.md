# Introduction

Gene Ontology is a public database which, among other things, classifies gene functions according to the molecular functions involved, the cellular compartment where the product is active, and the relevant biological pathways in which they play a part. These classes, or "terms", are highly useful in molecular biology, and are often referred to in the literature. However, with the size and complexity of biomedical publications, this information is often difficult to study in aggregate.  

`goldi` is a tool for identifying key terms in text. It has been developed with the intention of identifying ontological labels in free form text with specific application to finding Gene Ontology terms in the biomedical literature with strict canonical NLP quality control.

This package performs a few main objectives:

- Identifies terms in free text (we distribute the package with a set of Molecular Function terms from Gene Ontology for easy use)
- Summarizes the quantity and quality of annotations across a corpus
- Provides helpful functions for working with `goldi` class objects, including enrichment tests between two corpora. 

`goldi` is freely distributed on CRAN and Github, and bug reports are always welcome. 

Please see the other pages on this website for description of the main functions, as well as some examples of `goldi` in the real world. 


## Installation

`goldi` can be installed from CRAN with

```R
install.packages("goldi")
```

Or, you may choose to install the latest stable development version with

```R
devtools::install_github("Chris1221/goldi")
```

## Status 

The package is currently checked on `R-oldrel` (v`3.3.3`), `R-release` (v`3.4.0`), and `R-devel` (v`3.5.0`) on

- [Ubuntu LTS 14.06 on Travis-CI](https://travis-ci.org/Chris1221/goldi)
- [XCode 8.3 on OSX 10.13 on Travis-CI](https://travis-ci.org/Chris1221/goldi)
- Winbuilder 

If you notice any issues, please raise it on the repository!

## Minimal Example

`goldi` attempts to identify terms in free text through semantic similarity. This means that if a term and a sentence share a high number of words, the sentence has a higher probability of talking about the term.

Given the following input text and the included pre-computed term document matrix for approximately 10,000 Gene Onotlogy molecular function terms, we can find which are discussed in our text.

```R
# Give the free form text
doc <- "In this sentence we will talk about ribosomal chaperone activity. In this sentence we will talk about nothing. Here we discuss obsolete molecular terms."

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
```

Note in the above example, we impliment a few other options. Firstly, we don't want to see the output or the log for this example, so we pipe them to `/dev/null`. Secondly, we would like to return the output as an R object instead of writing it to a file, so we specify `object = TRUE`. 

This will output the following table:

|          Term                |                               Context                            |
| ---------------------------- | ---------------------------------------------------------------  |
| ribosomal_chaperone_activity | In this sentence we will talk about ribosomal chaperone activity |

This will give the term identified and the context in the free form where it was identified. This table will form the basis for all further analysis.

## Getting help

For help, please post an issue on the repository.
