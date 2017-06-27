<script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script>

## goldi   ![Build Status](https://travis-ci.org/Chris1221/goldi.svg?branch=master) [![codecov](https://codecov.io/gh/Chris1221/goldi/branch/master/graph/badge.svg)](https://codecov.io/gh/Chris1221/goldi) ![CRAN_S- RcppCore/Rcpptatus_Badge](http://www.r-pkg.org/badges/version/goldi) ![](http://cranlogs.r-pkg.org/badges/grand-total/goldi) <div data-badge-type="4" data-doi=" 	10.1101/073460" data-hide-no-mentions="true" class="altmetric-embed"></div> 

### **G**ene **O**ntology **L**abel **D**iscernment and **I**dentification

`goldi` is a tool for identifying key terms in text. It has been developed with the intention of identifying ontological labels in free form text with specific application to finding [Gene Ontology](http://geneontology.org) terms in the biomedical literature with strict canonical NLP quality control. 

<div data-badge-details="right" data-badge-type="donut" data-doi="http://dx.doi.org/10.1101/073460" data-condensed="true" data-hide-no-mentions="true" class="altmetric-embed"></div>

### Status 

`goldi` is not currently published on CRAN but is being resubmitted.

The package is currently checked on `R-oldrel` (v`3.3.3`), `R-release` (v`3.4.0`), and `R-devel` (v`3.5.0`) on

- Ubuntu LTS 14.06 on Travis-CI 
- XCode 8.3 on OSX 10.13 on Travis-CI
- Winbuilder 

### Installation

`goldi` can be installed from CRAN with

```R
install.packages("goldi")
```

Or, you may choose to install the latest stable development version with

```R
devtools::install_github("Chris1221/goldi")
```

### Minimal Example

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

### FAQ

Q: **This is all really confusing, where can I read more about this package?**
> A: Please see the pre print of our paper.

Q: **How does `goldi` match terms to sentences?**
> A: `goldi` accomplishes this by finding the number of similar words in a term and in a sentence, comparing this to a user defined acceptance function A(n) based on the length of the term n. The default function is given by the following: <p align = "center"> ![A](http://www.sciweavers.org/tex2img.php?eq=%5Cmathcal%7BA%7D%28n%29%20%3D%20%5Cbegin%7Bcases%7D%20n%20%26%20n%20%5Cleq%203%20%5C%5C%20n-1%20%26%204%20%5Cleq%20n%20%5Cleq%207%20%5C%5C%20n-2%20%26%208%20%5Cleq%20n%20%5Cleq%2010%20%5C%5C%20n-3%20%26%20n%20%3E%2010%20%5Cend%7Bcases%7D&bc=White&fc=Black&im=jpg&fs=12&ff=mathdesign&edit=0) <p> This may be represented as a vector in R `lims <- c(1,2,3,3,4,5,6,6,7,8,9)` If the number of words present equals or exceeds this function, then a match is declared. You are encouraged to play around and find what acceptance function works for you.

Q: **What if I don't have my text in R, but instead as a text or PDF file?**
> A: `goldi` has four distinct methods for importing text locally, please see the wiki article on the subject.

Q: **Installation from CRAN is not working and it says something about `slam`, what's going on?**

> A: Newer versions of the `tm` package, which is a dependency of `goldi` require a package named `slam` which needs to be compiled from Fortran. Try the following, and if it doesn't work, raise an issue on the repository and we'll get it fixed!
Type the following into terminal (on Mac OSX):
```sh
curl -O http://r.research.att.com/libs/gfortran-4.8.2-darwin13.tar.bz2
sudo tar fvxz gfortran-4.8.2-darwin13.tar.bz2 -C /
```
Install `slam`:
```R
install.packages("slam")
```
Reinstall `goldi`:
```R
install.packages("goldi")
```

Q: **When I install the package, I get messages about `libc` or `gcc` versions. What's happening?**
> A: The most likely scenario is that your `gcc` compiler (which compiles the `c++` code) is out of date, espcially if you are on an older version of linux distribution like CentOS on some cluster systems. Contact your system administrator and try to update `gcc`.

Q: **How can I work with abstracts from pubmed?**
> A: We recommend the `RISmed` package.

Q: **Where can I see some examples of this package in use?**
> A: Please see the included vignettes, especially the overexpression analysis implimented in the paper.

Q: **I am looking for a project to work on with `goldi`, do you have any ideas?**
> A: Please see [here](https://github.com/Chris1221/goldi/blob/master/project_ideas.md).

Q: **Nothing is working, who can I complain to?**
> A: Please raise an issue on this repository, that's most likely to get answered.

### Citation

Cole, Christopher B., et al. "Semi-Automated Identification of Ontological Labels in the Biomedical Literature with goldi." bioRxiv (2016): 073460.

```
@article{cole2016semi,
  title={Semi-Automated Identification of Ontological Labels in the Biomedical Literature with goldi},
  author={Cole, Christopher B and Patel, Sejal and French, Leon and Knight, Jo},
  journal={bioRxiv},
  pages={073460},
  year={2016},
  publisher={Cold Spring Harbor Labs Journals}
}
```

