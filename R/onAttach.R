onAttach <- function(libname, pkgname) {
  # Runs when attached to search() path such as by library() or require()
  if (interactive()) {
    v = packageVersion("mineR")

    packageStartupMessage(
			  paste0(
			"@------------------------------------------------------@
|     goldi     |     v",v,"     |   3/Aug/2016   |
| ---------------------------------------------------- |
|         (C) Christopher B. Cole, MIT License         |
| ---------------------------------------------------- |
|  For documentation, citation, bug reports, and more: |
|          http://github.com/Chris1221/goldi           |
@ ---------------------------------------------------- @"
				 )
			  )


  }
}
