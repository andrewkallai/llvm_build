#!/bin/sh

#BUILD SCRIPT FOR UNIVERSITY OF DELAWARE'S DARWIN
set -x
set -e

export PATH="$HOME/ninja-linux/:$PATH"
export PATH="$HOME/cmake/cmake-4.0.1-linux-x86_64/bin:$PATH"
#module load gcc/13.2
module load llvm/18.1.8
#module load openmpi/4.1.1-gcc12.2
#module load binutils
module load pytorch/2.5.1

SRC=/home/users/andrewka/new_llvm
INSTALL=$HOME/llvm-5install
BUILD=$HOME/llvm_regular_build_5

LLVM_PROJECTS="clang;lld"
LLVM_RUNTIMES="openmp;offload"
TARGETS="X86;NVPTX"

mkdir -p $INSTALL
mkdir -p $BUILD
cd $BUILD

cmake -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=${INSTALL} \
  -D CMAKE_C_COMPILER=clang \
  -D CMAKE_CXX_COMPILER=clang++ \
  -D LLVM_ENABLE_PROJECTS=${LLVM_PROJECTS} \
  -D LLVM_ENABLE_ASSERTIONS=ON \
  -D LLVM_OPTIMIZED_TABLEGEN=ON \
  -D BUILD_SHARED_LIBS=ON \
  -D LLVM_CCACHE_BUILD=OFF \
  -D LLVM_ENABLE_RUNTIMES=${LLVM_RUNTIMES} \
  -D LLVM_ENABLE_LIBPFM=OFF \
  -D LIBOMPTARGET_PLUGINS_TO_BUILD="cuda" \
  -D LLVM_APPEND_VC_REV=ON \
  -G Ninja ${SRC}/llvm-project/llvm

cmake --build . --target install

#./bin/llvm-lit -v test/tools/input-gen/

if [ $? -eq 0 ]; then
  :
  #cd ..
  #rm -r llvm_build_tmp
fi
