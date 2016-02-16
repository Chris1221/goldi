#' Internal expression replacement with grep
#'
#' @param x pattern
#'
#' @export

replaceExpressions.character <- function(x){
	x <- gsub("-", " ", x, ignore.case =FALSE, fixed = TRUE)
	x <- gsub(".", "\n", x,ignore.case = FALSE, fixed = TRUE)
	x <- gsub("_", "\n", x,ignore.case = FALSE, fixed = TRUE)
	return(x) 
}