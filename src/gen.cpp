// [[Rcpp::depends(RcppArmadillo)]]

#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

//' @export
// [[Rcpp::export]]
arma::umat gen_cor(arma::uvec term_vector, arma::vec terms, arma::vec sentences, arma::mat pdf_tdm, arma::mat term_tdm, arma::vec thresholds) {

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

	for(uword i = 0; i < terms.n_elem; i++){
	
  	//	Step 1: Find where words are equal to one for the first term
		arma::uword term_index = term_vector(i);
		arma::vec term = term_tdm.col(term_index);

		uvec words = find(term >= 1);

	//	Step 2: Subset the pdf to just the rows which are the correct words
	//		Might need to make a row vector out of this or something
		arma::mat pdf_subset = pdf_tdm.rows(words);
	
	//	Step 3: Find sums of each column in this subset
	//	
	//		This is the number of terms in the sentence which are
	//		also part of the term i.
	//
	//		Dim 0 means to take the sum of the COLUMNS as opposed
	//		to the rows.
		arma::rowvec sums = sum(pdf_subset, 0);
	
	// 	Step 4: Loop through thresholds
	//
	//		See if any of the sentence hits the threshold and if so then
	//		accept it.
	//
	//		First find how many words there are in the term
	
		uword nword = words.n_elem;
		
	//		Note: have to shift the index down one, as the first threshold
	//		is the 0th element.
		arma::uvec sentence_index = find( sums >= thresholds(nword-1) );
	
	//	Step 5: If sentence_index is empty, continue on to next iteration

	//	Create a matrix to hold the term and the sentence numbers
	//		Note that this is a umatrix because it is indices
	//		I think this has to be outside the if statement
	//	
	//	This will *probably* error.
		arma::umat out_add(sentence_index.n_elem, 2);
	
		if(sentence_index.n_elem > 0){
		
			//	Add the sentence indices to the second column.
			out_add.col(2) = sentence_index;

		//	Fill the first column with the term index
			out_add.col(1).fill(i);
		
		}
	
	//	Step 6: Merge rows onto output column
		
		arma::umat out = join_cols(out, out_add);
	}
	
	return out;
}
