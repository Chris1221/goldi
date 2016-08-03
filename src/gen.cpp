// [[Rcpp::depends(RcppArmadillo)]]

#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

//' @export
// [[Rcpp::export]]
arma::mat gen_cor(arma::vec causal, arma::mat all) {

	// int nSample = causal.n_elem;
	int nSnp = all.n_cols;
	
	arma::vec out(nSnp);

	for(int i = 0; i < nSnp; i++){
		arma::vec other = all.col(i);
		
		arma::mat temp = arma::cor(causal, other);

		out(i) = pow(temp(0,0),2);
	}

	return out;

}
