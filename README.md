# PHINDaccess RNAseq course

## Date & place

### When ?
From Monday 10th to Thursday 13th of February, 2020


## Where ?

IPT (Institut Pasteur Tunis)

## Duration

4 full days (7-8h/day?)

## Instructors

[Sarah Bonnin](sarah.bonnin@crg.eu)

[Luca Cozzuto](luca.cozzuto@crg.eu)

## The plan (draft)
The webpage is at https://biocorecrg.github.io/PHINDaccess_RNAseq_2020 

### Day 1

#### 9:00-10:15
* Introduction of the course: goals of the course, outline
* How to use the singularity image:
  * Test with simple commands
* Goals of RNA-seq experiments
* Overview of platforms (Illumina, Nanopore, Pacbio)
#### 10:45-12:00
* Protocols: 
  * polyA capture, ribo0, total RNA, microRNA, mRNA
  * Stranded versus unstranded protocols
  * Adaptors
* Experimental / sequencing design
  * Replicates
  * Sequencing depth
  * Read types: single, paired end. Read length
#### 13:30-14:45
* Get raw data from public repository
  * Browse different repos
  * Check fasta file and explain format
* Get "toy" fastq from us (TBD: one chromosome from a small genome, to reduce computation)
* FastQC (compare what should be seen in genome versus transcriptome), FastqScreen
  * Explain details of reports
#### 15:15-16:30
* Adaptor trimming
  * Run QC tools and adaptor trimming on one sample, give the second one as exercise
  * Run QC tools on both "raw" and trimmed fastq files

### Day 2

#### 9:00-10:15
* Get reference genome or transcriptome (fasta file): ENSEMBL, Gencode, UCSC
  * Check fasta file, count sequences, grep headers, etc.
* Get reference annotation (GTF)
  * Explain GTF format
  * Parsing GTF: retrieving only genes, only coordinates, only gene ID, etc.
#### 10:45-12:00
* Mapping theory
  * Types of mappers
  * Pros and con, which to choose ?
* Map data to reference genome
  * SALMON
  * (STAR too computationally greedy)
#### 13:30-14:45
* Explain SAM and BAM format
  * Fields in common with fastq format
  * Fields specific to SAM/BAM
  * Play with samtools: convert SAM to BAM, sort BAM, index BAM.
#### 15:15-16:30
* UCSC Genome browser
  * Load BAM
  * Explore annotations
  * Convert bam to bigwig and load bigwig

### Day 3

#### 9:00-10:15
* Refreshing R
#### 10:45-12:00
* Differential expression analysis
  * Theory and popular tools
* DESeq2
  * Raw counts / input
  * Import data from SALMON
  * Import data from STAR even if we couldn't map it?
  * Prepare transcript-to-gene annotation file for SALMON
  * Sample sheet
  * Analysis
#### 13:30-14:45
* DESeq2
  * Prepare transcript-to-gene annotation file for SALMON
  * Sample sheet
  * Analysis
  * Understanding output
  * Filtering results, gene selection
#### 15:15-16:30
* Visualization of differential expression analysis
  * PCA
  * Dendrogram
  * Heatmap
  * Scatter plot?

### Day 4

#### 9:00-10:15
* multiQC on FastQC, FastqScreen and mapped data
* ?
#### 10:45-12:00
* Functional analysis
  * Databases: GO, KEGG, MSigDB
  * Run Enrichr
  * Run GO/Panther tool
#### 13:30-14:45
* Functional analysis
  * GSEA: theory and run
#### 15:15-16:30
* Keep this last session in case the course is running late.
* BUT if time allows:
  * GOstats? KEGGprofile?

## Computers in training room

Description: Ubuntu 18.04.3 LTS

Release: 18.04

Linux: 5.0.0-37-generic    

RAM:  7.7 Go

Storage: 480.08 Go

Graphic Card: NIVIDIA Corporation GK208B (GeForce GT 710)

Keyboard Layout: AZERTY

### Requirements for the course:

* Oracle VM virtual box installed on all computers
* We will provide the virtual image necessary for the course (Scientific Linux, 5Go RAM, ? CPUs)
* Access to websites, from the virtual machine: 
  * https://biocorecrg.github.io/PHINDaccess_RNAseq_2020/
  * https://hub.docker.com/
  * https://www.ncbi.nlm.nih.gov/geo/
    * https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE126535
  * https://www.ebi.ac.uk/arrayexpress/
  * https://www.encodeproject.org/
    * https://www.encodeproject.org/experiments/ENCSR937WIG/
    * https://www.encodeproject.org/experiments/ENCSR525HSH/
  * https://www.ncbi.nlm.nih.gov/sra
  * https://www.ebi.ac.uk/ena
  * https://www.ddbj.nig.ac.jp/dra/index-e.html
  * https://public-docs.crg.es/biocore/
  * https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
  * https://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/
  * https://github.com/relipmoc/skewer
  * https://www.ensembl.org/index.html
    * ftp://ftp.ensembl.org/pub/release-96/fasta/homo_sapiens/dna/
    * http://ensemblgenomes.org/
  * https://genome.ucsc.edu/
    * https://genome-euro.ucsc.edu
  * https://www.gencodegenes.org/human/release_29.html
  * https://blast.ncbi.nlm.nih.gov/Blast.cgi
  * http://bowtie-bio.sourceforge.net/index.shtml
  * http://bowtie-bio.sourceforge.net/bowtie2/index.shtml
  * http://bio-bwa.sourceforge.net/
  * https://github.com/smarco/gem3-mapper
  * https://ccb.jhu.edu/software/tophat/index.shtml
  * http://ccb.jhu.edu/software/hisat2/index.shtml
  * https://github.com/alexdobin/STAR
    * http://labshare.cshl.edu/shares/gingeraslab/www-data/dobin/STAR/Releases/FromGitHub/Old/STAR-2.5.3a/doc/STARmanual.pdf
  * http://www.cs.cmu.edu/~ckingsf/software/sailfish/
  * https://salmon.readthedocs.io/en/latest/index.html
  * https://pachterlab.github.io/kallisto/
  * https://samtools.github.io/hts-specs/SAMv1.pdf
  * http://samtools.sourceforge.net/
  * http://blog.biochen.com/FlagExplain.html
  * http://qualimap.bioinfo.cipf.es/
  * https://www.ncbi.nlm.nih.gov/
  * https://jbrowse.org/
  * http://gmod.org/wiki/GBrowse_2.0_HOWTO
  * https://software.broadinstitute.org/software/igv/
  * https://multiqc.info/
  * https://bioconductor.org
    * https://bioconductor.org/packages/release/bioc/html/DESeq2.html
    * https://bioconductor.org/packages/release/bioc/html/edgeR.html
    * https://bioconductor.org/packages/release/bioc/html/limma.html
  * http://master.bioconductor.org/packages/release/workflows/vignettes/rnaseqGene/inst/doc/rnaseqGene.html
  * https://hbctraining.github.io/DGE_workshop/lessons/04_DGE_DESeq2_analysis.html
  * http://bioinformatics.sph.harvard.edu/
  * https://f1000research.com/articles/5-1438/v2
  * http://geneontology.org/
  * https://www.genome.jp/kegg/
  * http://software.broadinstitute.org/gsea
  * http://pedagogix-tagc.univ-mrs.fr/courses/ASG1/practicals/go_statistics_td/go_statistics_td_2015.html
  * http://amp.pharm.mssm.edu/Enrichr/
  




