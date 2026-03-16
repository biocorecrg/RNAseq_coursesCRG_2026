# Pre-processing and Quality Control of Raw Sequencing Data

## Data for this course and SRA download:

The **Sequence Read Archive (SRA)** at NCBI is the world's largest public repository of raw sequencing data. It is the primary source for publicly available datasets to use for practice, benchmarking, or reproduction of published results.

### SRA Accession Types

| Prefix | Level | Example |
|--------|-------|---------|
| `PRJNA` | BioProject — the overall study | PRJNA257197 |
| `SAMN` / `SRS` | BioSample — a biological specimen | SAMN03254300 |
| `SRX` | Experiment — library preparation metadata | SRX123456 |
| `SRR` / `ERR` | Run — the actual sequencing reads | SRR1553607 |

The **SRR Run accession** is what you need to download reads. A single experiment (SRX) may have multiple runs (SRR). The data that will be using for the hands-on exercises is from GEO data set **GSE76647**. Specifically, it contains *Homo sapiens* samples from differentiated (5-day differentiation) and undifferentiated primary keratinocytes. Additionally, some samples underwent a knock-down of the **FOXC1** gene. 

We could try to download these datasets from SRA directly but due to time constrains, we have already prepared fastq files that correspond to **chromosome 6 only**. You will find them in the data directory within the repository of the course. 

## Raw Data QC

Before any downstream analysis (alignment, read count, differential expression, functional enrichment), it is critical to assess the **quality of raw sequencing reads** and pre-process them accordingly. Poor-quality data can introduce errors that propagate through the entire pipeline.

Pre-processing includes:
- Quality control of initial reads
- Adapter trimming
- Filtering out low-quality reads
- Trimming reads at low-quality base positions
- rRNA removal (where applicable)

---

### Tools Overview

| Tool | Purpose |
|:----:|:-------:|
| **FastQC** | Per-read quality metrics |
| **FastQ Screen** | Contamination screening against reference genomes |
| **Kraken2** | Taxonomic classification to detect biological contamination |
| **MultiQC** | Aggregates reports from all tools into one summary |

---

## FastQC

[**FastQC**](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) is the standard first-pass QC tool for sequencing reads. It reads FASTQ files (also in gzipped format) and produces an **HTML report** with multiple modules, each assessing a different aspect of read quality.

**Key metrics assessed:**
- Per-base sequence quality (Phred scores)
- Per-sequence quality scores
- Per-base sequence content (A/T/G/C composition)
- Per-sequence GC content
- Per-base N content
- Sequence length distribution
- Sequence duplication levels
- Overrepresented sequences
- Adapter content

> **Reminder — Phred quality scores**
>
> Phred scores (Q scores) encode the probability of a base-calling error:
>
> | Phred Score | Error Probability | Accuracy |
> |-------------|-------------------|----------|
> | Q10 | 1 in 10 | 90% |
> | Q20 | 1 in 100 | 99% |
> | Q30 | 1 in 1,000 | 99.9% |
> | Q40 | 1 in 10,000 | 99.99% |
>
> Reads are generally considered good quality if the median Phred score is ≥ Q30 across most positions.

### Running FastQC

```bash
# Run FastQC on a single file
fastqc sample.fastq.gz

# Run on multiple files
fastqc sample1.fastq.gz sample2.fastq.gz

# Specify output directory
fastqc -o ./fastqc_results/ sample.fastq.gz

# Use multiple threads (faster for large files)
fastqc -t 4 -o ./fastqc_results/ *.fastq.gz

# Go to the "quality_control" folder
mkdir ~/RNAseq_coursesCRG_2026/quality_control
cd ~/RNAseq_coursesCRG_2026/quality_control

# Run FastQC for one sample
$RUN fastqc ~/RNAseq_coursesCRG_2026/docs/data/reads/SRR3091420_1_chr6.fastq.gz -o .

# Run for all samples
$RUN fastqc ~/RNAseq_coursesCRG_2026/docs/data/reads/*.fastq.gz -o .

# Check output
ls .
# Expected: sample_fastqc.html, sample_fastqc.zip (per sample)
```

Display the results in a browser:

```bash
firefox SRR3091420_1_chr6_fastqc.html &
```

You can also extract the zip archive to access results in text format:

```bash
# Extract
unzip SRR3091420_1_chr6_fastqc.zip

# Remove remaining .zip file
rm SRR3091420_1_chr6_fastqc.zip

# Display content of directory
ls SRR3091420_1_chr6_fastqc

# File fastqc_data.txt contains the results in text format
less SRR3091420_1_chr6_fastqc/fastqc_data.txt
```

### Interpreting Key Plots

#### 1. Per Base Sequence Quality

- **Good:** Box plots remain in the **green zone** (Q > 28)
- **Warning:** Boxes drop into yellow (Q 20–28)
- **Fail:** Boxes drop into red (Q < 20)
- Common pattern: quality drops at the 3' end — this is normal for Illumina data

Below is an example of a good quality dataset (top) and a poor quality dataset (bottom). In the latter, the average quality drops dramatically towards the 3'-end.

![Good quality per base](images/fastqc.png)
*Figure: Good quality per base sequence*

![Bad quality per base](images/bad_fastqc.png)
*Figure: Bad quality per base sequence*

#### 2. Per Sequence GC Content

- Should follow a **normal bell-shaped curve**
- A shifted peak may indicate contamination or adapter dimers
- Bimodal distribution = likely contamination from another organism

#### 3. Adapter Content

- Should be near **0%** in well-prepared libraries
- High adapter content indicates insufficient insert size or failed library prep
- Adapters **must be trimmed** before alignment

This problem arises when the sequenced DNA fragment is **shorter than the read length** — the sequencer runs out of insert and reads into the adapter:

```
Ideal case (insert > read length):
  5'──────────────── INSERT ────────────────3'
  |←────── Read (150 bp) ──────→|

Problem case (insert < read length):
  5'──── INSERT ────3'
  |←──── Read ─────────────── ADAPTER →|
                   ↑
         Adapter sequence contaminates the read
```

#### 4. Overrepresented Sequences

- FastQC will BLAST-match overrepresented sequences
- Common hits: TruSeq adapters, polyA tails, rRNA
- Any unknown overrepresented sequence warrants investigation

> **Important — General rules do not apply to all applications**
>
> The guides above apply to regular RNA-seq datasets. In other applications, these rules do not hold:
> - **Small RNA-seq libraries:** insert size is smaller and adapter content is expected to be higher (see example below).
> - **Single-cell experiments:** read 1 contains the cell barcode and UMI, so its GC content profile may be altered.

![FastQC report for a small RNA-seq sample](images/fastqc_small_rnas.png)
*Figure: FastQC report for a small RNA-seq sample showing elevated adapter content*

## Exercises: FastQC Pattern Recognition Exercises

The following exercises use publicly available datasets from NCBI SRA, each chosen to illustrate a specific and **recognisable FastQC signature**. For each one, download the data, run FastQC, and answer the interpretation questions below. To download these datasets, NCBI provides the **SRA Toolkit**:

```bash
# Download a single run (compressed .sra format)
prefetch SRR1234567

# Convert to FASTQ (single-end)
fasterq-dump SRR1234567 --outdir ./fastq/

# For paired-end data, split into R1 and R2
fasterq-dump SRR1234567 --split-files --outdir ./fastq/

# Compress the output (fasterq-dump does not gzip by default)
gzip ./fastq/SRR1234567.fastq

# Download + convert in one step (skips local .sra file)
fasterq-dump SRR1234567 --outdir ./fastq/ --temp /tmp/

# Download only a subset of reads (useful for testing)
fasterq-dump SRR1234567 --outdir ./fastq/ -X 100000
# -X 100000 downloads only the first 100,000 reads
```

> **Note on download size:** Full SRA runs can be large (several GB). For the exercises below, downloading 1–2 million reads is sufficient to see the QC patterns clearly. Use `fasterq-dump -X 1000000` to limit the download.

---

### Dataset 1:

| Field | Value |
|-------|-------|
| Accession | `SRR5438575` |
| Study | GSE96960 — human serum miRNA profiling |
| Library type | miRNA-seq, single-end, Illumina HiSeq 2500 |
| Read length | 50 bp |

```bash
# Download 1 million reads
fasterq-dump SRR5438575 --outdir ./fastq/ -X 1000000
gzip ./fastq/SRR5438575.fastq

# Run FastQC
fastqc ./fastq/SRR5438575.fastq.gz -o ./fastqc_results/
firefox ./fastqc_results/SRR5438575_fastqc.html &
```
**Discussion questions:**
1. Is this adapter content a sign of a failed experiment? Why or why not?
2. What minimum read length would you expect to recover after adapter trimming, and why?
3. Would you apply the same quality interpretation to a standard mRNA-seq dataset with this level of adapter content?

---

### Dataset 2:

**Dataset:** Human total RNA-seq without ribo-depletion from human liver.

| Field | Value |
|-------|-------|
| Accession | `SRR390728` |
| Study | GSE30567 — human liver total RNA-seq |
| Library type | Total RNA-seq, single-end |
| Read length | 72 bp |

```bash
# Download 1 million reads
fasterq-dump SRR390728 --outdir ./fastq/ -X 1000000
gzip ./fastq/SRR390728.fastq

# Run FastQC
fastqc ./fastq/SRR390728.fastq.gz -o ./fastqc_results/
firefox ./fastqc_results/SRR390728_fastqc.html &
```

**Discussion questions:**
1. Would rRNA reads interfere with downstream differential expression analysis? How?
2. At what percentage of rRNA reads would you consider a ribo-depletion to have failed?
3. What sequencing strategy would you choose if you intentionally wanted to retain rRNA signal?

---

### Dataset 3

**Dataset:** Human PBMCs profiled with 10x Chromium v3 chemistry — a widely used reference scRNA-seq dataset.

| Field | Value |
|-------|-------|
| Accession | `SRR9201794` |
| Study | GSE132044 — human PBMC 10x Chromium v3 |
| Library type | 10x Genomics Chromium 3' scRNA-seq, paired-end |
| R1 length | 28 bp (16 bp cell barcode + 12 bp UMI) |
| R2 length | 91 bp (cDNA insert) |

```bash
# Download paired-end reads (R1 + R2)
fasterq-dump SRR9201794 --split-files --outdir ./fastq/ -X 1000000
gzip ./fastq/SRR9201794_1.fastq   # R1: barcode + UMI
gzip ./fastq/SRR9201794_2.fastq   # R2: cDNA

# Run FastQC on both reads
fastqc ./fastq/SRR9201794_1.fastq.gz ./fastq/SRR9201794_2.fastq.gz -o ./fastqc_results/

# Open both reports and compare
firefox ./fastqc_results/SRR9201794_1_fastqc.html &
firefox ./fastqc_results/SRR9201794_2_fastqc.html &
```

**Discussion questions:**
1. Should you trim or quality-filter the R1 barcode read in a 10x scRNA-seq experiment? Why or why not?
2. Why is it important to run FastQC on **both** R1 and R2 separately rather than treating the dataset as a standard paired-end RNA-seq library?
3. If you saw the R1 profile from this exercise in a standard bulk RNA-seq dataset, what would you conclude?

---

## FastQ Screen

[**FastQ Screen**](https://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/) screens reads to detect **cross-species contamination** or unexpected biological sequences. It is particularly useful for:

- Detecting **human contamination** in non-human samples (and vice versa)
- Identifying **mycoplasma**, **PhiX**, or **E. coli** contamination
- Verifying the **species of origin** of a sample

The tool works by:
1. Taking a subsample (~100,000 reads by default, adjustable with `--subset`)
2. Aligning reads to each reference genome using **Bowtie2**
3. Reporting the **percentage of reads** mapping to each reference
4. Generating a stacked bar chart showing mapping distribution

### Setting Up Databases

> **WARNING:** Do not run the following command in class — it will take too much time and resources.

```bash
# Download default databases
$RUN fastq_screen --get_genomes
```

This downloads 14 Bowtie2 indexes (model organisms and known contaminants):
- *Arabidopsis thaliana*, *Drosophila melanogaster*, *Escherichia coli*
- *Homo sapiens*, *Mus musculus*, *Rattus norvegicus*
- *Caenorhabditis elegans*, *Saccharomyces cerevisiae*
- Lambda, Mitochondria, PhiX, Adapters, Vectors, rRNA

Upon download, the **FastQ_Screen_Genomes** folder is created. You must provide a **fastq_screen.conf** configuration file with paths to the Bowtie2 binary and genome indices:

```
# This is a configuration file for fastq_screen

BOWTIE2 /usr/local/bin/bowtie2

## Human
DATABASE Human /path/to/FastQ_Screen_Genomes/Human/Homo_sapiens.GRCh38

## Mouse
DATABASE Mouse /path/to/FastQ_Screen_Genomes/Mouse/Mus_musculus.GRCm38

## E. coli
DATABASE Ecoli /path/to/FastQ_Screen_Genomes/E_coli/Ecoli

## PhiX
DATABASE PhiX /path/to/FastQ_Screen_Genomes/PhiX/phi_plus_SNPs

## Adapters
DATABASE Adapters /path/to/FastQ_Screen_Genomes/Adapters/contaminants
```

### Running FastQ Screen

```bash
$RUN fastq_screen --conf FastQ_Screen_Genomes/fastq_screen.conf \
           ~/RNAseq_coursesCRG_2026/docs/data/reads/SRR3091420_1_chr6.fastq.gz \
           --outdir ~/RNAseq_coursesCRG_2026/quality_control/
```

To view example results for SRR3091420_1_chr6.fastq.gz:

```bash
cd ~/RNAseq_coursesCRG_2026/quality_control/

wget https://public-docs.crg.es/biocore/projects/training/PHINDaccess2020/SRR3091420_1_fastq_screen.tar.gz
tar -zvxf SRR3091420_1_fastq_screen.tar.gz

firefox SRR3091420_1_screen.html
```

![FastQ Screen results](images/SRR3091420_1_screen.png)

### Output Files

```
sample_screen.html     # Visual HTML report with bar charts
sample_screen.txt      # Tab-delimited mapping statistics
```

Example `_screen.txt` output:

```
#Fastq_screen version: 0.15.3
Genome    #Reads_processed  #Unmapped  %Unmapped  #One_hit_one_genome  %One_hit  #Multiple_hits  %Multiple
Human     100000            95020      95.02      4830                 4.83      150             0.15
Mouse     100000            99780      99.78      180                  0.18      40              0.04
Ecoli     100000            99950      99.95      45                   0.05      5               0.00
PhiX      100000            100000     100.00     0                    0.00      0               0.00
```

### Interpreting Results

FastQ Screen results require careful interpretation — context matters depending on which databases are in your config.

**The `%Multiple` column and rRNA:** If your config includes an rRNA database, the `%Multiple` column will often be substantially elevated. This reflects the fact that rRNA sequences are **highly conserved across all domains of life**, so rRNA-derived reads legitimately map to multiple genomes. This is especially pronounced in total RNA-seq, metatranscriptomic libraries, or poorly ribo-depleted samples. In these cases, focus on:
- **`%One_hit_one_genome`** for the target organism — your primary signal
- **`%One_hit_one_genome`** for non-target organisms — elevated unique hits to an unexpected genome are the clearest sign of true contamination
- **Relative proportions** across genomes rather than absolute `%Multiple` values

**General guidelines:**
- **Expected:** The large majority of uniquely mapping reads should map to the target organism
- **Investigate:** Elevated unique hits to non-target organisms (e.g., >1–2% uniquely to *E. coli* in a human sample)
- **Flag:** High mapping to PhiX beyond expected spike-in levels, or unexpectedly high human signal in non-human samples
- **Do not over-interpret:** High `%Multiple` alone — always check whether an rRNA database is included before drawing conclusions

---

## Kraken2

[**Kraken2**](https://github.com/DerrickWood/kraken2) performs **k-mer based taxonomic classification** of sequencing reads. Unlike FastQ Screen — which aligns to specific genomes — Kraken2 classifies reads against a **broad taxonomic database**, enabling detection of unexpected organisms at genus/species level.

**Use cases:**
- Detecting **microbial contamination** in eukaryotic samples
- **Metagenomics** community profiling
- Validating **microbial sequencing** samples
- Identifying **viral contamination**

### How Kraken2 Works

1. Breaks each read into **k-mers** (default k=35)
2. Looks up each k-mer in a pre-built hash table of taxonomic assignments
3. Uses a **lowest common ancestor (LCA)** algorithm to assign a taxonomy
4. Reports classification at each taxonomic level (phylum → species)

### Building or Downloading a Database

```bash
# Download prebuilt standard database (~8 GB, includes bacteria, archaea, viruses, human)
# From: https://benlangmead.github.io/aws-indexes/k2
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20240904.tar.gz
mkdir kraken2_db
tar -xzf k2_standard_08gb_20240904.tar.gz -C kraken2_db/

# Or build a custom database (requires more disk space)
kraken2-build --standard --db kraken2_db/ --threads 16
```

### Basic Usage

```bash
# Classify single-end reads
kraken2 \
    --db kraken2_db/ \
    --threads 8 \
    --report sample_kraken2_report.txt \
    --output sample_kraken2_output.txt \
    sample.fastq.gz

# Classify paired-end reads
kraken2 \
    --db kraken2_db/ \
    --threads 8 \
    --paired \
    --report sample_kraken2_report.txt \
    --output sample_kraken2_output.txt \
    sample_R1.fastq.gz sample_R2.fastq.gz
```

### Understanding the Output

The report file (`--report`) follows this tab-delimited format:

```
% reads   # reads  # reads at taxon  rank  taxID   name
 78.50    78500    420               D     2       Bacteria
 15.20    15200    15200             S     9606    Homo sapiens
  5.10    5100     200               D     10239   Viruses
  1.20    1200     1200              U     0       unclassified
```

| Column | Description |
|--------|-------------|
| % reads | Percentage of reads assigned to this taxon |
| # reads | Number of reads under this taxon (including children) |
| # reads at taxon | Reads assigned directly (not to children) |
| rank | D=Domain, P=Phylum, C=Class, O=Order, F=Family, G=Genus, S=Species |
| taxID | NCBI taxonomy ID |
| name | Taxonomic name |

### Interpreting Results

- **Expected (human WGS):** >95% reads classified as *Homo sapiens*
- **Investigate:** Any bacterial taxon at >1% in a non-metagenomic sample
- **Common contaminants:** *Mycoplasma* spp., *E. coli*, *Cutibacterium acnes* (skin)
- **Spike-ins:** PhiX should appear at low levels in Illumina data

---

## MultiQC — Raw Data Summary

[**MultiQC**](https://github.com/MultiQC/MultiQC) **aggregates QC reports** from multiple tools and multiple samples into a **single interactive HTML report**. Instead of reviewing dozens of individual FastQC HTML files, MultiQC produces one unified dashboard.

**Supported tools include:** FastQC, FastQ Screen, Kraken2, Trimmomatic, STAR, HISAT2, Salmon, featureCounts, Picard, samtools, and [many more](https://multiqc.info/modules/).

### Running MultiQC

```bash
cd ~/RNAseq_coursesCRG_2026/

# Create a folder for the MultiQC result
mkdir multiqc_report
cd ~/RNAseq_coursesCRG_2026/multiqc_report

# Link QC, trimming and mapping data
ln -s ~/RNAseq_coursesCRG_2026/quality_control* .
ln -s ~/RNAseq_coursesCRG_2026/mapping* .
ln -s ~/RNAseq_coursesCRG_2026/trimming

# Run MultiQC on the directory
$RUN multiqc .

# Visualize in browser
firefox multiqc_report.html
```

![MultiQC report](images/multiqc.png)

### Useful Options

```bash
# Ignore files or folders
$RUN multiqc . --ignore trimming --force

# Rename output file
$RUN multiqc . --ignore trimming --filename multiqc_notrimming --force

# Export all plots (saved in multiqc_plots/ as pdf, svg and png)
$RUN multiqc . --export --force

# Exclude specific samples
multiqc . --ignore-samples "bad_sample*"

# Use a config file
multiqc . --config multiqc_config.yaml

```

### Example `multiqc_config.yaml`

```yaml
title: "RNA-seq QC Report — Project XYZ"
report_comment: "Initial QC of untrimmed raw reads"

fn_clean_exts:
    - ".fastq.gz"
    - "_R1"
    - "_R2"
    - "_001"

module_order:
    - fastqc
    - fastq_screen
    - kraken

fastqc_config:
    reads_min_count: 1000000
```

---

## Read Pre-processing: adapter trimming and rRNA removal

After running raw QC, two issues commonly stand out in the MultiQC report that must be addressed before alignment:

| Problem | Consequence if not addressed |
|:-------:|------------------------------|
| Adapter sequences | Misalignments, spurious variant calls, reduced mapping rate |
| Low quality 3' bases | Increased error rate in alignments and assemblies |
| rRNA reads | Wasted sequencing depth; biased expression estimates |

---

## Adapter Trimming

### The Landscape of Tools

Several mature tools exist for adapter trimming and quality filtering. They share the same core goal but differ in speed, flexibility, and default behaviour.

| Tool | Language | Strengths | Typical Use Case |
|------|----------|-----------|-----------------|
| **Trimmomatic** | Java | Highly configurable, widely used | General Illumina trimming |
| **Cutadapt** | Python | Precise adapter specification, great docs | When adapters are known exactly |
| **TrimGalore** | Perl wrapper | Auto-detects adapters, wraps Cutadapt + FastQC | Most RNA-seq / WGS workflows |
| **fastp** | C++ | Very fast, all-in-one QC + trim | Large datasets, speed-critical |
| **BBDuk** | Java (BBTools) | Flexible k-mer trimming, contaminant removal | Complex filtering needs |
| **PRINSEQ** | Perl | Broad filtering options including complexity | Metagenomics, older workflows |

### How Trimming Works

All tools follow the same general logic:

**Step 1 — Adapter Sequence Matching:** The tool is given (or detects) the known adapter sequence and searches for it within each read. When found, the adapter and everything 3' of it is clipped. Most tools allow a configurable **error rate** to account for sequencing errors within the adapter.

```
Read:   ACGTACGTACGTACGT[AGATCGGAAGAGC...]
                         ↑ adapter match
Result: ACGTACGTACGTACGT
```

**Step 2 — Quality-Based Trimming:** Separately from adapter removal, tools can trim bases from the 3' end below a Phred quality threshold. The most common algorithm is a **sliding window** approach: start from the 3' end, calculate average quality in a window (e.g., 4 bp), remove it if below threshold, and repeat moving inward until the window passes.

**Step 3 — Minimum Length Filtering:** After trimming, reads that are too short to align reliably are discarded entirely (common threshold: 20–36 bp).

> **Paired-end reads:** In paired-end mode, **both reads of a pair must be handled together**. If one read is discarded (too short after trimming), its partner must also be removed or placed in an "orphan" file to maintain pairing integrity — aligners require paired reads to be in the same order.

### Trimming with TrimGalore

[**TrimGalore**](https://github.com/FelixKrueger/TrimGalore) is a **wrapper** around Cutadapt and FastQC that adds automatic adapter detection, integrated FastQC re-running, and sensible defaults — making it the most practical choice for standard Illumina RNA-seq and WGS data.

```bash
# Single-end reads
trim_galore sample.fastq.gz

# Specify output directory and run FastQC on output
trim_galore --fastqc -o trimmed/ sample.fastq.gz
```

**Key options:**

```bash
trim_galore \
    --quality 20 \              # Trim 3' bases below Q20 (default: 20)
    --length 36 \               # Discard reads shorter than 36 bp after trimming
    --stringency 3 \            # Minimum adapter overlap (default 1; increase to avoid over-trimming)
    --fastqc \                  # Run FastQC on output
    --cores 4 \                 # Parallel processing
    -o trimmed_output/ \
    ~/RNAseq_coursesCRG_2026/docs/data/reads/SRR3091420_1_chr6.fastq.gz
```

**Specifying adapters manually:**

```bash
# Illumina TruSeq adapter (most common for single-end)
trim_galore \
    --adapter AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
    ~/RNAseq_coursesCRG_2026/docs/data/reads/SRR3091420_1_chr6.fastq.gz

# Nextera adapter
trim_galore --nextera ~/RNAseq_coursesCRG_2026/docs/data/reads/SRR3091420_1_chr6.fastq.gz

# Small RNA (miRNA) adapter
trim_galore --small_rna ~/RNAseq_coursesCRG_2026/docs/data/reads/SRR3091420_1_chr6.fastq.gz
```

**Output files:**

```
trimmed_output/
├── SRR3091420_1_chr6_trimmed.fq.gz                      # Trimmed reads
└── SRR3091420_1_chr6.fastq.gz_trimming_report.txt        # Trimming stats
```

**Reading the trimming report:**

```
Total reads processed:               5,000,000
Reads with adapters:                 2,150,000  (43.0%)    ← worth noting
Reads written (passing filters):     4,987,320  (99.7%)
Quality-trimmed:                 8,250,000 bp  (1.1%)
Adapter-trimmed:               125,400,000 bp  (16.7%)
Total written (filtered):      616,349,680 bp  (82.2%)
```

Key numbers to check:
- **Reads with adapters:** confirms the adapter contamination seen in FastQC
- **Reads written (passing filters):** should remain high (>95%); low values suggest aggressive trimming or very short inserts
- **Total basepairs removed:** gives a sense of how much data was lost to trimming

**Batch processing multiple samples:**

```bash
#!/bin/bash
RAWDIR=~/RNAseq_coursesCRG_2026/docs/data/reads
OUTDIR=~/RNAseq_coursesCRG_2026/trimming
mkdir -p "${OUTDIR}"

for FASTQ in "${RAWDIR}"/*.fastq.gz; do
    SAMPLE=$(basename "${FASTQ}" .fastq.gz)
    echo "Trimming: ${SAMPLE}"
    trim_galore \
        --quality 20 \
        --length 36 \
        --fastqc \
        --cores 4 \
        -o "${OUTDIR}" \
        "${FASTQ}"
done

echo "All samples trimmed."
```

---

## rRNA Removal with RiboDetector

Even after trimming, RNA-seq libraries often retain a proportion of **ribosomal RNA reads** from incomplete ribo-depletion (e.g., RiboZero, RNase H) or polyA selection inefficiency. These reads:

- Consume sequencing depth without contributing to gene expression estimates
- Can bias normalization and differential expression results
- Inflate total read counts relative to informative mRNA reads

[**RiboDetector**](https://github.com/hzi-bifo/RiboDetector) is a **deep learning-based** tool that accurately identifies and removes rRNA reads without relying on a reference database. It uses a neural network trained on a broad set of rRNA sequences from bacteria, archaea, and eukaryotes, enabling robust detection even for divergent or novel rRNA sequences.

**Advantages over alignment-based tools:**
- No reference database download or maintenance required
- Faster and more memory-efficient than alignment-based approaches
- Handles partial rRNA matches and divergent sequences well
- GPU acceleration available for large datasets

### Installation

```bash
# Install via pip
pip install ribodetector

# Or via conda
conda install -c bioconda ribodetector
```

### Basic Usage

```bash
# Single-end reads
ribodetector_cpu \
    -t 8 \
    -l 100 \
    -i ~/RNAseq_coursesCRG_2026/trimming/SRR3091420_1_chr6_trimmed.fq.gz \
    -e rrna \
    --rrna ~/RNAseq_coursesCRG_2026/ribodetector_output/SRR3091420_1_chr6_rrna.fq.gz \
    -o ~/RNAseq_coursesCRG_2026/ribodetector_output/SRR3091420_1_chr6_nonrrna.fq.gz

# Paired-end reads
ribodetector_cpu \
    -t 8 \
    -l 100 \
    -i sample_R1_trimmed.fq.gz sample_R2_trimmed.fq.gz \
    -e rrna \
    --rrna rrna_R1.fq.gz rrna_R2.fq.gz \
    -o nonrrna_R1.fq.gz nonrrna_R2.fq.gz

# GPU-accelerated (requires CUDA)
ribodetector \
    -t 8 \
    -l 100 \
    -i sample_trimmed.fq.gz \
    -e rrna \
    --rrna rrna_reads.fq.gz \
    -o nonrrna_reads.fq.gz
```

### Key Parameters

| Parameter | Description |
|-----------|-------------|
| `-t` | Number of threads |
| `-l` | Read length (bp) — should match your actual read length after trimming |
| `-i` | Input FASTQ file(s) |
| `-e rrna` | Ensure rRNA reads are written to the `--rrna` output (use `norrna` to keep only clean reads) |
| `--rrna` | Output file for detected rRNA reads |
| `-o` | Output file for non-rRNA reads (use downstream) |
| `--chunk_size` | Number of reads processed per batch (default: 256; increase for speed if RAM allows) |

> **Setting `-l` correctly:** RiboDetector is length-aware — always set `-l` to match the read length in your input file. After TrimGalore, reads may vary in length; use the modal or maximum post-trim read length as a guide.

### Output Files

```
ribodetector_output/
├── SRR3091420_1_chr6_rrna.fq.gz       # rRNA reads (removed from analysis)
└── SRR3091420_1_chr6_nonrrna.fq.gz    # Clean reads for downstream use ← use these
```

### Interpreting the Output

RiboDetector does not produce a separate log file by default, but read counts can be inferred by comparing input and output:

```bash
# Count reads in input
echo $(zcat trimmed.fq.gz | wc -l) / 4 | bc

# Count reads in clean output
echo $(zcat nonrrna.fq.gz | wc -l) / 4 | bc

# Count rRNA reads removed
echo $(zcat rrna.fq.gz | wc -l) / 4 | bc
```

A rRNA percentage of 1–10% is typical for well-depleted libraries. Values >20–30% suggest ribo-depletion failure and should be flagged, though the reads can still be usable after removal.

---

## Post-Processing QC with MultiQC

After trimming and rRNA removal, verify that:
1. **Adapter contamination is gone** — the FastQC Adapter Content module should be flat near 0%
2. **Read quality has improved** — per-base quality at 3' ends should be higher
3. **Read counts remain acceptable** — we haven't lost too many reads
4. **rRNA depletion was effective** — the proportion removed is within expected range

The most powerful approach is to run MultiQC on **pre- and post-trimming FastQC results together**, enabling direct side-by-side comparison.

### Generating FastQC on Trimmed and Cleaned Reads

```bash
# FastQC on trimmed reads (if not already done via --fastqc in TrimGalore)
mkdir -p ~/RNAseq_coursesCRG_2026/fastqc_trimmed/
fastqc -t 4 -o ~/RNAseq_coursesCRG_2026/fastqc_trimmed/ ~/RNAseq_coursesCRG_2026/trimming/*_trimmed.fq.gz

# FastQC on rRNA-removed reads
mkdir -p ~/RNAseq_coursesCRG_2026/fastqc_clean/
fastqc -t 4 -o ~/RNAseq_coursesCRG_2026/fastqc_clean/ ~/RNAseq_coursesCRG_2026/ribodetector_output/*_nonrrna.fq.gz
```

### Running MultiQC Across All Three Stages

```bash
multiqc \
    ~/RNAseq_coursesCRG_2026/quality_control/ \    # FastQC on untrimmed reads
    ~/RNAseq_coursesCRG_2026/fastqc_trimmed/ \     # FastQC on TrimGalore output
    ~/RNAseq_coursesCRG_2026/fastqc_clean/ \       # FastQC on rRNA-removed reads
    ~/RNAseq_coursesCRG_2026/trimming/ \           # TrimGalore trimming reports
    -o ~/RNAseq_coursesCRG_2026/multiqc_comparison/ \
    -n pre_vs_post_processing_report \
    -f

firefox ~/RNAseq_coursesCRG_2026/multiqc_comparison/pre_vs_post_processing_report.html
```

With raw and trimmed samples in the same report, use a config file to keep sample names clean:

```yaml
# multiqc_config.yaml
title: "Pre vs Post Processing QC"
report_comment: "Comparing raw, trimmed, and rRNA-removed reads"

fn_clean_exts:
    - ".fastq.gz"
    - "_val_1"
    - "_val_2"
    - "_trimmed"
    - "_clean"
    - "_R1"
    - "_R2"
    - "_001"
```

### What to Look for in the Comparison Report

**Adapter Content**
- Raw: adapter signal visible, rising towards 3' end
- Post-trim: flat line near 0% — if not, re-examine adapter sequences or increase `--stringency`

**Per Base Sequence Quality**
- Raw: possible quality drop at 3' end
- Post-trim: 3' quality drop should be reduced or eliminated

**Per Sequence GC Content**
- If a skewed GC peak was present in raw data due to rRNA, post-rRNA removal should normalise it
- Persistent skew after removal suggests other contamination — revisit FastQ Screen / Kraken2

**Sequence Length Distribution**
- Raw: all reads same length (e.g., 150 bp)
- Post-trim: distribution of shorter lengths — this is **expected and normal**

**TrimGalore Section (MultiQC)**
- Shows % reads with adapters per sample, total bp trimmed, and reads failing minimum length filter
- Outlier samples (e.g., one sample with 80% adapter rate vs. ~40% for others) warrant investigation — possible library prep failure

---

## Final Exercise

The file `~/RNAseq_coursesCRG_2026/docs/data/reads/example2_reads.fq.gz` contains a set of single-end reads from an unknown sample. Apply the full pre-processing pipeline we covered in this session:

1. Run **FastQC** on the raw reads and inspect the HTML report.
2. Run **FastQ Screen** to check for cross-species contamination.
3. Run **Kraken2** to perform taxonomic classification.
4. Run **TrimGalore** to remove adapters and low-quality bases.
5. Run **RiboDetector** to remove rRNA reads from the trimmed output.
6. Run **FastQC** again on both the trimmed and rRNA-cleaned reads.
7. Aggregate all results with **MultiQC** and compare the pre- and post-processing reports.

Once you have inspected all the outputs, consider the following questions:

- Which results from the quality control are **unexpected** for a standard RNA-seq dataset? Describe what you observe and why it deviates from what would normally be considered "good" quality.
- Can you think of a **specific sequencing application** where those results would actually be expected and perfectly normal? Explain your reasoning.

---

## Further Reading

### Documentation

- **FastQC:** https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
- **FastQ Screen:** https://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/
- **Kraken2:** https://github.com/DerrickWood/kraken2/wiki
- **MultiQC:** https://multiqc.info/docs/ — Module list: https://multiqc.info/modules/
- **TrimGalore:** https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/ — User Guide: https://github.com/FelixKrueger/TrimGalore/blob/master/Docs/Trim_Galore_User_Guide.md
- **Cutadapt:** https://cutadapt.readthedocs.io/
- **RiboDetector:** https://github.com/hzi-bifo/RiboDetector

### Key Articles

- Andrews, S. (2010). **FastQC: A Quality Control Tool for High Throughput Sequence Data.**
- Wingett, S. & Andrews, S. (2018). **FastQ Screen: A tool for multi-genome mapping and quality control.** *F1000Research*, 7, 1338. https://doi.org/10.12688/f1000research.15931.2
- Wood, D.E. et al. (2019). **Improved metagenomic analysis with Kraken 2.** *Genome Biology*, 20, 257. https://doi.org/10.1186/s13059-019-1891-0
- Ewels, P. et al. (2016). **MultiQC: Summarize analysis results for multiple tools and samples in a single report.** *Bioinformatics*, 32(19), 3047–3048. https://doi.org/10.1093/bioinformatics/btw354
- Martin, M. (2011). **Cutadapt removes adapter sequences from high-throughput sequencing reads.** *EMBnet.journal*, 17(1), 10–12. https://doi.org/10.14806/ej.17.1.200
- Bolger, A.M. et al. (2014). **Trimmomatic: a flexible trimmer for Illumina sequence data.** *Bioinformatics*, 30(15), 2114–2120. https://doi.org/10.1093/bioinformatics/btu170
- Deng, Z. et al. (2022). **RiboDetector: accurate and rapid RiboRNA sequences detector based on deep learning.** *Nucleic Acids Research*, 50(10), e60. https://doi.org/10.1093/nar/gkac112