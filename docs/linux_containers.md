---
layout: page
title: Linux containers
navigation: 3
---

# Basic concepts on Linux containers

During this course we will use tools that are stored in a [**Linux container**](https://en.wikipedia.org/wiki/LXC). 

A Linux Container can be seen as a **minimal virtual environment** that can be used in any Linux-compatible machine. 

Using containers is time- and resources-savingas they allow:
* Controlling for software installation and dependencies and
* Reproducibility of the analysis.

For this course, we created a [**Docker**](https://www.docker.com/) image from [this Dockerfile](https://github.com/biocorecrg/PHINDaccess_RNAseq_2020/blob/master/Dockerfile) available for download from [DockerHub](https://cloud.docker.com/u/biocorecrg/repository/docker/biocorecrg/rnaseq2020).

This will allow all of us to use **exactly the same versions of the tools**.

This image can be downloaded and used on computers running Linux/Mac OS (if you have a root access on the computer) or can be converted into another Linux Container called [**Singularity**](https://www.sylabs.io/docs/), which we will be using in this course. Singularity containers are easier to share and to export, and they can be ran without root privileges.

The Singularity image is a file that is accessed by the program **singularity** in order to execute the programs installed inside this image. 
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

To access the image during the course, we will store the following command in the environmental variable **RUN** :

```{bash}
# Export the RUN variable
export RUN="singularity exec -e ~/rnaseq_course/singularity_image/rnaseq2020-1.0.simg"

# Access the salmon program inside the image
$RUN salmon --help
```


<br/>

