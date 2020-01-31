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

This image can be downloaded and used on computers running Linux/Mac OS or can be converted into another Linux Container called [**Singularity**](https://www.sylabs.io/docs/), which we will be using in this course. Singularity containers are easier to share and to export.

The Singularity image is a simple file: it can be accessed by the program **singularity** in order to access and executes the programs installed inside. 
<br>
This image can be created using the following command (imported from the [Docker hub repository](https://hub.docker.com/) and converted on the fly):

```{bash}
# go to the folder created to store the image
cd ~/rnaseq_course/singularity_image

# import image from Docker hub
singularity pull docker://biocorecrg/rnaseq2020:1.0
```

This creates the "rnaseq2020-1.0.simg" file.

<br>
The image can be accessed/run the following way:

```{bash}
singularity exec -e rnaseq2020-1.0.simg salmon --help
```

In order to facilitate the access to the image during the course, we will store the previous command in the **RUN** variable:

```{bash}
# Export the RUN variable
export RUN="singularity exec -e ~/rnaseq_course/singularity_image/rnaseq2020-1.0.simg"

# Access the image
$RUN salmon --help
```


<br/>

