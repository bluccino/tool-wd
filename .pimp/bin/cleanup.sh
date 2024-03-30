#!/bin/bash
# cleanup (cleanup script for virtual environment)

echo '=== cleanup virtual environment ...'
unalias wd
unalias de
#unalias ve  # intentionally commented
unalias clean
unalias ?

WORKIDB=$OLD_WORKIDB
