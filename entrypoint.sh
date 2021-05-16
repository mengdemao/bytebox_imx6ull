#!/bin/bash
export PATH=$PATH:/compiler/arm-bytebox-linux-gnueabihf/bin
export PATH=$PATH:/compiler/aarch64-bytebox-linux-gnueabihf/bin

cd /playground
eval $*
