---
layout: page
title: Genome Browser 
navigation: 15
---

# Genome Browser
Read alignments (in the BAM, CRAM or BigWig formats) can be displayed in a genome browser, which is a program allowing users to browse, search, retrieve and analyze genomic sequences and annotation data using a graphical interface.

There are two kinds of genome browsers:
* Web-based genome browsers:
  * [UCSC Genome Broswer](https://genome-euro.ucsc.edu/cgi-bin/hgGateway?redirect=manual&source=genome.ucsc.edu)
  * [Ensembl Genome Browser](https://www.ensembl.org/index.html)
  * [NCBI Genome Data Viewer](https://www.ncbi.nlm.nih.gov/genome/gdv/)

* Desktop applications (some can also be used for generatig a web-based genome browser):
  * [JBrowse](https://jbrowse.org/)
  * [GBrowse](http://gmod.org/wiki/GBrowse_2.0_HOWTO)
  * [IGV](https://software.broadinstitute.org/software/igv/)
  
Small size data can be directly uploaded to the genome browser, while large files are normally placed on a web-server that is accessible to the browser. To explore BAM and CRAM files produced by the STAR mapper, we first need to sort and index the files. In our case, sorting has been already done by STAR's **BAM SortedByCoordinate** option. 
<br>
The indexing can be done with samtools:

```{bash}
cd ~/rnaseq_course/mapping

$RUN samtools index bam_chr6/SRR3091420_1_chr6-trimmedAligned.sortedByCoord.out.bam
$RUN samtools index bam_chr6/SRR3091420_1_chr6Aligned.sortedByCoord.out.cram

```


## UCSC Genome Browser

**IMPORTANT!** 
<br>
Be careful with the **chromosome name conventions**!
<br>
Different genome browsers name chromosomes differently. UCSC names chromosomes as **chr1**, **chr2**,...**chrM**; while Ensembl, **1**, **2**, ... **MT**. 
<br>
When you map reads to a genome with a given convention you cannot directly display BAM/CRAM files in the genome browser that uses a different convention.
<br>
**GENCODE** uses the **UCSC convention**, while **ENSEMBL doesn't**: we need to change the chromosomes names before being able to load them in the UCSC Genome Browser. 

```{bash}
cd ~/rnaseq_course/mapping

# create new sub-directory
mkdir bam_ucsc

# convert chromosome naming (produce a SAM file)
$RUN samtools view -h bam_chr6/SRR3091420_1_chr6-trimmedAligned.sortedByCoord.out.bam | awk -F "\t" 'BEGIN{OFS="\t"}{if($1 ~ /^@/){print $0} else {print $1,$2,"chr"$3,$4,$5,$6,$7,$8,$9,$10,$11,$12}}' | sed 's/chrMT/chrM/g' | sed 's/SN:/SN:chr/g' > bam_ucsc/SRR3091420_1_chr6_ucsc.sam

# convert SAM to BAM
$RUN samtools view -b -o bam_ucsc/SRR3091420_1_chr6_ucsc.bam bam_ucsc/SRR3091420_1_chr6_ucsc.sam

# create index for BAM file
$RUN samtools index bam_ucsc/SRR3091420_1_chr6_ucsc.bam

# remove SAM file
rm bam_ucsc/SRR3091420_1_chr6_ucsc.sam
```

First, you need to upload your sorted bam (or cram) file(s) **together with an index (.bai or .crai) file(s)** to a http server that is accessible from the Internet. 
<br>

We uploaded the files for this project (chromosome 6 only) are in:

```
https://public-docs.crg.es/biocore/projects/training/PHINDaccess2020/ucsc/
```

Using the mouse's right click, copy one of the bam files URL address.
<br>  

Now go to the [UCSC genome browser website](https://genome-euro.ucsc.edu/cgi-bin/hgGateway?redirect=manual&source=genome.ucsc.edu).

<img src="images/ucsc1.png"  align="middle" />

Choose human genome version hg38 (that corresponds to the ENSEMBL annotation we used). Click **GO**. 

<img src="images/ucsc2.png"  align="middle" />

At the bottom of the image click **ADD CUSTOM TRACK** 

<img src="images/ucsc_add_custom_track.png"  align="middle" />

and provide information describing the data to be displayed:
* **track type** indicates the kind of file: **bam** (same is used for uploading .cram)
* **name** of the track 
* **bigDataUrl** the URL where the BAM or CRAM file is located 

```{bash}
track type=bam name="test" bigDataUrl=https://public-docs.crg.es/biocore/projects/training/PHINDaccess2020/ucsc/SRR3091420_1_chr6_ucsc.bam
```

Click "Submit".

<img src="images/ucsc4.png"  align="middle" />

This indicates that everything went ok and we can now display the data. Since our data are restricted to chromosome 6 we have to display that chromosome. For example, let's select the gene **QRSL1** then **go**.

<img src="images/ucsc_search_gene.png"  align="middle" />

And we can display it. 
<img src="images/ucsc_gene_view.png.png"  align="middle" />

The default view can be changed by clicking on the grey bar on the left of the "My BAM" track. You can open a window with different settings; for example, you can change the **Display mode** to **Squish**.

<img src="images/ucsc7.png"  align="middle" />

This will change how data are displayed. We can now see single reads aligned to the forward and reverse DNA strands (blue is to **+strand** and red, to **-strand**).  You can also see that many reads are broken; that is, they are mapped to splice junctions.

<img src="images/ucsc8.png"  align="middle" />

We can also display only the coverage by selecting in "My BAM Track Settings" **Display data as a density graph** and  **Display mode: full**. 

<img src="images/ucsc9.png"  align="middle" />

These expression signal plots can be helpful for comparing different samples (in this case, make sure to set comparable scales on the Y-axes). 

<img src="images/ucsc_profile_view.png"  align="middle" />

<br/>
