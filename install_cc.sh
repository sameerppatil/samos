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
# ftp://ftp.gnu.org/gnu/binutils/binutils-2.30.tar.gz
# ftp://ftp.gnu.org/gnu/gcc/gcc-8.1.0/gcc-8.1.0.tar.gz
REPO_DIR=$(pwd)
EXTERNAL_TOOLS_DIR="$REPO_DIR/tools/external_tools_src"
LOCAL_TOOLS_DIR="$REPO_DIR/tools/local"

dependency_list=(   "libgmp3-dev"
                    "libmpfr-dev"
                    "libcloog-isl-dev"
                    "libmpc-dev"
                    "texinfo"
                    "libisl-dev")

tar_file_list=("binutils-2.30.tar.gz"
                "gcc-8.1.0.tar.gz")

function join_by { local IFS="$1"; shift; echo "$*"; }

function install_dependency()
{
    echo -e "\n"
    echo "This program is going to install following dependencies:"
    join_by ",  " ${dependency_list[@]}
    echo -e " "
    read -r -p "${1:-Please press Yes(y) if you wish to continue, s for skip, a for abort:} " response
    case "$response" in
        y|Y )
            echo "Continuing process"
            payload=$(join_by " " ${dependency_list[@]})
            cmd="sudo apt-get install -y ${payload}"
            echo "${cmd}"
            OUTPUT=$(${cmd})
            ret=$?
            CheckError ${FUNCNAME} 1
            ;;
        s|S )
            echo "Skipping installation"
            return 0
            ;;
        *)
            echo "Aborting process!"
            return 1
            ;;
    esac
}

function CheckError()
{
    func_name=${1}
    retval=${2}

    if [ "$retval" -ne "0" ];
    then
        echo "${func_name}() returned ${retval}, aborting!"
        exit
    fi
}

function extract_tar_file()
{
    pushd ${EXTERNAL_TOOLS_DIR}

    file_name=${1}
    cmd="tar -xf ${file_name} -C ${LOCAL_TOOLS_DIR} --skip-old-files"
    echo "${cmd}"
    OUTPUT=$(${cmd})
    ret=$?
    CheckError ${FUNCNAME} ${ret}
    popd
}

function extract_all_files()
{
    pushd ${EXTERNAL_TOOLS_DIR}
    for f in "${tar_file_list[@]}"
    do
        extract_tar_file ${f}
    done
    popd
}

function install_binutils()
{
    pushd $LOCAL_TOOLS_DIR
    mkdir build-binutils
    cd build-binutils
    ../binutils-2.30/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
    make
    make install
    popd
}

function install_gcc()
{
    pushd $LOCAL_TOOLS_DIR
    mkdir build-gcc
    cd build-gcc
    ../gcc-8.1.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
    make all-gcc
    make all-target-libgcc
    make install-gcc
    make install-target-libgcc
    popd
}

function download_tar_files()
{
    wget -nc ftp://ftp.gnu.org/gnu/gcc/gcc-8.1.0/gcc-8.1.0.tar.gz -P ${EXTERNAL_TOOLS_DIR}
    wget -nc ftp://ftp.gnu.org/gnu/binutils/binutils-2.30.tar.gz -P ${EXTERNAL_TOOLS_DIR}
}

export PREFIX="$LOCAL_TOOLS_DIR/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

echo $PATH
echo $PREFIX

mkdir -p "${LOCAL_TOOLS_DIR}"
mkdir -p "${EXTERNAL_TOOLS_DIR}"

download_tar_files
ret=$?
CheckError "download_tar_files" "${ret}"

install_dependency
ret=$?
CheckError "install_dependency" "${ret}"

extract_all_files
ret=$?
CheckError "extract_all_files" "${ret}"

install_binutils
ret=$?
CheckError "install_binutils" "${ret}"

install_gcc
ret=$?
CheckError "install_gcc" "${ret}"


