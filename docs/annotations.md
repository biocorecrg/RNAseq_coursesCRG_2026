# Hands-on: Reference genome/transcriptome and annotation

<img src="images/RNAseq_workflow.png" width="1000"/>

After sequencing, reads are pre-processed and quality-checked. The next step is to **map** them to a reference. This raises two key questions: "What references are available?" and "Which one should I use?"

## Reference sequences


Before proceeding, we need to retrieve a **reference genome** or **transcriptome** from a public database, along with its **annotation**:
* A **FASTA file** contains the actual genome/transcriptome sequence.
* A **GTF/GFF file** contains the corresponding annotation.


### Public resources on genome/transcriptome sequences and annotations

* [GENCODE](https://www.gencodegenes.org/) contains an accurate annotation of the **human** and **mouse** genes derived either using **manual curation**, **computational analysis** or **targeted experimental approaches**. GENCODE also contains information on functional elements, such as protein-coding loci with alternative splicing variants, non-coding loci, and pseudogenes.
* [Ensembl](https://www.ensembl.org/index.html) contains both **automatically generated** and **manually curated** annotations. They host different genomes together with comparative genomics data and their variants. [Ensembl genomes](http://ensemblgenomes.org/) extends the genomic information across different taxonomic groups: bacteria, fungi, metazoa, plants, and protists. Ensembl also integrates a genome browser.
* [UCSC Genome Browser](https://genome.ucsc.edu/) hosts information about different genomes. It integrates the GENCODE and Ensembl information as additional tracks. 

### Where to find the files

#### GENCODE

The current version for *Homo sapiens* genome is release [**49**](https://www.gencodegenes.org/human/release_49.html).
<br>
The files you would need are:
* FASTA file for the [**Genome sequence, primary assembly**](https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/GRCh38.primary_assembly.genome.fa.gz)
* FASTA file corresponding to the [**transcripts**](https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/gencode.v49.transcripts.fa.gz)
* GTF file of the [**Comprehensive gene annotation**](https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/gencode.v49.annotation.gtf.gz)



<div align="center">
  <img src="images/gencode_human_gtf.png" width="800" />
</div>

You can retrieve them via command line typing:

```bash
# genome
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/GRCh38.primary_assembly.genome.fa.gz

# transcriptome
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/gencode.v49.transcripts.fa.gz

# annotation
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/gencode.v49.annotation.gtf.gz
```

#### ENSEMBL

The current version of the *Mus musculus* genome in [Ensembl](https://www.ensembl.org/index.html) is [**release 115**](ftp://ftp.ensembl.org/pub/release-115/)

The files you would need are:
* FASTA file for the [**genome primary assembly**](ftp://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_rm.primary_assembly.fa.gz)
* FASTA file corresponding to the [**CDS regions / transcripts**](ftp://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/cds/Homo_sapiens.GRCh38.cds.all.fa.gz)
* GTF file for the [**annotation**](ftp://ftp.ensembl.org/pub/release-115/gtf/homo_sapiens/Homo_sapiens.GRCh38.99.chr.gtf.gz)


<div align="center">
  <img src="images/ensembl_human_main.png" width="800" />
</div>

<div align="center">
  <img src="images/ensembl_ftp.png" width="800" />
</div>

```bash
# genome
wget ftp://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_rm.primary_assembly.fa.gz

# transcriptome
wget ftp://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/cds/Homo_sapiens.GRCh38.cds.all.fa.gz

# annotation
wget ftp://ftp.ensembl.org/pub/release-115/gtf/homo_sapiens/Homo_sapiens.GRCh38.115.chr.gtf.gz
```
<br/>

## Our data set

To speed up the mapping process, we retrieved a subset of the FASTA and GTF files that correspond **only to chromosome 6** here: [reference_chr6_Hsapiens.tar.gz)](https://biocorecrg.github.io/RNAseq_coursesCRG_2026/latest/data/annotation/reference_chr6_Hsapiens.tar.gz)

You can download them from:

```bash
# go to the appropriate folder
cd ~/rnaseq_course/reference_genome

# download reference files for chromosome 6
wget https://biocorecrg.github.io/RNAseq_coursesCRG_2026/latest/data/annotation/reference_chr6_Hsapiens.tar.gz

# extract archive
tar -xvzf reference_chr6_Hsapiens.tar.gz

# remove remaining .tar.gz archive
rm reference_chr6_Hsapiens.tar.gz
```

### FASTA file

The genome is often stored as a **FASTA file** (.fa file): each header (that can be chromosomes, transcripts, proteins), starts with "**>**":

```bash
zcat reference_chr6/Homo_sapiens.GRCh38.dna.chrom6.fa.gz | head -n 1
```

The size of the chromosome (in bp) is already reported in the header, but we can check it as follows:

```bash
zcat ~/rnaseq_course/reference_genome/reference_chr6/Homo_sapiens.GRCh38.dna.chrom6.fa.gz | grep -v ">" | tr -d '\n' | wc -m  

# 170805979
```

### GTF file

The annotation is stored in **G**eneral **T**ransfer **F**ormat (**GTF**) format (which is an extension of the older **[GFF format](https://genome.ucsc.edu/FAQ/FAQformat.html#format3)**): a tabular format with one line per genome feature, each one containing 9 columns of data. In general it has a header indicated by the first character **"#"** and one row per feature composed in 9 columns:

| Column number | Column name | Details |
| ----: | :---- | :---- |
| 1 | seqname | name of the chromosome or scaffold; chromosome names can be given with or without the 'chr' prefix. |
| 2 | source | name of the program that generated this feature, or the data source (database or project name) |
| 3 | feature | feature type name, e.g. Gene, Variation, Similarity |
| 4 | start | Start position of the feature, with sequence numbering starting at 1. |
| 5 | end | End position of the feature, with sequence numbering starting at 1. |
| 6 | score | A floating point value. |
| 7 | strand | defined as + (forward) or - (reverse). |
| 8 | frame | One of '0', '1' or '2'. '0' indicates that the first base of the feature is the first base of a codon, '1' that the second base is the first base of a codon, and so on.. |
| 9 | attribute | A semicolon-separated list of tag-value pairs, providing additional information about each feature. |


```bash
zcat reference_chr6/Homo_sapiens.GRCh38.115.chr6.gtf.gz | head -n 10
```

Let's check the 9th field:

```bash
zcat reference_chr6/Homo_sapiens.GRCh38.115.chr6.gtf.gz | cut -f9 | head
```

Let's check how many genes are in the annotation file:

```bash
zcat reference_chr6/Homo_sapiens.GRCh38.115.chr6.gtf.gz | grep -v "#" | awk '$3=="gene"' | wc -l 

# 4230
```

And get a final counts of every feature:

```bash
zcat reference_chr6/Homo_sapiens.GRCh38.115.chr6.gtf.gz | grep -v "#" | cut -f3 | sort | uniq -c 

      1 
 101233 CDS
 172707 exon
  19185 five_prime_utr
   4230 gene
      3 Selenocysteine
  10180 start_codon
   9955 stop_codon
  16561 three_prime_utr
  25648 transcript

```

<br>



