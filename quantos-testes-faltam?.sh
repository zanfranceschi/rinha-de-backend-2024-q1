#!/usr/bin/bash

pushd ./participantes > /dev/null
echo "APIs to be tested:"
find '.' -mindepth 1 -maxdepth 1 -type d \! -exec test -e '{}/testada' \; -print
find '.' -mindepth 1 -maxdepth 1 -type d \! -exec test -e '{}/testada' \; -print | wc -l
popd > /dev/null
