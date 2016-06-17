.onAttach <- function(libname, pkgname) {
  # Runs when attached to search() path such as by library() or require()
  if (interactive()) {
    v = packageVersion("mineR")

    packageStartupMessage(paste0("mineR v", v, ". This version is unstable and should not be used in development. More information and guide at https://github.com/chris1221/mineR."))


  }
}
