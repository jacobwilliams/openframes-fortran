#!/bin/bash

#
# an experimental script to build OpenFrames
#

# version numbers of dev tools:
export PYTHON_VERSION=3.9
export OSG_VERSION=3.6.5
export CMAKE_VERSION=3.25
export SWIG_VERSION=4.0
export NUMPY_VERSION=1.24
export PYQT_VERSION=5.15

# magic to make conda work:
eval "$(conda shell.bash hook)"

# set up directories:
rm -rf ./build 
mkdir ./build

# create the conda environment and activate it:
conda create --channel nodefaults --channel conda-forge --prefix ./build/osgenv --solver libmamba python=$PYTHON_VERSION openscenegraph=$OSG_VERSION cmake=$CMAKE_VERSION swig=$SWIG_VERSION numpy=$NUMPY_VERSION PYQT=$PYQT_VERSION
cd build
conda activate ./osgenv

# configure:
cmake -D OSG_DIR=./osgenv -D OF_BUILD_DEMOS=ON -D OF_PYTHON_MODULE=ON -D SWIG_EXECUTABLE=./osgenv/bin/swig ..

# build:
make -j 4 install