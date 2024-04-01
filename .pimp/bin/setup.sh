#!/bin/bash
# setup (setup script for virtual environment)

echo '=== setup virtual environment ...'

alias ve='source pimp --activate'
alias de=deactivate
alias clean='source clean.sh'
alias ?="bash `pimp --venv`/bin/help"

   # setup wd alias and WORKIDB

if [ "`type -t wd`" == "alias" ]; then  # if alias wd already existing
   RESTORE_WD=`alias wd`                # then prepare restore cmd for cleanup
else                                    # else alias wd does not exist
   RESTORE_WD='unalias wd'              # => restore cmd is just to unalias
fi
alias wd="source wd.sh"                 # define/redefine wd alias

OLD_WORKIDB=$WORKIDB
WORKIDB=$VIRTUAL_ENV/etc

   # setup complete - give hint on help

ec -g 'type ? for help on virtual environment commands'
