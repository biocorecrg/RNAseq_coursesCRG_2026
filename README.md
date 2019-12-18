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
  

## The plan (draft)
The webpage is at https://biocorecrg.github.io/PHINDaccess_RNAseq_2020 

### Day 1
* Introduction (lecture)
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


