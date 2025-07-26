#!/bin/bash

#
# an experimental script to build OpenFrames
#
# first run setup_env.sh to set up the environment
#
# then:
#    pixi shell --manifest-path ./build/osgenv/pixi.toml
#    ./build_openframes.sh

set -e  # exit on error

cd ./build

# configure:
cmake -G Ninja \
      -D CMAKE_BUILD_TYPE=Release \
      -D OSG_DIR=./osgenv \
      -D OF_BUILD_DEMOS=ON \
      -D OF_PYTHON_MODULE=ON \
      -D SWIG_EXECUTABLE=./osgenv/.pixi/envs/default/bin/swig \
      ../OpenFrames

# build:
ninja
ninja install
