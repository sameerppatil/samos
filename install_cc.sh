#!/bin/bash
# This script installs Cross compiler for i686 platform
#
#

dependency_list=(   "libgmp3-dev"
                    "libmpfr-dev"
                    "libcloog-isl-dev"
                    "libmpc-dev"
                    "texinfo"
                    "libisl-dev")

function join_by { local IFS="$1"; shift; echo "$*"; }

function install_dependency()
{
    echo -e "\n"
    echo "This program is going to install following dependencies:"
    join_by ",  " ${dependency_list[@]}
    echo -e " "
    # read -r -p "Please press Yes(y) if you wish to continue." response
    read -r -p "${1:-Please press Yes(y) if you wish to continue.} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            echo "Continuing process"
            ;;
        *)
            echo "Aborting process!"
            return
            ;;
    esac
}

REPO_DIR=$(pwd)

export PREFIX="$REPO_DIR/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

echo $PATH
echo $PREFIX

install_dependency

