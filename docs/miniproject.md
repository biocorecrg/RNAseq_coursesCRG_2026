---
layout: page
title: Small project in groups
navigation: 21
---

# Small project

## Data set selection

We will try and analysis [this data](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE128010).

<br>
GEO dataset **GSE128010** studies the effect of the knock-out of gene **SPP381** in *Saccharomyces cerevisiae*.
<br>
**The data is paired-end! You need to adapt the pipeline!**

## Pipeline

* Create a new folder in ~/rnaseq_course
* Download raw data from [**SRA Run Selector**](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE128010) with **fastq-dump**
	* Back up: you can alternatively download the data with **wget** from: https://public-docs.crg.es/biocore/projects/training/PHINDaccess2020/miniproject
* Quality control of the data with **FastQC**.
* Decide if you need to trim the data! If so, use **skewer**.
* Retrieve genome reference genome and annotation files from [**ENSEMBL**](http://www.ensembl.org/Saccharomyces_cerevisiae/Info/Index): ENSEMBL also provides fasta files for transcripts in the **cdna** folder of the FTP.
* Prepare **SALMON** index.
* Map data with **SALMON**
* Proceed with the differential expression analysis with **DESeq2**: import data, fit model, extract diffferential expression of WT vs KO, build dendrogram and run PCA. Filter genes.
* If any time is left, explore what kind of **functional analysis** you can run on this data set.


https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE67163
