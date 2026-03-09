# Running the full analysis using the RNAseq nf-core pipeline 

All the previous steps can be chained together in what bioinformaticians call a pipeline.
Historically, each lab developed its own pipelines using custom code tailored to their specific IT infrastructure. 
In many cases, this code was so ad-hoc that adapting it to other environments was nearly impossible. 
This was a major barrier to reproducibility and collaboration.
This challenge sparked some open-source projects, including one invented here at CRG: [Nextflow](https://www.nextflow.io/). 
Nextflow is a domain-specific language built on Groovy that enables scalable, reproducible, and portable scientific workflows. 
It abstracts away infrastructure complexity, allowing the same pipeline to run on a laptop, HPC cluster, or cloud environment.
From the very beginning, a community of scientists adopted the tool and began building a curated collection of high-quality, peer-reviewed bioinformatics pipelines. 
This community, known as [nf-core](https://nf-co.re), now maintains over 100 pipelines covering diverse applications—from RNA-seq and variant calling to metagenomics and spatial transcriptomics. 
All nf-core pipelines follow strict guidelines for structure, documentation, and testing, ensuring consistency and reliability across the entire collection.
