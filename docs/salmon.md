---
layout: page
title: Mapping with Salmon
navigation: 16
---


# Mapping using Salmon

<img src="images/RNAseq_workflow.png" width="1000"/>

[**Salmon**](https://combine-lab.github.io/salmon/) is a tool for quantifying the expression of transcripts using RNA-seq data. 
<br>
It is a **quasi-mapper**: it doesn't produce the read alignments (and doesn't output BAM/SAM files). Salmon "quasi-maps" reads to the transcriptome rather than to the genome. 
<br>
Salmon can also make use of pre-computed alignments (in the form of a SAM/BAM file) instead of the FASTQ files.

<br/>

## Building the Salmon index

To make an index for **Salmon**, we need transcript sequences in the FASTA format.
<br>
This can be found easily in **GENCODE**.
<br>
The transcript sequences corresponding to chromosome 6 was prepared and already downloaded in **~/rnaseq_course/reference_genome/**
<br>

**Salmon** does not need any decompression of the input, so we can index by using this command:

```{bash}
cd ~/rnaseq_course/mapping

# index
$RUN salmon index -t ~/rnaseq_course/reference_genome/reference_chr6/gencode.v33.transcripts.chr6.fa.gz \
          -i index_salmon --gencode
```

We add the parameter **--gencode** as our data come from **Gencode version 29** and their header contains several identifiers separated by the character **&#x7c;**. This parameter allows the program to parse the header and keep only the transcript identifier.

<br/>

## Quantifying transcript expression

To quantify reads with **Salmon**, we need to specify the type sequencing library, aka [**Fragment Library Types** in Salmon](https://salmon.readthedocs.io/en/latest/library_type.html), using three letters:

**The first:**

|Symbol |Meaning | Reads|  
| :---: | :----: |:----: |
|I|inward|-> ... <- |
|O|outward|<- ... ->|
|M|matching|> ... ->|

**The second:**

|Symbol |Meaning |
| :---: | :----: |
|S|stranded|
|U|unstranded|

**The third:**

|Symbol |Meaning |
| :---: | :----: |
|F|read 1 (or single-end read) comes from the forward strand|
|R|read 1 (or single-end read) comes from the reverse strand|

<br/>
From the STAR output for read counts we already know that for the analyzed experiment the **U** (**Untranded**) library was used. 
<br>
If we want to assign the reads to the genes (option **-g**) in addition to transcripts we have to provide a **GTF file** corresponding to the transcript version which was used to build the Salmon index. 
<br>
We have it already for chromosome 6, in **~/rnaseq_course/reference_genome/**

<br>
We can proceed with the mapping.

```{bash}
cd ~/rnaseq_course/mapping

$RUN salmon quant -i index_salmon -l U \
    -r ~/rnaseq_course/raw_data/fastq_chr6/SRR3091420_1_chr6.fastq.gz \
    -o alignments/SRR3091420_1_chr6_salmon \
    -g ~/rnaseq_course/reference_genome/gencode.v33.annotation_chr6.gtf.gz \
    --seqBias \
    --validateMappings

```

We can check the results inside the folder "alignments".

```{bash}
ls alignments/SRR3091420_1_chr6_salmon/

```

For explanation of all output files, see the [Salmon documentation](https://salmon.readthedocs.io/en/latest/file_formats.html).
<br>
The most interesting to us in this course is the file **quant.genes.sf**, that is a tab-separated file containing the read counts for genes:


|Column |Meaning |   
| :----: | :---- |
|Name| Gene name|
|Length| Gene length|
|EffectiveLength| Effective length after considering biases|
|TPM|Transcripts Per Million|
|NumReads|Estimated number of reads considering both univocally and multimapping reads|

```{bash}
head -n 5 alignments/SRR3091420_1_chr6_salmon/quant.genes.sf 

Name	Length	EffectiveLength	TPM	NumReads
ENSG00000285803.1	1152	1116.21	7.96961	15.764
ENSG00000285712.1	1590	1545.58	2.19064	6
ENSG00000285824.1	1120	860.855	6.91601	10.551
ENSG00000285884.1	790	515.683	3.28285	3
...
```

There is also similar formatted file that provides read counts for transcript:
```{bash}

head -n 5 alignments/SRR3091420_1_chr6_salmon/quant.sf 
Name	Length	EffectiveLength	TPM	NumReads
ENST00000016171.5	2356	1970.742	659.861626	2304.468
ENST00000020673.5	4183	5925.497	0.000000	0.000
ENST00000173785.4	925	868.802	0.000000	0.000
ENST00000181796.6	3785	3216.057	0.000000	0.000
...
```

We will use information on read counts for genes from **quant.genes.sf** files for the differential expression (DE) analysis.

<br/>
