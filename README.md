# RNAseq course COURSES@CRG 
### 16-20 March 2026
## Decoding Transcriptomes: A Practical Course on RNA-seq
https://courses.crg.eu/events/decoding-transcriptomes-practical-course-rna-seq

This hands-on program provides a comprehensive introduction to RNA sequencing, guiding participants through the complete workflow from sample preparation to data analysis. Participants will gain practical experience in RNA quality control, mRNA library preparation for Next Generation Sequencing (NGS), and library quality control. On the computational side, they will work with real sequencing data to learn key steps including data quality assessment, alignment, quantification, differential expression analysis, and functional interpretation.

The course integrates laboratory practice with computational training, equipping participants with the skills needed to design robust RNA-seq experiments and to apply reproducible analysis workflows following the FAIR practices. The program is complemented by theoretical lectures on state-of-the-art transcriptomics and bioinformatics, a guided visit to the CRG Genomics Unit, and networking activities.

**This repo covers only the computational part of the course**

### The webpage is at https://biocorecrg.github.io/RNAseq_coursesCRG_2026/ 

## Agenda
### Day 3 - Wed 18 March 2026
* 11:30 - 12:00 **Talk: Pre-processing of raw data and fastq format - What happens with data after the libraries were sequenced (Anna Delgado)**
* 12:00 - 12:30 **Talk: FAIR & Reproducible practices in Bioinformatics - containers, public repos, git/GitHub (Toni Hermoso)**
* 12:30 - 13:00 **Talk: RNA-seq data analysis: Workflow & Approaches (Luca Cozzuto)** _here or later to cover: Map reads to genome or transcriptome? Existing approaches/methods to read mapping in an RNA-seq experiment: pros and cons, which to choose?_
* 13:00 - 14:00 _Lunch_
* 14:00 - 14:30 Hands-on: Basics of Linux CLI
* 14:30 - 16:00 Hands-on: Read QC: fastq format, FastQC, FastqScreen, kraken, MultiQC (Anna)
* 16:00 - 16:15 _Coffee break_
* 16:15 - 17:00 Hands-on: Read pre-processing: adapter trimming, riboPicker, MultiQC (Anna or Luca?)
* 17:00 - 18:00 Hands-on: Getting reference genome/transcriptome and annotation (ENSEMBL, Gencode, UCSC Genome Browser), GTF/GFF format (Luca)

### Day 4 - Thu 19 March 2026
* 9:00 - 11:00 Hands-on: Read mapping to the reference genome/transcriptome and quantification (STAR, Salmon, SAM/BAM format, samtools, explore BAM/bigwig file in the UCSB Genome Browser, gene/transcript quantification, QualiMap) (Luca)
* 11:00 - 11:30 _Coffee break_
* 11:30 - 13:00 Hands-on: Review R basics (RStudio) (Julia/Fabian)
* 13:00 - 14:00 _Lunch_
* 14:00 - 16:00 Hands-on: DESeq2: import data from STAR and SALMON, filtering and normalization (vst, log2(deseq-native)), PCA, sample clustering, boxplots for selected genes, batch correction using ComBat (for that we will need to use a different dataset) (Fabian/Julia)
* 16:00 - 16:15 _Coffee break_
* 16:15 - 18:00 Hands-on: DE analysis using DESeq2. Gene selection, volcano plots, heatmaps. Functional analysis using R packages (for gene sets) and the GSEA application (for all genes) (Fabian/Julia)
* 18:00 - 21:00 Social activity

### Day 5 - Fri 20 March 2026
* 9:00 - 11:00 Hands-on: Running the full analysis using an nf-core pipeline (Luca)
* 11:00 - 11:30 _Coffee break_
* 11:30 - 12:00 **Talk: Design of RNA-seq experiment & Beyond bulk RNA-seq (Julia)**
* 12:00 - 13:00 Q&A and General discussion
* 13:00 - 14:00 _Lunch_

