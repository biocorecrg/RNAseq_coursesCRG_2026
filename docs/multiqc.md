---
layout: page
title: MultiQC report
navigation: 17
---

# Combining reports
At this point, we can summarize all the work done with the tool [**MultiQC**](https://multiqc.info/). 
MultiQC aggregates outputs from many bioinformatics tools across many samples into a single report by searching a given directory for analysis logs and compiling a HTML report. 

<br>
MultiQC supports many tools: see the different [modules](https://multiqc.info/docs/#multiqc-modules)

<br>
Let's create a multiqc_report folder and link all analysis done so far.

```{bash}
cd ~/rnaseq_course/

# create a folder for the multiqc result
mkdir multiqc_report
cd ~/rnaseq_course/multiqc_report

# link QC, trimming and mapping data
ln -s ~/rnaseq_course/quality_control* .
ln -s ~/rnaseq_course/mapping* .
ln -s ~/rnaseq_course/trimming
```

Then run **multiqc** on the directory **multiqc_report** to combine all reports:

```{bash}
cd ~/rnaseq_course/multiqc_report

$RUN multiqc .
```

We can visualize the final report in the internet browser:

```{bash}
firefox multiqc_report.html
```

<img src="images/multiqc.png"  align="middle" />

MultiQC is very customizable. You can ignore files or folder:

```{bash}
$RUN multiqc . --ignore trimming --force

# Note that --force must be set in order to allow the overwriting of existing report
```

Rename output file

```{bash}
$RUN multiqc . --ignore trimming --filename multiqc_notrimming --force
```

You can export all images

```{bash}
$RUN multiqc . --export --force

# by default, plots are saved in folder "multiqc_plots" in pdf, svg and png format.
ls multiqc_plots/
```


<br/>
