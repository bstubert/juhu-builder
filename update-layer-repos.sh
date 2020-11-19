#!/bin/bash

workDir=$(pwd)/nvent-vita
srcDir=$workDir/sources
bspDir=$srcDir/meta-juhu-bsp
repo=$workDir/bin/repo

mkdir -p $workDir
mkdir -p $srcDir

cd $workDir
$repo sync -j $(nproc)

cd $bspDir
git pull --rebase

cd $workDir
#rm ./seco-setup.sh
#ln -sf ./sources/meta-juhu-bsp/scripts/juhu-setup.sh ./juhu-setup.sh
