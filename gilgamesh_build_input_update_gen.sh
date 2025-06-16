#!/bin/sh

#BUILD SCRIPT FOR UNIVERSITY OF OREGON'S ILLYAD 
set -x
set -e

export PATH="$HOME/llvm-libcxx-install/bin:$HOME/sw/python/Python-3.12.10_install/bin:$HOME/cmake-4.0.1-linux-x86_64/bin:$HOME/ninja-linux/:$PATH"
export LD_LIBRARY_PATH="$HOME/llvm-libcxx-install/lib/x86_64-unknown-linux-gnu:$HOME/sw/python/Python-3.12.10_install/lib:$LD_LIBRARY_PATH"
export CXXFLAGS="-stdlib=libc++"

SRC=/home/users/andrewka
INSTALL=$HOME/llvm-4input-gen-install

LLVM_PROJECTS="clang;lld"
#LLVM_RUNTIMES="libcxx;libcxxabi;libunwind;compiler-rt"
LLVM_RUNTIMES="compiler-rt"

mkdir -p $INSTALL
cd $HOME
mkdir -p llvm_build_tmpi4

cd $HOME/llvm_build_tmpi4

cmake -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=${INSTALL} \
  -D CMAKE_C_COMPILER=clang \
  -D CMAKE_CXX_COMPILER=clang++ \
  -D LLVM_USE_LINKER=lld \
  -D LLVM_ENABLE_PROJECTS=${LLVM_PROJECTS} \
  -D LLVM_ENABLE_ASSERTIONS=ON \
  -D LLVM_OPTIMIZED_TABLEGEN=ON \
  -D BUILD_SHARED_LIBS=ON \
  -D LLVM_CCACHE_BUILD=OFF \
  -D LLVM_ENABLE_RUNTIMES=${LLVM_RUNTIMES} \
  -D COMPILER_RT_BUILD_INPUTGEN=ON \
  -D LLVM_ENABLE_LIBCXX=ON \
  -D LLVM_APPEND_VC_REV=ON \
  -D LLVM_TARGETS_TO_BUILD="Native" \
  -G Ninja ${SRC}/LLVM_forks/input-gen-llvm-project/llvm

cmake --build . --target install

./bin/llvm-lit -v test
