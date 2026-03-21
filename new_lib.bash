#!/usr/bin/env bash
# This is a lib file for new_lib. Put any functions that you want to use in the tool script here.


## SOURCE GUARD DO NOT REMOVE new_lib.bash -----------------------------------------
if [[ -v new_lib_lib_sourced ]]; then
    return 0
fi
new_lib_lib_sourced=1
## --------------------------------------------------------------------------------------

new_lib_lib_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

