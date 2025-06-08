#!/bin/sh

#BUILD SCRIPT FOR UNIVERSITY OF OREGON'S ILLYAD 
set -x
set -e

export PATH="$HOME/sw/python/Python-3.12.10_install/bin:$HOME/cmake-4.0.1-linux-x86_64/bin:$HOME/ninja-linux/:$PATH"
export LD_LIBRARY_PATH="$HOME/sw/python/Python-3.12.10_install/lib:$LD_LIBRARY_PATH"

module load llvm/18.1.8

SRC=/home/users/andrewka
INSTALL=$HOME/llvm-libcxx-install

LLVM_PROJECTS="clang;lld"
LLVM_RUNTIMES="compiler-rt;libcxx;libcxxabi;libunwind"

mkdir -p $INSTALL
cd $HOME
mkdir -p llvm_build_tmpcxx2

cd $HOME/llvm_build_tmpcxx2

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
  -G Ninja ${SRC}/LLVM_forks/input-gen-llvm-project/llvm

cmake --build . --target install
