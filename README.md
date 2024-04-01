![Working Directory](etc/working-directory.jpg)

# Working Direcory

`wd` (working directory) is a `bash` based tool to change/manage working directories.

* verbose navigation through file tree
* recognize number arguments as directory number prefixes
* memorize current directory as current working directory
* navigate to current working directory
* navigate to git home directory
* memorize current working directory by custom label
* list custom labels
* navigate to labeled directory
* consecutive operations


# Pre-Requisites

The only pre-requisite to install and run `wd` is a `bash` (shell) environment, as it is standard on Linux, Mac-OS and Windows/WSL platforms.

Installation can be done by downloading and unzipping a git repository
and following the instructions in the next section. `git` is no absolute requirement, but helpful when cloning the installation repository, and necessary if all steps of the tutorial are intented to be followed.

`wd` depends on two other (non-standard) shell scripts, `ec` (echo colored text) and `idb` (info database), which are automatically installed during the installation process of `wd`.



# Installation

## Step 1: Download/Clone `tool-wd` Repository

From a github host (e.g. `https://github.com/bluccino`)
either download load the repository `tool-wd` or use `git` to clone.

```
    path-to $ git clone https://github.com/bluccino/tool-wd.git
```

## Step 2: Install `wd`

In the repository's root directory source script `bin/install` by passing argument `<bin>` as the path of the installation directory.

```
    path-to $ cd tool-wd
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

Inside of folders `01-pico` we create five child folders with empty
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
    NOTE:
       1) using `cd` for silent navigation
       2) using `wd` for verbose navigation
~~~

## Recognize Number Arguments as Directory Number Prefixes

Let us also create sample folders for the `02-ble` directory. When
we change the directory to `02-ble` we use the short form `wd 2`, where `wd` recognizes argument `2` as directory number prefix `02-*` (or `2-*`).  
Inside of `02-ble` we create three subfolders, each containing a dummy file.

```
    sample-tree $ wd 2    # navigate by using number prefix of directory
    working in: .../sample-tree/02-ble
    02-ble $ mkdir 01-adv 02-scan 03-gatt
    02-ble $ for F in `ls`; do touch $F/$F.dummy; done
```

Now change the directory to subfolder `03-gatt`.

```
    02-ble $ wd 3    # navigate by using number prefix of directory
    working in: .../sample-tree/02-ble/03-gatt
    03-gatt.dummy
```

Let's do a trial and invoke `wd 1`:

```
    03-gatt $ wd 1    # just a trial
    working in: .../sample-tree/02-ble/01-adv
    01-adv.dummy
```

Obviously we navigate now to sibling folder 01-adv, since the current directory has no subfolder `01-*`. This allows to navigate easily to the other two sibling folders.

```
    01-adv $ wd 2    # navigate to sibling folder
    working in: .../sample-tree/02-ble/02-scan
    02-scan.dummy
    02-scan $ wd 3    # navigate to sibling folder
    working in: .../sample-tree/02-ble/03-gatt
    03-gatt.dummy
```

Thus, we summarize the notable observation:    

~~~
    NOTE:
       1) If the current directory has a child directory with prefix
          '<n>.*' or '0<n>-*' then command 'wd <n>' will navigate to
          this child directory.  
       2) If the current directory has no child directory with prefix
          '<n>.*' or '0<n>-*' then command 'wd <n>' will navigate to
          the sibling directory with related number prefix.
~~~


## Memorize Current Directory as Current Working Directory    

Command `wd .` memorizes the current directory as current working directory.

```
   03-gatt $ wd .     # memorize current dir as current working dir
   change working directory: .../sample-tree/02-ble/03-gatt
   working in: .../sample-tree/02-ble/03-gatt
   03-gatt.dummy
```


## Navigate to Current Working Directory

Command `wd` (without arguments) navigates to (memorized)
current working directory.

```
   03-gatt $ wd 1    # navigate to sibling dir 01-*
   working in: .../sample-tree/02-ble/01-adv
   01-adv.dummy
   01-adv $ wd       # change to current working directory
   working in: .../sample-tree/02-ble/03-gatt
   03-gatt.dummy
```


## Navigate to Git Home Directory

Command `wd ...` navigates to git home directory (which is recognized
by containing the (hidden) subfolder `.git`.

```
    03-gatt $ wd ...    # navigate to git home directory
    working in: .../sample-tree
    01-pico	02-ble
```    

Let us recap the file tree we are dealing with.

```    
    sample-tree $ tree --dirsfirst -a -L 2
    .
    ├── .git
    │   ├── hooks
    │   ├── info
    │   ├── logs
    │   ├── objects
    │   ├── refs
    │   ├── COMMIT_EDITMSG
    │   ├── HEAD
    │   ├── config
    │   ├── description
    │   └── index
    ├── 01-pico
    │   ├── 01-hello
    │   ├── 02-log
    │   ├── 03-blink
    │   ├── 04-button
    │   └── 05-pico
    └── 02-ble
        ├── 01-adv
        ├── 02-scan
        └── 03-gatt
```


## Memorize Current Working Directory by Custom Label

Assume, we want to provide labels `blink:`, `  for folders `01-pico/03-blink` and
`02-ble/02-scan`. By applying multiple arguments, `wd` performs consecutive operations.

```    
    sample-tree $ wd 1 3
    working in: .../sample-tree/01-pico
    01-hello   02-log   03-blink   04-butto   05-pico
    working in: .../sample-tree/01-pico/03-blink
    03-blink.dummy    
```

We will define now label `blink:` for directory `01-pico/03-blink'.

```
    03-blink $ wd -! blink: 'sample 01-pico/03-blink'
```
For definition of the second folder we navigate to folder `02-ble/02-scan'
with `wd ... 2 2`.

```
    03-blink $ wd ... 2 2
    working in: .../sample-tree
    01-pico   02-ble
    working in: .../sample-tree/02-ble
    01-adv    02-scan    03-gatt
    working in: .../sample-tree/02-ble/02-scan
    02-scan.dummy
```

Now we can define a second label `scan:` for directory `02-ble/02-scan'.

```
    02-scan $ wd -! scan: 'sample 02-ble/02-scan'
```


## List Custom Labels

Use command `wd -l` to see all defined (custom) labels.

```
    02-scan $ wd -l
    wd labels:
      blink: sample 01-pico/03-blink    (.../sample-tree/01-pico/03-blink)
      scan: sample 02-ble/02-scan       (.../sample-tree/02-ble/02-scan)
```

## Navigate to Labeled Directory

With labels defined we can easily navigate between labeld directories, the  git home folder or the current working directory.

```
    02-scan $ wd blink:
    working in: .../sample-tree/01-pico/03-blink
    03-blink.dummy
    03-blink $ wd scan:
    working in: .../sample-tree/02-ble/02-scan
    02-scan.dummy
    02-scan $ wd ...     # navigate to git home dir
    working in: .../sample-tree
    01-pico    02-ble
    sample-tree $ wd     # navigate to current working directory
    working in: .../sample-tree/02-ble/03-gatt
    03-gatt.dummy
    03-gatt $
```

# Conclusions

* The `bash` based tool `wd` allows verbose navigation through the file tree, similar to the `cd` command, which navigates silently.
* If directories are prefixed with numbers followed by a hyphen (e.g.,
  `3-*` or `05-*` then such directories can be short-addressed by numbers.
* `wd` provides options to memorize a current working directory (`wd .`) and to change back to the current working directory (`wd`).
* `wd` provides possibilities to define labeled directories (`wd -! <lab>: ...`) and to navigate to labeled directories (`wd <lab>:`).
* There is a short form (`wd ...`) to navigate to the git home folder
* Finally, providing multiple arguments causes `wd` to perform consecutive operations.
