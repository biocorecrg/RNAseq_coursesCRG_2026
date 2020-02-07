---
layout: page
title: Course data
navigation: 9
---

# Data used in this course

For this course, we will use public data sets from GEO data set **GSE76647**.

## Exercise:

* Go to the GEO page corresponding to entry **GSE76647**
* Retrieve the **SRA codes** corresponding to the following samples (from the **SRA RUN Selector**): GSM2031982, GSM2031983, GSM2031984, GSM2031985, GSM2031986, GSM2031987, GSM2031988, GSM2031989, GSM2031990, GSM2031991.
* What information can you retrieve about these samples?
* Download the raw data for all these samples using **fastq-dump** (it can take a long time!).


<br>
<br>
<br>




## Data details

* Data set **GSE76647** has 10 *Homo sapiens* samples from differentiated (5-day differentiation) and undifferentiated primary keratinocytes.
<br>
Some of the samples underwent a knockdown of the **FOXC1** gene:

|GEO ID |SRA ID |Sample name |Differentiation |Condition |
|GSM2031982 |SRR3091420 |5p4_25c |undiff |WT |
|GSM2031983 |SRR3091421 |5p4_27c |undiff |WT |
|GSM2031984 |SRR3091422 |5p4_28c |diff 5 days |WT |
|GSM2031985 |SRR3091423 |5p4_29c |diff 5 days |WT |
|GSM2031986 |SRR3091424 |5p4_30c |diff 5 days |WT |
|GSM2031987 |SRR3091425 |5p4_31cfoxc1 |undiff |WT |
|GSM2031988 |SRR3091426 |5p4_32cfoxc1 |undiff |WT |
|GSM2031989 |SRR3091427 |5p4_33cfoxc1 |undiff |WT |
|GSM2031990 |SRR3091428 |5p4_34cfoxc1 |diff 5 days |WT |
|GSM2031991 |SRR3091429 |5p4_35cfoxc1 |diff 5 days |WT |

* The fastq files can be downloaded as follows

```{bash}
# Go to the "raw_data" folder
cd ~/rnaseq_course/raw_data

# Download raw data files
for sra in SRR309142{0,1,2,3,4,5,6,7,8,9}
do echo $sra
$RUN fastq-dump --gzip --origfmt --skip-technical --split-files $sra
done
```

* **BACK UP**

In case downloading those files is too slow, we have prepared fastq files that correspond to **chromosome 6 only**. Please download it for later usage:

```{bash}
# go to raw data folder
cd ~/rnaseq_course/raw_data

# archive containing the 6 fastq files for chromosome 6 only
wget https://public-docs.crg.es/biocore/projects/training/PHINDaccess2020/fastq_chr6.tar.gz

# extract archive
tar -xvzf fastq_chr6.tar.gz

# remove .tar.gz file
rm fastq_chr6.tar.gz
```

