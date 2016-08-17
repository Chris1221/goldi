#' @title Calculate the hypergeometric tail
#'
#' @description Given N articles, B of which are annotated to a given term, the chance that .b of these articles are annotated in a test set of size .n is equal to the hypergeometric tail function.
#'
#' @details P value is computed as in referenced article (GOrilla). Briefly, the P value is the sum from .b to the minimum of .n and B of .n choose i plus N-.n choose B - i all divided by N choose B.
#'
#' @param N Total number of articles
#' @param B Total number of annotations
#' @param .n Number of articles in target group
#' @param .b Number of annotations in target group
#'
#' @return P value of the hypergeometric distribution.
#'
#' @references Eden, E., Navon, R., Steinfeld, I., Lipson, D., & Yakhini, Z. (2009). GOrilla: a tool for discovery and visualization of enriched GO terms in ranked gene lists. BMC Bioinformatics, 10(1), 1–7. http://doi.org/10.1186/1471-2105-10-48
#'
#' @export

hgt <- function(.b, N, B, .n){

  p = 0

  for(i in .b:min(.n, B)){
    p = p + ((choose(.n, i) + choose(N-.n, B - i)) / choose(N, B))
  }

  return(p)
}