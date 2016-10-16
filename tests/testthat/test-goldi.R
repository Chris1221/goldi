context("Test the main function")
library(goldi)
#declare test variables

doc <- "Ribosomal chaperone activity."
data("TDM.go.df")
#TDM.go.df <- TDM.go.df[c(1:5),]

lims <- c(1,2,3,3,4,5,6,6,7,8,9)

log = "/dev/null"
ouput = "/dev/null"

os <- .Platform$OS.type
#out <- structure(c("ribosomal_chaperone_activity", "Ribosomal chaperone activity"), .Dim = 1:2)

out <- structure(c("ribosomal_chaperone_activity", "Ribosomal chaperone activity"
		  ), .Dim = 1:2, .Dimnames = list(NULL, c("Identified Terms", "Context"
							 ))) 
test_that("testing main function", {
  if(os != "unix") skip("Tests are not currently performed on windows.")

  expect_equal(
    goldi(doc = doc,
          terms = "empty",
          output = output,
          lims = lims,
          log = log,
          object = TRUE,
          reader = "local",
          term_tdm = TDM.go.df),
    out)
})

