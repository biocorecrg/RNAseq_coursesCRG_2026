# Talk: Experimental design of RNA-seq experiment

---

## Reproducibility in biological experiments

Reproducibility is a central goal of scientific research. <br>
A result is considered reproducible when independent experiments performed under similar conditions lead to consistent conclusions. <br>
In biological studies, reproducibility can be challenging because biological systems exhibit substantial natural variability and experiments often involve multiple sources of technical variation.


Several factors can reduce reproducibility, including 
- small sample sizes, 
- uncontrolled experimental conditions, and 
- systematic biases introduced during sample preparation or data acquisition. 

High-throughput experiments such as RNA-seq are particularly sensitive to these issues because they measure thousands of features simultaneously and rely on statistical models to detect differences between conditions.

The large-scale study lead by [SEQC Consortium 2014](https://pmc.ncbi.nlm.nih.gov/articles/PMC4321899)
showed that RNA-seq results are consistent across technical replicates, laboratories, and sequencing platforms.

However, the most recent study on replicability of bulk RNA-seq experiments published in [PLOS Comp Biol 2025](https://journals.plos.org/ploscompbiol/article?id=10.1371%2Fjournal.pcbi.1011630)
confirmed the previous study ([RNA 2016](https://pubmed.ncbi.nlm.nih.gov/27022035/))
that biological variability remains substantial, and 
statistical power of reliable differential expression analysis strongly depends on the number of biological replicates.

Many studies still use fewer samples than recommended.


Careful experimental design helps ensure that results are reproducible and statistically interpretable. Experimental design aims to 
- reduce bias, 
- control unwanted sources of variation, and 
- provide sufficient information to estimate biological variability.

---

## What makes a well-designed experiment?

<div style="display:flex; justify-content:center;">

| |
|:---:|
| ![fishy](images/good_exp_design.jpg) | 
| *Figure is adapted from Cambridge University's Experimental Design Manual 2016* |

</div>

<br><br>

### Experimental design begins with the biological question, and affects every stage of an RNA-seq experiment

<div style="display:flex; justify-content:center;">

| |
|:---:|
| ![fishy](images/exp_design.jpg) | 
| *Figure is from [https://galaxyproject.org/tutorials/rb_rnaseq/](https://galaxyproject.org/tutorials/rb_rnaseq/)* |

</div>

:::{note}
Think:

```
biological question
       ↓
experimental design
       ↓
sample preparation
       ↓
sequencing
       ↓
bioinformatics
```
:::



<br>

**Examples of biological questions**:
1. Which genes change their expression levels between treated and control samples?

2. Which transcript isoforms or alternative splicing events differ between treated and control samples?

3. Which genes are expressed at very low levels in this tissue, and how does their expression change between conditions?

4. Which cell types respond to treatment, and what genes change expression within each cell type?

<br>

### Three basic principles of experimental design

<br>


| **Goal** | **What it means in RNA-seq experiments** | **Design principle** |
|------|------------------|------------------|
| **Unbiased estimates** | Observed expression differences should reflect biological differences rather than artifacts from sequencing lanes, library preparation order, or operator effects. | **Randomization** |
| **Precise estimates** | Known sources of variation such as batch, patient, or sequencing run are accounted for to improve accuracy of expression estimates. | **Blocking** |
| **Adequate statistical power** | Sufficient biological replicates are included so that true differential expression can be detected despite biological variability. | **Replication** |

<br>

:::{important} **Core principles of experimental design**
These three principles form the foundation of experimental design:

- **Randomization** reduces systematic bias.
- **Blocking** controls known sources of variation.
- **Replication** allows estimation of biological variability and increases statistical power.

<small>Source: [Statistics Knowledge Portal](https://www.jmp.com/en/statistics-knowledge-portal/design-of-experiments/key-design-of-experiments-concepts/key-principles-of-experimental-design)</small>
:::

<br>
How to address core principles of experimental design for a RNA-seq experiments:<br>

• **Replication**  → sequence multiple independent biological samples

• **Randomization**  → distribute samples across lanes or library batches

• **Blocking**  → include batch in the model ( design = ~ batch + condition )


<br>  

---

## Replication or Why independent samples are required

Replication is essential for reliable statistical inference in RNA-seq experiments.  
Replication allows estimation of **biological variability**, which determines whether observed differences in gene expression are larger than expected by chance.

:::{important} **Golden rule of replication**
Replicates must represent **independent biological samples (or units)**, not repeated measurements of the same sample.
:::

---

### Experimental units

The **experimental unit** is the smallest entity that independently receives the treatment.  

It defines the level at which **biological replication** occurs.

| Term                  | Meaning                                          |
| --------------------- | ------------------------------------------------ |
| **Experimental unit** | entity that independently receives the treatment |
| **Sample**            | material measured by sequencing                  |

<br>

In many RNA-seq experiments, <br>

**Experimental unit = Sample = Biological replicate** 
<br>

Examples:

| Experiment | Experimental unit | RNA-seq sample |
|---|---|---|
| Drug treatment in mice | individual mouse | RNA extracted from each mouse |
| Patient RNA-seq study | patient | tissue sample from each patient |
| Cell culture experiment | independent culture | RNA extracted from each culture |
<br>

| mouse   | RNA-seq sample |
| ------- | -------------- |
| mouse 1 | sample 1       |
| mouse 2 | sample 2       |
| mouse 3 | sample 3       |

<br>

However, multiple samples can sometimes originate from the same experimental unit. 
For example:

| mouse   | tissue sample |
| ------- | ------------- |
| mouse 1 | liver         |
| mouse 1 | kidney        |
| mouse 1 | brain         |


**experimental unit = mouse != sample** <br>
**samples = tissues != biological replicate**

<br>

| RNA extraction | library   |
| -------------- | --------- |
| sample A       | library 1 |
| sample A       | library 2 |


**experimental unit = RNA sample** <br>
**libraries = technical replicates != biological replicate**
<br><br>

:::{important}
Treating samples originated from the same experimental unit
as **independent replicates** would result in **pseudoreplication**. <br>
Once the experimental unit is defined, the number of independent units 
determines the number of **biological replicates** in the experiment.
:::

<br>

---

### Biological vs technical replicates

**Biological replicates** are samples derived from **independent biological sources**.  
They capture natural biological variability.

Examples:

- different individuals  
- independent cell cultures  
- independent tissue samples  

<br>

**Technical replicates** are repeated measurements of the **same biological sample**.

Examples:

- different library preparations from the same RNA sample  
- sequencing the same library in multiple lanes  
- repeated sequencing runs of the same library

  <br>

| Type of replicate | Example | What it measures |
|---|---|---|
| **Biological replicate** | RNA-seq from three different mice | Biological variability |
| **Technical replicate** | Two libraries prepared from the same RNA sample | Technical variability |
| **Lane replicate** | Same library sequenced in two lanes | Sequencing variability |

<br>

Technical replicates measure **technical variability**, which can arise from:

- library preparation (reverse transcription, PCR)
- sequencing reactions
- sample loading or lane effects

However, modern RNA-seq protocols have **very low technical variability**.

<br>

---

### Pseudoreplication

A common mistake is **pseudoreplication**, where technical replicates are incorrectly treated as biological replicates.

Example:

```
Mouse 1
  ├── library 1
  ├── library 2
  └── library 3
```

Treating them as independent samples artificially inflates statistical significance.
<br>

Typical examples of pseudoreplication include:

- multiple libraries prepared from the same RNA extraction  
- multiple wells from the same cell culture  
- several tissue slices from the same animal  

<br>

**Questions:** 
**Are these samples technical replicates, biological replicates, or pseudoreplicates?**
1. Three samples of blood were obtained from a healthy patient not under any treatment during three consecutive days at the same hour.
2. 1000 cells were isolated from a tumor sample obtained from a single patient.
The cells were divided into three batches, pooled again, and three RNA-seq libraries were prepared and sequenced independently.
3. RNA was extracted from a single mouse liver sample.
Three independent RNA-seq libraries were prepared from this RNA extraction by 3 different people and sequenced separately.
4. Bone marrow was obtained from 12 mice. Cells from 6 mice were pooled to form sample 1; and cells from another 6 mice, to make sample 2. 
5. Three vials of blood were obtained from a patient at the same time; from each, a library was prepared independently and sequenced. 

<br>

---

### Technical vs biological variability in RNA-seq

Studies have shown that **biological variability is typically much larger than technical variability** in RNA-seq experiments.

Key studies:

- [SEQC Consortium 2014](https://pmc.ncbi.nlm.nih.gov/articles/PMC4321899)
- [Schurch et al, RNA 2016](https://pubmed.ncbi.nlm.nih.gov/27022035/)
- [Degen & Medo, PLOS Comp Biol 2025](https://journals.plos.org/ploscompbiol/article?id=10.1371%2Fjournal.pcbi.1011630)
]<br>

These studies demonstrated that RNA-seq measurements are highly reproducible across technical replicates.

:::{admonition} 
:class: important
**Biological replication is more important than performing technical replicates** in most RNA-seq experiments.
:::

<br>

---

### Replication and statistical power

Statistical power is the probability that an RNA-seq experiment correctly detects a true difference in gene expression between conditions;
that is, the probability of rejecting the null hypothesis when it is false. <br>
The null hypothesis is that the gene expression is the same in both conditions.

**Power** is the probability of **not accepting a false null hypothesis**, or the probability of detecting a specified difference, or **effect size**, given it exists, within the population *(e.g., a fold change in a microarray experiment or a change in the size of a tumour)*. 

:::{admonition} 
:class: note
The desired power of the research experiment is usually above 80%; <br>
while for clinical studies, it might be required to be above 90%. 
:::

**Power (aka, sensitivity of the statistical test) = 1 - (type II error)**,  *(type II error is an error of accepting a false null hypothesis)*

power = 0.8 --> 80% chance of detecting a true differential expression signal

If all other parameters remain the same, 
a larger experiment will have more power than a smaller experiment. 
<br><br>
However, if an experiment is too large and 
a smaller experiment would have achieved the same 
statistical result, it is **overpowered experiment** 
and then it has wasted subjects, money, time and effort, and is potentially unethical. 
<br><br>
On the other hand, if an experiment is too small, it may **lack power and miss important differences that do actually exist**. <br>
Therefore, an **underpowered study** also wastes resources and can be unethical. 
<br><br>
It is important to know what effect size is important to ensure that an experiment is sufficiently powered.
<br>

In RNA-seq experiments, replication increases the ability to detect true differences in gene expression.
<br>
The statistical power of an RNA-seq experiment depends on:

- **number of biological replicates**: 2 replicates → low power, 
6 replicates → good power
- **effect size** (magnitude of expression change): log2fc=3 easy to detect, log2fc=0.5 need more power
- **biological variability** within each condition: higher variability → lower power
- **sequencing depth**: more reads → lower-expressed genes are detected

<br>

:::{note}
```
power increases with
  ↑ number of replicates
  ↑ effect size
  ↓ biological variability
  ↑ sequencing depth
```
:::

Increasing the number of biological replicates generally improves power **more than increasing sequencing depth**.

<br>
---

### Number of replicates in RNA-seq experiments

> "RNA-seq is now the technology of choice for genome-wide differential gene expression experiments..."
>
> — [Schurch et al., 2016](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4878611/)


| Effect of the number of biological replicates on the detection of differentially expressed genes (Schurch et al., 2016).|
| :---:  |
|<img src="images/fig2_schurch_2016.png" width="700" align="middle" />|
| adapted from [Schurch, et al., RNA, 2016; Fig 2.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4878611/)|

The study showed that:

- with **3 replicates**, many differentially expressed genes are missed
- with **6 replicates**, most strong signals are detected
- detecting small expression changes may require **more than 10 replicates**

<br/>










## Factorial design to address wide range of the result applicability

<div style="display:flex; justify-content:center;">

| |
|:---:|
| ![fishy](images/factorial_design_1.jpg) | 
| *Figure is adapted from Cambridge University's Experimental Design Manual 2016*|

</div>

done? 



## Power analysis & sample size

Sample size calculations, power calculations and power analysis (the terms are used interchangeably) are a way of determining the appropriate number of replicates (the sample size) for a study.

**Power** is the probability of **not accepting a false null hypothesis**, or the probability of detecting a specified difference, or **effect size**, given it exists, within the population *(e.g., a fold change in a microarray experiment or a change in the size of a tumour)*. 

The desired power of research experiment is usually above 80%; while for clinical studies, it might be required to be above 90%. 

**Power (aka, sensitivity of the statistical test) = 1 - (type II error)**,  *(type II error is an error of accepting a false null hypothesis)*

If all other parameters remain the same, a larger experiment will have more power than a smaller experiment. However, if an experiment is too large and a smaller experiment would have achieved the same statistical result, it is **overpowered experiment** and it has wasted subjects, money, time and effort, and is potentially unethical. On the other hand, if an experiment is too small, it may **lack power and miss important differences that do actually exist**. Therefore, an **underpowered study** also wastes resources and can be unethical. It is important to know what effect size is important to ensure that an experiment is sufficiently powered.

### Factors affecting a power calculation
* The precision and variance of measurements within any sample
* Magnitude of a significant difference (aka, effect size)
* Significance level (in biology, usually 0.05); that is, how certain we want to be to avoid type I error *(when the null hypothesis is incorrectly rejected)* 
* The type of statistical test performed

### Example 
We study the difference of some measurement in two populations (in which we assume this variable is normally distributed and variance of two populations are the same). 
<br/>

We draw two samples (n=2) from each population independently and randomly and get
```
x = c(9, 11)
y = c(17,19)
```


We run the *t-test on difference of means* and get **p-value=0.03** *( in R, use function t.test(x, y) )*.

<br/>

Since we know the variance for x and y, *var(x) = 2; var(y) = 2*, we can calculate the power of the t-test to detect the observed **effect size delta**  *( in R, use function power.t.test(n, delta, sd, sig.level = 0.05) )*
```
delta = (mean(y) - mean(x)) / sqrt(var) = 8 / sqrt(2)

> power.t.test(n = 2, delta = 8/sqrt(2), sd = sqrt(2))

     Two-sample t test power calculation

              n = 2
          delta = 5.656854
             sd = 1.414214
      sig.level = 0.05
          power = 0.5645141
    alternative = two.sided

NOTE: n is number in *each* group
```


The obtained **power = 0.56**. This means that **Type II error** (or the probability of accepting a false null hypothesis, that is, concluding that there is NO difference when in fact there is the difference) **= 1 - power = 44% !!!!** – in roughly 44% of tests conducted with **these parameters for n and sd**, the given effect size delta will be NOT seen as significant even when it is significant. 

It is a waist of resources to conduct such an **under-powered study**. 

If we want to detect this effect size (difference in means of 8) with higher power, we have to increase the number of samples (n).

<br/>

**But what difference in means can we detect with just 2 samples at a sufficient enough power?**


```
x = c(9, 11)
y = c(24, 26)
```
We run the t-test on difference of means and get **p-value=0.009**.


Since we know the variance for x and y, *var(x) = 2; var(y) = 2*, we can calculate the power of the t-test to detect the observed effect size:
```
delta = (mean(y) - mean(x)) / sqrt(sd) = 15 / sqrt(2)

> power.t.test(n = 2, delta = 15/sqrt(2), sd = sqrt(2))

     Two-sample t test power calculation

              n = 2
          delta = 10.6066
             sd = 1.414214
      sig.level = 0.05
          power = 0.9387922
    alternative = two.sided
```


The obtained **power = 0.94 !!!** 
This is an **adequtely powered experiment**. That is if the true difference of means of two populations is 15, we can detect it drawing only 2 random and independent samples from each population. And while conducting the t-test we will commit Type II error in only 6% of tests; that is, the given effect size will be NOT seen as significant (p-value will be above 0.05). 

If however the significance level alpha becomes more stringent, say 0.01, the power will decrease:
```
> power.t.test(n = 2, delta = 15/sqrt(2), sd = sqrt(2), sig.level = 0.01)

     Two-sample t test power calculation

              n = 2
          delta = 10.6066
             sd = 1.414214
      sig.level = 0.01
          power = 0.4343263
    alternative = two.sided
```

<br/>

We can calculate directly how many samples are needed to observe that effect size (difference in means =15) at power=0.9 and significance level=0.01:
```
> power.t.test(power = 0.9, delta = 15/sqrt(2), sd = sqrt(2), sig.level = 0.01)

     Two-sample t test power calculation

              n = 2.539062
          delta = 10.6066
             sd = 1.414214
      sig.level = 0.01
          power = 0.9
    alternative = two.sided

```


Or, for difference in means = 2 at power=0.8 and significance level=0.05:
```
> power.t.test(power = 0.8, delta = 2/sqrt(2), sd = sqrt(2), sig.level = 0.05)

     Two-sample t test power calculation

              n = 16.71477
          delta = 1.414214
             sd = 1.414214
      sig.level = 0.05
          power = 0.8
    alternative = two.sided

NOTE: n is number in *each* group
```

<br/>

Consider also examples on page 36 of the [Cambridge manual](https://rawgit.com/bioinformatics-core-shared-training/experimental-design/master/ExperimentalDesignManual.pdf)

<br/>

## Design of RNA-seq experiment

| Things to consider|
| :---:  |
|<img src="images/exp_design.jpg" width="700" align="middle" />|
|from [https://galaxyproject.org/tutorials/rb_rnaseq/](https://galaxyproject.org/tutorials/rb_rnaseq/)|

<br/>


## Technical vs. biological replicates

**Technical replicates can be defined as different library preparations from the same RNA sample.** They should account for batch effects from the library preparation such as reverse transcription and PCR amplification. To avoid possible lane effects (e.g., differences in the sample loading, cluster amplification, and efficiency of the sequencing reaction), it is good practice to multiplex the same sample over different lanes of the same flowcell. In most cases, technical variability introduced by the sequencing protocol is quite low and well controlled.

**Technical replicates** are samples in which the starting biological material is the same, but the replicates are processed separately: there, we test the technical variability. It can be done for example to assess the **variability in library preparation**, or in the **sequencing** part itself.

Technical variation of the sequencing protocols is very low: **hence technical replicates are nowadays considered unnecessary** (in the era of microarrays, it was more problematic).

<br/> 

**Biological replicates** are samples in which the starting biological material is different. It could include:
  * Different organisms
  * Different cell cultures
  * Different samplings of the same tumors

Why are **biological** replicates important?

They are crucial to assess the **variability within an experimental group**: the more the number of replicates, the better this assessment, and thus the more precise the differential expression measurement.

<br/> 

**Questions:** Are those samples technical or biological replicates?
* Three samples of blood were obtained from a healthy patient not under any treatment during three consecutive days at the same hour.
* Three samples of blood were obtained from a healthy patient not under any treatment during a day in the morning, after lunch and after dinner.
* Three samples of blood were obtained from three healthy patient not under any treatment.
* Bone marrow was obtained from 12 mice. Cells from 6 mice were pooled to form sample 1; and cells from another 6 mice, to make sample 2.  


<br/>

From [ENCODE Guidelines and Best Practices for RNA-Seq](https://www.encodeproject.org/documents/cede0cbe-d324-4ce7-ace4-f0c3eddf5972/@@download/attachment/ENCODE%20Best%20Practices%20for%20RNA_v2.pdf):
"In all cases, experiments should be performed with **two or more biological replicates**, unless there is a compelling reason why this is impractical or wasteful (e.g. overlapping time points with high temporal resolution). **A biological replicate is defined as an independent growth of cells/tissue** and subsequent analysis. **Technical replicates from the same RNA library are not required, except to evaluate cases where biological variability is abnormally high.** In such instances, separating technical and biological variation is critical. In general, detecting and quantifying low prevalence RNAs is inherently more variable than high abundance RNAs. As part of the ENCODE pipeline, annotated transcript and genes are quantified using RSEM and the values are made available for downstream correlation analysis. 
**Replicate concordance:** the gene level quantification should have a Spearman correlation of >0.9 between **isogenic replicates** *(Two replicates from biosamples derived from the same human donor or model organism strain. These biosamples have been treated separately; i.e. two growths, two separate knockdowns, or two different excisions)* and >0.8 between **anisogenic replicates** *(Two biological replicates from similar tissue biosamples derived from different human donors or model organism strains)*."

<br/>


## Number of replicates in RNA-seq experiment

From [Schurch, et al., RNA, 2016](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4878611/):
"RNA-seq is now the technology of choice for genome-wide differential gene expression experiments, but it is not clear how many biological replicates are needed to ensure valid biological interpretation of the results or which statistical tools are best for analyzing the data. An RNA-seq experiment with 48 biological replicates in each of two conditions was performed to answer these questions and provide guidelines for experimental design. **With three biological replicates, nine of the 11 tools evaluated found only 20%–40% of the significantly differentially expressed (SDE) genes identified with the full set of 42 clean replicates. This rises to >85% for the subset of SDE genes changing in expression by more than fourfold. To achieve >85% for all SDE genes regardless of fold change requires more than 20 biological replicates.**" 

| Recommendations for RNA-seq experiment design for identifying differentially expressed (DE) genes|
| :---:  |
|<img src="images/fig2_schurch_2016.png" width="700" align="middle" />|
| from [Schurch, et al., RNA, 2016; Fig 2.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4878611/)|

Final recommendations from this paper:
* At least 6 replicates per condition for all experiments.
* At least 12 replicates per condition for experiments in which identifying of the majority of all DE genes is important.
* For experiments with <12 replicates per condition; use edgeR (exact) or DESeq2.
* For experiments with >12 replicates per condition; use DESeq.
* Apply a fold-change threshold (T) appropriate to the number of replicates per condition between 0.1 ≤ abs(T) ≤ 0.5.

<br/>


## RNA-Seq: Paired-end vs. single-end reads, read size and sequencing depth

| Paired-end read |
| :---:  |
|<img src="images/read.png" width="400" align="middle" />|

<br/>
Sequencing depth refers to the number of reads covering each genomic position, on average.

It is calculated as **(total number of reads * average read length) / total length of genome**. However, since in RNA-seq experiments scientists are dealing with transcriptomes rather than genomes, it is conventinal to tak about **the number of reads**.


### General gene-level differential expression
* For large genomes (human/mouse), ENCODE suggests to have per sample 30 million single-end (mappable to the genome) reads of size 50 bp and more (and use stranded protocol with polyA selection).

### Gene-level differential expression with detection of low-expressed genes
* For large genomes, 30-60M single-end (aligned to the genome) reads of size 50 bp and more (stranded protocol with polyA selection).

### Differential expression of gene isoforms and detection of new isoforms
* 50-100M paired-end reads of size 100 bp or more

### *De novo* transcriptome assembly
* 100-200M paired-end reads of size 150 bp or more

<br/>

| Adding more sequencing depth after 10 M reads gives diminishing returns on power to detect DE genes, whereas adding biological replicates improves power significantly regardless of sequencing depth |
| :---:  |
|<img src="images/seq_depth_Bioinformatics_2014.png" width="800" align="middle" />|
| from [Liu et al., RNA-seq differential expression studies: more sequence or more replication? Bioinformatics, 2014](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3904521/)|



<br/>

## Resources
* [ENCODE Guidelines and Best Practices for RNA-Seq](https://www.encodeproject.org/documents/cede0cbe-d324-4ce7-ace4-f0c3eddf5972/@@download/attachment/ENCODE%20Best%20Practices%20for%20RNA_v2.pdf)
* [The Experimental Design Assistant from NC3RS, UK](https://eda.nc3rs.org.uk/experimental-design)
* [https://github.com/hbctraining/rnaseq_overview/blob/master/lessons/experimental_planning_considerations.md](https://github.com/hbctraining/rnaseq_overview/blob/master/lessons/experimental_planning_considerations.md)
* [Experimental design manual, Cambridge University, UK ](https://rawgit.com/bioinformatics-core-shared-training/experimental-design/master/ExperimentalDesignManual.pdf)
* [Paper on statistical power in biomedical science](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5367316/)
* [Paper "Statistical significance and statistical power in hypothesis testing"](http://muscle.ucsd.edu/More_HTML/papers/pdf/Lieber_JOR_1990.pdf)
* [Blog post "Underpowered statistics"](https://www.statisticsdonewrong.com/power.html)
* [Paper "An introduction to power and sample size estimation"](https://emj.bmj.com/content/20/5/453)
* [Paper "Mindless statistics"](http://library.mpib-berlin.mpg.de/ft/gg/GG_Mindless_2004.pdf)
* [http://chagall.med.cornell.edu/RNASEQcourse/Intro2RNAseq.pdf](http://chagall.med.cornell.edu/RNASEQcourse/Intro2RNAseq.pdf)
* [Paper "How many biological replicates are needed in an RNA-seq experiment and which differential expression tool should you use?" RNA, 2016](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4878611/)
* [Paper "RNA-seq differential expression studies: more sequence or more replication?" Bioinformatics, 2014](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3904521/)



