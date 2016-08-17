`mineR`: An R Package for Fuzzy Keyword Identification and Quantification in Natural Language
--------------------------

Status:

| Branch | Travis-CI | Appveyor | Coverage | CRAN | Downloads | Publication |
| :--- | :---: | :---: | :--: | :---: | :---: | :---: |
| `master` | ![Build Status](https://travis-ci.org/Chris1221/mineR.svg?branch=master) | ![Build status](https://ci.appveyor.com/api/projects/status/v64oe85q29btxln9?svg=true) | [![codecov.io](https://codecov.io/github/Chris1221/mineR/coverage.svg?branch=master)](https://codecov.io/github/Chris1221/mineR?branch=master) | ![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/mineR) | ![](http://cranlogs.r-pkg.org/badges/mineR) | GitXiv |
| `devel` |![Build Status](https://travis-ci.org/Chris1221/mineR.svg?branch=devel) | [![Build status](https://ci.appveyor.com/api/projects/status/v64oe85q29btxln9?svg=true)](https://ci.appveyor.com/project/Chris1221/miner) | [![codecov.io](https://codecov.io/github/Chris1221/mineR/coverage.svg?branch=devel)](https://codecov.io/github/Chris1221/mineR?branch=devel) | ![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/mineR) | ![](http://cranlogs.r-pkg.org/badges/mineR) | GitXiv | 

`mineR` is a tool for identifying key terms in text. It has been developed with the intention of identifying ontological labels in free form text with specific application to finding [Gene Ontology] terms in the biomedical literature. `mineR` accomplishes this by finding the number of similar words in a term and in a sentence, comparing this to a user defined acceptance function A(n) based on the length of the term n:

![A](http://www.sciweavers.org/tex2img.php?eq=%5Cmathcal%7BA%7D%20%3D%20%5Cbegin%7Bcases%7D%20n%20%26%20n%20%5Cleq%203%20%5C%5C%20n-1%20%26%204%20%5Cleq%20n%20%5Cleq%207%20%5C%5C%20n-2%20%26%208%20%5Cleq%20n%20%5Cleq%2010%20%5C%5C%20n-3%20%26%20n%20%3E%2010%20%5Cend%7Bcases%7D&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=0)



To install

```{R}
library(devtools)
install_github("Chris1221/mineR")
```

For FAQ and tutorials, see the wiki. 

A basic run would consist of

```{R}
library(mineR)
doc <- "my_file.pdf" #declare your input document
terms <- "my_term_list.txt" #declare your term list

mineR(doc = doc, terms = terms) #run the function
```

Any problems or questions should be [raised as issues](https://github.com/Chris1221/mineR/issues/new)
