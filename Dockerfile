FROM biocorecrg/centos-perlbrew-pyenv-java:centos7

# File Author / Maintainer
MAINTAINER Toni Hermoso Pulido <toni.hermoso@crg.eu>
MAINTAINER Luca Cozzuto <lucacozzuto@gmail.com> 
MAINTAINER Sarah Bonnin <sarah.bonnin@crg.eu> 

ARG FASTQC_VERSION=0.11.9
ARG STAR_VERSION=2.7.3a
ARG QUALIMAP_VERSION=2.2.1
ARG SKEWER_VERSION=0.2.2
ARG MULTIQC_VERSION=1.8
ARG SAMTOOLS_VERSION=1.10
ARG BCFTOOLS_VERSION=1.10.2
ARG FASTQSCREEN_VERSION=0.14.0
ARG BOWTIE2_VERSION=2.3.5.1
ARG SALMON_VERSION=1.1.0
ARG SRATOOLKIT_VERSION=2.9.6

#upgrading pip
RUN yum install -y epel-release python-pip
RUN pip install --upgrade pip

#INSTALLING FASTQC
RUN bash -c 'curl -k -L https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${FASTQC_VERSION}.zip > fastqc.zip'
RUN unzip fastqc.zip; chmod 775 FastQC/fastqc; ln -s $PWD/FastQC/fastqc /usr/local/bin/fastqc

#INSTALLING FASTQ_SCREEN
RUN yum install -y perl-devel perl-CPAN perl-GD wget
RUN yum install -y gd gd-devel
#RUN wget http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/perl-GDTextUtil-0.86-23.el7.noarch.rpm
#RUN yum install -y perl-GDTextUtil-0.86-23.el7.noarch.rpm
RUN wget http://repo.openfusion.net/centos7-x86_64/perl-App-cpanminus-1.7006-1.el7.noarch.rpm
RUN yum install -y perl-App-cpanminus-1.7006-1.el7.noarch.rpm

#RUN curl -L http://cpanmin.us | perl - --sudo App::cpanminus
RUN cpanm -f GD::Graph::bars
RUN wget -O - https://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/fastq_screen_v${FASTQSCREEN_VERSION}.tar.gz | tar -xvzf -
RUN cp fastq_screen_v${FASTQSCREEN_VERSION}/* /usr/local/bin/
RUN sed s/perl/env\ perl/g fastq_screen_v${FASTQSCREEN_VERSION}/fastq_screen > /usr/local/bin/fastq_screen 

#INSTALLING BOWTIE2
RUN yum install -y yum install tbb.x86_64
RUN bash -c 'curl -k -L https://sourceforge.net/projects/bowtie-bio/files/bowtie2/${BOWTIE2_VERSION}/bowtie2-${BOWTIE2_VERSION}-linux-x86_64.zip/download > bowtie2.zip'
RUN unzip bowtie2.zip; mv bowtie2-${BOWTIE2_VERSION}*/bowtie2* /usr/local/bin/

# Installing Skewer
RUN bash -c 'curl -k -L https://downloads.sourceforge.net/project/skewer/Binaries/skewer-${SKEWER_VERSION}-linux-x86_64 > /usr/local/bin/skewer'
RUN chmod +x /usr/local/bin/skewer

# Installing STAR
RUN bash -c 'curl -k -L https://github.com/alexdobin/STAR/archive/${STAR_VERSION}.tar.gz > STAR.tar.gz'
RUN tar -zvxf STAR.tar.gz
RUN cp STAR-${STAR_VERSION}/bin/Linux_x86_64/* /usr/local/bin/
RUN rm STAR.tar.gz

# Installing QUALIMAP
RUN bash -c 'curl -k -L https://bitbucket.org/kokonech/qualimap/downloads/qualimap_v${QUALIMAP_VERSION}.zip > qualimap.zip'
RUN unzip qualimap.zip
RUN rm qualimap.zip

RUN ln -s $PWD/qualimap_v${QUALIMAP_VERSION}/qualimap /usr/local/bin/

# Installing MULTIQC // Latest dev version is much better. 
RUN yum install -y python-devel libcurl-devel
RUN pip install --upgrade pyparsing --ignore-installed pyparsing
RUN pip install multiqc==1.7

# Installing samtools
RUN yum install -y xz-devel.x86_64 bzip2
RUN wget -O - https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 | tar -jxvf - > samtools-${SAMTOOLS_VERSION}
RUN cd samtools-${SAMTOOLS_VERSION}; ./configure; make; make install; cd ../ 

# Installing BCFtools
RUN wget -O - https://github.com/samtools/bcftools/releases/download/${BCFTOOLS_VERSION}/bcftools-${BCFTOOLS_VERSION}.tar.bz2 | tar -jxvf - > bcftools-${BCFTOOLS_VERSION}
RUN cd bcftools-${BCFTOOLS_VERSION}; ./configure; make; make install; cd ../

# Installing salmon
RUN wget -O - https://github.com/COMBINE-lab/salmon/releases/download/v${SALMON_VERSION}/salmon-${SALMON_VERSION}_linux_x86_64.tar.gz | tar -xvzf -

RUN ln -s $PWD/salmon-*/bin/salmon /usr/local/bin/salmon

# copy GSEA java executable in image
COPY gsea-3.0.jar .

#INSTALLING SRATOOLKIT: configure?
RUN wget -O - https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/${SRATOOLKIT_VERSION}/sratoolkit.${SRATOOLKIT_VERSION}-centos_linux64.tar.gz | tar -zxvf -
RUN cd sratoolkit.${SRATOOLKIT_VERSION}-centos_linux64/bin; ln -s $PWD/fastq-dump /usr/local/bin/fastq-dump; cd ../../


# cleaning
RUN yum clean all
RUN rm -fr *.zip *.gz *.bz2 *rpm
RUN rm -fr STAR-* bedtools2  samtools-*

# build as: docker build --no-cache --tag biocorecrg/rnaseq2020:1.0 . node-hp0102


