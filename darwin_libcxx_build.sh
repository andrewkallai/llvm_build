#!/bin/sh

#BUILD SCRIPT FOR UNIVERSITY OF DELAWARE'S DARWIN
set -x
set -e

export PATH="$HOME/cmake-3.30.0-linux-x86_64/bin:$PATH"
#export PATH="/lustre/schandra_crpl/sw/LLVM/previous_llvm_install/bin:$PATH"
#export LD_LIBRARY_PATH="/lustre/schandra_crpl/sw/LLVM/previous_llvm_install/lib:$LD_LIBRARY_PATH"

vpkg_require ninja
vpkg_require gcc/12.2.0
vpkg_require python/3.8.6


SRC=/lustre/schandra_crpl/sw/LLVM
INSTALL=$HOME/llvm-libcxx-install

LLVM_PROJECTS="clang;lld;compiler-rt"

mkdir -p $INSTALL
#cd $SRC 
cd $HOME
mkdir -p llvm_build_libcxx
#cd ./build
cd $HOME/llvm_build_libcxx

cmake ${SRC}/llvm-project/llvm -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=${INSTALL} \
  -DCMAKE_C_COMPILER=gcc \
  -DCMAKE_CXX_COMPILER=g++ \
#  -DCMAKE_CXX_USING_LINKER_MODE="-fuse-ld=lld" \
  -DCMAKE_LINKER_TYPE=LLD \
#  -DCMAKE_CXX_FLAGS="-fuse-ld=lld" \
#  -DLLVM_USE_LINKER=lld \
  -DLLVM_ENABLE_PROJECTS=${LLVM_PROJECTS} \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_OPTIMIZED_TABLEGEN=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DLLVM_CCACHE_BUILD=OFF \
  -DLLVM_APPEND_VC_REV=OFF \
  -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
  -DLLVM_ENABLE_LIBCXX=ON \


  #-DINSTALL_PARALLEL=ON

cmake --build .
#cmake --build . --target install/parallel
cmake --build . --target install

#./bin/llvm-lit -v test/tools/input-gen/

if [ $? -eq 0 ]; then
  #cd ..
  #rm -r llvm_build_tmp
fi
#  -DCMAKE_INSTALL_PREFIX=${SRC}llvm_19.x \

#  -DCMAKE_C_COMPILER=clang \
#  -DCMAKE_CXX_COMPILER=clang++ \
