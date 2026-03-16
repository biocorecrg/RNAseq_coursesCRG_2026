#!/bin/bash

if [ -f "$(pwd)/tidyverse.sif" ]; then
    echo "container already exists, skipping download"
else
    singularity pull $(pwd)/tidyverse.sif docker://rocker/tidyverse:4
fi

SIF=tidyverse.sif

# specify path to tmp directory created in previous section
TMPDIR=rstudio-tmp

if [ -d "$TMPDIR" ]; then
    echo "tmp directory already exists, skipping creation"
else
    mkdir -p "$TMPDIR/var/lib"
    mkdir -p "$TMPDIR/var/run"
    mkdir -p "$TMPDIR/tmp"
    mkdir -p "$TMPDIR/home"
fi

singularity exec \
    --bind /etc/passwd:/etc/passwd \
    --bind /etc/group:/etc/group \
    --workdir $TMPDIR/home \
    -B $TMPDIR/var/lib:/var/lib/rstudio-server \
    -B $TMPDIR/var/run:/var/run/rstudio-server \
    -B $TMPDIR/tmp:/tmp \
    $SIF \
    rserver --www-address=127.0.0.1 --server-user=$(whoami)
