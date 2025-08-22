#!/bin/sh

#BUILD SCRIPT FOR UNIVERSITY OF DELAWARE'S DARWIN
set -x
set -e

PATH="$HOME/sw/ccache/ccache-4.11.3_install/bin:$HOME/ninja-linux/:$PATH"
export PATH="$HOME/cmake/cmake-4.0.1-linux-x86_64/bin:$PATH"
module load llvm/18.1.8
module load pytorch/2.5.1

#SRC=/home/users/andrewka/new_llvm
SRC=/home/users/andrewka/LLVM_clones
INSTALL=$HOME/LLVM_installs/llvm-spec-install
BUILD=$HOME/LLVM_builds/llvm_for_spec_build

#LLVM_PROJECTS="clang;lld;mlir;flang"
LLVM_PROJECTS="clang;lld"
#LLVM_RUNTIMES="compiler-rt;flang-rt;openmp;offload"
LLVM_RUNTIMES="compiler-rt;openmp;offload"
TARGETS="X86;NVPTX"
#TARGETS="X86;NVPTX;AMDGPU"

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
  -D LLVM_CCACHE_BUILD=ON \
  -D LLVM_ENABLE_RUNTIMES=${LLVM_RUNTIMES} \
  -D LIBOMPTARGET_PLUGINS_TO_BUILD="cuda" \
  -D LLVM_TARGETS_TO_BUILD=${TARGETS} \
  -D LLVM_APPEND_VC_REV=ON \
  -G Ninja ${SRC}/llvm-project-spec/llvm

  #-D LLVM_ENABLE_LIBPFM=OFF \

cmake --build . --target install

