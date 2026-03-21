#!/usr/bin/env bash
# This is a lib file for create. Put any functions that you want to use in the tool script here.


## SOURCE GUARD DO NOT REMOVE create.bash -----------------------------------------
if [[ -v create_lib_sourced ]]; then
    return 0
fi
create_lib_sourced=1
## --------------------------------------------------------------------------------------

create_lib_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

