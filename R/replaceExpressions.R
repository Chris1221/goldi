#' Internal expression replacement with grep
#'
#' @param x pattern
#'
#' @export

replaceExpressions <- function(x) {
	UseMethod("replaceExpressions", x)
}

