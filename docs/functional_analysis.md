# Hands-on: Functional analysis

First, get the files from the **undifferentiated only** DESeq2 analysis (in case we did not have time to do it):

```bash
# get file
wget https://github.com/biocorecrg/RNAseq_coursesCRG_2026/tree/master/docs/data/differential_expression/undiff

```

## Databases

### Gene Ontology

| |
|:---:|
| ![Gene Ontology logo](images/GO_logo.png) |

The [Gene Ontology (GO)](http://geneontology.org/) describes our knowledge of the biological domain with respect to three aspects (domains):

| GO domain | Description | Biological Level |
| :--- | :--- | :--- |
| **Biological Process (BP)** | Coordinated series of molecular activities that contribute to a biological goal. | Integrative (e.g., *mitosis*, *DNA repair*) |
| **Molecular Function (MF)** | Elemental activities performed by a gene product at the molecular level. | Elemental (e.g., *catalysis*, *binding*) |
| **Cellular Component (CC)** | The physical locations or complexes where a gene product is active. | Spatial (e.g., *nucleus*, *ribosome*) |

:::{admonition} Differences in number and granularity
:class: note

* **Biological Process** is typically the largest and most complex domain, often yielding the most specific biological insights in RNA-seq studies.
* The structure is a **Directed Acyclic Graph (DAG)**, meaning a term can have multiple parents.
* **True Path Rule**: If a gene is associated with a specific child term, it is automatically associated with all its parent terms up to the root. This is why "higher" terms in the hierarchy (closer to the root) contain many more genes than "lower", more specific terms.
:::

Example: the gene product "cytochrome c" is associated with the **molecular function** *oxidoreductase activity*, the **biological process** *oxidative phosphorylation*, and the **cellular component** *mitochondrial matrix*.

The structure of GO can be described as a graph: each GO term is a **node**, and each **edge** represents the relationship (e.g., *is_a*, *part_of*) between nodes.

| |
|:---:|
| ![GO example graph](images/GO_example_graph.png) |

GO:0019319 (hexose biosynthetic process) is part of GO:0019318 (hexose metabolic process) and also part of GO:0046364 (monosaccharide biosynthetic process). They all share common **parent nodes**, for example GO:0008152 (metabolic process), and eventually a **root node** that is here **biological process**.

### KEGG pathways

The [Kyoto Encyclopedia of Genes and Genomes (KEGG)](https://www.genome.jp/kegg/) is a database for understanding high-level functions and utilities of the biological system.

It provides comprehensible manually-drawn pathways representing biological processes or disease-specific pathways.
Example of the [*Homo sapiens* melanoma pathway](https://www.genome.jp/dbget-bin/www_bget?hsa05218):

| |
|:---:|
| ![KEGG melanoma pathway](images/kegg_hsa05218.png) |

### Molecular Signatures Database (MSigDB)

| |
|:---:|
| ![MSigDB banner](images/gsea_msig_banner.png) |

The [Molecular Signatures Database (MSigDB)](http://software.broadinstitute.org/gsea/msigdb/index.jsp) is a collection of  35361 gene sets in the Human Molecular Signatures Database (MSigDB) (as of March 2026) created to be used with the GSEA software (but not only).

It is divided into [9 major collections](https://www.gsea-msigdb.org/gsea/msigdb/human/collections.jsp) (that include the previously described Gene Ontologies and KEGG pathways):

| |
|:---:|
| ![MSigDB collections](images/gsea_msig_sets.png) |

:::{admonition} Mouse MSigDB Collections
:class: note

A collection of gene sets is also available for mouse: [Mouse Molecular Signatures Database (MSigDB)](https://www.gsea-msigdb.org/gsea/msigdb/mouse/collections.jsp).
:::

## Enrichment analysis based on gene selection

Tools based on a user-selection of genes usually require 2 inputs:

* **Gene Universe:** in our example, all genes used in our analysis (after filtering out low counts).
* **List of genes selected from the universe:** our selection of genes given the criteria we previously used: **padj < 0.05**.

They are often based on the **Hypergeometric test** or on the **Fisher's exact test**. You can have a look at this [page](http://pedagogix-tagc.univ-mrs.fr/courses/ASG1/practicals/go_statistics_td/go_statistics_td_2015.html) for some explanation of both tests.

Let's prepare this list from the file we saved before:

```bash
mkdir -p ~/rnaseq_course/functional_analysis
cd ~/rnaseq_course/functional_analysis

# The gene symbol is in the 12th column, sed '1d' removes the header
cut -f 12 ~/rnaseq_course/differential_expression/undiff/deseq2_selection_padj005_undiff.txt | sed '1d' > deseq2_selection_padj005_symbols.txt
```

### enrichR

[EnrichR](http://amp.pharm.mssm.edu/Enrichr/) is a gene-list enrichment tool developed at the Icahn School of Medicine (Mount Sinai).

| |
|:---:|
| ![EnrichR interface](images/enrichr_interface.png) |

It does not require the input of a gene universe: only a selection of genes or a BED file.

| |
|:---:|
| ![EnrichR paper](images/enrichr_paper1.jpg) | Title: <https://pmc.ncbi.nlm.nih.gov/articles/PMC3637064/> |

The default EnrichR interface works for *Homo sapiens* and *Mus musculus*.
However, EnrichR also provides a [set of tools](https://amp.pharm.mssm.edu/modEnrichr/) for ortholog conversion and enrichment analysis of more organisms:

| |
|:---:|
| ![EnrichR modEnrichr interface](images/enrichr_interface2.png) |

In the [main page](http://amp.pharm.mssm.edu/Enrichr/), paste our list of selected **gene symbols** (*deseq2_selection_padj005_symbols.txt*) and **Submit**!

| |
|:---:|
| ![EnrichR all results](images/enrichr_results_all.png) |

KEGG Human pathway **bar graph** visualization:

| |
|:---:|
| ![EnrichR bar graph](images/enrichr_results_bar.png) |

KEGG Human pathway **table** visualization:

| |
|:---:|
| ![EnrichR table](images/enrichr_results_table.png) |

KEGG Human pathway **clustergram** visualization:

| |
|:---:|
| ![EnrichR clustergram](images/enrichr_results_clustergram.png) |

For **Cell Types**, you can also visualize networks, for example **Human gene Atlas**:

| |
|:---:|
| ![EnrichR network](images/enrichr_results_network.png) |

You can also export some graphs as PNG, JPEG or SVG.

### GO / Panther tool

The [main page of GO](http://geneontology.org/) provides a tool to test the enrichment of gene ontologies or Panther/Reactome pathways in pre-selected gene lists.

The tool needs a selection of differentially expressed genes (supported IDs are: gene symbols, ENSEMBL IDs, HUGO IDs, UniGene, ..) and a gene universe.

Prepare files using this time the **ENSEMBL IDs**:

```bash
cd ~/rnaseq_course/functional_analysis

# Extract all gene IDs used in our analysis
cut -f 1 ~/rnaseq_course/differential_expression/undiff/normalized_counts_log2_star_undiff.txt | sed '1d' > deseq2_UNIVERSE_ENSEMBL.txt

# Extract significant gene symbols only
cut -f 1 ~/rnaseq_course/differential_expression/undiff/deseq2_selection_padj005_undiff.txt | sed '1d' > deseq2_selection_padj005_ENSEMBL.txt
```

Paste our selection, and select **biological process** and **Homo sapiens**:

| |
|:---:|
| ![GO tool interface](images/GO_tool_interface.png) |

**Launch**!

| |
|:---:|
| ![GO tool input](images/GO_tool_input1.png) |

**Analyzed List** is what we just uploaded (*deseq2_selection_padj005_ENSEMBL.txt*).
In **Reference List**, we need to upload a file containing the **universe** (*deseq2_UNIVERSE_ENSEMBL.txt*): *Change → Browse → (select deseq2_UNIVERSE_ENSEMBL.txt) → Upload list*

* Launch analysis

| |
|:---:|
| ![GO tool results ENSEMBL](images/GO_tool_results_ensembl.png) |

* Try the same analysis using the **gene symbols** instead of ENSEMBL IDs

```bash
# Get universe with gene symbols (we already have the gene selection in deseq2_selection_padj005_symbol.txt)
cut -f11 ~/rnaseq_course/differential_expression/undiff/normalized_counts_log2_star_undiff.txt | sed '1d' > deseq2_UNIVERSE_symbols.txt
```

* **Launch**!

| |
|:---:|
| ![GO tool results symbols](images/GO_tool_results_symbols.png) |

### With R: GOstats

In RStudio, load the `GOstats` package:

```r
setwd("~/rnaseq_course/functional_analysis")

library("GOstats")
```

Read in differentially expressed genes:

```r
de_select <- read.table("deseq2_selection_padj005_ENSEMBL.txt", header=T, as.is=T, sep="\t")
```

The gene universe can be the list of genes **after filtering for low counts**: we prepared it already: **deseq2_UNIVERSE_ENSEMBL.txt**

```r
de_univ <- read.table("deseq2_UNIVERSE_ENSEMBL.txt", header=T, as.is=T, sep="\t")
```

GOstats works only with **Entrez IDs**: we can get them with the **biomaRt** package, as we did for the differential expression analysis.

```r
library(biomaRt)

# load database
mart <- useMart(biomart="ENSEMBL_MART_ENSEMBL", host="https://sep2025.archive.ensembl.org", path="/biomart/martservice", dataset="hsapiens_gene_ensembl")

# ENSEMBL IDs for differentially expressed genes
ids <- de_select

# get Entrez IDs
entrez <- getBM(attributes=c('entrezgene', 'ensembl_gene_id'), filters ='ensembl_gene_id', values = ids, mart = mart)

# get Entrez IDs for the universe
ids_univ <- de_univ
entrez_univ <- getBM(attributes=c('entrezgene', 'ensembl_gene_id'), filters ='ensembl_gene_id', values = ids_univ, mart = mart)
```

:::{admonition} Note
:class: note

As biomaRt may cause connection issues, you can download pre-computed Entrez ID files directly:

```bash
cd ~/rnaseq_course/functional_analysis

wget https://github.com/biocorecrg/RNAseq_coursesCRG_2026/tree/master/docs/data/functional_analysis/deseq2_selection_padj005_entrez.txt

wget https://github.com/biocorecrg/RNAseq_coursesCRG_2026/tree/master/docs/data/functional_analysis/deseq2_UNIVERSE_entrez.txt
```

```r
entrez <- read.table("deseq2_selection_padj005_entrez.txt", header=T, as.is=T, sep="\t")
entrez_univ <- read.table("deseq2_UNIVERSE_entrez.txt", header=T, as.is=T, sep="\t")
```

:::

We can proceed with the **hypergeometric test** (enrichment) for the **Biological Process** ontologies:

```r
# install annotation package
BiocManager::install("org.Hs.eg.db")

# Set p-value cutoff
hgCutoff <- 0.001

# Set parameters
params <- new("GOHyperGParams",
 geneIds=na.omit(unique(entrez)),
 universeGeneIds=na.omit(unique(entrez_univ)),
 ontology="BP",
 annotation="org.Hs.eg",
 pvalueCutoff=hgCutoff,
 conditional=FALSE,
 testDirection="over")

# Run enrichment test
hgOver <- hyperGTest(params)

# Get a summary table
df <- summary(hgOver)
```

| GOBPID | Pvalue | OddsRatio | ExpCounts | Counts | Size | Term |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| GO:0016477 | 4.322880e-05 | 3.594820 | 5.82993675 | 17 | 1098 | cell migration |
| GO:0010884 | 7.630680e-05 | 45.181065 | 0.08495354 | 3 | 16 | positive regulation of lipid storage |
| GO:0097755 | 8.408726e-05 | 19.842188 | 0.23362224 | 4 | 44 | positive regulation of blood vessel diameter |
| GO:0060485 | 9.996919e-05 | 7.305817 | 1.08315765 | 7 | 204 | mesenchyme development |
| GO:0035150 | 1.250790e-04 | 11.541689 | 0.48848286 | 5 | 92 | regulation of tube size |
| GO:0035296 | 1.250790e-04 | 11.541689 | 0.48848286 | 5 | 92 | regulation of tube diameter |

**GOstats** also provides an **HTML report**:

```r
# Produce HTML report
htmlReport(hgOver, file="GOstats_BP.html")
```

We can open the report in a web browser.

### With R: KEGGprofile

Load the **KEGGprofile** package:

```r
library(KEGGprofile)
```

KEGGprofile also works with **Entrez ID** (we got them for the GOstats analysis).

```r
# KEGG pathway enrichment
KEGGresult <- find_enriched_pathway(na.omit(unique(entrez$entrezgene)),
 returned_genenumber=10,
 species='hsa',
 download_latest = TRUE)

# Format results
kegg_final <- data.frame(KEGGresult$stastic,
 genes_entrezid=unlist(lapply(KEGGresult$detail, function(x)paste(x, collapse=",")), use.names=F),
 stringsAsFactors=F)

# Write table to file
write.table(kegg_final, "KEGGprofile_results.txt", sep="\t", row.names=F, col.names=T, quote=F)
```

Results table:

| Pathway_Name | Gene_Found | Gene_Pathway | Percentage | pvalue | pvalueAdj |
|:---:|:---:|:---:|:---:|:---:|:---:|
| Metabolic pathways | 88 | 1489 | 0.06 | 4.644397e-08 | 1.565162e-05 |
| Cytokine-cytokine receptor interaction | 26 | 294 | 0.09 | 3.187192e-05 | 3.580279e-03 |
| Viral protein interaction with cytokine and cytokine receptor | 12 | 100 | 0.12 | 1.671507e-04 | 8.047114e-03 |
| NF-kappa B signaling pathway | 10 | 102 | 0.10 | 2.490180e-03 | 3.356763e-02 |
| Mitophagy - animal | 11 | 65 | 0.17 | 8.801457e-06 | 1.483046e-03 |
| C-type lectin receptor signaling pathway | 10 | 104 | 0.10 | 2.898658e-03 | 3.757106e-02 |

## Enrichment based on ranked lists of genes using GSEA

### GSEA (Gene Set Enrichment Analysis)

| |
|:---:|
| ![GSEA presentation](images/gsea_presentation.png) |

[GSEA](http://software.broadinstitute.org/gsea/) is available as a Java-based tool.

#### Algorithm

GSEA doesn't require a threshold: the whole set of genes is considered.

| |
|:---:|
| ![GSEA paper figure](images/gsea_paper.jpg) |

GSEA checks whether a particular gene set (for example, a gene ontology) is **randomly distributed** across a list of **ranked genes**.

The algorithm consists of 3 key elements:

1. **Calculation of the Enrichment Score**
The Enrichment Score (ES) reflects the degree to which a gene set is overrepresented at the extremes (top or bottom) of the entire ranked gene list.
2. **Estimation of Significance Level of ES**
The statistical significance (nominal p-value) of the **Enrichment Score (ES)** is estimated by using an empirical phenotype-based permutation test procedure. The **Normalized Enrichment Score (NES)** is obtained by normalizing the ES for each gene set to account for the size of the set.
3. **Adjustment for Multiple Hypothesis Testing**
Calculation of the FDR to control the proportion of false positives.

| |
|:---:|
| ![GSEA explained animation](images/gsea_explained.gif) |

:::{seealso}
See the [GSEA Paper](https://www.ncbi.nlm.nih.gov/pubmed/16199517) for more details on the algorithm.
:::

The main GSEA algorithm requires 3 inputs:

* Gene expression data
* Phenotype labels
* Gene sets

#### Gene expression data in TXT format

The input should be normalized read counts filtered for low counts (we created it in the DESeq2 tutorial → *normalized_counts.txt*!).

The first column contains the gene ID (HUGO symbols for *Homo sapiens*).
The second column contains any description or symbol, and will be ignored by the algorithm.
The remaining columns contain normalized expressions: one column per sample.

| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| NAME | DESCRIPTION | 5p4_25c | 5p4_27c | 5p4_28c | 5p4_29c | 5p4_30c | 5p4_31cfoxc1 | ... |
| DKK1 | NA | 0 | 0 | 0 | 0 | 0 | 0 | ... |
| HGT | NA | 0 | 0 | 0 | 0 | 0 | 0 | ... |

:::{admonition} Exercise
:class: tip

Adjust the file **normalized_counts_log2_star.txt** so the first column is the gene symbol, the second is the gene ID (or anything else), and the remaining ones are the expression columns. Save the new file as **gsea_normalized_counts.txt**.

```r
setwd("~/rnaseq_course/differential_expression/undiff/")

## Read undiff normalized counts
norm_counts <- read.table("normalized_counts_log2_star_undiff.txt",as.is = TRUE, sep="\t", header = TRUE)

## Check our sample columns and gene id and gene name columns
colnames(norm_counts)
# write normalized counts for GSEA
x <- norm_counts
sample_val<-norm_counts[,2:6] ## Selecting the sample columns with the normalized values. 

#Select column names and ensembl gene ids
y <- x[,c(1,11)] ## Select the gene_id and gene_name columns
colnames(y)
x <- data.frame(NAME=y[,2], DESCRIPTION=y[,1])
x <- cbind(x,sample_val)
colnames(x)

setwd("~/rnaseq_course/functional_analysis")

write.table(x, "R_norm_counts_for_GSEA.txt", quote=F, col.names=T, row.names=F, sep="\t")
```

:::

#### Phenotype labels in CLS format

A phenotype label file defines phenotype labels (experimental groups) and assigns those labels to the samples in the corresponding expression data file.

| |
|:---:|
| ![GSEA phenotypes format](images/gsea_phenotypes.png) |

Let's create it for our experiment:

```
10 2 1
# WT KO
WT WT WT WT WT KO KO KO KO KO
```

:::{admonition} Note
:class: note

The first label used is assigned to the first class named on the second line; the second unique label is assigned to the second class named; and so on.

So the phenotype file could also be:

```
10 2 1
# WT KO
0 0 0 0 0 1 1 1 1 1
```

The first label **WT** in the second line is associated to the first label **0** on the third line.
:::

:::{admonition} Exercise
:class: tip

Create the phenotype labels file and save it as **gsea_phenotypes.cls**.
:::

#### Download and run GSEA

##### Download Java application

GSEA is Java-based. Launch it from a terminal window:

```bash
#Download GSEA
wget https://data.broadinstitute.org/gsea-msigdb/.test/gsea/software/desktop/4.0/GSEA_Linux_4.0.3.zip
unzip GSEA_Linux_4.0.3.zip
cd GSEA_Linux_4.0.3
bash gsea.sh 
```

| |
|:---:|
| ![GSEA interface](images/gsea_interface.png) |

In *Steps in GSEA analysis* (upper left corner):

* Go to **Load data**: select **gsea_normalized_counts.txt** and **gsea_phenotypes.cls** and load.

| |
|:---:|
| ![GSEA load files](images/gsea_load_files.png) |

* Go to **Run GSEA**

| |
|:---:|
| ![GSEA parameters](images/gsea_parameters_commented.png) |

* Results: **index.html**

| |
|:---:|
| ![GSEA results index](images/gsea_results_index_commented.png) |

* **Enrichment results in HTML**

| |
|:---:|
| ![GSEA results stats](images/gsea_results_stats.png) |

* Details for one gene set:
  * Summary of enrichment: phenotype, stats (Nominal p-value, FDR q-value, FWER p-value), enrichment scores (ES and Normalized ES)
  * Enrichment plot

| |
|:---:|
| ![GSEA enrichment details](images/gsea_results_details1.png) |

Table of genes: ranking, individual enrichment scores, core enrichment Yes/No.

:::{admonition} Note on core enrichment genes
:class: note

From GSEA documentation: *"Genes with a Yes value in this column contribute to the leading-edge subset within the gene set. This is the subset of genes that contributes most to the enrichment result."*
:::

| |
|:---:|
| ![GSEA gene table](images/gsea_results_details2.png) |

Heatmap of all genes from that gene set (ranked by GSEA) for each sample:

| |
|:---:|
| ![GSEA heatmap](images/gsea_results_details3.png) |

:::{admonition} Suggestions for GSEA
:class: tip

* Selection of pathways / gene sets: select the **lowest FDR** first.
* If you are looking for genes to validate on certain pathways:
  * It is better if those genes belong to the **core enrichment**.
  * It is also good to go back to the **differential expression** analysis table and make sure that their **adjusted-value** is low.
* You can also upload **your own gene sets** (for example a gene signature taken from a specific paper) to test against your list of genes, using one of the [GSEA gene set database formats](http://software.broadinstitute.org/cancer/software/gsea/wiki/index.php/Data_formats#Gene_Set_Database_Formats).
:::

## Further reading

* [GSEA User Guide](https://docs.gsea-msigdb.org/#GSEA/GSEA_User_Guide/)
* [clusterProfiler](https://bioconductor.org/packages/clusterProfiler/)
* [GOstats](https://bioconductor.org/packages/GOstats/)
