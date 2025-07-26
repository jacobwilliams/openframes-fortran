#!/bin/bash

#
# setup pixi env to build OpenFrames
#

set -e  # exit on error

# version numbers of dev tools:
export PYTHON_VERSION=3.10
export OSG_VERSION=3.6.5
export CMAKE_VERSION=3.25
export SWIG_VERSION=4.0
export NUMPY_VERSION=1.24
export PYSIDE_VERSION=6.9.1
export NINJA_VERSION=1.11
export OPENFRAMESREPO=https://github.com/ravidavi/OpenFrames.git

rm -rf ./OpenFrames
rm -rf ./build

# get openframes:
git clone $OPENFRAMESREPO

# set up directories:
mkdir ./build
cd ./build

# create the conda environment and activate it:
mkdir ./osgenv
cd ./osgenv
pixi init .
pixi add python=$PYTHON_VERSION openscenegraph=$OSG_VERSION cmake=$CMAKE_VERSION swig=$SWIG_VERSION numpy=$NUMPY_VERSION pyside6=$PYSIDE_VERSION ninja=$NINJA_VERSION
