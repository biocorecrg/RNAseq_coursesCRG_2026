#!/bin/bash

if [ -f "$HOME/rstudio.sif" ]; then
    echo "container already exists, skipping download"
else
    singularity pull $HOME/rstudio.sif docker://rocker/tidyverse:4
fi

SIF=$HOME/rstudio.sif

# specify path to tmp directory created in previous section
TMPDIR=$HOME/rstudio-tmp

if [ -d "$TMPDIR" ]; then
    echo "tmp directory already exists, skipping creation"
else
    mkdir -p "$TMPDIR/var/lib"
    mkdir -p "$TMPDIR/var/run"
    mkdir -p "$TMPDIR/tmp"
    mkdir -p "$TMPDIR/home"
fi

singularity exec \
    --workdir $TMPDIR/home \
    -B $TMPDIR/var/lib:/var/lib/rstudio-server \
    -B $TMPDIR/var/run:/var/run/rstudio-server \
    -B $TMPDIR/tmp:/tmp \
    $SIF \
    bash -c "useradd -u $(id -u) -g $(id -g) -m $(whoami) 2>/dev/null || true; rserver --www-address=127.0.0.1 --server-user=$(whoami)"
