#' @title Calculate enriched terms in a target set
#'
#' @description Given a target set of articles under question, we wish to compare the frequencies of term occurance to a control set of articles.  We set a threshold above which to investigate terms (setting this threshold higher reduces spurious associated but decreases power to identify true associations) and calculate the enrichment and the P value of association (see \code{\link{hgt}} for more details).
#'
#' @details This function mimics a truncated version of the output of \href{https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-10-48}{GOrilla} by identifying and quantifying the enrichment of terms in a target set of articles. Given N articles and B associations of the given term, the enrichment of b terms in the n articles in the target set is given by \eqn{\frac{\frac{b}{n}}{\frac{B}{N}}}.
#'
#' @param target Set of \code{\link{goldi}} output for a target set of articles.
#' @param control Set of \code{\link{goldi}} output for a control set of articles.
#' @param threshold Only investigate associations which have been founder greater than this number of times.
#' @param correction Correction to impliment on association P values. Users may choose any value which \code{\link[stats]{p.adjust}} may accept.
#'
#' @references Eden, E., Navon, R., Steinfeld, I., Lipson, D., & Yakhini, Z. (2009). GOrilla: a tool for discovery and visualization of enriched GO terms in ranked gene lists. BMC Bioinformatics, 10(1), 1–7. http://doi.org/10.1186/1471-2105-10-48
#'
#' @return A formated data.frame with three columns: terms, enrichments, and P values.
#'
#' @export

enrichment <- function(target, control, threshold, correction = "fdr"){

  # Summarise the target set

  target %<>%
    as.data.frame() %>%
    group_by_("V1") %>%
    summarise_(length = "length(V1)") %>%
    filter(length > threshold) %>%
    arrange(-length)

  control %<>%
    as.data.frame %>%
    group_by_("V1") %>%
    summarise_(length = "length(V1)") %>%
    arrange(-length)

  results <- data.frame(Term = character(), Enrichment = double(), P = double(), stringsAsFactors = F)

  for(i in target$V1) {

    row <- nrow(results)+1

    i <- as.character(i)

    N = nrow(control) + nrow(target)
    .n = nrow(target)
    B = nrow(control[control$V1 == i,]) + target$length[row]
    .b = target$length[row]

    p = hgt(.b, N, B, .n)
    e = (.b / .n) / (B / N)



    results[row, "Term"] <- as.character(i)
    results[row, "Enrichment"] <- e
    results[row, "P"] <- p

  }

  results$P <- p.adjust(results$P, method = correction)

  return(results)
  }