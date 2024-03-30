#!/bin/bash
# setup (setup script for virtual environment)

echo '=== setup virtual environment ...'
alias wd="source $VIRTUAL_ENV/bin/wd.sh"
alias ve='source pimp --activate'
alias de=deactivate
alias clean='source clean.sh'
alias ?="bash `pimp --venv`/bin/help"

OLD_WORKIDB=$WORKIDB
WORKIDB=$VIRTUAL_ENV/etc

ec -g 'type ? for help on virtual environment commands'
