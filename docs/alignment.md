---
layout: page
title: Read mapping
navigation: 13
---

# Read mapping to a reference genome/transcriptome

<img src="images/RNAseq_workflow.png" width="1000"/>

Once sequencing reads are pre-processed and their quality is ensured, we can proceed mapping them to a reference genome or transcriptome. 

|Mapping of short reads|
| :---:  |
|<img src="images/800px-Mapping_Reads.png" width="500" align="middle" />|
|from Wikipedia|

<br/>


## Tools for read mapping

Once FASTA and GTF files for a reference genome/transcriptome are obtained, we need to choose an aligner (that is, an algorithm for the read mapping) to perform the mapping. 

|Read mappers timeline|
| :---:  |
|<img src="images/mappers_timeline.jpeg" width="800" align="middle" />|
|from [https://www.ebi.ac.uk/~nf/hts_mappers/](https://www.ebi.ac.uk/~nf/hts_mappers/)|

<br/>

Further, before doing the mapping we have to calculate an index for the reference DNA sequence that a chosen algorithm will use. Like the index at the end of a book, an index of a large DNA sequence allows one to rapidly find shorter sequences embedded within it. Different tools use different approaches at genome/transcriptome indexing.

|k-mer index|
| :---:  |
|<img src="images/index_kmer.png" width="300" align="middle" />|
|from [https://www.coursera.org/learn/dna-sequencing/lecture/d5oFY/lecture-indexing-and-the-k-mer-index](https://www.coursera.org/learn/dna-sequencing/lecture/d5oFY/lecture-indexing-and-the-k-mer-index)|


<br/>

### Fast (splice-unaware) aligners to a reference transcriptome
These tools can be used for aligning short reads to a transcriptome reference, because if a genome is used these tools would not map reads to splicing junctions. They can be much faster than traditional aligners like [**Blast**](https://blast.ncbi.nlm.nih.gov/Blast.cgi) but less sensitive and may have limitations about the read size. 

* [**Bowtie**](http://bowtie-bio.sourceforge.net/index.shtml) is an ultrafast, memory-efficient short read aligner geared toward quickly aligning large sets of short DNA sequences (reads) to large genomes/transcriptomes. Bowtie uses a Burrows-Wheeler index. 
* [**Bowtie2**](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml) is an ultrafast and memory-efficient tool for aligning sequencing reads to long reference sequences. It is particularly good at aligning reads of length 50 up to 100s or 1,000s to relatively long (e.g. mammalian) genomes. Bowtie 2 indexes the transcriptome with an FM Index. 
* [**BWA**](http://bio-bwa.sourceforge.net/) is a software package for mapping low-divergent sequences against a large reference genome, such as the human genome. BWA indexes the genome with an FM Index.
* [**GEM**](https://github.com/smarco/gem3-mapper) is a high-performance mapping tool for aligning sequenced reads against large reference genomes. In particular, it is designed to obtain best results when mapping sequences up to 1K bases long. GEM3 indexes the reference genome using a custom FM-Index design and performs an adaptive gapped search based on the characteristics of the input and the user settings. 

<br/>

### Splice-aware aligners to a reference genome
These aligners are able to map to the splicing junctions described in the annotation and even to detect novel ones. Some of them can detect gene fusions and SNPs and also RNA editing. For some of these tools, the downstream analysis requires the assignation of the aligned reads to a given gene/transcript.

* [**Tophat**](https://ccb.jhu.edu/software/tophat/index.shtml) is a fast splice junction mapper for RNA-Seq reads. It aligns RNA-Seq reads to mammalian-sized genomes using the ultra high-throughput short read aligner Bowtie, and then analyzes the mapping results to identify splice junctions between exons.
* [**HISAT2**](http://ccb.jhu.edu/software/hisat2/index.shtml) is **the next generation of spliced aligner from the same group that have developed TopHat**. It is a fast and sensitive alignment program for mapping next-generation sequencing reads (both DNA and RNA) to a population of human genomes (as well as to a single reference genome). The indexing scheme is called a Hierarchical Graph FM index (HGFM). 
* [**STAR**](https://github.com/alexdobin/STAR) is an ultrafast universal RNA-seq aligner. It uses sequential maximum mappable seed search in uncompressed suffix arrays followed by seed clustering and stitching procedure. It is also able to search for gene fusions.

<br/>

### Quasi-mappers (alignment-free mappers) to a reference transcriptome
These tools are way faster than the previous ones because they don't need to report the resulting alignments (BAM/SAM files) but only  associate a read to a given transcript for quantification. They don't discover novel transcript variants (or splicing events) or detect variations, etc.

* [**Sailfish**](http://www.cs.cmu.edu/~ckingsf/software/sailfish/) replaces read mapping with intelligent k-mer indexing and counting, thus allowing fast quantification of isoform abundance (for example, the authors claim that it takes about 15 minutes for a set of 150 million reads).
* [**Salmon**](https://salmon.readthedocs.io/en/latest/index.html) is **an advanced version of Sailfish, by the same authors**, tool for wicked-fast transcript quantification from RNA-seq data. It requires a set of target transcripts to quantify and a K-mer parameter to make the index (i.e. minimum acceptable alignment). 
* [**Kallisto**](https://pachterlab.github.io/kallisto/) is a program for quantifying abundances of transcripts from bulk and single-cell RNA-Seq data. It is based on the novel idea of pseudoalignment for rapidly determining the compatibility of reads with targets, without the need for alignment.

<br/>

For the results of different mappers/aligners comparison, see
* [https://www.ecseq.com/support/ngs/best-RNA-seq-aligner-comparison-of-mapping-tools](https://www.ecseq.com/support/ngs/best-RNA-seq-aligner-comparison-of-mapping-tools)
* [https://mikelove.wordpress.com/2018/05/05/salmon-vs-kallisto/](https://mikelove.wordpress.com/2018/05/05/salmon-vs-kallisto/)

<br/>

