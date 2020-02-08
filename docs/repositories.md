---
layout: page
title: Data repositories
navigation: 7
---

# RNA-Seq data repositories

**Public data repositories** exist that store data ("raw" and processed) produced by the community from a variety of experiments: microarrays, high-throughput sequencing, high throughput PCR, etc.

It is nowadays required by most journals to make data **publicly available** upon publication of study in a peer-reviewed journal.

The major repositories for gene expression data:
* [**GEO**](https://www.ncbi.nlm.nih.gov/geo/) 
* [**Array-express**](https://www.ebi.ac.uk/arrayexpress/)
* [**ENCODE**](https://www.encodeproject.org/)

These repositories  are linked to the repositories of NGS raw data (Fastq files):
* [**SRA**](https://www.ncbi.nlm.nih.gov/sra) (Sequence Read Archive) 
* [**ENA**](https://www.ebi.ac.uk/ena) (European Nucleotide Archive) 
* [**DDBJ-DRA**](https://www.ddbj.nig.ac.jp/dra/index-e.html) 

<br/>

### EXERCISE
Let's explore [this GEO record](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE76647) (GSE76647)
* Which platform and protocol were used for sequencing?
* What type of RNA was sequenced? From which organism?
* How many samples were sequenced?

<br/>

## Downloading data from a public repository

**fastq-dump** program from the [**SRA toolkit**](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=toolkit_doc) allows you to retrieve raw data from the **SRA** platform, using the command line:
<br>
```{bash}
fastq-dump --gzip --origfmt --split-files --skip-technical SRR-IDENTIFIER

# For us, it would be:
$RUN fastq-dump --gzip --origfmt --split-files --skip-technical SRR-IDENTIFIER
```

The options used here are:
* **--split-files** for paired-end data (if omitted, fastq-dump outputs a single interleaved file)
* **--origfmt**: to avoid the generic "SRA" naming. Keep the original name of the reads.
* **--gzip**: get a gzip-compressed fastq file (fastq files can ve very storage consuming!)
* **--skip-technical**: download only biological reads (do not output barcodes, linkers, etc.)
<br>

### EXERCISE

Going back to the previous [GEO record](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE126535):
* Where can you find the SRA identifiers (code SRR...), for each sample?
* How large are the raw data files?

<br/>

Another source of high quality data on gene expression in human and mouse is [The Encyclopedia of DNA Elements (ENCODE)](https://www.encodeproject.org/). Using the ENCODE portal one can access data produced by the ENCODE Consortium.


<br/>
