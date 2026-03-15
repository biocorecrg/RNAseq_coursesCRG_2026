# Hands-on: Adapter trimming, rRNA removal and post-processing data QC

In the previous lecture, we ran FastQC, FastQ Screen, and Kraken2 on raw untrimmed reads. Looking back at our MultiQC report, two issues stood out:

**1. Adapter contamination**

FastQC's *Adapter Content* module flagged Illumina adapter sequences accumulating towards the **3' end of reads**. This happens when the sequenced DNA fragment is **shorter than the read length** — the sequencer runs out of insert and reads into the adapter ligated to the other end of the molecule.

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

**2. rRNA overrepresentation** 

FastQ Screen's `%Multiple` column was inflated, and FastQC's *Overrepresented Sequences* module likely flagged ribosomal RNA hits. Even with ribo-depletion protocols, a fraction of rRNA reads typically persists.

### Why Does This Matter?

| Problem | Consequence if not addressed |
|:---------:|------------------------------|
| Adapter sequences | Misalignments, spurious variant calls, reduced mapping rate |
| Low quality 3' bases | Increased error rate in alignments and assemblies |
| rRNA reads | Wasted sequencing depth; biased expression estimates |

**The solution:** Clean the reads before alignment and the remaining downstream analysis. 

## Adapter Trimming: The Landscape of Tools

Several mature tools exist for adapter trimming and quality filtering. They share the same core goal but differ in speed, flexibility, and default behaviour.

| Tool | Language | Strengths | Typical Use Case |
|------|----------|-----------|-----------------|
| **Trimmomatic** | Java | Highly configurable, widely used | General Illumina trimming |
| **Cutadapt** | Python | Precise adapter specification, great docs | When adapters are known exactly |
| **TrimGalore** | Perl wrapper | Auto-detects adapters, wraps Cutadapt + FastQC | Most RNA-seq / WGS workflows |
| **fastp** | C++ | Very fast, all-in-one QC + trim | Large datasets, speed-critical |
| **BBDuk** | Java (BBTools) | Flexible k-mer trimming, contaminant removal | Complex filtering needs |
| **PRINSEQ** | Perl | Broad filtering options including complexity | Metagenomics, older workflows |

In this session, we will use **TrimGalore** as it is the most practical choice for standard Illumina RNA-seq and WGS data because it automatically detects adapter sequences, integrates quality trimming, and optionally re-runs FastQC on trimmed output in a single command. Before diving into TrimGalore specifically, it helps to understand the general strategies these tools use.

- **Step1 1: Adapter Sequence Matching**

The tool is given (or detects) the known adapter sequence and searches for it within each read. When found, the adapter and everything 3' of it is clipped.

```
Read:   ACGTACGTACGTACGT[AGATCGGAAGAGC...]
                         ↑ adapter match
Result: ACGTACGTACGTACGT
```

Most tools allow a configurable **error rate** (mismatches + indels) to account for sequencing errors within the adapter itself.

- **Step 2: Quality-Based Trimming**

Separately from adapter removal, tools can trim bases from the 3' end that fall below a Phred quality threshold. The most common algorithm is a **sliding window** approach:

1. Start from the 3' end
2. Calculate average quality in a window (e.g., 4 bp)
3. Remove the window if average quality < threshold
4. Repeat moving inward until the window passes

- **Step 3: Minimum Length Filtering**

After trimming, reads that are too short to align reliably are discarded entirely (common threshold: 20–36 bp).

:::{admonition} What Happens to Paired-End Reads?
:class: important

In paired-end mode, **both reads of a pair must be handled together**. If one read is discarded (too short after trimming), its partner must also be removed or placed in an "orphan" file to maintain pairing integrity — aligners require paired reads to be in the same order.

:::

## TrimGalore

[**TrimGalore**](https://github.com/FelixKrueger/TrimGalore) is a **wrapper script** around Cutadapt and FastQC, developed by the Babraham Bioinformatics group (same team as FastQC). It adds:

- **Automatic adapter detection** — identifies Illumina, Nextera, or small RNA adapters without user input
- **Integrated FastQC** — optionally re-runs FastQC on trimmed output
- **Sensible defaults** — quality cutoff Q20, minimum length 20 bp, paired-end awareness

### Basic Usage

```bash
# Single-end reads
trim_galore sample.fastq.gz

# Paired-end reads
trim_galore --paired sample_R1.fastq.gz sample_R2.fastq.gz

# Specify output directory
trim_galore --paired -o trimmed/ sample_R1.fastq.gz sample_R2.fastq.gz

# Run FastQC on trimmed output automatically
trim_galore --paired --fastqc -o trimmed/ sample_R1.fastq.gz sample_R2.fastq.gz
```

### Key Options Explained

```bash
trim_galore \
    --paired \                  # Paired-end mode
    --quality 20 \              # Trim 3' bases below Q20 (default: 20)
    --length 36 \               # Discard reads shorter than 36 bp after trimming
    --stringency 3 \            # Minimum adapter overlap to trigger trimming (default: 1)
    --fastqc \                  # Run FastQC on output
    --cores 4 \                 # Parallel processing
    -o trimmed_output/ \        # Output directory
    sample_R1.fastq.gz \
    sample_R2.fastq.gz
```

> **Note on `--stringency`:** The default value of 1 bp overlap can lead to over-trimming (false positive adapter matches). For most purposes, `--stringency 3` or higher is more conservative and appropriate.

### Specifying Adapters Manually

TrimGalore auto-detects adapters in most cases, but you can specify them explicitly:

```bash
# Illumina TruSeq adapters (most common)
trim_galore \
    --adapter AGATCGGAAGAGCACACGTCTGAACTCCAGTCA \
    --adapter2 AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
    --paired sample_R1.fastq.gz sample_R2.fastq.gz

# Nextera adapters
trim_galore --nextera --paired sample_R1.fastq.gz sample_R2.fastq.gz

# Small RNA (miRNA) adapters
trim_galore --small_rna sample.fastq.gz
```

### TrimGalore Output Files

```
trimmed_output/
├── sample_R1_val_1.fq.gz           # Trimmed R1 reads
├── sample_R2_val_2.fq.gz           # Trimmed R2 reads
├── sample_R1.fastq.gz_trimming_report.txt   # Trimming stats for R1
├── sample_R2.fastq.gz_trimming_report.txt   # Trimming stats for R2
├── sample_R1_val_1_fastqc.html     # FastQC report on trimmed R1 (if --fastqc)
└── sample_R2_val_2_fastqc.html     # FastQC report on trimmed R2 (if --fastqc)
```

### Reading the Trimming Report

```
SUMMARISING RUN PARAMETERS
===========================
Input filename: sample_R1.fastq.gz
Adapter sequence: 'AGATCGGAAGAGC' (Illumina TruSeq)
Quality Phred score cutoff: 20
Minimum length: 20 bp

RUN STATISTICS
==============
Total reads processed:               5,000,000
Reads with adapters:                 2,150,000  (43.0%)    ← worth noting
Reads written (passing filters):     4,987,320  (99.7%)
Total basepairs processed:     750,000,000 bp
Quality-trimmed:                 8,250,000 bp  (1.1%)
Adapter-trimmed:               125,400,000 bp  (16.7%)
Total written (filtered):      616,349,680 bp  (82.2%)
```

Key numbers to check:
- **Reads with adapters:** A high percentage confirms the adapter contamination seen in FastQC
- **Reads written (passing filters):** Should remain high (>95%) — low values suggest aggressive trimming or very short inserts
- **Total basepairs removed:** Gives a sense of how much data was lost to trimming

### Running TrimGalore on Multiple Samples

```bash
#!/bin/bash
# Batch TrimGalore for all paired-end samples

RAWDIR="raw_reads"
OUTDIR="trimmed"
mkdir -p "${OUTDIR}"

for R1 in "${RAWDIR}"/*_R1.fastq.gz; do
    R2="${R1/_R1.fastq.gz/_R2.fastq.gz}"
    SAMPLE=$(basename "${R1}" _R1.fastq.gz)
    
    echo "Trimming: ${SAMPLE}"
    
    trim_galore \
        --paired \
        --quality 20 \
        --length 36 \
        --fastqc \
        --cores 4 \
        -o "${OUTDIR}" \
        "${R1}" "${R2}"
done

echo "All samples trimmed."
```

## rRNA Removal with RiboPicker

Even after trimming, RNA-seq libraries often retain a proportion of **ribosomal RNA reads**. These originate from incomplete ribo-depletion (e.g., RiboZero, RNase H) or polyA selection inefficiency. rRNA reads:

- Consume sequencing depth without contributing to gene expression estimates
- Can bias normalization and differential expression results
- Inflate total read counts relative to informative mRNA reads

[**RiboPicker**](https://ribopicker.sourceforge.net/) screens reads against rRNA reference databases and **removes matching reads**, keeping only the non-rRNA fraction for downstream analysis. Briefly, it follows these steps:

1. Maintains a **database of rRNA reference sequences** (16S, 18S, 23S, 28S, 5S, 5.8S rRNA from multiple organisms)
2. Aligns each read against the database using a fast local alignment approach
3. Reads that align above a similarity/coverage threshold are classified as **rRNA** and separated out
4. Non-rRNA reads are written to a clean output file

### Setting Up the rRNA Database

RiboPicker uses its own pre-formatted databases. Download from the RiboPicker website or use the bundled databases:

```bash
# List available bundled databases
ls $(which ribopicker.pl | xargs dirname)/../db/

# Common databases:
# rrnadb    - broad rRNA (16S, 18S, 23S, 28S, 5S)
# silva     - SILVA rRNA sequences
# rfam      - Rfam RNA families
```

### Basic Usage

```bash
# Single-end reads
ribopicker.pl \
    -i trimmed/sample_trimmed.fastq \
    -dbs rrnadb \
    -out_dir ribopicker_output/

# Paired-end reads
ribopicker.pl \
    -i trimmed/sample_R1_val_1.fastq.gz \
    -i2 trimmed/sample_R2_val_2.fastq.gz \
    -dbs rrnadb \
    -out_dir ribopicker_output/ \
    -id 95 \      # minimum % identity (default: 90)
    -al 80        # minimum % read length aligned (default: 80)
```

### Key Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `-id` | 90 | Minimum % nucleotide identity to rRNA |
| `-al` | 80 | Minimum % of read length that must align |
| `-dbs` | — | Comma-separated list of databases to use |
| `-out_dir` | — | Output directory |

> **Choosing thresholds:** More stringent thresholds (higher `-id`, higher `-al`) reduce false positives (accidentally removing non-rRNA reads) but may miss divergent rRNA sequences. For standard eukaryotic RNA-seq, the defaults are appropriate.

### RiboPicker Output Files

```
ribopicker_output/
├── sample_rrna.fastq         # rRNA reads (removed from analysis)
├── sample_nonrrna.fastq      # Clean reads for downstream use ← use these
└── sample_ribopicker.log     # Summary statistics
```

### Interpreting the Log

```
Total sequences: 4,987,320
rRNA sequences:    312,458  (6.3%)     ← removed
Non-rRNA sequences: 4,674,862  (93.7%) ← kept
```

A rRNA percentage of 1–10% is typical for well-depleted libraries. Values >20–30% suggest ribo-depletion failure and should be flagged, though the reads can still be usable after removal.

## Post-Processing QC with MultiQC

After trimming and rRNA removal, we want to verify that:
1. **Adapter contamination is gone** — the FastQC Adapter Content module should now be clean
2. **Read quality has improved** — the per-base quality distribution at 3' ends should be higher
3. **We haven't lost too many reads** — overall read counts should remain acceptable
4. **rRNA depletion was effective** — the proportion of rRNA reads removed is within expected range

The most powerful way to do this is to run MultiQC on **both the pre- and post-trimming FastQC results together**, so the report contains side-by-side comparisons.

### Generating FastQC on Trimmed + Cleaned Reads

```bash
# Step 1: FastQC on trimmed reads (if not already done via --fastqc in TrimGalore)
mkdir -p fastqc_trimmed/
fastqc -t 8 -o fastqc_trimmed/ trimmed/*_val_*.fq.gz

# Step 2: FastQC on rRNA-removed reads
mkdir -p fastqc_clean/
fastqc -t 8 -o fastqc_clean/ clean_output/*_clean*.fastq.gz
```

### Running MultiQC Across All Three Stages

The key insight is to point MultiQC at directories from **all processing stages** at once:

```bash
multiqc \
    fastqc_raw/ \          # FastQC on untrimmed reads (from Lecture 1)
    fastqc_trimmed/ \      # FastQC on TrimGalore output
    fastqc_clean/ \        # FastQC on rRNA-removed reads
    trimmed/ \             # TrimGalore trimming reports
    ribopicker_output/ \   # RiboPicker logs (if supported by MultiQC version)
    -o multiqc_comparison/ \
    -n pre_vs_post_processing_report \
    -f

# Open the report
open multiqc_comparison/pre_vs_post_processing_report.html
```

### Using Sample Name Labels for Clarity

With raw and trimmed samples in the same report, the names can become confusing. Use a MultiQC config to add cleaner labels:

```yaml
# multiqc_config.yaml
title: "Pre vs Post Processing QC"
report_comment: "Comparing raw, trimmed, and rRNA-removed reads"

# Strip suffixes for cleaner sample names
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

```bash
multiqc \
    fastqc_raw/ fastqc_trimmed/ fastqc_clean/ trimmed/ \
    --config multiqc_config.yaml \
    -o multiqc_comparison/ -f
```

### What to Look for in the Comparison Report

#### FastQC Module Comparison: Key Modules to Check

**Adapter Content**
- Raw: Adapter signal visible, rising towards 3' end
- Post-trim: Flat line near 0% — if not, re-examine adapter sequences or increase `--stringency`

**Per Base Sequence Quality**
- Raw: Possible quality drop at 3' end
- Post-trim: 3' quality drop should be reduced or eliminated

**Per Sequence GC Content**
- If a skewed GC peak was present in raw data due to rRNA:
  - Post-rRNA removal: GC distribution should look more normal
  - Persistent skew after removal = possible other contamination, revisit FastQ Screen / Kraken2

**Sequence Length Distribution**
- Raw: All reads same length (e.g., 150 bp)
- Post-trim: Distribution of shorter lengths — this is **expected and normal**

#### TrimGalore Section (MultiQC)

MultiQC parses TrimGalore reports and adds:
- % reads with adapters per sample (bar chart)
- Total bp trimmed
- Reads failing minimum length filter

Outlier samples (e.g., one sample with 80% adapter rate vs. ~40% for others) warrant investigation — possible library prep failure.

## Further reading materials

### Documentation

- **TrimGalore Documentation:** https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/
- **TrimGalore User Guide:** https://github.com/FelixKrueger/TrimGalore/blob/master/Docs/Trim_Galore_User_Guide.md
- **Cutadapt Documentation:** https://cutadapt.readthedocs.io/
- **RiboPicker:** http://ribopicker.sourceforge.net/
- **Ribodetector (DL-based alternative):** https://github.com/hzi-bifo/RiboDetector

### Articles

- Martin, M. (2011). **Cutadapt removes adapter sequences from high-throughput sequencing reads.** *EMBnet.journal*, 17(1), 10–12. https://doi.org/10.14806/ej.17.1.200
- Bolger, A.M. et al. (2014). **Trimmomatic: a flexible trimmer for Illumina sequence data.** *Bioinformatics*, 30(15), 2114–2120. https://doi.org/10.1093/bioinformatics/btu170
- Schmieder, R. & Edwards, R. (2011). **Fast identification and removal of sequence contamination from genomic and metagenomic datasets.** *PLOS ONE*, 6(3). https://doi.org/10.1371/journal.pone.0017288 *(RiboPicker)*

