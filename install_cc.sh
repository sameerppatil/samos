#!/bin/bash
# This script installs Cross compiler for i686 platform
#
#
#
# TODO: Make this script more robust, and does following
# TODO: apt-gets dependencies, extracts tar files,
# installs them.
# Better approach would be make this code (and its dependent tar files) as
# separate repo.

EXTERNAL_TOOLS_DIR="tools/external_tools_src"

dependency_list=(   "libgmp3-dev"
                    "libmpfr-dev"
                    "libcloog-isl-dev"
                    "libmpc-dev"
                    "texinfo"
                    "libisl-dev")

tar_file_list=("binutils-2.29.1.tar.gz"
                "gcc-7.2.0.tar.gz")

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

function CheckError()
{
    func_name=${1}
    retval=${2}

    if [ "$retval" -ne "0" ];
    then
        echo "${func_name} returned ${retval}, aborting!"
        exit
    fi
}

function extract_tar_file()
{
    pushd ${EXTERNAL_TOOLS_DIR}

    file_name=${1}
    cmd="tar -xf ${file_name}"
    # echo "${cmd}"
    OUTPUT=$(${cmd})
    ret=$?
    CheckError ${FUNCNAME} 1
    popd
}

function install_external_tools()
{
    for f in "${tar_file_list[@]}"
    do
        extract_tar_file ${f}
    done
}

REPO_DIR=$(pwd)

export PREFIX="$REPO_DIR/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

echo $PATH
echo $PREFIX

install_dependency

install_external_tools
