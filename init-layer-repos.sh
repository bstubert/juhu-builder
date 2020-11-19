#!/bin/bash

workDir=$(pwd)/nvent-vita
srcDir=$workDir/sources

mkdir -p $workDir
mkdir -p $srcDir
cd $workDir

repo=$workDir/bin/repo
mkdir -p $workDir/bin
if [ ! -f ./bin/repo ]; then
    curl https://storage.googleapis.com/git-repo-downloads/repo > $repo
    chmod a+x $repo
fi

$repo init -u git@github.com:bstubert/juhu-manifest.git -b main -m juhu.xml

