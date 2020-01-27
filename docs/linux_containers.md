---
layout: page
title: Linux containers
navigation: 2
---

# Basic concepts on Linux containers

During this course we will use tools which are stored in a [**Linux container**](https://en.wikipedia.org/wiki/LXC). 

A Linux Container can be seen as a **minimal virtual environment** that can be used in any Linux-compatible machine. 

Using containers is time- and resources-saving:
* Control of installation and dependencies
* Reproducibility of the analysis

For this course, we created a [**Docker**](https://www.docker.com/) image from [this Dockerfile](https://github.com/biocorecrg/PHINDaccess_RNAseq_2020/blob/master/Dockerfile) available for download from [DockerHub](https://cloud.docker.com/u/biocorecrg/repository/docker/biocorecrg/rnaseq2020).

This will allow us to use **exactly the same versions of the tools**.

This image can be downloaded and used on computers running Linux/Mac OS or can be converted into another Linux Container called [**Singularity**](https://www.sylabs.io/docs/), which we will be using in this course. 

The Singularity image is a file that can be accessed by the program Singularity for executing any software installed within that image. This image can be created using the following command:

```{bash}
singularity pull docker://biocorecrg/rnaseq2020:1.0
```

And accessed/run with:

```{bash}
export RUN="singularity exec -e $PWD/rnaseq2020-1.0.simg"
$RUN STAR --help
```


<br/>

