#!/bin/sh

#BUILD SCRIPT FOR UNIVERSITY OF DELAWARE'S DARWIN
set -x
set -e

export PATH="$HOME/cmake-3.30.0-linux-x86_64/bin:$PATH"
export PATH="/lustre/schandra_crpl/sw/LLVM/previous_llvm_install/bin:$PATH"
export LD_LIBRARY_PATH="/lustre/schandra_crpl/sw/LLVM/previous_llvm_install/lib:$LD_LIBRARY_PATH"
vpkg_require ninja
vpkg_require gcc/12.2.0
vpkg_require python/3.8.6


SRC=/lustre/schandra_crpl/sw/LLVM/
INSTALL=$HOME/llvm-install

#LLVM_PROJECTS="clang;clang-tools-extra;compiler-rt;openmp"
LLVM_PROJECTS="clang"

mkdir -p $INSTALL
#cd $SRC 
cd /tmp
mkdir -p build
#cd ./build
cd /tmp/build
#cmake ../llvm-project/llvm -G Ninja \
cmake ${SRC}llvm-project/llvm -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALL} \
  -DCMAKE_C_COMPILER=gcc \
  -DCMAKE_CXX_COMPILER=g++ \
  -DLLVM_ENABLE_PROJECTS=${LLVM_PROJECTS} \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLIBOMPTARGET_ENABLE_DEBUG=ON \
  -DLIBOMPTARGET_DEVICE_ARCHITECTURES="sm_70;sm_80" \
  -DLLVM_OPTIMIZED_TABLEGEN=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DLLVM_CCACHE_BUILD=OFF \
  -DLLVM_APPEND_VC_REV=OFF

cmake --build .
cmake --build . --target install/parallel
if [ $? -eq 0 ]; then
  cd ..
  rm -r build
fi
#  -DCMAKE_INSTALL_PREFIX=${SRC}llvm_19.x \

#  -DCMAKE_C_COMPILER=clang \
#  -DCMAKE_CXX_COMPILER=clang++ \
