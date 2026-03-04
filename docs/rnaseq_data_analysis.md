RNA-seq data analysis: Workflow & Approaches 
=================

Luca Cozzuto

What is the transcriptome?
----------------

The transcriptome is the set of all RNA molecules produced by a virus, a cell, or a population of cells, such as a tissue, organ, or organism.
The genetic information is stored in DNA in units called “genes”. 

Not all genes are active at all times.

Cells need to express specific genes to produce the proteins and RNA molecules necessary for their structure and function.

<img src="images/transcriptome.jpg" width="200" />

History of Transcriptome Analysis Techniques
----------------

Prior to the 2000s, we were able to measure the expression of few genes using mainly to methods: the Northern Blot and the PCR.

 - The Northern Blot (1977, James Alwine, David Kemp, and George Stark) is a technique for detecting specific RNA molecules that uses RNA separation by gel electrophoresis, followed by transfer to a membrane, and then hybridization with a probe with a labeled complementary DNA or RNA to visualize the target.

<img src="images/north_blot.png" width="600" />

 
 - Real Time-PCR and Real Time-qPCR (Mid 1990s).

PCR (Polymerase Chain Reaction) is a technique invented in 1983 that amplifies specific DNA sequences exponentially through repeated cycles of heating (DNA denaturation) and cooling (primer annealing and extension). RT-PCR (Reverse Transcription PCR) extends this by first converting RNA into complementary DNA (cDNA) using reverse transcriptase enzyme, then amplifying the cDNA with standard PCR. This allows detection and quantification of specific RNA molecules. Quantitative RT-PCR (qRT-PCR or RT-qPCR), developed in the 1990s, measures amplification in real-time, providing precise quantification of gene expression levels.

<img src="images/pcr.jpg"  width="900" />

`Image from: Bong D, Sohn J, Lee SV. Brief guide to RT-qPCR. Mol Cells. 2024 Dec;47(12):100141.`


- In 2001, with the publication of the human genome, the whole list of protein genes became available. Some companies, like Agilent, started to manufacture chips containing thousands of DNA probes spotted in a grid pattern in what is known as a "microarray". Fluorescently-labeled RNA samples hybridize to complementary probes, allowing simultaneous measurement of expression levels for thousands of genes in a single experiment.

<img src="images/microarray.jpg"  width="400" />

`Image from: https://bitesizebio.com/7206/introduction-to-dna-microarrays/`




(Luca Cozzuto) here or later to cover: Map reads to genome or transcriptome? 
Existing approaches/methods to read mapping in an RNA-seq experiment: pros and cons, which to choose?
