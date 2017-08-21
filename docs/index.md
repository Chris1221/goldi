# Introduction

Gene Ontology is a public database which, among other things, classifies gene functions according to the molecular functions involved, the cellular compartment where the product is active, and the relevant biological pathways in which they play a part. These classes, or "terms", are highly useful in molecular biology, and are often referred to in the literature. However, with the size and complexity of biomedical publications, this information is often difficult to study in aggregate.  

`goldi` is a tool for identifying key terms in text. It has been developed with the intention of identifying ontological labels in free form text with specific application to finding Gene Ontology terms in the biomedical literature with strict canonical NLP quality control.

This package performs a few main objectives:

- Identifies terms in free text (we distribute the package with a set of Molecular Function terms from Gene Ontology for easy use)
- Summarizes the quantity and quality of annotations across a corpus
- Provides helpful functions for working with `goldi` class objects, including enrichment tests between two corpora. 

`goldi` is freely distributed on CRAN and Github, and bug reports are always welcome. 

Please see the other pages on this website for description of the main functions, as well as some examples of `goldi` in the real world. 