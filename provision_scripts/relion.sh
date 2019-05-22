#!/bin/sh

VAGRANT_SHARE=$1
STAGING_DIR=$2

apt-get update
apt-get install -y cmake build-essential mpi-default-bin mpi-default-dev libfftw3-dev libx11-dev libtiff-dev

git clone https://github.com/3dem/relion.git
cd relion
mkdir build
cd build
cmake ..
make -j4
make install


