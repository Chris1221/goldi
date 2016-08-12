// [[Rcpp::depends(RcppArmadillo)]]

#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

//' @export
// [[Rcpp::export]]
arma::uword match_min(arma::uvec term_vector) {

  //	Inputs:
  //
  //		term_vector: Index vector of where each of the terms is in the pdf_tdm.
  //			i.e. the ith element of term_vector is j. 
  //			Therefor, term i is at column j in the pdf_tdm. 
  //		terms: List of terms used, this is the vector of column names of term_tdm.
  //		sentences: Vector of sentences read in from the PDf.
  //		pdf_tdm: Term document matrix of words in the PDF
  //		term_pdf: Term document matrix of words in the terms and pdf sentences.
  //		thresholds: Acceptance thresholds
  //
  // 	Outputs:
  //
  // 		List of terms identified as in the PDF
  // 		Column 1 is the index of the term.
  // 		Column 2 is the index of the sentence.
  // 		
  // 		We then substitute in the term and the sentence by index.
  //
  //

  // 	Loop through each term in turn:
	
  // 	Set up output vector outside of loop space.
	//arma::umat out;

//	for(uword i = 0; i < terms.n_elem; i++){
	uword i = 0;	
  	//	Step 1: Find where words are equal to one for the first term
	uword term_index = term_vector(i);
	//arma::vec term = term_tdm.col(term_index);

	//uvec words = find(term >= 1);
//	}
	
	return term_index;
}
