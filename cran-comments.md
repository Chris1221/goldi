## Release Summary

This is the second release of `goldi`. It resolves an unstated LLAPACK dependency which caused CRAN checks to fail on solaris-sparc and solaris-x86. My apologies for the error.

## Test environments
* Local OS X Install, R 3.3.1 + R Devel 
* Linux Ubuntu 12.04 LTS Server Edition 64 bit (through Travis-CI), R 3.3.1 + R Devel
* Windows through Appveyor, R 3.3.1 + R Devel

## R CMD check results
There were no ERRORs or WARNINGs.

There was one NOTE:

	* checking CRAN incoming feasibility ... NOTE
	Maintainer: 'Christopher B. Cole <chris.c.1221@gmail.com>'

	New submission

	License components with restrictions and base license permitting such:
	  MIT + file LICENSE
	File 'LICENSE':
	  YEAR: 2016
	  COPYRIGHT HOLDER: Christopher B. Cole

This note has appeared since it is the first submission to CRAN of this package. We do not believe that it represents an issue.

## Downstream dependencies
There are no downstream dependencies.
