# Hands-on: Genome Browser
Read alignments (in BAM, CRAM, or BigWig formats) can be displayed in a genome browser, which is a program that allows users to browse, search, retrieve, and analyze genomic sequences and annotation data using a graphical interface.

There are two kinds of genome browsers:
* Web-based genome browsers:
  * [UCSC Genome Broswer](https://genome-euro.ucsc.edu/cgi-bin/hgGateway?redirect=manual&source=genome.ucsc.edu)
  * [Ensembl Genome Browser](https://www.ensembl.org/index.html)
  * [NCBI Genome Data Viewer](https://www.ncbi.nlm.nih.gov/genome/gdv/)

* Desktop applications (some can also be used for generating a web-based genome browser):
  * [JBrowse](https://jbrowse.org/)
  * [GBrowse](http://gmod.org/wiki/GBrowse_2.0_HOWTO)
  * [IGV](https://software.broadinstitute.org/software/igv/)
  
Small-sized data can be directly uploaded to the genome browser, while large files are normally placed on a web server that is accessible to the browser. To explore BAM and CRAM files produced by the STAR mapper, we first need to sort and index the files. 

## UCSC Genome Browser

We uploaded the files for this project (chromosome 6 only) to:[https://biocorecrg.github.io/RNAseq_coursesCRG_2026/latest/data/aln/index.html](https://biocorecrg.github.io/RNAseq_coursesCRG_2026/latest/data/aln/index.html)

Using the mouse's right click, copy the URL address of one of the BAM files.
<br>  

Now go to the [UCSC genome browser website](https://genome-euro.ucsc.edu/cgi-bin/hgGateway?redirect=manual&source=genome.ucsc.edu).

<img src="images/ucsc1.png" />


Choose human genome version hg38 (that corresponds to the ENSEMBL annotation we used). Click **GO**. 

<img src="images/ucsc2.png" />

At the bottom of the image, click **ADD CUSTOM TRACK** 

<img src="images/ucsc_add_custom_track.png"  />

and provide information describing the data to be displayed:
* **track type** indicates the kind of file: **bam** (same is used for uploading .cram)
* **name** of the track 
* **bigDataUrl** the URL where the BAM or CRAM file is located 

```bash
track type=bam name="test" bigDataUrl=https://biocorecrg.github.io/RNAseq_coursesCRG_2026/latest/data/aln/SRR3091420_1_chr6Aligned.sortedByCoord.out.bam

```

Click "Submit".

<img src="images/ucsc4.png"   />

This indicates that everything went ok and we can now display the data. Since our data are restricted to chromosome 6 we have to display that chromosome. For example, let's select the gene **QRSL1** then **go**.

<img src="images/ucsc_search_gene.png"  />

And we can display it. 

The default view can be changed by clicking on the grey bar on the left of the "My BAM" track. You can open a window with different settings; for example, you can change the **Display mode** to **Squish**.

This will change how data is displayed. We can now see single reads aligned to the forward and reverse DNA strands (blue is to **+strand** and red, to **-strand**).  You can also see that many reads are broken; that is, they are mapped to splice junctions.

<img src="images//ucsc5.png"  />

We can also display only the coverage by selecting in "My BAM Track Settings" **Display data as a density graph** and  **Display mode: full**. 

<img src="images/ucsc9.png"   />

These expression signal plots can be helpful for comparing different samples (in this case, make sure to set comparable scales on the Y-axes). 

<img src="images/ucsc8.png"  />

<br/>
