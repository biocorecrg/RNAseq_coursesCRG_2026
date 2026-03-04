RNA-seq data analysis: Workflow & Approaches 
=================

Luca Cozzuto

What is the transcriptome?
----------------

The transcriptome is the set of all RNA molecules produced by a virus, a cell, or a population of cells, such as a tissue, organ, or organism.
The genetic information is stored in DNA in units called “genes”. 

Not all genes are active at all times.

Cells need to express specific genes to produce the proteins and RNA molecules necessary for their structure and function.

<p align="center"> <img src="images/transcriptome.jpg" width="200" /> </p>


History of Transcriptome Analysis Techniques
----------------

Prior to the 2000s, we were able to measure the expression of few genes using mainly to methods: the Northern Blot and the PCR.

 - The Northern Blot (1977, James Alwine, David Kemp, and George Stark) is a technique for detecting specific RNA molecules that uses RNA separation by gel electrophoresis, followed by transfer to a membrane, and then hybridization with a probe with a labeled complementary DNA or RNA to visualize the target.

<p align="center"> <img src="images/north_blot.png" width="600" /> </p>

 
 - Real Time-PCR and Real Time-qPCR (Mid 1990s).

PCR (Polymerase Chain Reaction) is a technique invented in 1983 that amplifies specific DNA sequences exponentially through repeated cycles of heating (DNA denaturation) and cooling (primer annealing and extension). RT-PCR (Reverse Transcription PCR) extends this by first converting RNA into complementary DNA (cDNA) using reverse transcriptase enzyme, then amplifying the cDNA with standard PCR. This allows detection and quantification of specific RNA molecules. Quantitative RT-PCR (qRT-PCR or RT-qPCR), developed in the 1990s, measures amplification in real-time, providing precise quantification of gene expression levels.

<p align="center"> <img src="images/pcr.jpg"  width="900" /> </p>

`Image from: Bong D, Sohn J, Lee SV. Brief guide to RT-qPCR. Mol Cells. 2024 Dec;47(12):100141.`


- In 2001, with the publication of the human genome, the whole list of protein genes became available. Some companies, like Agilent, started to manufacture chips containing thousands of DNA probes spotted in a grid pattern in what is known as a "microarray". Fluorescently-labeled RNA samples hybridize to complementary probes, allowing simultaneous measurement of expression levels for thousands of genes in a single experiment.

<p align="center"> <img src="images/microarray.jpg"  width="300" /> </p>

`Image from: https://bitesizebio.com/7206/introduction-to-dna-microarrays/`

- In 2005 and 2006, a new class of automatic sequencers entered the market, marking the beginning of the "next-generation sequencing" era. The 454 sequencer was based on pyrosequencing technology: a method that detects DNA synthesis by capturing flashes of light released each time a nucleotide is added to a growing DNA chain. A year later, the Solexa Genome Analyzer, later acquired by Illumina, used a different approach based on sequencing-by-synthesis with reversible terminators.

<p align="center"> <img src="images/454.jpg"  width="200" /> <img src="images/solexa.jpg"  width="100" /></p>

Using these technologies for sequencing libraries of Expressed Sequence Tags (EST) allows the analysis  of a large part of the transcriptome, or performing RNAseq analysis.   

In 2006 and in 2008, two milestone papers were published using this concept:

- Bainbridge MN, et al. **Analysis of the prostate cancer cell line LNCaP transcriptome using a sequencing-by-synthesis approach**. BMC Genomics. 2006 Sep 29;7:246. [doi: 10.1186/1471-2164-7-246](https://doi.org/10.1186/1471-2164-7-246).

- Mortazavi A, et al. **Mapping and quantifying mammalian transcriptomes by RNA-Seq**. Nat Methods. 2008 Jul;5(7):621-8. [doi: 10.1038/nmeth.1226](https://doi:10.1038/nmeth.1226). 

The whole workflow is described in the following image:

<p align="center">
  <img src="images/polyA_sequencing.jpg" width="400" />
</p>

From that moment, different labs tried to apply the same technique to different transcriptome data. So we were then able to analyze:

| Method | Details |
|--------|---------|
| mRNA or better cDNA sequencing | after polyA enrichment |
| Total RNA sequencing | after ribo depletion, to include also non-coding RNAs |
| Small RNA sequencing | after size selection, snoRNAs, microRNAs, tRNAs… |
| RIP sequencing | after RNA immunoprecipitation, detecting ribo-protein binding sites |
| Meta-transcriptomics | for the whole transcriptome of a bacterial population |

During this course, we will focus on bulk RNAseq, because is important for you to know that currently we are also able to detect the transcriptome of single cells and their spatial location.

<p align="center">
  <img src="images/all_rnaseqs.png" width="400" />
</p>


(Luca Cozzuto) here or later to cover: Map reads to genome or transcriptome? 
Existing approaches/methods to read mapping in an RNA-seq experiment: pros and cons, which to choose?
