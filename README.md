# mineR

[![Build Status](https://travis-ci.org/Chris1221/mineR.svg?branch=master)](https://travis-ci.org/Chris1221/mineR) [![codecov.io](https://codecov.io/github/Chris1221/mineR/coverage.svg?branch=master)](https://codecov.io/github/Chris1221/mineR?branch=master)

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
