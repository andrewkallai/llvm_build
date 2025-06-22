#!/bin/bash

export PYTHONPATH="$HOME/LLVM_forks/ml-compiler-opt:$PYTHONPATH"
export PATH="$HOME/sw/python/Python-3.11.13_install/bin:$HOME/llvm-4input-gen-install/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/llvm-libcxx-install/lib/x86_64-unknown-linux-gnu:$HOME/sw/python/Python-3.11.13_install/lib:$HOME/llvm-4input-gen-install/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$HOME/sw/libffi/libffi-3.4.8_install/lib64:$HOME/sw/bzip2/bzip2-1.0.8_install/lib:$HOME/sw/sqlite3/sqlite-autoconf-3500100_install/lib:$HOME/sw/libtool/libtool-2.5.4_install/lib:$LD_LIBRARY_PATH"
export PATH_TO_COMPILE="/storage/users/andrewka/.cache/huggingface/hub/datasets--llvm-ml--ComPile"

INSTALL="$HOME/llvm-4input-gen-install"
export PATH="$(readlink -f "$INSTALL")/bin/:$PATH"
export LD_LIBRARY_PATH="$(readlink -f "$INSTALL")/lib/:$LD_LIBRARY_PATH"
export LIBRARY_PATH="$(readlink -f "$INSTALL")/lib/:$LIBRARY_PATH"
export LIBRARY_PATH="$(readlink -f "$INSTALL")/lib/linux/:$LIBRARY_PATH"
export LIBRARY_PATH="$(readlink -f "$INSTALL")/lib/clang/18/lib/x86_64-unknown-linux-gnu/:$LIBRARY_PATH"
export LIBRARY_PATH="$(readlink -f "$INSTALL")/lib/clang/19/lib/x86_64-unknown-linux-gnu/:$LIBRARY_PATH"
export LIBRARY_PATH="$(readlink -f "$INSTALL")/lib/clang/20/lib/x86_64-unknown-linux-gnu/:$LIBRARY_PATH"
export LIBRARY_PATH="$(readlink -f "$INSTALL")/lib/clang/21/lib/x86_64-unknown-linux-gnu/:$LIBRARY_PATH"