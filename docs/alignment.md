# Read mapping (Hands on)

<img src="images/RNAseq_workflow.png" width="1000"/>

What does it mean to map reads to a transcriptome? During sequencing, we read both ends of each RNA fragment—these are called "paired-end reads." Mapping to the transcriptome means finding where these paired reads match in our database of known transcript sequences. Since transcripts already have introns removed and exons joined together, the reads align directly without needing to "jump" across gaps like they would when mapping to the genome.

<div align="center">
<img src="images/800px-Mapping_Reads.png" width="500" align="middle" />
</div>

## Tools for read mapping

Multiples **aligners** were developed over the last decades, using different **algorithms**: 

|Read mappers timeline|
| :---:  |
|<img src="images/mappers_timeline.jpeg" width="800" />|


## Index
Before doing the mapping, we have to prepare an **index** from the reference DNA sequence that a chosen algorithm will use. 
<br>
Like the index at the end of a book, an index of a large DNA sequence allows one to **rapidly find shorter sequences embedded in it**. Different tools use different approaches at genome/transcriptome indexing.

|k-mer index|
| :---:  |
|<img src="images/index_kmer.png" width="300" />|
|from [https://www.coursera.org/learn/dna-sequencing/lecture/d5oFY/lecture-indexing-and-the-k-mer-index](https://www.coursera.org/learn/dna-sequencing/lecture/d5oFY/lecture-indexing-and-the-k-mer-index)|


### Fast (splice-unaware) aligners to a reference transcriptome
These tools can be used for aligning **short reads** to a transcriptome reference.
<br>
If a genome were used as a reference, these tools would not map reads to **splicing junctions**.
<br>
They can be much faster than traditional aligners like [**Blast**](https://blast.ncbi.nlm.nih.gov/Blast.cgi) but less sensitive and may have limitations about the read size. 

* [**Bowtie**](http://bowtie-bio.sourceforge.net/index.shtml) is an ultrafast, memory-efficient short read aligner geared toward quickly aligning large sets of short DNA sequences (reads) to large genomes/transcriptomes. Bowtie uses a **Burrows-Wheeler index**. 
* [**Bowtie2**](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml) is an ultrafast and memory-efficient tool for aligning sequencing reads to long reference sequences. It is particularly good at aligning reads of **length 50 up to 100s or 1,000s** to **relatively long (e.g. mammalian) genomes**. Bowtie 2 indexes the transcriptome with an **FM Index**. 
* [**BWA**](http://bio-bwa.sourceforge.net/) is a software package for mapping **low-divergent sequences** against a **large reference genome**, such as the human genome. BWA indexes the genome with an **FM Index**.

<br/>

### Splice-aware aligners to a reference genome

These aligners are able to map to the **splicing junctions** described in the annotation and even to detect novel ones. 
<br>
Some of them can detect **gene fusions** and **SNPs** and also **RNA editing**. For some of these tools, the downstream analysis requires the assignation of the aligned reads to a given gene/transcript.

* [**HISAT2**](http://ccb.jhu.edu/software/hisat2/index.shtml) is **the next generation of spliced aligner from the same group that have developed TopHat**. It is a fast and sensitive alignment program for mapping next-generation sequencing reads (both DNA and RNA) to a population of human genomes (as well as to a single reference genome). The indexing scheme is called a **Hierarchical Graph FM index (HGFM)**. 
* [**STAR**](https://github.com/alexdobin/STAR) is an ultrafast universal RNA-seq aligner. It uses **sequential maximum mappable seed search** in uncompressed suffix arrays followed by seed clustering and stitching procedure. It is also able to search for gene fusions.

<br/>

### Quasi-mappers (alignment-free mappers) to a reference transcriptome

These tools are way faster than the previous ones because they don't need to report the resulting alignments (BAM/SAM files) but only  associate a read to a given transcript for quantification. They don't discover novel transcript variants (or splicing events) or detect variations, etc.

* [**Salmon**](https://salmon.readthedocs.io/en/latest/index.html) is **an advanced version of Sailfish, by the same authors**, tool for wicked-fast transcript quantification from RNA-seq data. It requires a set of target transcripts to quantify and a K-mer parameter to make the index (i.e. minimum acceptable alignment). 
* [**Kallisto**](https://pachterlab.github.io/kallisto/) is a program for quantifying abundances of transcripts from **bulk and single-cell RNA-Seq data**. It is based on the novel idea of **pseudoalignment** for rapidly determining the compatibility of reads with targets, without the need for alignment.


<br/>


# Reference genome: FASTA and GTF/GFF

Before proceeding, we need to retrieve a **reference genome or transcriptome** from a public database, along with its **annotation**:
* A **FASTA file** contains the actual genome/transcriptome sequence.
* A **GTF/GFF file** contains the corresponding annotation.


