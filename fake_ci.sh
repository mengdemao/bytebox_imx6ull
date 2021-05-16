#!/bin/bash

# 设置版本号
VERSION_MAJOR=$(git tag -l | tail -1)
VERSION_MINOR=$(git show -s --pretty=format:%h)

# 启动构建
docker build -t mengdemao/bytebox-compiler:${VERSION_MAJOR}.${VERSION_MINOR} .
