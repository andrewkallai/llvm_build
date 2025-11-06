#!/bin/bash

#BUILD SCRIPT FOR UNIVERSITY OF DELAWARE'S DARWIN
set -x
set -e

alias python='python3.11'

PREFIX=$HOME/sw
#PATH="/home/users/andrewka/sw/python/Python-3.12.10_install/bin:$HOME/sw/ccache/ccache-4.11.3_install/bin:$HOME/ninja-linux/:$PATH"

export PATH="$PREFIX/CCache/ccache-4.12.1-linux-x86_64:$PREFIX/Ninja/bin:$PREFIX/CMake/cmake-4.1.2-linux-x86_64/bin:$PATH"

#export LD_LIBRARY_PATH="/home/users/andrewka/sw/python/Python-3.12.10_install/lib:$LD_LIBRARY_PATH"

#export LIBRARY_PATH="/home/users/andrewka/sw/libffi/libffi-3.4.8_install/lib:$LIBRARY_PATH"
#export CFLAGS="-I/home/users/andrewka/sw/libffi/libffi-3.4.8_install/include"

#module load gcc/13.2
#module load gcc/14.0.1
#module load llvm/18.1.8 
#module load cuda/12.5

#SRC=/home/users/andrewka/new_llvm
SRC=$PREFIX/LLVM
INSTALL=$HOME/LLVM_installs/llvm-complete-offloading-install
BUILD=$HOME/LLVM_builds/llvm_for_offload-complete_build

LLVM_PROJECTS="clang;lld;mlir;flang;lldb"
LLVM_RUNTIMES="compiler-rt;flang-rt;openmp;offload"
TARGETS="X86;NVPTX;AMDGPU"

mkdir -p $INSTALL
mkdir -p $BUILD
cd $BUILD

cmake -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_INSTALL_PREFIX=${INSTALL} \
  -D CMAKE_C_COMPILER=gcc \
  -D CMAKE_CXX_COMPILER=g++ \
  -D LLVM_ENABLE_PROJECTS=${LLVM_PROJECTS} \
  -D LLVM_ENABLE_ASSERTIONS=ON \
  -D LLVM_OPTIMIZED_TABLEGEN=ON \
  -D BUILD_SHARED_LIBS=ON \
  -D LLVM_CCACHE_BUILD=ON \
  -D LLVM_ENABLE_RUNTIMES=${LLVM_RUNTIMES} \
  -D LLVM_TARGETS_TO_BUILD=${TARGETS} \
  -D RUNTIMES_nvptx64-nvidia-cuda_LLVM_ENABLE_RUNTIMES=openmp \
  -D RUNTIMES_amdgcn-amd-amdhsa_LLVM_ENABLE_RUNTIMES=openmp \
  -D LLVM_RUNTIME_TARGETS="default;amdgcn-amd-amdhsa;nvptx64-nvidia-cuda" \
  -D LLVM_APPEND_VC_REV=ON \
  -G Ninja ${SRC}/llvm-project/llvm

  #-D LLVM_ENABLE_LIBPFM=OFF \
  #-D LIBOMPTARGET_PLUGINS_TO_BUILD="cuda;host" \

cmake --build . --target install

./bin/llvm-lit -v test
