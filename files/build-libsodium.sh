#!/bin/bash

set -e

RELEASE=libsodium-1.0.2

cd /tmp
wget https://download.libsodium.org/libsodium/releases/$RELEASE.tar.gz -O $RELEASE.tar.gz
tar -zxf $RELEASE.tar.gz
cd $RELEASE
./configure --prefix=/usr
make && make check && make install
rm libsodium*
