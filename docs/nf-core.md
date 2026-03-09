# Running the full analysis using the RNAseq nf-core pipeline 

All the previous steps can be chained together in what bioinformaticians call a pipeline.
Historically, each lab developed its own pipelines using custom code tailored to its specific IT infrastructure. 
In many cases, this code was so ad hoc that adapting it to other environments was nearly impossible. 
This was a major barrier to reproducibility and collaboration.
This challenge sparked some open-source projects, including one invented here at CRG: [Nextflow](https://www.nextflow.io/). 

<div align="center">
<img src="images/nextflow_logo.png" width="300"  />
</div>

Nextflow is a domain-specific language built on Groovy that enables scalable, reproducible, and portable scientific workflows. 
It abstracts away infrastructure complexity, allowing the same pipeline to run on a laptop, HPC cluster, or cloud environment.
From the very beginning, a community of scientists adopted the tool and began building a curated collection of high-quality, peer-reviewed bioinformatics pipelines. 
This community, known as [nf-core](https://nf-co.re), now maintains over 100 pipelines covering diverse applications—from RNA-seq and variant calling to metagenomics and spatial transcriptomics. 
All nf-core pipelines follow strict guidelines for structure, documentation, and testing, ensuring consistency and reliability across the entire collection.

<div align="center">
<img src="images/nf-core.png" width="800"  />
</div>

</br>

These pipelines leverage containerization to ensure reproducibility and portability. Each bioinformatics tool runs inside a Linux container (such as Singularity/Apptainer or Docker), eliminating dependency conflicts and the "works (only :) ) on my machine" problem.
Most nf-core pipelines rely on container images from [Biocontainers](https://biocontainers.pro/), a community-driven project that automatically builds and hosts containers for thousands of bioinformatics tools. These pre-built images are publicly available at [quay.io](https://quay.io/), allowing pipelines to pull the exact software versions they need on-demand.

<div align="center">
<img src="images/biocontainers_screen.png" width="300"  />
</div>

For our data analysis, we will use the [nf-core RNAseq pipeline](https://nf-co.re/rnaseq/3.23.0/). The whole analysis is described in this fancy diagram:

<div align="center">
<img src="images/nf-core-rnaseq_metro_map_grey_animated.svg" width="800"  />
</div>

As you can see, we have almost 40 tools that are chained and available. This level of complexity was nearly impossible in the past without the use of an orchestrator.

We can identify 5 macro areas:
- Preprocessing: merge different sequencing runs, infer strandness, QC, UMI extraction, adapter trimming and contaminants and rRNA removal.  
- Genome alignment using either Star, Hisat2 or bowtie2. Quantification with Rsem or Salmon. (Hisat2 has no quantification method)
- Transcriptome pseudo-alignment with either Salmon or Kallisto.
- Post-processing after genome alignmentgnment: sorting, umi and read deduplication, transcriptome assembly, and quantification. Generation of read coverage files (bigWig) for displaying in genome browsers.
- Quality control and reporting after post-processing: QC on alignment, such as RSeQC, qualimap, etc. Detection of contamination and final reporting with MultiQC 


