// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// match
arma::umat match(arma::uvec term_vector, arma::vec terms, arma::vec sentences, arma::mat pdf_tdm, arma::mat term_tdm, arma::vec thresholds);
RcppExport SEXP mineR_match(SEXP term_vectorSEXP, SEXP termsSEXP, SEXP sentencesSEXP, SEXP pdf_tdmSEXP, SEXP term_tdmSEXP, SEXP thresholdsSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< arma::uvec >::type term_vector(term_vectorSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type terms(termsSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type sentences(sentencesSEXP);
    Rcpp::traits::input_parameter< arma::mat >::type pdf_tdm(pdf_tdmSEXP);
    Rcpp::traits::input_parameter< arma::mat >::type term_tdm(term_tdmSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type thresholds(thresholdsSEXP);
    __result = Rcpp::wrap(match(term_vector, terms, sentences, pdf_tdm, term_tdm, thresholds));
    return __result;
END_RCPP
}