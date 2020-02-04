---
layout: page
title: Mapping with STAR
navigation: 14
---


# Mapping using STAR

For the **STAR** running options, see [STAR Manual](http://labshare.cshl.edu/shares/gingeraslab/www-data/dobin/STAR/Releases/FromGitHub/Old/STAR-2.5.3a/doc/STARmanual.pdf).


## Building the STAR index

To make an index for STAR, we need both the genome sequence in FASTA format and the annotation in GTF format. 
<br>
As STAR is very resource consuming, we will create an index for **chromosome 6 only**. We already downloaded the **FASTA** and **GTF** files (in ~/rnaseq_course/reference_genome) needed for the indexing.

<br>

However, STAR requires **unzipped** .fa and .gtf files.

```{bash}
# go to reference_genome folder
cd ~/rnaseq_course/reference_genome/

# unzip files (keep original zipped file)
zcat Homo_sapiens.GRCh38.88.chr6.gtf.gz > Homo_sapiens.GRCh38.88.chr6.gtf
zcat Homo_sapiens.GRCh38.dna.chrom6.fa.gz > Homo_sapiens.GRCh38.dna.chrom6.fa
```

**Q. How much (in percentage) disk space is saved when those two files are kept zipped vs unzipped?**

**Once index is built, we have to not forget to remove those unzipped files!**


To index the genome with **STAR** for RNA-seq analysis, the **sjdbOverhang** option needs to be specified for detecting possible splicing sites. 
<br>
It usually equals the minimum read size minus 1; it tells **STAR** what is the maximum possible stretch of sequence that can be found on one side of a spicing site. 
<br>
In our case, since the read size is 49 bases, we can accept maximum 48 bases on one side and one base on the other of a splicing site; that is, to set up this parameter to **48**. 
<br>
This also means that for every different read-length to be aligned a new STAR index needs to be generated. Otherwise a drop in aligned reads can be experienced.

<br>
Building the STAR index (option **--runMode genomeGenerate**):

```{bash}
# go to mapping folder
cd ~/rnaseq_course/mapping

# create sub-folder where index will be generated
mkdir index_star_chr6

$RUN STAR --runMode genomeGenerate --genomeDir index_star_chr6 \
            --genomeFastaFiles ~/rnaseq_course/reference_genome/Homo_sapiens.GRCh38.dna.chrom6.fa \
            --sjdbGTFfile ~/rnaseq_course/reference_genome/Homo_sapiens.GRCh38.88.chr6.gtf \
            --sjdbOverhang 48 \
	    --outFileNamePrefix Hsapiens_chr6
```


## Aligning reads to the genome (and counting them at the same time!)

To use **STAR** for the read alignment (default **--runMode** option), we have to specify the following options:
* the index directory (**--genomeDir**)
* the read files (**--readFilesIn**)
* if reads are compressed or not (**--readFilesCommand**)

The following options are optional:
* **--outSAMtype**: type of output. Default is "BAM Unsorted"; STAR outputs unsorted Aligned.out.bam file(s). *"The paired ends of an alignment are always adjacent, and multiple alignments of a read are adjacent as well. This ”unsorted” file cannot be directly used with downstream software such as HTseq, without the need of name sorting."*
* **--outFileNamePrefix**: the path for the output directory and prefix of all output files. By default, this parameter is ./, i.e. all output files are written in the current directory.
* **--quantMode**. With the **--quantMode GeneCounts** option set, STAR will count the number of reads per gene while mapping. A read is counted if it **overlaps (1nt or more)** one and only one gene. In case of mapping paired-end data, both ends are checked for overlaps. The counts coincide with those produced by the [**htseq-count**](https://htseq.readthedocs.io/en/release_0.11.1/count.html) tool with default parameters. **This option requires annotations (GTF or GFF with –sjdbGTFfile option) used at the genome generation step, or at the mapping step.** (from [STAR Manual](http://labshare.cshl.edu/shares/gingeraslab/www-data/dobin/STAR/Releases/FromGitHub/Old/STAR-2.5.3a/doc/STARmanual.pdf)) 

<br>

We can try to launch the mapping for one file:

```{bash}
# go to mapping folder
cd ~/rnaseq_course/mapping

# create sub-folder where we will store the alignments
mkdir alignments

$RUN STAR --genomeDir index_star_chr6 \
      --readFilesIn ~/rnaseq_course/raw_data/fastq_chr6/SRR3091420_1_chr6.fastq.gz \
      --readFilesCommand zcat \
      --outSAMtype BAM SortedByCoordinate \
      --quantMode GeneCounts \
      --outFileNamePrefix alignments/SRR3091420_1_chr6
```

If this was successful and not too slow and resource consuming, you can do it for all samples, in a **loop**:

```{bash}
for fastq in ~/rnaseq_course/raw_data/*chr6*fastq.gz
do echo $fastq
$RUN STAR --genomeDir index_star_chr6 \
      --readFilesIn $fastq \
      --readFilesCommand zcat \
      --outSAMtype BAM SortedByCoordinate \
      --quantMode GeneCounts \
      --outFileNamePrefix alignments/$(basename $fastq .fastq.gz)
done
```

**BACKUP !!**

If it is too resource consuming, you can download the aligned files in **BAM** format from:

```{bash}
wget https://public-docs.crg.es/biocore/projects/training/PHINDaccess2020/bam_chr6.tar.gz
```

Let's explore the output directory "alignments" (or "bam_chr6", if we used the backup).

```{bash}
ln -lh alignments
```

<br/>

## Read counts 

STAR outputs read counts per gene into **PREFIX**ReadsPerGene.out.tab file with 4 columns which correspond to different **strandedness options**:
|column 1 |gene ID |
|column 2 |counts for unstranded RNA-seq |
|column 3 |counts for the 1st read strand aligned with RNA (htseq-count option -s yes) |
|column 4 |counts for the 2nd read strand aligned with RNA (htseq-count option -s reverse)|

```{bash}
head alignments/SRR3091420_1_chr6ReadsPerGene.out.tab 
```

| | | | |   
| :----: | :----: | :----: |  :----: |
|gene id| read counts per gene (unstranded) | read counts per gene (read 1)|read counts per gene (read 2)| 
|N_unmapped      |1294    |1294    |1294 |
|N_multimapping  |91464   |91464   |91464 |
|N_noFeature     |33532   |393560  |413923 |
|N_ambiguous     |29745   |7998    |7330 |
|ENSG00000271530 |0       |0       |0 |
|ENSG00000220212 |0       |0       |0 |
|ENSG00000170590 |2       |2       |0 |


Select the output according to the strandedness of your data. Note, if you have stranded data and choose one of the columns 3 or 4, the other column (4 or 3) will give you the count of antisense reads. 
<br>
For example, in the stranded protocol shown in "Library preparation", Read 1 is mapped to the antisense strand (this is also true for single-end reads), while Read 2, to the sense strand.

**Which protocol, stranded or unstranded, was used for this RNA-seq data?**

We can count the number of reads mapped to each strand by using a simple awk script:

```{bash}
grep -v "N_" head alignments/SRR3091420_1_chr6ReadsPerGene.out.tab 
 | awk '{unst+=$2;forw+=$3;rev+=$4}END{print unst,forw,rev}'

# 725410 387129 367434
```

It can be seen that 387,129 Reads 1 (forward) were mapped to known genes and 367,434 Reads 2 (reverse) were mapped to known genes.
<br>
These numbers are very similar, which indicates that the protocol used for this mRNA-Seq experiment is **unstranded**.
<br>
If the protocol used was stranded, there would be a **strong imbalance** between number of reads mapped to known genes in forward versus reverse strands.


<br/>

## BAM/SAM/CRAM format

The **BAM format** is a compressed version of the [**SAM format**](https://samtools.github.io/hts-specs/SAMv1.pdf) (which is a plain text) and cannot thus being seen as a text. To explore the BAM file, we have to convert it to the SAM format by using [**samtools**](http://samtools.sourceforge.net/). Note that we use the parameter **-h** to show also the header that is hidden by default. 

```{bash}
$RUN samtools view -h alignments/SRR3091420_1_chr6Aligned.sortedByCoord.out.bam | head -n 10

@HD     VN:1.4  SO:coordinate
@SQ     SN:6    LN:170805979
@PG     ID:STAR PN:STAR VN:STAR_2.5.3a  CL:STAR   --genomeDir index_chr6   --readFilesIn ../RNAseq/output_nextflow/Alignments/selection_chr6/SRR3091420_1_chr6.fastq.gz      --readFilesCommand zcat      --outFileNamePrefix alignments/SRR3091420_1_chr6   --outSAMtype BAM   SortedByCoordinate      --quantMode GeneCounts   
@CO     user command line: STAR --genomeDir index_chr6 --readFilesIn ../RNAseq/output_nextflow/Alignments/selection_chr6/SRR3091420_1_chr6.fastq.gz --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outFileNamePrefix alignments/SRR3091420_1_chr6
10416098        0       6       113167  255     49M     *       0       0       GGGAAAAGTACAAATTCAACATGTAATTGTATAGTAATCCATATAAAAA        bbbeeeeecggggiiiiiiiiiihhhiiighhiihhhhigiiiiiiiih       NH:i:1   HI:i:1  AS:i:48 nM:i:0
8553177 272     6       119288  3       1S48M   *       0       0       TGAAATCCAGTGGGACAGTCAAATCTTAAAGCTCCAAAATGATCTCCTT        hiiiiiiiiiiiiigiiiiiiiihiihiiiiihhiigggggeeeeebbb       NH:i:2  HI:i:2   AS:i:47 nM:i:0
4630026 272     6       128432  3       49M     *       0       0       AGCACTAACCATTGTAGCATGCCAATATACTCAAAATTCAATGAAATTC        hfgehhggiihhhiiihhiihhhhffffghdihhiifggggeeeeebbb       NH:i:2  HI:i:2   AS:i:48 nM:i:0
4630026 272     6       128432  3       49M     *       0       0       AGCACTAACCATTGTAGCATGCCAATATACTCAAAATTCAATGAAATTC        hfgehhggiihhhiiihhiihhhhffffghdihhiifggggeeeeebbb       NH:i:2  HI:i:2   AS:i:48 nM:i:0
10689795        0       6       135934  255     49M     *       0       0       AAGGCTGCAATGAGCTGTGATCGCACCACCGCACCCAAGCCTGGGTGGT        bbbeeeeeggggfiiiighiiiiiiiiiiiiiihiihfhhiiiii_ega       NH:i:1   HI:i:1  AS:i:44 nM:i:2
10416101        0       6       136561  255     49M     *       0       0       CCCAACGTTTAGACTACACAATGAGTTAAGAACGACAAAAATAAGCTCA        ___ecccceeeeghhhhhhhhgfgiihfhhhhfhffffgghhhidfffh       NH:i:1   HI:i:1  AS:i:48 nM:i:0
```

The first part indicated by the first character **@** in each row is the header:

| Symbol|  |  |   
| :----: | :---- | :---- |
| **@HD** header line	| **VN:1.4** version of the SAM format|	**SO:coordinate** sorting order|
| **@SQ** reference sequence dictionary 	| **SN:6** sequence name|	**LN:170805979** sequence length|
| **@PG** program used|	**ID:STAR** **PN:STAR**	**VN:2.5.3a** version| **CL:STAR   --genomeDir index_chr6   --readFilesIn ../RNAseq/output_nextflow/Alignments/selection_chr6/SRR3091420_1_chr6.fastq.gz      --readFilesCommand zcat      --outFileNamePrefix alignments/SRR3091420_1_chr6   --outSAMtype BAM   SortedByCoordinate      --quantMode GeneCounts** command line|
|**@CO** One-line text comment||**user command line: STAR --genomeDir index_chr6 --readFilesIn ../RNAseq/output_nextflow/Alignments/selection_chr6/SRR3091420_1_chr6.fastq.gz --readFilesCommand zcat --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --outFileNamePrefix alignments/SRR3091420_1_chr6**|

The rest is a read alignment. 

| Field|Value |   
| :----: | :---- |
|Query name 	|8553177|
|FLAG 	|272 * |
|Reference name 	|6|
|Leftmost mapping position (1-based)	|119288|
|Mapping quality 	|3 *(p=0.5)* |
|CIGAR string |1S48M *|
|Reference sequence name of the primary alignment of the mate | * = no mate	(= *same chromosome*)|
|Position of the primary alignment of the mate| 	0|
|observed fragment length| 	0|
|Sequence |TGAAATCCAGTGGGACAGTCAAATCTTAAAGCTCCAAAATGATCTCCTT|
|Quality	|hiiiiiiiiiiiiigiiiiiiiihiihiiiiihhiigggggeeeeebbb|

\* **FLAG 272** means that the read is non paired, and that it maps on the reverse strand.
<br>
**CIGAR string 1S48M** means that 1 base was soft clip (S) and 48 bases were mapped to the reference (M). N would correspond to bases unmapped.
<br>
You can use [this website for the translation of SAM FLAG values](https://www.samformat.info/sam-format-flag) and [this one for interpreting CIGAR strings](https://www.drive5.com/usearch/manual/cigar.html).

<br>
Extra fields are often present and differ between aligners [https://samtools.github.io/hts-specs/SAMtags.pdf](https://samtools.github.io/hts-specs/SAMtags.pdf). In our case we have:

| Field|Meaning |   
| :----: | :---- |
|NH:i:2|number of mapping to the reference|
|HI:i:2|which alignment is the reported one (in this case is the second one)|	
|AS:i:74|Alignment score calculate by the aligner|
|nM:i:9|number of difference with the reference*|

\* *Note that historically this has been ill-defined and both data and tools exist that disagree with this
definition.*

<br/>

Let's convert BAM to SAM:

```{bash}
$RUN samtools view -h alignments/SRR3091420_1_chr6Aligned.sortedByCoord.out.bam > alignments/SRR3091420_1_chr6Aligned.sortedByCoord.out.sam
```

You can see that the SAM file is **5 times larger** than the BAM file.
<br> 
Yet, the more efficient way to store the alignment is to use the [**CRAM format**](https://samtools.github.io/hts-specs/CRAMv3.pdf). CRAM is fully compatible with BAM, and main repositories, such as GEO and SRA, accept alignments in the CRAM format. [UCSC Genome Browser can visualize both BAM and CRAM files](https://genome.ucsc.edu/goldenPath/help/cram.html). It is now a widly recommended format for storing alignments.
<br>
To convert **BAM** to **CRAM**, we have to provide unzipped and indexed version of the genome.


```{bash}
$RUN samtools faidx ~/rnaseq_course/reference_genome/Homo_sapiens.GRCh38.dna.chrom6.fa

$RUN samtools view -C alignments/SRR3091420_1_chr6Aligned.sortedByCoord.out.bam -T ~/rnaseq_course/reference_genome/Homo_sapiens.GRCh38.dna.chrom6.fa > alignments/SRR3091420_1_chr6Aligned.sortedByCoord.out.cram
```

You can see that a .cram file is twice as small as a .bam file.
<br>
Let's remove the .sam file:
```{bash}
rm alignments/*.sam 
```

<br/>

## Alignment QC

The quality of the resulting alignment can be checked using the tool [**QualiMap**](http://qualimap.bioinfo.cipf.es/). To run QualiMap, we specify the kind of analysis (**rnaseq**), the presence of paired-end reads within the bam file (**-pe**) and the strand of the library (**-p strand-specific-reverse**). 

**IMPORTANT**: before running QualiMap ensure enough disk space for a temporary directory ./tmp that the program is required, running the following command:
```{bash}
export _JAVA_OPTIONS="-Djava.io.tmpdir=./tmp -Xmx6G"
```

<br/>

```{bash}
cd ~/rnaseq_course/mapping

# create folder
mkdir qc_qualimap

# run qualimap
$RUN qualimap rnaseq -pe -bam alignments/SRR3091420_1_chr6Aligned.sortedByCoord.out.bam \
	-gtf ~/rnaseq_course/reference_genome/Homo_sapiens.GRCh38.88.chr6.gtf \
	-outdir qc_qualimap -p unstranded
  
```

We can check the final report in a browser:

```{bash}
firefox qc_qualimap/qualimapReport.html
```
<img src="images/qualimap1.png"  align="middle" />

The report gives a lot of useful information, such as the total number of mapped reads, the amount of reads mapped to exons, introns or intergenic regions, and the bias towards one of the ends of mRNA (that can give information about RNA integrity or a protocol used). 

<img src="images/qualimap2.png"  align="middle" />

Looking at the gene coverage we can see a bias towards 5'-end that is compatible with the kind of stranded protocol used.

<img src="images/qualimap4.png"  align="middle" />

Finally, we can see that the majority of reads map to the exons.

<img src="images/qualimap3.png"  align="middle" />

<br/>

**IMPORTANT for running QualiMap on many samples (for detail, see [QualiMap documentation](http://qualimap.bioinfo.cipf.es/doc_html/command_line.html#rna-seq-qc)**
* Make sure to give to the output folder the name corresponding to a running sample; e.g., ./QC/SRR3091420_1_chr6; otherwise output files will be overwritten. 
* If you run QualiMap in parallel for many samples, make sure to create a different tmp-folder for each sample; e.g., ./tmp/SRR3091420_1_chr6Aligned.
* QualiMap sorts BAM files by read names. To speed up this part of the program execution, you can use samtools to sort the BAM files in parallel and using multiple CPUs and then to give to QualiMap a BAM file sorted by read names and provide an option --sorted.

<br/>

