---
layout: page
title: Course data
navigation: 9
---

# Data used in this course

For this course, we will use public data sets from GEO data set **GSE76647**.

## Data details

* Data set **GSE76647** has 10 samples from *Homo sapiens* differentiated (5-day differentiation) and undifferentiated primary keratinocytes.
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

In case downloading those files is too slow, we have prepared data for **chromosome 6 only**:

```{bash}
# Archive containing the 6 fastq files for chromosome 6 only
wget https://public-docs.crg.es/biocore/projects/phindaccess_rnaseq/fastq_chr6.tar.gz
```

