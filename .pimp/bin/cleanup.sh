#!/bin/bash
# cleanup (cleanup script for virtual environment)

echo '=== cleanup virtual environment ...'

eval $RESTORE_WD   # restore previous wd alias
WORKIDB=$OLD_WORKIDB

unalias clean
unalias ?
