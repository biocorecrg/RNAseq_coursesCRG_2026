# Hands-on: Linux CLI refresher

## Linux history

UNIX is a computer operating system originally developed in 1969 by a group of AT&T employees at Bell Labs.

UNIX-like derivatives spread:

- BSD
- AIX
- HP-UX
- Linux
* etc.

![Unix History][unix-history][^1]

[unix-history]: ./images/Unix_history.png

[^1]: [Source: Wikimedia Commons - UNIX history](https://commons.wikimedia.org/wiki/File:Unix_history-simple.svg)


### UNIX Philosophy

- Portable: Same code should work the same in different machines
- Multi-tasking: Different processes can run simultaneously. Every process has a unique identifier (PID)
- Multi-user: Many people can use the same machine at the same time. Users can share resources and processes
- Use of plain-text for storing data: also for configuration files
- Hierarchical file system
- Almost everything is a file: That includes devices and some information of processes
- Use of small programs all together to retrieve an output instead of an only multifunctional one

## Filesystem structure. Linux and Mac

```
/ (Root)
├── bin (Binaries)
├── boot (Boot files)
├── dev (Device files)
├── etc (Configuration files)
├── home (User personal data)
├── lib (Shared libraries)
├── media (Removable media)
├── mnt (Mount directory)
├── opt (Optional software)
├── proc (Process & kernel files)
├── root (Root user home)
├── sbin (System binaries)
├── srv (Service data)
├── tmp (Temporary files)
├── usr (User binaries & data)
│   ├── bin
│   ├── sbin
│   ├── lib
│   └── share
└── var (Variable data)
    └── log
```

You can inspect it with `ls /`. We will discover more later...

Other UNIX systems (e.g., Mac OS X) are similar, but not exactly the same.

```
/ (Root)
├── Applications/ (User apps like Chrome, Spotify)
├── Library/ (Shared system resources & settings)
├── System/ (Core macOS files; read-only)
│   └── Applications/ (Built-in apps like Safari, Mail)
├── Users/ (Equivalent to /home in Linux)
│   ├── yourusername/ (Desktop, Documents, etc.)
│   └── Shared/ (Files accessible to all users)
├── Volumes/ (Mounted drives, USBs, and DMGs)
├── bin/ (Essential Unix binaries) -> [Hidden]
├── sbin/ (System administration binaries) -> [Hidden]
├── usr/ (User binaries, libraries, and include files) -> [Hidden]
├── dev/ (Device files) -> [Hidden]
├── private/ (Contains actual etc, var, and tmp) -> [Hidden]
│   ├── etc/ (System configuration files)
│   ├── var/ (Variable data, logs, caches)
│   └── tmp/ (Temporary files)
└── cores/ (Core dumps for debugging) -> [Hidden]
```


## Move around

### Relative paths

- `cd` -> go to home
- `cd ../` -> go one level back
- `cd Desktop` -> go to Desktop
- `cd ../../` -> go two levels back
- `cd ../Desktop/..` -> don't move

### Absolute paths

- `cd /` -> go to root
- `cd /home/ubuntu/Desktop`
- `cd ~` -> go to home


Play with `ls` and different modifiers: `ls -l`, `ls -lt`, `ls -la`, etc.


**PRO TIP**: Don't use `man`, visit [tldr.sh](https://tldr.sh)

You can use from the terminal:

```
uv tool install tldr
tldr ls
```


## Create files and directories

To create file and folders in linux is quite simple. You can use a number of programs for creating an empty file (`touch`) or an empty directory (`mkdir`)

```bash
touch my_beautiful_file.txt
mkdir my_beautiful_folder
```

To display the list of files and folder we can use the command `ls`

```bash
ls

my_beautiful_file.txt  my_beautiful_folder
```

To change the name of a file (or a directory) you can use the command `mv` while for copying the file you can use `cp`. Adding the option **-r** (recursive) to `cp` allows to copy a whole folder and its content. 

```bash
mv my_beautiful_file.txt my_ugly_file.txt
mv my_beautiful_folder my_ugly_folder

cp my_ugly_file.txt my_beautiful_file.txt
cp my_ugly_folder -r my_beautiful_folder
```
If you omit the **-r** option the system will complain

```bash
cp my_ugly_folder my_other_folder

cp: omitting directory ‘my_ugly_folder’
```

You can use `mv` also for moving a file (or a directory) inside a folder. Also `cp` will allow you to make a copy inside a folder.

```bash
mv my_beautiful_file.txt my_beautiful_folder
cp my_ugly_file.txt my_ugly_folder

ls

my_beautiful_folder  my_ugly_file.txt  my_ugly_folder
```

For entering in a folder we can use the tool `cd`

```bash
cd my_ugly_folder

ls

my_ugly_file.txt
```

For going out we can move one level out 
```bash
cd ../

ls

my_beautiful_folder  my_ugly_file.txt  my_ugly_folder
```

Sometimes we get lost and would like to know where we are. We can use the command `pwd`

We can write to a file using the character **>**, that means output redirection.

```bash
echo "ATGTACTGACTGCATGCATGCCATGCA" > my_dna.txt
```

And display the content of the file using the program **cat**

```bash
cat my_dna.txt

ATGTACTGACTGCATGCATGCCATGCA
```

To convert this sequence to a RNA one we can just replace the **T** base with **U** by using the program `sed`. The sintax of this program is the following ```s/<TO BE REPLACED>/<TO REPLACE>/```.

You can add a **g** at the end if you want to replace every character found ```s/<TO BE REPLACED>/<TO REPLACE>/g```.

```bash

sed s/T/U/g my_dna.txt > my_rna.txt

cat my_rna.txt

AUGUACUGACUGCAUGCAUGCCAUGCA
```


### Recap

* `touch` writes empty files 
* `mkdir` created empty directories
* `mv` move files (or directory) or change their name
* `ls` list files and directories
* `cp` copy files and directories
* `cd` change the directory
* `pwd` displays where you are
* `echo` print values to standard output
* `cat` print the content of a file to standard output
* `sed` replace a string with another

## Download files

Then we can go back to our command line and use the program `wget` to download that file and using CTRL+C to paste the address:

```bash
wget ftp://ftp.ensemblgenomes.org/pub/bacteria/release-42/fasta/bacteria_22_collection/escherichia_coli_bl21_gold_de3_plyss_ag_/dna/README
```

Define a specific filename.

```bash
wget -O my_readme.txt ftp://ftp.ensemblgenomes.org/pub/bacteria/release-42/fasta/bacteria_22_collection/escherichia_coli_bl21_gold_de3_plyss_ag_/dna/README
```

Capture log (stdout and stderr)

```bash
wget -O my_readme.txt ftp://ftp.ensemblgenomes.org/pub/bacteria/release-42/fasta/bacteria_22_collection/escherichia_coli_bl21_gold_de3_plyss_ag_/dna/README > wget.log 2>&1
```

A similar existing tool is `curl`:

```bash
curl -o my_readme.txt ftp://ftp.ensemblgenomes.org/pub/bacteria/release-42/fasta/bacteria_22_collection/escherichia_coli_bl21_gold_de3_plyss_ag_/dna/README > curl.log 2>&1
```

`curl` is more powerful and you can do more stuff than simply download files (e.g., test API services)

## Piping

![Standard Streams][stdstreams-image][^2]

[stdstreams-image]: ./images/Stdstreams.png

[^2]: [Source: Wikimedia Commons - Stdstreams](https://commons.wikimedia.org/wiki/File:Stdstreams-notitle.svg)


**Pipe stdout to another command:**
```
ls | grep ".txt"
```
Lists files, then filters for `.txt` files.


**Redirect stdout to a file (overwrite):**
```
echo "Hello" > output.txt
```

**Append stdout to a file:**
```
echo "World" >> output.txt
```

**Redirect stderr to a file:**
```
ls non_existing_file 2> error.log
```

**Redirect both stdout and stderr to a file:**
```
command > all_output.log 2>&1
```

## Common data formats

* more
* less
* tar
* gzip / bzip2
* zcat


TODO: Review what we have in the course


## Manipulate files, piping, parsing, reformatting

TODO: To be adapted to course

* grep
* cut
* head
* tail (tail -f)


## Running programs

Mention to PATH

```
echo $PATH
```


### Running containers

We will use already pre-made containers, so we will not need installing so many programs.

For executing the tools from the container images, we will use Apptainer/Singularity?

Why Apptainer/Singularity?

- Not as popular as Docker, but very convenient for Bioinformatics and HPC environments
    - You don't need to worry so much about different kind of UNIX permissions


```
singularity pull RNAseq_course.sif docker://community.wave.seqera.io/library/fastq-screen_fastqc_kraken_multiqc_pruned:c1cc2fe6e981fe2c

singularity exec -e RNAseq_course.sif fastqc --version

```

```
export RUN="singularity exec -e RNAseq_course.sif"
$RUN fastqc --version

```

Mention to `.bashrc`

