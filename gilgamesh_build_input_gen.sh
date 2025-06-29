#!/bin/sh

#BUILD SCRIPT FOR UNIVERSITY OF DELAWARE'S DARWIN
set -x
set -e

export PATH="$HOME/ninja-linux/:$PATH"
module load cmake/3.30.3
module load gcc/13.2
module load pytorch/2.5.1


SRC=/home/users/andrewka
INSTALL=$HOME/llvm-input-gen-install

LLVM_PROJECTS="clang;lld;compiler-rt"

mkdir -p $INSTALL
#cd $SRC 
cd $HOME
mkdir -p llvm_build_tmp

cd $HOME/llvm_build_tmp

cmake -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=${INSTALL} \
  -D CMAKE_C_COMPILER=gcc \
  -D CMAKE_CXX_COMPILER=g++ \
  -D LLVM_ENABLE_PROJECTS=${LLVM_PROJECTS} \
  -D LLVM_ENABLE_ASSERTIONS=ON \
  -D LLVM_OPTIMIZED_TABLEGEN=ON \
  -D BUILD_SHARED_LIBS=ON \
  -D LLVM_CCACHE_BUILD=OFF \
  -D LLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
  -G Ninja ${SRC}/llvm-project/llvm

cmake --build . --target install

./bin/llvm-lit -v test/tools/input-gen/

if [ $? -eq 0 ]; then
  #cd ..
  #rm -r llvm_build_tmp
fi