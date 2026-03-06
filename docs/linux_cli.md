# Linux CLI refresher

## Filesystem structure. Linux and Mac

TODO: To place image here


## Create directory and practice moving around

To create file and folders in linux is quite simple. You can use a number of programs for creating an empty file (**touch**) or an empty directory (**mkdir**)

```{bash}
touch my_beautiful_file.txt
mkdir my_beautiful_folder
```

To display the list of files and folder we can use the command **ls**

```{bash}
ls

my_beautiful_file.txt  my_beautiful_folder
```

To change the name of a file (or a directory) you can use the command **mv** while for copying the file you can use **cp**. Adding the option **-r** (recursive) to **cp** allows to copy a whole folder and its content. 

```{bash}
mv my_beautiful_file.txt my_ugly_file.txt
mv my_beautiful_folder my_ugly_folder

cp my_ugly_file.txt my_beautiful_file.txt
cp my_ugly_folder -r my_beautiful_folder
```
If you omit the **-r** option the system will complain

```{bash}
cp my_ugly_folder my_other_folder

cp: omitting directory ‘my_ugly_folder’
```

You can use **mv** also for moving a file (or a directory) inside a folder. Also **cp** will allow you to make a copy inside a folder.

```{bash}
mv my_beautiful_file.txt my_beautiful_folder
cp my_ugly_file.txt my_ugly_folder

ls

my_beautiful_folder  my_ugly_file.txt  my_ugly_folder
```

For entering in a folder we can use the tool **cd**

```{bash}
cd my_ugly_folder

ls

my_ugly_file.txt
```

For going out we can move one level out 
```{bash}
cd ../

ls

my_beautiful_folder  my_ugly_file.txt  my_ugly_folder
```

Sometimes we get lost and would like to know where we are. We can use the command **pwd**

<img src="pics/lost.jpg" width="400"/>

We can write to a file using the character **>**, that means output redirection.

```{bash}
echo "ATGTACTGACTGCATGCATGCCATGCA" > my_dna.txt
```

And display the content of the file using the program **cat**

```{bash}
cat my_dna.txt

ATGTACTGACTGCATGCATGCCATGCA
```

To convert this sequence to a RNA one we can just replace the **T** base with **U** by using the program **sed**. The sintax of this program is the following ```s/<TO BE REPLACED>/<TO REPLACE>/```.
<br>You can add a **g** at the end if you want to replace every character found ```s/<TO BE REPLACED>/<TO REPLACE>/g```.

```{bash}

sed s/T/U/g my_dna.txt > my_rna.txt

cat my_rna.txt

AUGUACUGACUGCAUGCAUGCCAUGCA
```


### Recap

* **touch** writes empty files 
* **mkdir** created empty directories
* **mv** move files (or directory) or change their name
* **ls** list files and directories
* **cp** copy files and directories
* **cd** change the directory
* **pwd** displays where you are
* **echo** print values to standard output
* **cat** print the content of a file to standard output
* **sed** replace a string with another

## Download files


TODO: To be adapted to course

Then we can go back to our command line and use the program wget to download that file and using CTRL+C to paste the address:

```
wget ftp://ftp.ensemblgenomes.org/pub/bacteria/release-42/fasta/bacteria_22_collection/escherichia_coli_bl21_gold_de3_plyss_ag_/dna/README
```

Mention curl here

* more
* less
* tar
* gzip / bzip2
* zcat

## Manipulate files, piping, parsing, reformatting

TODO: To be adapted to course

* grep
* cut
* head
* tail (tail -f)


## Mention about the formats

TODO: Review what we have in the course

## Running programs

Mention to PATH


### Running containers

We will use already pre-made containers with Apptainer.

Why Apptainer/Singularity?

- Not as popular as Docker, but very convenient for Bioinformatics
    - You don't need to worry about different kind of permissions


```
apptainer pull ...

apptainer exec -e ...

```
