replaceExpressions <- function(x) UseMethod("replaceExpressions", x)

replaceExpressions.PlainTextDocument <- replaceExpressions.character <- function(x) {
    x <- gsub("-", " ", x, ignore.case =FALSE, fixed = TRUE)
    x <- gsub(".", "\n", x,ignore.case = FALSE, fixed = TRUE)
    x <- gsub("_", "\n", x,ignore.case = FALSE, fixed = TRUE)
    return(x) 
}