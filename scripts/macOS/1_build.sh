#!/bin/bash
# this is a script shell for compiling meshlab in a MacOS environment.
# Requires a Qt environment which is set-up properly, and an accessible
# cmake binary.
#
# Without given arguments, MeshLab will be built in the meshlab/src/build
# directory, and installed in $BUILD_PATH/../install.
#
# You can give as argument the BUILD_PATH and the INSTALL_PATH in the
# following way:
# sh macos_build.sh --build_path=/path/to/build --install_path=/path/to/install
# -b and -i arguments are also supported.

#realpath function
#realpath() {
#    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
#}

#default paths wrt the script folder
SCRIPTS_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SOURCE_PATH=$SCRIPTS_PATH/../../src
BUILD_PATH=$SOURCE_PATH/build
INSTALL_PATH=$SOURCE_PATH/install
CORES="-j4"
DOUBLE_PRECISION_OPTION=""
NIGHTLY_OPTION=""

#check parameters
for i in "$@"
do
case $i in
    -b=*|--build_path=*)
        BUILD_PATH="${i#*=}"
        shift # past argument=value
        ;;
    -i=*|--install_path=*)
        INSTALL_PATH="${i#*=}"
        shift # past argument=value
        ;;
    -j*)
        CORES=$i
        shift # past argument=value
        ;;
    -d|--double_precision)
        DOUBLE_PRECISION_OPTION="-DBUILD_WITH_DOUBLE_SCALAR=ON"
        shift # past argument=value
        ;;
    -n|--nightly)
        NIGHTLY_OPTION="-DMESHLAB_IS_NIGHTLY_VERSION=ON"
        shift # past argument=value
        ;;
    *)
        # unknown option
        ;;
esac
done

#create build path if necessary
if ! [ -d $BUILD_PATH ]
then
    mkdir -p $BUILD_PATH
fi

#create install path if necessary
if ! [ -d $INSTALL_PATH ]
then
    mkdir -p $INSTALL_PATH
fi

cd $BUILD_PATH
cmake -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=$INSTALL_PATH $DOUBLE_PRECISION_OPTION $NIGHTLY_OPTION $SOURCE_PATH
make $CORES
make install
