#!/bin/bash
export PATH="/home/users/andrewka/grace_hopper/sw/ccache/ccache-4.11.3_install/bin:$PATH"
export CCACHE_DIR=/home/users/andrewka/grace_hopper/sw/SGLang/sglang-v0.4.6/sgl-kernel/ccache
export CCACHE_BACKEND=""
export CCACHE_KEEP_LOCAL_STORAGE="TRUE"
unset CCACHE_READONLY
#PYTORCH_PATH="/home/users/andrewka/grace_hopper/sw/PyTorch/libtorch-2.7.0/libtorch"
#export LD_LIBRARY_PATH="${PYTORCH_PATH}/lib:$LD_LIBRARY_PATH"
#export CPPFLAGS="-I${PYTORCH_PATH}/include:$CPPFLAGS"
export PATH=/packages/cuda/12.6.3/bin:$PATH
export CUDA_HOME="/packages/cuda/12.6.3"

