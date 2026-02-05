# RNAseq course COURSES@CRG 16-20 March 2026
## Decoding Transcriptomes: A Practical Course on RNA-seq
https://courses.crg.eu/events/decoding-transcriptomes-practical-course-rna-seq

This hands-on program provides a comprehensive introduction to RNA sequencing, guiding participants through the complete workflow from sample preparation to data analysis. Participants will gain practical experience in RNA quality control, mRNA library preparation for Next Generation Sequencing (NGS), and library quality control. On the computational side, they will work with real sequencing data to learn key steps including data quality assessment, alignment, quantification, differential expression analysis, and functional interpretation.

The course integrates laboratory practice with computational training, equipping participants with the skills needed to design robust RNA-seq experiments and to apply reproducible analysis workflows following the FAIR practices. The program is complemented by theoretical lectures on state-of-the-art transcriptomics and bioinformatics, a guided visit to the CRG Genomics Unit, and networking activities.

**This repo covers only the computational part of the course**

## The webpage is at https://biocorecrg.github.io/RNAseq_course_2019/ 

## Agenda
### Day 3 - Wed 18 March 2026
* 11:00 - 11:30 **Talk:** Pre-processing of raw data and fastq format - What happens with data after the libraries were sequenced **(Anna Delgado)**
* 11:30 - 12:00 _Coffee break_
* 

Anna DelgadoIntroduction (lecture)
  * goals of course
  * SMALL INTRODUCTION ON HOW TO USE THE SINGULARITY IMAGE
  * goals of RNA-seq experiments
  * overview of platforms (Illumina, Nanopore, PacBio ?)
  * polyA, ribo0, total RNA, microRNA
  * stranded, unstranded
  * adaptors
  * read type: single, paired end; read length.
  * experimental / sequencing design
  * sequencing depth
* Get raw data from public repository (Drosophila ?): check fastq file
* Adaptor trimming
* FastQC (compare what should be seen in genome versus transcriptome), FastqScreen, MultiQC

### Day 2
* Get reference genome or transcriptome: ENSEMBL, Gencode, UCSC
* GTF format; a bit of exploration and excercises 
* Map reads to genome or transcriptome? 
* Existing approaches/methods to read mapping in an RNA-seq experiment: pros and cons, which to choose?
* Map data to reference genome:
  * STAR
  * SALMON
* SAM / BAM formats (play with samtools)
* How to explore BAM files (e.g., using NCBI Genome Workbench https://www.ncbi.nlm.nih.gov/tools/gbench/tutorial6/; UCSC browser https://genome.ucsc.edu/goldenPath/help/bam.html - which http server can be used in the class for this?) other tools to view BAM file SeqMonk, RNAseqViewer, IGB,...
* Make bigwig-files from BAMs and load into GenomeBrowser

I suggest to move Genome Browser here to show its major functionality and to look at BAM and bigwig files. It can be ok to expand it to Day 3. Maybe, move SALMON to Day 3 and compare alignments from STAR ans SALMON using statistics on mapping and looking at bigwig-files in the borwser? 

### Day 3
* DESeq2: import data from STAR and SALMON
* online tool that integrates DESeq2, edgeR, limma, and more: http://52.90.192.24:3838/rnaseq2g/
* RSEM after SALMON?
* Gene selection
* PCA, heatmap

### Day 4
* Genome browser: ENSEMBL, UCSC or IGV
* bigwig?
* Conversion from UCSC chromosome naming convention to ENSEMBL's ?
* Gene Ontology analysis:
  * enrichR
  * DAVID ?
  * GSEA

### Day 5
* Mini project on small genome: provide link to public data

link to CRG course:  https://public-docs.crg.es/rguigo/courses/rnaseq/2017

