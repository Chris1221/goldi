`mineR`: An R Package for Fuzzy Keyword Identification and Quantification in Natural Language
--------------------------

Status:

| Branch | Travis-CI | Appveyor | Coverage | CRAN | Downloads | Publication |
| :--- | :---: | :---: | :--: | :---: | :---: | :---: |
| `master` | ![Build Status](https://travis-ci.org/Chris1221/mineR.svg?branch=master) | ![Build status](https://ci.appveyor.com/api/projects/status/v64oe85q29btxln9?svg=true) | [![codecov.io](https://codecov.io/github/Chris1221/mineR/coverage.svg?branch=master)](https://codecov.io/github/Chris1221/mineR?branch=master) | ![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/mineR) | ![](http://cranlogs.r-pkg.org/badges/mineR) | GitXiv |
| `devel` |![Build Status](https://travis-ci.org/Chris1221/mineR.svg?branch=devel) | [![Build status](https://ci.appveyor.com/api/projects/status/v64oe85q29btxln9?svg=true)](https://ci.appveyor.com/project/Chris1221/miner) | [![codecov.io](https://codecov.io/github/Chris1221/mineR/coverage.svg?branch=devel)](https://codecov.io/github/Chris1221/mineR?branch=devel) | ![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/mineR) | ![](http://cranlogs.r-pkg.org/badges/mineR) | GitXiv | 

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
