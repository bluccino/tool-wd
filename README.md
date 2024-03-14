![Working Directory](etc/working-directory.jpg)

# Working Direcory

`wd` (working directory) is a `bash` based tool to change/manage working directories.

* verbose navigation through file tree
* path and directory contents
* memorizing the current directory as current working directory
* change directory to current working directory
* recognize number arguments as directory number prefixes
* recognize `...` as the `git` home directory
* memorize current working directory by custom label
* list custom labels
* change current directory to labeled working directory


# Pre-Requisites

The only pre-requisites for installing and running `wd` is a `bash` (shell) environment, as it is standard on Linux, Mac-OS and Windows/WSL platforms. 

Installation can bedone by downloading and unzipping a git repository
and following the instructions in the next section. `git` is no absolute requirement, but helpful when cloning the installation repository, and necessary if all steps of the tutorial want to be followed.

`wd` depends on two other (non-standard) shell scripts, `ec` (echo colored text) and `idb` (info database), which are automatically installed during the installation process of `wd`.



# Installation

## Step 1: Download/Clone `tool-wd` Repository

From a github host (e.g. `https://github.com/bluccino`)
either download load the repository `tool-wd` or use `git` to clone.

```
    ... $ git clone https://github.com/bluccino/tool-wd.git
``` 

## Step 2: Download/Clone `tool-wd` Repository

In the repository's root directory source script `bin/install` by passing argument `<bin>` as the path of the installation directory.

```
    ... $ cd tool-wd
    tool-wd $ source bin/install <bin>
```

This installation procedure creates a local virtual environment `@tool-wd` with temporary tools like `pimp` and `west` in order to pull the right dependencies from github and to perform the installation. 

## Step 3: Define a `wd` Alias 

The workhorse of tool `wd` is the `bash` script `wd.sh` which always needs to be sourced (with either `source wd.sh ...`or `. wd.sh ...`). To deal with the cute shorthand `wd` an alias definition

```
    $ alias wd='source wd.sh'
```

is required. This alias is defined as part of the installation process,
but will be forgotten when the `bash` shell is closed. Thus, the suggestion is to add the alias definition in a `bash` startup script.


# Tutorial

## Creating a Playground

Create a git repository `sample-tree` with two subfolders `01-pico` and
`02-ble`.

```
    ... $ mkdir path-to/sample-tree
    ... $ cd path-to/sample-tree
    sample-tree $ git init          # init a git repository
    Initialized empty Git repository in ...
    sample-tree $ mkdir 01-pico 02-ble
```

## Verbose Navigation

Let us visit subfolder `01-pico` utilizing the navigation function of `wd`. The syntax is the same as for the `cd` (change directory) command.
The difference is that `wd` additionaly prints the working directory and list the file in the new current directory (which in our case is empty).

```
    sample-tree $ wd 01-pico    # use 'wd' to navigate
    working in: .../sample-tree/01-pico
```

Inside of folders `01-pico` we create other child folders with empty
dummy files.

```
    01-pico $ mkdir 01-hello 02-log 03-blink 04-button 05-pico
    01-pico $ for F in `ls`; do touch $F/$F.dummy; done
```

Let us navigate up one level in the file tree. Again `wd` shows us the path of the current directory, as well as the current directory's contents. 

```
    01-pico $ wd ..            # use 'wd' to navigate up
    working in: .../sample/sample-tree
    01-pico	02-ble
    sample-tree $
```

So we have two possibilities of navigation through the file tree.

~~~
    1) using `cd` for silent navigation
    2) using `wd` for verbose navigation 
~~~

## Recognize Number Arguments as Directory Number Prefixes

Let us also create sample folders for the `02-ble` directory. When
we change the directory to `02-ble` we use the short form `wd 2`, where `wd` recognizes argument `2` as directory number prefix `02-*` (or `2-*`).  

```
    sample-tree $ wd 2    # navigate by using number prefix for directory
```



```
    
    01-pico $ tree --dirsfirst -a -L 2 
```







```
    # use 'wd' to navigate    
    02-ble $ mkdir 01-adv 02-scan 03-gatt
    02-ble $ for F in `ls`; do touch $F/$F.dummy; done
``` 

This is what we got so far:

```
```


