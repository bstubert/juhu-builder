# Instructions to Build Juhu image

## Dependencies

This repository depends on the following repositories:

* [meta-juhu-bsp](https://github.com/bstubert/meta-juhu-bsp) - a minimal extension of `meta-seco-bsp` layer with the image recipe `juhu-image-test-qt.bb`.
* [juhu-manifest](https://github.com/bstubert/juhu-manifest) - manifest file listing all the layer repositories.
* [cuteradio-apps](https://github.com/bstubert/cuteradio-apps) - a simple Internet radio application written in QML, Qt and C++.

## Prerequisites

Create a working directory `$WORKDIR`, which you can access as a normal user. All the following commands are executed in this directory unless stated otherwise.

Download the repository containing all the scripts for building the juhu image.

    $ git clone git@github.com:bstubert/juhu-builder.git

When one of the build scripts changes, you update them:

    $ cd $WORKDIR/juhu-builder
    $ git pull

Initialise and update the layer repositories.

    $ juhu-builder/init-layer-repos.sh 
    $ juhu-builder/update-layer-repos.sh

Initialising the layer repositories is necessary only once. Updating the layer repositories is needed when you change the revisions in the manifest file or when you change something in `meta-juhu-bsp`, which isn't pinned to a specific revision.

Build the Docker container used to build the Linux kernel and image.

    $ ./juhu-builder/build-docker-image.sh juhu:2020-11-19 juhu-builder/18.04/

## Building the Linux image

Start the Docker container, which enters the Yocto build environment:

    $ ./juhu-builder/run-docker-shell.sh juhu:2020-11-19
    Machine is  seco-sbc-a62
    Distro is  seco-imx-fb
    Ram Size is  1G_4x256M
    U-Boot configuration is  sd
    setting to default Build Directory

    [...]

    Your build environment has been configured with:

        MACHINE=seco-sbc-a62
        SDKMACHINE=x86_64
        DISTRO=seco-imx-fb
        EULA=1
        BSPDIR=
        BUILD_DIR=.
        meta-freescale directory found

    juhu@80d102c1da27:/public/Work/korbinian/build$

You build the juhu Linux image with:

    juhu@80d102c1da27:/public/Work/korbinian/build$ bitbake juhu-image-test-qt

The recipe `juhu-image-test-qt.bb` is simplified version of `seco-image-test-qt.bb`. It merges `seco-image-qt.bb` into `seco-image-test-qt.bb` and removes the `packagegroup-fsl-tools` recipe groups and some other tool recipes. The reason for removing these recipes is that many of them wouldn't build for the `seco-imx-fb` distro.

The script `run-docker-shell.sh` runs the script `korbinian/juhu-setup.sh`, which sources the script `korbinian/seco-setup.sh`:

    source ./seco-setup.sh -m seco-sbc-a62 -d seco-imx-fb -r 1G_4x256M -u sd

The script `korbinian/seco-setup.sh` is a slightly modified version of the orginal `seco-setup.sh` script from `meta-seco-bsp`. It adds the following lines to `korbinian/build/conf/local.conf`:

    ACCEPT_FSL_EULA = "1"
    UBOOT_CONFIG ??= "sd"
    DL_DIR ?= "${TOPDIR}/../downloads"
    SSTATE_DIR ?= "${TOPDIR}/../sstate-cache"
    DISTRO_FEATURES_remove = " x11 wayland vulkan"
    DISTRO_FEATURES_append = " alsa opengl"
    LICENSE_FLAGS_WHITELIST = "commercial"

The script removes some unnecessary layers like `meta-rust`, `meta-java` and `meta-browser` from 
`korbinian/build/conf/bblayers.conf` and adds the new layer `meta-juhu-bsp`.

