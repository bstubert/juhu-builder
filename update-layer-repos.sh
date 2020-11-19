#!/bin/bash

workDir=$(pwd)/korbinian
srcDir=$workDir/sources
repo=$workDir/bin/repo

mkdir -p $workDir
mkdir -p $srcDir

cd $workDir
$repo sync -j $(nproc)

cd $workDir
rm -f ./seco-setup.sh ./juhu-setup.sh
ln -sf ./sources/meta-juhu-bsp/scripts/seco-setup.sh ./seco-setup.sh
ln -sf ./sources/meta-juhu-bsp/scripts/juhu-setup.sh ./juhu-setup.sh
