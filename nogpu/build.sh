#!/bin/bash

# Run with sudo

ROOTFS=$(pwd)/rootfs

mkdir -p $ROOTFS
# install basic system
multistrap -a armhf -f minimal.conf -d $ROOTFS

