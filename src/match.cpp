// [[Rcpp::depends(RcppArmadillo)]]

#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

//' @title Match terms
//' @description Match terms in C++
//' @param term_vector Index vector of where each of the terms is in the pdf_tdm. i.e. the ith element of term_vector is j. Therefor, term i is at column j in the pdf_tdm.
//' @param terms List of terms used, this is the vector of column names of term_tdm.
//' @param sentences Vector of sentences read in from the PDf.
//' @param pdf_tdm Term document matrix of words in the PDF
//' @param term_tdm Term document matrix of words in the terms and pdf sentences.
//' @param thresholds Acceptance thresholds
//' @param pdf_index Index of terms in PDF
//' @return List of matched terms.
//' @export
// [[Rcpp::export]]
Rcpp::CharacterMatrix match(arma::uvec term_vector, arma::mat pdf_tdm, arma::mat term_tdm, arma::vec thresholds, arma::uvec pdf_index, std::vector<std::string> terms, std::vector<std::string> sentences) {

  //	Inputs:
  //
  //		term_vector: Index vector of where each of the terms is in the pdf_tdm.
  //			i.e. the ith element of term_vector is j.
  //			Therefor, term i is at column j in the pdf_tdm.
  //		terms: List of terms used, this is the vector of column names of term_tdm.
  //		sentences: Vector of sentences read in from the PDf.
  //		pdf_tdm: Term document matrix of words in the PDF
  //		term_tdm: Term document matrix of words in the terms and pdf sentences.
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
	arma::mat out(1,2, fill::zeros);

	for(uword i = 0; i < term_vector.n_elem; i++){

  	//	Step 1: Find where words are equal to one for the first term
		arma::uword term_index = term_vector(i);
		arma::vec term = pdf_tdm.col(term_index-1);

	// 	Step 1a: Count the number of words in the term TDM
	// 		This  is different than words as shown here

		uvec term_words = find( term_tdm.col(i) > 0);
		uword nword = term_words.n_elem;

		uvec words = find(term > 0);

	//	Step 2: Subset the pdf to just the rows which are the correct words
	//		Might need to make a row vector out of this or something

	//	MORE EXCEPTION HANDLING
		if(words.n_elem > 0){
			arma::mat pdf_subset = pdf_tdm.submat(words, pdf_index);

		//	Step 3: Find sums of each column in this subset
		//
		//		This is the number of terms in the sentence which are
		//		also part of the term i.
		//
		//		Dim 0 means to take the sum of the COLUMNS as opposed
		//		to the rows.
			arma::rowvec sums = sum(pdf_subset, 0);
			arma::vec sums_col = conv_to<vec>::from(sums);

		// 	Step 4: Loop through thresholds
		//
		//		See if any of the sentence hits the threshold and if so then
		//		accept it.
		//
		//		First find how many words there are in the term

		//	uword nword = words.n_elem;

		//	EXCEPTION CATCHING: TERMS LONGER THAN THE MAX LENGTH OF THRESHOLDS
		//			DO SOMETHING BETTER HERE

			if(nword + 1 < thresholds.n_elem){

			//		Note: have to shift the index down one, as the first threshold
			//		is the 0th element.
				arma::uvec sentence_index = find( sums_col > (thresholds(nword)-1) );

			//	Step 5: If sentence_index is empty, continue on to next iteration

			//	Create a matrix to hold the term and the sentence numbers
			//		Note that this is a umatrix because it is indices
			//		I think this has to be outside the if statement
			//
			//	This will *probably* error.

				if(sentence_index.n_elem > 0){


					arma::mat out_add(sentence_index.n_elem, 2, fill::zeros);

					//	Add the sentence indices to the second column.
					out_add.col(1) = conv_to<vec>::from(sentence_index);

				//	Fill the first column with the term index
					out_add.col(0).fill(i);

				//	Step 6: Merge rows onto output column

					//arma::mat out = join_cols(out, out_add);

					out.insert_rows(0, out_add);
				}
			}

		}
	}


	// Step 7: Substitute in strings

	// Step 7a. Get rid of first row used to initialize the matrix:
	out.shed_row(out.n_rows - 1);


	Rcpp::CharacterMatrix out_char(out.n_rows, out.n_cols);

	for(uword i = 0; i < out.n_rows; i++){

		out_char(i, 0) = terms[out(i, 0)];
		out_char(i, 1) = sentences[out(i, 1)];

	}



	return out_char;
}
