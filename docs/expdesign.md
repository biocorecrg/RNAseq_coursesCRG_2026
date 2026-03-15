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
How to address core principles of experimental design for a RNA-seq experiments:
<br>

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

<div style="display:flex; justify-content:center;">

| |
|:---:|
| ![fishy](images/tech_bio_replicates.png) | 
| *adapted from [Bernd Klaus, EMBO 2015](https://link.springer.com/article/10.15252/embj.201592958)* |

</div>

<br>

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

<br>

:::{important}
**Increasing the number of biological replicates generally improves statistical power more than increasing sequencing depth**
([Tarazona et al., 2011](https://genome.cshlp.org/content/21/12/2213), 
[Liu et al., 2014](https://academic.oup.com/bioinformatics/article/30/3/301/236651), 
[Schurch et al., 2016](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4878611/)).
:::

<br>

<div style="display:flex; justify-content:center;">

| |
|:---:|
| ![fishy](images/Fig1_Liu_2014.png) | 
| **(a) Increase in biological replication significantly increases the number of DE genes identified.** Numbers of sequencing reads have a diminishing return after 10 M reads. Line thickness indicates depth of replication, with 2 replicates the darkest and 7 replicates the lightest. The lines are smoothed averages for each replication level, with the shaded regions corresponding to the 95% confidence intervals. <br> **(b) Power of detecting DE genes increases with both sequencing depth and biological replication.** Similar to the trends in (a), increases in the power showed diminishing returns after 10 M reads. <br> *Figure is adapted from [Liu et al., 2014](https://academic.oup.com/bioinformatics/article/30/3/301/236651)* |

</div>

<br><br>

---

### Number of replicates in RNA-seq experiments

> "RNA was sequenced from 48 biological replicate samples of Saccharomyces cerevisiae in each of two well-studied experimental conditions; wild-type (WT) and a Δsnf2 mutant. ... <br>
       Bootstrap runs were performed with i = 100 iterations and nr = 2,…,40 replicates in each condition.<br>
       For a given value of nr, the mean log2 transformed fold change [log2(FC)] and median adjusted P-value or FDR calculated across all the bootstrap iterations was considered representative of the measured behavior for each individual gene. <br>
       Genes were marked as SDE when the adjusted P-value or FDR was ≤0.05. <br>
       From these results, true positive, true negative, false positive, and false negative rates were calculated as a function of nr for four arbitrary fold-change thresholds (|lo⁢g2⁡(𝐹⁡𝐶)| =𝑇 ∈{0,0.3,1,2}), by comparing the SDE genes from each bootstrap with the SDE genes from the tool's gold standard."
>
> — [Schurch et al., 2016](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4878611/)


<div style="display:flex; justify-content:center;">

| |
|:---:|
| ![fishy](images/fig2_schurch_2016.png) | 
| **Statistical properties of edgeR (exact) as a function of log2FC threshold, T, and the number of replicates, nr. (A)** The fraction of all (7126) genes called as SDE as a function of the number of replicates nr. **(B)** Mean true positive rate (TPR) as a function of nr for four thresholds (solid curves). **(C)** Mean TPR as a function of T for nr (solid curves). **(D)** The number of genes called as TP, FP, TN, and FN as a function of nr. <br> *Figure is adapted from [Schurch, et al., RNA, 2016](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4878611/)* |

</div>


The study showed that:

- With **3 replicates**, many differentially expressed genes are missed --> Fig A - <30% SDEs identified; 
in particular, many lower expressed genes are missed --> Fig B - TPR = 0.8 for log2FC > 1
- With **6 replicates**, most strong signals are detected --> Fig A - ~40% SDEs identified;
Fig B - TPR = 0.87 for log2FC > 1; TPR = 0.8 for log2FC > 0.5
- Detecting small expression changes may require **more than 10 replicates** --> Fig. C - TPR = 0.9 for log2FC > 0.3 (i.e., FC = 1.24)

<br>


---

### When the number of replicates is limited

In practice, RNA-seq experiments are often performed with a small number of biological replicates due to cost or sample availability. <br>
However, studies have shown that differential expression results obtained from small cohort sizes are often difficult to reproduce in independent experiments.

A recent analysis by [Degen & Medo, 2025](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1011630) 
simulated more than 18,000 RNA-seq experiments by repeatedly 
subsampling real datasets with cohort sizes ranging from 3 to 15 replicates. <br><br>
The study showed that **experiments with small cohort sizes frequently produce differential expression results that are unlikely to replicate well.**
<br><br>
However, low replicability does not necessarily imply that the results are incorrect. 
In many cases, the main problem is low recall (missing true signals) rather than a high rate of false positives.

<div style="display:flex; justify-content:center;">

| |
|:---:|
| ![fishy](images/expdesign_journal.pcbi.1011630.g002.PNG) | 
| **DEG performance metrics as a function of the cohort size.** Each symbol summarizes the median of 100 cohorts. All panels show results using the DESeq2 Wald test with abs(log2FC) above 1. <br> *Figure is adapted from [Degen & Medo, 2025](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1011630)* |

</div>

<br>

**Fig A shows the median replicability of 100 subsampled cohorts as a function of the cohort size.**
<br>Except for the SNF2 data set, all data sets show low (<0.5) replicability for the smallest cohort size of N = 3. <br>
For the largest cohort size of N = 15, a wide range of replicability values is observed, depending on the data set. 
<br>
**Fig C & D show that the precision rises more steeply than recall for small cohort sizes.** <br>
10 out of 18 data sets exceed the precision of 0.9 for N>5. <br>

In contrast, for all data sets except SNF2, recall is below 0.5 for N<7. <br>
<br>
**That means that false negatives (low recall) are a more significant driver of low replicability than false positives (low precision).**
<br><br>


<div style="display:flex; justify-content:center;">

| |
|:---:|
| ![fishy](images/expdesign_journal.pcbi.1011630.g003.PNG) | 
| **Heat maps and fold change estimates for SNF2 and LMAB data sets.** <br> Left column: Heat maps showing the logCPM correlation of samples for the SNF2 and LMAB data sets. Heat map rows and columns were ordered using hierarchical Ward clustering. <br> Right column: Fold change estimates of expressed genes in the SNF2 and LMAB data sets. **Blue dots represent the ground truth estimate from the full data set.** Gray (red) bars represent the interquartile range of estimates obtained from 100 subsampled cohorts of size N = 3 (N = 15). The horizontal dashed line shows the logFC threshold used to define DEGs. <br> *Figure is adapted from [Degen & Medo, 2025](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1011630)* |

</div>

<br>

> The best-performing SNF2 data set is so homogeneous and well-separated by condition that the subsampling has little influence on the logFC estimation, which has little variance even for the smallest cohort sizes. 
<br><br>By contrast, the worst-performing LMAB data has few true DEGs and 
the logFC estimates exhibit substantial sampling variance, 
which leads to **logFC estimates that are either inflated or deflated.** ...
<br>In the case of inflation of a non-DEG, the respective gene is more likely to spuriously pass significance 
and fold change thresholds, thus yielding a false positive. ...<br>
[this is] **the study that inflates effect sizes and undermines the reliability of results.** <br><br>
These findings are consistent with expectations, given that the SNF2 samples originate from cell colonies, whereas the LMAB samples are derived from heterogeneous tumor tissues. 
>
> — [Degen & Medo, 2025](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1011630) 

<br>

---

### Recommendations when replication is limited (from Degen & Medo, 2025)

When experiments must be performed with a small number of replicates:

- Interpret differential expression results with caution.
- Focus on **large effect sizes** rather than small fold changes.
- Validate key findings using independent experiments.
- Use **resampling or bootstrapping approaches** to estimate the reliability of results.

These approaches can help estimate whether the results of an underpowered RNA-seq experiment are likely to contain many false discoveries.

<br> **What does it mean "focus on large effect size"?**
<br> That means that instead of testing the null hypothesis log2FC=0 <br>
test for **abs(log2FC) > lfcThreshold** (e.g., =1). <br><br>
**This improves interpretability and maintains proper type I error control.**
<br><br>DESeq2 implementation:
```
results(dds, lfcThreshold = 1)
```
Thus, instead of asking
```
Is the gene differentially expressed?
```
you ask
```
Is the fold change larger than a biologically meaningful threshold?
```

<br>

:::{admonition} 
:class: important
When replication cannot be increased, researchers should treat RNA-seq results as **hypothesis-generating rather than definitive evidence.**
Significant DEGs from one small cohort are unlikely to be significant in another small cohort (low replicability), 
unless it is known that the population is **very homogeneous** (e.g. cell cultures).

:::

<br>

Typical recommendations for bulk RNA-seq experiments:

| Replicates per condition | Interpretation |
|---|---|
| 2 | insufficient |
| 3 | minimum |
| 5–6 | recommended |
| >10 | very robust |

<br>
---


### Recommended number of sequencing reads

For bulk RNA-seq differential expression experiments in human/mouse, 
the [ENCODE consortium](https://www.encodeproject.org/data-standards/rna-seq/long-rnas/)
 recommends for each replicate to have **at least 30 million mapped paired reads per sample**.

Because not all reads map to the reference genome or transcriptome, the number of **sequenced reads must be higher** than the number of mapped reads. 
<br>In typical RNA-seq experiments, mapping rates are often around **80–85%**, depending on the organism, library preparation, and read quality.
<br>
This implies that achieving 30 million mapped reads usually requires sequencing approximately:

| Target mapped reads | Typical mapping rate | Approximate reads to sequence |
|---|---|---|
| 30 million | 80–85% | 35–40 million reads |

Mapping rates can vary depending on several factors:

- quality of the RNA and library preparation
- contamination (e.g., rRNA)
- completeness of the reference genome or transcriptome
- read length and sequencing quality

Therefore, sequencing projects typically aim for **slightly higher sequencing depth than the desired number of mapped reads** to ensure sufficient usable data for downstream analysis.

Typical sequencing depths for bulk RNA-seq experiments include:

| Application | Recommended sequencing reads per sample |
|---|---|
| Gene-level differential expression | 35-40 million |
| Alternative transcript or isoform analysis | 50–100 million |
| Detection of rare or lowly expressed transcripts | >100 million |

Sequencing depth influences several aspects of RNA-seq data analysis:
- **Detection of low-expression genes.**  
  Low abundance transcripts require sufficient sequencing depth to be reliably detected.

- **Precision of expression estimates.**  
  Genes with higher read counts have lower sampling noise and therefore more stable expression estimates.

- **Isoform detection and alternative splicing analysis.**  
  Resolving transcript isoforms typically requires deeper sequencing than gene-level expression analysis.

:::{admonition} 
:class: important
Increasing sequencing depth cannot compensate for insufficient biological replication.  
While deeper sequencing improves sensitivity for detecting transcripts, it does not improve estimation of biological variability between samples.
:::

<br>

:::{admonition} 
:class: note
Consider using existing tools to estimate the sample size for the target power
- The R library **[SsizeRNA](https://pubmed.ncbi.nlm.nih.gov/27029470/)** (Sample Size Calculation for RNA-Seq) 
allows for predicting the sample size used in an experiment with the target power, 
considering variable fold changes for specific genes, 
while also enabling the validation of predictions through a built-in function. 
- **[PROPER](https://pmc.ncbi.nlm.nih.gov/articles/PMC4287952/)** (PROspective Power Evaluation for RNAseq) provides methods to assess the relationship between power and sample size in the context of differential expression (DE) detection from RNA-seq data, taking into account the read depth. It performs a comprehensive evaluation of statistical power and the actual type I error depending on the sample size, based on simulation studies.
:::

<br><br>

---

## Randomization or How to avoid systematic bias

:::{admonition} 
:class: important
Replication → estimate biological variability and increase statistical power
Randomization → avoid systematic bias by preventing correlation between biological conditions and technical factors
:::


### Variables, factors, and levels

In experimental design, experiments are described in terms of **variables**, **factors**, and **levels**.

| Term | Meaning | Example in RNA-seq |
|---|---|---|
| Variable | Any measured or controlled property | gene expression level |
| Factor | A variable that defines experimental conditions | treatment, genotype, sex |
| Level | The specific value of a factor | treated / control |

Examples of **biological factors** in an RNA-seq experiment:

| Factor | Levels |
|---|---|
| Treatment | control, drug |
| Sex | male, female |
| Genotype | wild type, mutant |

Biological factors define the structure of the experiment 
and determine how samples will be compared in statistical models.

<br>

:::{admonition} **Technical vs biological factors**
:class: important
- biological factor → treatment, genotype
- **technical factor → batch, lane**
:::

Common sources of technical variation in an RNA-seq experiment:

- **sample processing order**
- **RNA extraction batches**
- **library preparation batches**
- **sequencing lanes or flowcells**

Therefore, if samples from one experimental condition are processed 
together, **technical effects may become confounded 
with biological conditions**, and it becomes impossible 
to distinguish true biological effects from technical artifacts.

<br>

:::{admonition} **Confound** (verb) - definition
:class: note
To cause surprise or confusion, especially by not according with their expectations.
:::


<br>


---


### Randomization in practice

**The goal of the randomization technique** 
is to distribute potential technical variation 
**evenly across experimental groups**, 
ensuring that observed differences between conditions are more likely to reflect biological differences rather than systematic bias.

<br>
Randomization should be applied at every stage 
of the experimental workflow where technical variation 
may occur.


:::{admonition} **Samples must be randomly distributed across experimental steps:**
:class: important
- sample processing order
- RNA extraction batches
- library preparation
- sequencing lanes
:::



For example, a problematic design would be:

| Lane | Samples |
|---|---|
| Lane 1 | all control samples |
| Lane 2 | all treated samples |

In this case, any **lane effect** would be indistinguishable from the treatment effect.

A better design distributes samples randomly:

| Lane | Samples |
|---|---|
| Lane 1 | control, treated, control |
| Lane 2 | treated, control, treated |

Randomization ensures that technical variation is spread across biological experimental groups.
<br>
Randomization protects against **unknown or uncontrolled sources of technical variation** 
such as subtle differences in sample handling, reagent performance, or sequencing runs. By distributing samples from different biological conditions across experimental steps, randomization prevents these unknown factors from becoming systematically associated with the biological condition.

<br>

---

### Batch effects in RNA-seq

A **batch** is a group of samples processed together under the same technical conditions during an experimental step.  
Batches can introduce systematic technical variation unrelated to the biological factors of interest.

<br>

Examples of batches in RNA-seq experiments:

| Experimental step     | Example of batch                            |
|-----------------------|---------------------------------------------|
| RNA extraction        | samples extracted on the same day           |
| library preparation   | samples prepared using the same reagent kit |
| sequencing            | samples run on the same flowcell or lane    |
| laboratory processing | samples processed in the same lab           |

<br>

#### How to detect potential batches?

Ask whether technical conditions differed across samples:

- Were all RNA isolations performed on the same day?
- Were all library preparations performed on the same day?
- Did the same person perform the RNA isolation/library preparation for all samples?
- Did you use the same reagents for all samples?
- Did you perform the RNA isolation/library preparation in the same location?

If any answer is **“No”**, then **technical batches may exist**.

<br>

Having batches does **not automatically mean there is a batch effect problem**.  
Batches are common and often unavoidable in real experiments.

**The batch effect becomes problematic when the batch variable is correlated with the biological condition of interest**, making it difficult or impossible to distinguish biological effects from technical variation.

---

#### Batches exist but are randomized (good design)

| Batch   | Samples                 |
|--------|--------------------------|
| Batch 1 | control, **treated** |
| Batch 2 | control, **treated** |
| Batch 3 | control, **treated** |
| Batch 4 | control, **treated** |

Here, batch and condition are independent.

Batch effects may exist but **can be separated from the biological effect**.

Solution: batch can be ignored if its effect is small or modeled (in DESeq, design = ~ batch + condition)


---

#### Batches exist and are partially correlated (risky design)

| Batch   | Samples                 |
|--------|--------------------------|
| Batch 1 | **treated**, **treated** |
| Batch 2 | control, **treated** |
| Batch 3 | control, **treated** |
| Batch 4 | control, control |

Here, batch and condition are **partially correlated**.

Batch effects can still be modeled statistically, 
but the design is **suboptimal** and 
may reduce statistical power.

Solution: batch can be modeled (in DESeq, design = ~ batch + condition)


---

#### Batch is fully confounded with condition (fatal design error):

| Batch   | Samples          |
| ------- | ---------------- |
| Batch 1 | **treated**, **treated** |
| Batch 2 | control, control |
| Batch 3 | **treated**, **treated** |
| Batch 4 | control, control |

treatment effect = batch effect

The biological condition is perfectly confounded with the batch variable.

**No statistical method can separate these effects.**


:::{admonition} **Batch effect rule**
:class: important
Batch effects are only problematic when the batch variable is correlated with the biological condition being tested.
:::

<br>

---

## Blocking or How to control known variation

:::{admonition} 
:class: important
Replication → estimate biological variability and increase statistical power
Randomization → avoid systematic bias by preventing correlation between biological conditions and technical factors
Blocking → control known variation
:::

Blocking is used when a known source of variation exists 
(for example, library preparation batches or patients).
<br>Blocking handles known, recorded factors explicitly modeling batch as variable.
<br> While randomization protects against factors that are not modeled or cannot be modeled.


Even if batches contain the same number of samples per condition,
processing order can introduce bias 
(e.g., reagent degradation, operator fatigue - technical factors that cannot be modeled).

**Example: systematic bias caused by processing order**
<br>Batch 1

| Sample | treated | treated | treated | control | control | control |
|--------|---------|---------|---------|---------|---------|---------|
| Processing order | 1 | 2 | 3 | 4 | 5 | 6 |

<br>Batch 2

| Sample | control | control | control | treated | treated | treated |
|--------|---------|---------|---------|---------|---------|---------|
| Processing order | 1 | 2 | 3 | 4 | 5 | 6 |


Since the processing order can introduce unknown bias that cannot be modeled,
randomization has to be applied.

**Randomized processing order**
<br>Batch 1

| Sample | control | treated | control | treated | treated | control |
|--------|---------|---------|---------|---------|---------|---------|
| Processing order | 1 | 2 | 3 | 4 | 5 | 6 |

<br>Batch 2

| Sample | treated | control | treated | control | control | treated |
|--------|---------|---------|---------|---------|---------|---------|
| Processing order | 1 | 2 | 3 | 4 | 5 | 6 |

<br>Randomizing the processing order distributes potential technical variation (e.g. reagent degradation or operator effects) across biological conditions.


:::{admonition} **Key message**
:class: important
Randomize what you cannot control, 
<br>block what you can control (using batch in statistical model: design = ~ batch + condition).
:::
Randomize what you cannot control, block what you can control.

<br>

---

## Factorial designs and interactions

:::{admonition} 
:class: important
Replication → estimate biological variability and increase statistical power
Randomization → avoid systematic bias by preventing correlation between biological conditions and technical factors
Blocking → control known variation
Factorial design → structure biological questions
:::

Many RNA-seq experiments involve more than one biological factor.  
When multiple factors are studied simultaneously, 
the experiment follows a **factorial design**.

Factorial designs allow researchers to investigate 
the effects of multiple variables in a single experiment and to test whether these variables interact with each other.

<div style="display:flex; justify-content:center;">

| |
|:---:|
| ![fishy](images/images/factorial_design_1.jpg) | 
| Example of a factorial experimental design with two factors: treatment and sex. The design allows testing main effects and their interaction. <br> *Figure is adapted from Cambridge University's Experimental Design Manual 2016* |

</div>

In this example, the experiment contains two factors (biological variables):

- **Treatment** (control vs treated)
- **Sex** (male vs female)

Each factor has two levels, producing four experimental groups.
<br>This is a **2 × 2 factorial design**.

Such a design allows testing:

- **Main effect of treatment** - Does the treatment change gene expression?
- **Main effect of sex** - Do males and females differ in gene expression?
- **Interaction between treatment and sex** - Does the treatment affect males and females differently?

An **interaction** occurs when the effect of one factor depends on the level of another factor.

The real statistical test of interaction is:
```
(treated_males − control_males)
−
(treated_females − control_females)
```

Example for a specific gene:

| Sex | Control | Drug |
|---|---|---|
| Male | low expression | high expression |
| Female | low expression | unchanged |

In this example, the treatment changes gene expression in **males but not females**, 
indicating a **treatment × sex interaction**.

That is,
```
(treated_male − control_male)
≠
(treated_female − control_female)
```

This difference of differences is exactly what the interaction term tests.

In RNA-seq analysis, for each gene, a model such as
```
design = ~ sex + treatment + sex:treatment
```
tests three things:

| term          | interpretation                                 |
| ------------- | ---------------------------------------------- |
| sex           | baseline difference between males and females  |
| treatment     | treatment effect averaged across sexes         |
| sex:treatment | whether treatment effect differs between sexes |

For our example gene:

| Effect           | Interpretation                                                |
| ---------------- | ------------------------------------------------------------- |
| sex effect       | none apparent in controls                                     |
| treatment effect | differs between sexes                                         |
| interaction      | **suggested by the pattern but must be tested statistically** |

The pattern suggests a potential **treatment × sex interaction**, 
because the treatment increases expression in males 
but not in females. 
However, whether this interaction is statistically significant depends on the variability between replicates and the number of samples.

<br>

---

### Why factorial designs are useful

Factorial designs allow researchers to:

- test multiple biological hypotheses in a single experiment
- increase experimental efficiency
- avoid performing multiple separate experiments

However, factorial designs require 
**sufficient replication in each experimental group** 
to reliably estimate effects and interactions.

When multiple factors are studied, the number of experimental groups increases because each combination of factor levels must be measured.

Example:

| Treatment | Sex |
|---|---|
| control | male |
| control | female |
| drug | male |
| drug | female |

This is a **2 × 2 factorial design**, producing four experimental groups.

If each group contains *n* biological replicates, the total number of samples becomes:
```
total samples = number of groups × replicates per group
```


For example:

| Replicates per group | Total samples |
|---|---|
| 3 | 12 |
| 5 | 20 |
| 8 | 32 |

In factorial experiments, replication is needed not only to estimate the **main effects** of each factor, but also to estimate **interactions between factors**.

An interaction occurs when the effect of one factor depends on the level of another factor.  
Statistically, interaction effects compare **differences between differences**.

Example interaction test:
```
(treated_male − control_male) − (treated_female − control_female)
```


Because interaction terms involve additional comparisons and are often smaller than main effects, they typically require **more biological replication** to detect reliably.


In RNA-seq experiments, factorial designs are common when studying treatment effects across **sex, genotype, time points, or environmental conditions**.

:::{admonition} 
:class: important
A practical rule of thumb is that each experimental group 
should contain **at least 3–5 biological replicates**, 
although larger numbers are often required when studying subtle effects or interactions.
:::



---

## Appendix. Power analysis & sample size

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
We study the difference of some measurement in two populations, 
in which we assume this variable is normally distributed,
so we could use the t-test on the difference of means. 
<br/>

We draw two samples (n=2) from each population independently and randomly and get
```
x = c(9, 11)
y = c(17,19)
```


We run the *t-test on difference of means* (it is equal 8)
and get **p-value=0.03** *( in R, use function t.test(x, y) )*.

<br/>

Since we know the variance for x and y, *var(x) = 2; var(y) = 2*, 
we can calculate the power of the t-test to detect the observed **effect size delta**  
*( in R, use function power.t.test(n, delta, sd, sig.level = 0.05) )*
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


The obtained **power = 0.56**. 
This means that **Type II error**,
or the probability of accepting a false null hypothesis;
 that is, concluding that there is NO difference in means
 when in fact there is the difference) is
 **= 1 - power = 44% !!!!** 
 That means that in 44% of tests conducted with 
 **these parameters for n and sd**, 
 the given effect size delta will be NOT seen as significant even when it is significant. 

It is a waste of resources to conduct such an **under-powered study**. 

If we want to detect this effect size (difference in means of 8) with higher power, 
we have to increase the number of samples (n).

<br/>

**But what difference in means can we detect with just 2 samples at a sufficient power?**


```
x = c(9, 11)
y = c(24, 26)
```
We run the t-test on the difference of means (it is equal 15) 
and get **p-value=0.009**.


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
This is an **adequtely powered experiment**. 
That is, if the true difference of means of two populations is 15, 
we can detect it by drawing only 2 random and independent samples from each population. 
 That means that in only 6% (1 - power) of tests conducted with 
 **these parameters for n and sd**, 
 the given effect size delta will be NOT seen as significant even when it is significant. 

If however, the significance level alpha becomes more stringent,
 say 0.01, the power will decrease to 0.43:
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
n=2.54 --> We need to draw 3 samples from each group of our population to 
observe the difference of means = 15 
at significance level = 0.01 and power = 0.9

<br>

For a much smaller effect size of difference in means = 2 
at power=0.8 and significance level=0.05, we need n=17 (!):
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

<br>

---

## References

### RNA-seq experimental design and replication

- **Schurch NJ. RNA. 2016.**  
  *How many biological replicates are needed in an RNA-seq experiment and which differential expression tool should you use?*  
  [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4878611/](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4878611/)

- **Liu Y. Bioinformatics. 2014.**  
  *RNA-seq differential expression studies: more sequence or more replication?*  
  [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3904521/](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3904521/)

- **Tarazona S. Genome Research. 2011.**  
  *Differential expression in RNA-seq: a matter of depth or replication?*  
  [https://genome.cshlp.org/content/21/12/2213](https://genome.cshlp.org/content/21/12/2213)

- **SEQC Consortium. Nature Biotechnology. 2014.**  
  *A comprehensive assessment of RNA-seq accuracy, reproducibility and information content by the Sequencing Quality Control Consortium.*  
  [https://pmc.ncbi.nlm.nih.gov/articles/PMC4321899](https://pmc.ncbi.nlm.nih.gov/articles/PMC4321899)

- **Degen R. PLOS Computational Biology. 2025.**  
  *Replicability of RNA-seq differential expression results with small sample sizes.*  
  [https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1011630](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1011630)

- **Antoszewski M. Methods. 2025.**  
  *A practical guide to designing RNA-seq experiments.*  
  [https://www.sciencedirect.com/science/article/pii/S2001037025005525](https://www.sciencedirect.com/science/article/pii/S2001037025005525)


---

### Statistical power and experimental design

- **Lieber RL. Journal of Orthopaedic Research. 1990.**  
  *Statistical significance and statistical power in hypothesis testing.*  
  [http://muscle.ucsd.edu/More_HTML/papers/pdf/Lieber_JOR_1990.pdf](http://muscle.ucsd.edu/More_HTML/papers/pdf/Lieber_JOR_1990.pdf)

- **Biau DJ. Emergency Medicine Journal. 2003.**  
  *An introduction to power and sample size estimation.*  
  [https://emj.bmj.com/content/20/5/453](https://emj.bmj.com/content/20/5/453)

- **Button KS. Nature Reviews Neuroscience. 2013.**  
  *Power failure: why small sample size undermines the reliability of neuroscience.*  
  [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5367316/](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5367316/)

- **Gigerenzer G. Psychological Science. 2004.**  
  *Mindless statistics.*  
  [http://library.mpib-berlin.mpg.de/ft/gg/GG_Mindless_2004.pdf](http://library.mpib-berlin.mpg.de/ft/gg/GG_Mindless_2004.pdf)

---

### Guidelines and educational resources

- **ENCODE Consortium.**  
  *Guidelines and Best Practices for RNA-seq.*  
  [https://www.encodeproject.org/documents/cede0cbe-d324-4ce7-ace4-f0c3eddf5972/@@download/attachment/ENCODE%20Best%20Practices%20for%20RNA_v2.pdf](https://www.encodeproject.org/documents/cede0cbe-d324-4ce7-ace4-f0c3eddf5972/@@download/attachment/ENCODE%20Best%20Practices%20for%20RNA_v2.pdf)

- **Statistics Knowledge Portal – Design of Experiments.**  
  [https://www.jmp.com/en/statistics-knowledge-portal/design-of-experiments/key-design-of-experiments-concepts/key-principles-of-experimental-design](https://www.jmp.com/en/statistics-knowledge-portal/design-of-experiments/key-design-of-experiments-concepts/key-principles-of-experimental-design)

- **Experimental Design Assistant (NC3RS).**  
  [https://eda.nc3rs.org.uk/experimental-design](https://eda.nc3rs.org.uk/experimental-design)

- **Harvard Chan Bioinformatics Core RNA-seq training materials.**  
  [https://github.com/hbctraining/rnaseq_overview/blob/master/lessons/experimental_planning_considerations.md](https://github.com/hbctraining/rnaseq_overview/blob/master/lessons/experimental_planning_considerations.md)

- **Statistics Done Wrong – Underpowered statistics.**  
  [https://www.statisticsdonewrong.com/power.html](https://www.statisticsdonewrong.com/power.html)
  
    
