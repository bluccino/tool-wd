#!/bin/bash
# wd.sh - change working directory

   if [ "$*" == "-?" ] || [ "$*" == "--help" ]; then
      ec -g "usage: change working directory (version `wd.sh --version`)"
      echo  '  wd <topic>          # work with environment'
      echo  '  wd                  # cd $WORKDIR'
      echo  '  wd .                # set WORKDIR=`pwd`'
      echo  '  wd ..               # cd to parent directory and wd .'
      echo  '  wd ...              # cd to git home directory'
      echo  '  wd <n>              # cd to child or sibling folder <n>-...'
      echo  '  wd -l               # list wd labels'
      echo  '  wd -! lab: info     # define label for current directory'
      echo  '  wd -?               # show usage'
      echo  '  wd --help           # comprehensive help'
      echo  '  wd --version        # print version'
      echo  ''
      ec -g 'multiple args:'
      echo  '  wd 1 5              # change to 01-*/05-*'
      echo  '  wd .. ..            # change to ../..'
      echo  '  wd ... lessons      # change to lessons in repo home directory'

      if [ "$*" == "--help" ]; then
         echo ''
         ec -g 'define label:'
         echo "  wd -! lab: 'abc project'  # define label for current directory"
         echo "  wd -! lab: 'abc project' <dir>  # define label for directory <dir>"
         echo "  wd -! pd:  'picolo develop repo' ~/Git/Picolo/picolo-develop"
         echo "  wd -! pl:  'picolo lessons' ~/Git/Picolo/picolo-develop/lessons"
         echo "  wd -! bin: 'local binary directory' ~/bin"
      fi
      return 0 2>/dev/null || exit 0  # safe return/exit
   fi

#===============================================================================
# print version: gis --version
#===============================================================================

   if [ "$*" == "--version" ] || [ "$*" == "--v" ]; then
      echo "1.0.14a"
      return 0 2>/dev/null || exit 0  # safe return/exit
   fi

#===============================================================================
# check for 2-digit arg
#===============================================================================

   _DIGITS='0 1 2 3 4 5 6 7 8 9'
   _PREFIX=''
   for _DIGIT in $_DIGITS
   do
      if [ "$1" == "$_DIGIT" ]; then
         _PREFIX=0
      fi
   done

   _DIGITS=''
   _DIGITS=$_DIGITS' 00 01 02 03 04 05 06 07 08 09'
   _DIGITS=$_DIGITS' 10 11 12 13 14 15 16 17 18 19'
   _DIGITS=$_DIGITS' 20 21 22 23 24 25 26 27 28 29'
   _DIGITS=$_DIGITS' 30 31 32 33 34 35 36 37 38 39'
   _DIGITS=$_DIGITS' 40 41 42 43 44 45 46 47 48 49'
   _DIGITS=$_DIGITS' 50 51 52 53 54 55 56 57 58 59'
   _DIGITS=$_DIGITS' 60 61 62 63 64 65 66 67 68 69'
   _DIGITS=$_DIGITS' 70 71 72 73 74 75 76 77 78 79'
   _DIGITS=$_DIGITS' 80 81 82 83 84 85 86 87 88 89'
   _DIGITS=$_DIGITS' 90 91 92 93 94 95 96 97 98 99'

   if [ -d $_PREFIX$1-* ]; then
      ec -g $_PREFIX$1-*
      cd $_PREFIX$1-*
      source wd.sh `pwd`

      shift
      if [ "$*" != "" ]; then  # repeat recursively ?
         source wd.sh $*
      fi

		  unset _DIGITS
		  unset _DIGIT
		  unset _PREFIX
      return 0 2>/dev/null || exit 0  # safe return/exit
   else
      for _DIGIT in $_DIGITS
      do
         if [ "$_PREFIX$1" == "$_DIGIT" ]; then
            cd ../$_DIGIT-*
            source wd.sh `pwd`

					  unset _DIGITS
					  unset _DIGIT
					  unset _PREFIX
            return 0 2>/dev/null || exit 0  # safe return/exit
         fi
      done
   fi

   unset _DIGITS
   unset _DIGIT
   unset _PREFIX
#===============================================================================
# wd . (set WORKDIR environment variable to match current directory)
#===============================================================================

   if [ "$*" == "." ]; then
      WORKDIR=`pwd`
      ec -g "change working directory: $WORKDIR"
      ec -y "working in: `pwd`"
      ls
      return 0 2>/dev/null || exit 0  # safe return/exit
   fi

#===============================================================================
# cd to parent directory: wd ..
#===============================================================================

   if [ "$*" == ".." ]; then
      cd ..
      wd `pwd`
      return 0 2>/dev/null || exit 0  # safe return/exit
   fi

#===============================================================================
# cd to git home directory: wd ..
#===============================================================================

   if [ "$1" == "..." ]; then
      cd `gih`
      ec -y "working in: `pwd`"
      ls

      shift
      if [ "$*" != "" ]; then
        source wd.sh $*
      fi
      return 0 2>/dev/null || exit 0  # safe return/exit
   fi

#===============================================================================
# wd       # wd command without args (cd to $WORKDIR)
#===============================================================================

   if [ "$*" == "" ]; then
      cd $WORKDIR
      ec -y "working in: `pwd`"
      ls
      return 0 2>/dev/null || exit 0  # safe return/exit
   fi

#===============================================================================
# wd $* (set WORKDIR environment variable to match existing directory)
#===============================================================================

#  if [ -d "$1" ] && [ "$1" != "." ] && [ "$1" != ".." ]; then
   if [ -d "$1" ]; then
      if [ ! -d "$1" ]; then
         ec -r "wd: no directory: $1"
         return 0 2>/dev/null || exit 0  # safe return/exit
      fi

      cd "$1"

      shift
      if [ "$*" != "" ]; then
         source wd.sh $*
      else
         #WORKDIR=`pwd`
         #ec -y "current working directory: $WORKDIR"
         ec -y "working in: `pwd`"
         ls
      fi

      return 0 2>/dev/null || exit 0  # safe return/exit
   fi

#===============================================================================
# wd lab:   # change to labeled directory
#===============================================================================
   _LABEL=${1%":"}

   if [ "$1" != "$_LABEL" ]; then
      _DIR=`idb -r $ETC/workdir $_LABEL dir`

      if [ "$_DIR" != "" ]; then
         #ec -g "good directory: $_DIR"
         source wd.sh $_DIR
      else
         ec -r "unknown label: wd $*"
         bash wd.sh -?
         return 1 2>/dev/null || exit 1  # safe return/exit
      fi
      unset _DIR
      unset _LABEL
      return 0 2>/dev/null || exit 0  # safe return/exit
   fi

   unset  _LABEL
#===============================================================================
# wd -! <label> <info> <dir>
#===============================================================================

	if [ "$1" == "-!" ] && [ "$2" != "" ] && [ "$3" != "" ] \
                      && [ "$5" == "" ]; then
     if [ "$ETC" == "" ]; then
        ec -r "cannot add workdir label: wd $*"
        echo  '  environment variable ETC is not defined'
        echo  '  suggestion: $ export ETC=~/etc   # or something similar'
        return 0 2>/dev/null || exit 0  # safe return/exit
     fi

     if [ ! -d "$ETC" ]; then
        ec -r "no directory: ETC=$ETC"
        return 0 2>/dev/null || exit 0  # safe return/exit
     fi

     _IDB=$ETC/workdir
     if [ ! -d $_IDB ]; then
        idb -c $_IDB      # create workdir info database
     fi

     _LABEL=${2%":"}      # strip off ':'
     if [ "$_LABEL" == "$2" ]; then    # missing colon at end?
       ec -r "missing ':' at end of label: wd $*"
       echo "  => try: wd -! $2: '$3' $4"
     else  # all good => define label in info database
		     idb -s $_IDB "$_LABEL" info "$3"
		     if [ "$4" == "" ]; then          # current directory
		        idb -s $_IDB "$_LABEL" dir `pwd`
		     else                             # given directory by $4
		        idb -s $_IDB "$_LABEL" dir "$4"
		     fi
     fi

     unset _IDB
     unset _LABEL
     unset _IDB
     return 0 2>/dev/null || exit 0  # safe return/exit
  fi

#===============================================================================
# wd ---list-idb  # list labels of workdir info database
#===============================================================================

	if [ "$*" == "-l" ] || [ "$*" == "---list-idb" ]; then
     if [ "$ETC" == "" ]; then
        ec -r "cannot access workdir database: wd $*"
        echo  '  environment variable ETC is not defined'
        return 0 2>/dev/null || exit 0  # safe return/exit
     fi

     if [ ! -d "$ETC" ]; then
        ec -r "no directory: ETC=$ETC"
        return 0 2>/dev/null || exit 0  # safe return/exit
     fi

     ec -g 'wd labels:'
     _IDB=$ETC/workdir
     for _KEY in `ls $_IDB`
     do
        _INFO=`idb -r $_IDB $_KEY info`
        _DIR=`idb -r $_IDB $_KEY dir`

        echo "  $_KEY: $_INFO   ($_DIR)"
     done

     unset _KEY
     unset _INFO
     unset _DIR
     unset _IDB
     return 0 2>/dev/null || exit 0  # safe return/exit
  fi

#===============================================================================
# Is there more to do?
# - usage: wd .. ..
#          wd 1 5     # change to 01-.../05-...
#===============================================================================

	if [ "$2" != "" ]; then
     shift
     source wd.sh $*  # continue processing
     return 0 2>/dev/null || exit 0  # safe return/exit
  fi

#===============================================================================
# cannot deal with anything else ...
#===============================================================================

   ec -r "bad command: wd $*"
   source wd.sh -?
   return 1 2>/dev/null || exit 1  # safe return/exit
