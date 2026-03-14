---
title: "R basics"
layout: page
navigation: 17
---

# Reviewing some R basics

In this section, we will review the RStudio/POSIT software usage, and the R basics.


## RStudio

What is RStudio?

* Free and open source IDE (Integrated Development Environment) for R
* Available for Windows, Mac OS and LINUX

<img title="rstudio logo" alt="RStudio logo" src="images/rstudio_logo.jpeg" width="100">
<img title="posit logo" alt="posit logo" src="images/posit_logo.png" width="190">


### Panels

When you open RStudio, you will see 3-4 panels:

* top-left: scripts and files
* bottom-left: R console Linux-line terminal / command-line
* top-right: environment, history, connections, tutorial
* bottom-right: tree of folders and files, plots/graphs window, packages, help window, viewer, presentation

<img title="panels" alt="panels" src="images/rstudio_panels.png" width="700">




### Shortcuts

RStudio provides a variety of [shortcuts](https://docs.posit.co/ide/user/ide/reference/shortcuts.html) to make user interaction smoother.

Examples:

* CTRL + ENTER to send the current row or a selected block of code to the console
* CTRL + 2 to move the cursor to the console


## R Basics

### Objects

What stores data - if any kind - in R is an **object**.


<img title="panels" alt="panels" src="images/R_basics_objects.png" width="280">

Assignment operators (how to assign data to the object)

*  **<-** or **=**
* Mostly the same but, to avoid confusions:
    + Use **<-** for assignments
    +  Keep **=** for functions arguments

Assigning a value to the object **B**: 

```{r}
B <- 10
```

Reassigning: modifying the content of an object:

```{r}
B + 10
```

<span style="color:red">**B unchanged !!**</span><br>
```{r}
B <- B + 10
```

<span style="color:red">**B changed !!**</span><br>

You can see the objects you created in the **environment** panel (upper right).


Note: Naming an object in R is flexible. You should nevertheless follow a few base rules:

* You can use:
  + Letters (note that object names case sensitive: A and a are NOT the same)
  + Numbers (exception: the object name cannot start with a number)
  + Underscores _
* You cannot use:
  + Spaces
  + Most special characters


### Data types and data structures

#### Data types

Each object has a data type:
* Numeric (number - integer or double)
* Character (text)
* Logical (TRUE / FALSE)
* Factors (categorical variables)

Numeric: numbers, floats

```{r}
number_object <- 10
mode(number_object)
typeof(number_object)
str(number_object)
```

Character: text, strings of characters

```{r}
text_object <- "word"
mode(text_object)
typeof(text_object)
str(text_object)
```

Logical: boolean values (TRUE or FALSE)


```{r}
logical_object <- TRUE
mode(logical_object)
typeof(logical_object)
str(logical_object)
```

Factor: used to work with categorical variables, for example, in statistical modeling or graphing.

Creating a factor starts by creating an object, that is then converted to a factor.

```{r}
factor_object <- factor(text_object)
mode(factor_object)
typeof(factor_object)
str(factor_object)
```


#### Data structures

The main data structures in R are:

* Vector
* Factor
* Matrix
* Data frame

##### Vectors

Vectors are one-dimensional and contain a single data type.

Create a numeric vector:

```{r}
a <- c(1, 2, 3, 4, 5)
# equivalent to:
a <- 1:5
```

Create a second numeric vector, and check with elements of that second vector are also present in **a** with operator **%in%**:

```{r}
b <- 3:8

b[b %in% a]
```
 
Check the length of (i.e. number of elements in) a vector:

```{r}
length(b)
```

##### Data frame

Data frames are two-dimensional and can contain several data types (column-wise).

Create a data frame:

```{r}
df <- data.frame(Name=c("Maria", "Juan", "Alba", "Enrique"), 
        Age=c(23, 25, 31, 28),
        Vegetarian=c(TRUE, TRUE, FALSE, FALSE))
```

Check dimensions (i.e. number of rows and number of columns) of a dataframe:

```{r}
# Number of rows
nrow(df)

# Number of columns
ncol(df)

# Dimensions (first element is the number of rows, second element is the number of columns)
dim(df)
```

You can extract columns of a data frame with:

* Slicing operator **[]**
  * Access using the column name: `df[,"Age"]`
  * Access using the column index (i.e. position): `df[,2]`
* Dollar sign **$**: `df$Age`

You can extract rows using the slicing operator: df[1,]

Select rows of the data frame **if the Age column is superior to 24**:

```{r}
d[d$Age > 24,]
```

Select rows of the data frame based on multiple conditions, for example, **if the Age column is superior to 24 AND if Vegetarian is TRUE** :

```{r}
d[d$Age > 24 & d$Vegetarian == TRUE,]
```

Table of logical operators that can be used for data selection and filtering:

| Operator    | Description |
| -------- | ------- |
| <  | less than |
| <= | less than or equal to |
| > | greater than |
| >= | greater than or equal to |
| == | exactly equal to |
| != | not equal to  |
| !x | not x |
| x\|y | x OR y |
| x&y | x AND y |


## Paths and directories

Show the path of the current directory (i.e. working directory) with <b>getwd</b> (get working directory):

```{r}      
getwd()
```

Change working directory with **setwd** (set working directory)<br>

Go to a directory giving the absolute path (note: **~** is a shortcut to your home directory): 

```{r}
setwd("~/rnaseq_course")
```

Go to a directory using the relative path:

```{r}
setwd("differential_expression")
```

You are now in: "~/rnaseq_course/differential_expression"
<br>
Move one directory "up" the tree:

```{r} 
setwd("..")
```

You are now in: "~/rnaseq_course"


## Missing values

**NA** (Not Available) is a recognized element in R.

Finding missing values in a vector:

```{r}
# Create vector
x <- c(4, 2, 7, NA)

# Find missing values in vector:
is.na(x)

# Remove missing values
na.omit(x)
x[ !is.na(x) ]
```

Some functions can deal with NAs, either by default, or with specific parameters:

```{r}
x <- c(4, 2, 7, NA)

# default arguments
mean(x)

# set na.rm=TRUE for the mean function to work properly
mean(x, na.rm=TRUE)
```

In a matrix or a data frame, you can keep only rows where there are no NA values:

```{r}
# Create matrix with some NA values
mydata <- matrix(c(1:10, NA, 12:2, NA, 15:20, NA), ncol=3)

# Keep only rows without NAs
mydata[complete.cases(mydata), ]
# or
na.omit(mydata)
```

<br>
Check this [R blogger post on missing/null values](https://www.r-bloggers.com/r-null-values-null-na-nan-inf/)


## Read in, write out

### On vectors

Read a file as a vector using **scan**:

```{r}
# Read in file
scan(file="file.txt")
# Save in  object
k <- scan(file="file.txt")
```

By default, the function scans for "double" (numeric) elements: it fails if the input contains characters.<br>

If reading non-numeric data, you need to specify the type of data contained in the file: 

```{r}
# specify the type of data to scan
scan(file="file.txt", 
        what="character")
scan(file="~/file.txt", 
        what="character")
```


If the file is not in the current directory, you can provide a full or relative path. 

For example, if the file is located in the home directory, read it as:

```{r}
scan(file="~/file.txt", 
        what="character")
```

Write the content of a vector in a file with **write**:

```{r}
# create a vector
mygenes <- c("SMAD4", "DKK1", "ASXL3", "ERG", "CKLF", "TIAM1", "VHL", "BTD", "EMP1", "MALL", "PAX3")

# write in a file
write(x=mygenes, 
        file="gene_list.txt")
```

Like when reading a file, you can also specify a full or relative path where to write down a file:

```{r}
# Write to home directory
write(x=mygenes,
        file="~/gene_list.txt")
        
# Write to one directory up
write(x=mygenes,
        file="../gene_list.txt")
```

### Data frames or matrices

Read in a file as a data frame with **read.table**:

```{r}
a <- read.table(file="file.txt")
```

You can convert it as a matrix, if needed, with:

```{r}
a <- as.matrix(read.table(file="file.txt"))
```

Write a data frame or matrix to a file with **write.table**:

```{r}
write.table(x=a,
        file="file.txt")
```

Useful arguments:

<img title="writetable" alt="writetable" src="images/writetable.png" width="550">

Note that "\t" stands for tab-delimitation; if reading a **.csv** file, you can change to **sep=","** (or use the dedicated write.scv function!).


## Install packages

### R base

A set a standard packages which are supplied with R by default.<br>
Example: package base (write, table, rownames functions), package utils (read.table, str functions), package stats (var, na.omit, median functions).

### R contrib

All other packages:

* [CRAN](https://cran.r-project.org): Comprehensive R Archive Network
  + 23422\* packages available
  + find packages in https://cran.r-project.org/web/packages/
  + <img src="images/cran_packages.png" width="550"/>
* [Bioconductor](https://www.bioconductor.org/):
  + 2361\* packages available
  + find packages in https://bioconductor.org/packages
  + <img src="images/bioc_packages.png" width="550"/>

\* As of March 2026


Install a CRAN package using **install.packages**:

```{r}
install.packages('BiocManager', repos = 'http://cran.us.r-project.org', dependencies = TRUE)
```

Install a Bioconductor package using **BiocManager::install**:

```{r}
library('BiocManager')
BiocManager::install('GOstats')
```

## Exercises to warm up!

* Ex1.
	* Create a numeric vector **y** containing numbers from 2 to 11 (both included). 
	* How many elements are in y?
	* Show the 3rd and the 6th elements of y.
	* Show all elements of y that have a value inferior to 7.

* Ex2.
	* Create the vector **x** of 1000 random numbers from the normal distribution (see **rnorm** function).
	* What are the mean, median, minimum and maximum values of x?

* Ex3.
	* Create vector **y2** as: y2 <- c(1, 11, 5, 62,  NA, 18, 2, 8, NA)
	* What is the sum of all elements in y2 ?
	* Which elements of y2 are also present in y?
	* Remove NA values from y2.

* Ex4. 
	* Create the following data frame:

|    | | |
| -------- | ------- | -------- |
| 43 | 181 | M |
| 34 | 172 | F |
| 22 | 189 | M |
| 27 | 167 | F |

with :

* row names: **John, Jessica, Steve, Rachel**
* column names: **Age, Height, Sex**.

Then:

* Check the structure of df with str().
* Calculate the average age and height in df.
* Change the row names of df so the data becomes anonymous
  + Use for example Patient1, Patient2, etc.
* Write **df** to the file **mydf.txt** with **write.table()**. 
  + Explore parameters **sep**, **row.names**, **col.names**, **quote**.

<br>

**CORRECTION**

```{r}


* Ex1.
	* Create a numeric vector **y** containing numbers from 2 to 11 (both included). 

y <- 2:11 
# same as or y <- c(2, 3, 4, 5, 6, 7, 8, 9, 10, 11)

	* How many elements are in y?

length(y)

	* Show the 3rd and the 6th elements of y.

y[c(3,6)]

	* Show all elements of y that have a value inferior to 7.

y[y < 7]


* Ex2.
	* Create the vector **x** of 1000 random numbers from the normal distribution (see **rnorm** function).

x <- rnorm(1000)

	* What are the mean, median, minimum and maximum values of x?

mean(x); median(x); min(x); max(x)
# or more straightforward:
summary(x)


* Ex3.
	* Create vector **y2** as: y2 <- c(1, 11, 5, 62,  NA, 18, 2, 8, NA)
	* What is the sum of all elements in y2 ?
	
sum(y2, na.rm = TRUE)

	* Which elements of y2 are also present in y?

y2[y2 %in% y]

	* Remove NA values from y2.

y2 <- na.omit(y2)


* Ex4. 
	* Create the following data frame wih 
  * row names: **John, Jessica, Steve, Rachel**
  * column names: **Age, Height, Sex**.
  
df <- data.frame(Age=c(43, 34, 22, 27),
                 Height=c(181, 172, 189, 167),
                 Sex=c("M", "F", "M", "F"),
                 row.names = c("John", "Jessica", "Steve", "Rachel"))

* Check the structure of df with str().

str(df)

* Calculate the average age and height in df.

mean(df$Age) # same as mean(df[,"Age"])

mean(df$Height) # same as mean(df[,"Height"])

* Change the row names of df so the data becomes anonymous
  + Use for example Patient1, Patient2, etc.

rownames(df) <- c("Patient1", "Patient2", "Patient3", "Patient4")

* Write **df** to the file **mydf.txt** with **write.table()**. 
  + Explore parameters **sep**, **row.names**, **col.names**, **quote**.

write.table(df,
            "mydf.txt",
            sep="\t",
            row.names = TRUE,
            col.names = NA,
            quote = FALSE)
            
```
