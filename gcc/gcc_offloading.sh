#!/bin/bash

set -e
set -u
set -x

module load gcc/16.1.0

GCC_VERSION="16.2.0"
BUILD_ID="${GCC_VERSION}-20261112"
CUDA_VERSION="13.2.0"
JOBS=48

PREFIX="${HOME}/sw/gcc/gcc-install-${BUILD_ID}"
WORKSPACE_PATH="${HOME}/sw/gcc/gcc-build-${BUILD_ID}"
SRC_PATH="${WORKSPACE_PATH}/sources"
BUILD_PATH="${WORKSPACE_PATH}/build"

PKG_NAME="gcc-${GCC_VERSION}"
SRC_NAME="gcc-${GCC_VERSION}.tar.xz"
BINUTILS_PATH=${HOME}/sw/Binutils/binutils-2.47
export PATH="${BINUTILS_PATH}_install/bin:$PATH"
export LD_LIBRARY_PATH="${BINUTILS_PATH}_install/lib:$LD_LIBRARY_PATH"

mkdir -p ${BINUTILS_PATH}
cd ${BINUTILS_PATH}/..
wget https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.gz
tar --extract --file=binutils-2.47.tar.gz
cd binutils-2.47
./configure --prefix=${BINUTILS_PATH}_install
make -j ${JOBS}
make install

CUDA_ROOT="/packages/cuda/${CUDA_VERSION}"

#module -t list

mkdir -p "${SRC_PATH}"
mkdir -p "${BUILD_PATH}"
mkdir -p "${PREFIX}"
cd "${SRC_PATH}"

if [ ! -d nvptx-tools ]; then
    git clone https://github.com/SourceryTools/nvptx-tools.git nvptx-tools
    git clone  https://sourceware.org/git/newlib-cygwin.git nvptx-newlib
fi


# Get GCC source
wget "https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/${SRC_NAME}"

cd "${BUILD_PATH}"
cp -r ${SRC_PATH}/nvptx-tools ./
cp -r ${SRC_PATH}/nvptx-newlib ./

tar -xf "${SRC_PATH}/${SRC_NAME}"


HOST_TARGET=$(${PKG_NAME}/config.guess)
OFFLOAD_TARGET="nvptx-none"

# Build nvptx tools
cd "${BUILD_PATH}/nvptx-tools"
"${BUILD_PATH}/nvptx-tools/configure" \
    --with-cuda-driver-include="${CUDA_ROOT}/include" \
    --with-cuda-driver-lib="${CUDA_ROOT}/lib64" \
    --prefix="${PREFIX}" && \
    make -j "${JOBS:-1}" && \
    make install


cd "${BUILD_PATH}"
# Get pre-requisites
#if [[ ! -L "${PKG_NAME}/gmp"  || \
#      ! -L "${PKG_NAME}/mpc"  || \
#      ! -L "${PKG_NAME}/mpfr" ]]; then
cd "${PKG_NAME}"
./contrib/download_prerequisites
unlink newlib || true
ln -s "${BUILD_PATH}/nvptx-newlib/newlib" newlib
#fi

cd "${BUILD_PATH}"
mkdir -pv build-nvptx-gcc
cd build-nvptx-gcc

"${BUILD_PATH}/${PKG_NAME}/configure" \
   --target="${OFFLOAD_TARGET}" \
   --with-build-time-tools="${PREFIX}/nvptx-none/bin" \
   --with-cuda-driver-include="${CUDA_ROOT}/include" \
   --with-cuda-driver-lib="${CUDA_ROOT}/lib64" \
   --with-cuda-driver="${CUDA_ROOT}/bin" \
   --enable-languages="c,c++,fortran,lto" \
   --enable-as-accelerator-for="${HOST_TARGET}" \
   --with-newlib \
   --disable-sjlj-exceptions \
   --enable-newlib-io-long-long \
   make -j "${JOBS}" && \
   make install

cd "${BUILD_PATH}"
mkdir -p build-gcc
cd build-gcc

${BUILD_PATH}/${PKG_NAME}/configure \
    --enable-offload-targets="${OFFLOAD_TARGET}" \
    --with-cuda-driver-include="${CUDA_ROOT}/include" \
    --with-cuda-driver-lib="${CUDA_ROOT}/lib64" \
    --with-cuda-driver="${CUDA_ROOT}/bin" \
    --enable-languages="c,c++,fortran,lto" \
    --disable-multilib \
    --prefix="${PREFIX}" && \
    make -j "${JOBS}" && \
    make install

#cd "${BUILD_PATH}"

# mkdir -pv build-gcc
# cd build-gcc
# # Build host compiler
# log_step "Building GCC Host Compiler" "${BUILD_PATH}/${PKG_NAME}/configure" \
#     --prefix="${PREFIX}" \
#     --enable-offload-targets="${OFFLOAD_TARGET}" \
#     --with-cuda-driver-include="${CUDA_ROOT}/include" \
#     --with-cuda-driver-lib="${CUDA_ROOT}/lib64" \
#     --with-cuda-driver="${CUDA_ROOT}/bin" \
#     --enable-languages="c,c++,fortran,lto" \
#     --disable-multilib CFLAGS="-m64" && \
#     make -j "${JOBS:-1}" && \
#     make install

