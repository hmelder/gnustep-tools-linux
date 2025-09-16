#!/bin/sh

# Host
MAKE_JOBS=`nproc`
ABI_NAMES=${ABI_NAMES:-host}


BUILD_TYPE=${BUILD_TYPE:-RelWithDebInfo}

# Phases
PHASE_GLOB="${ROOT_DIR}/phases/[0-9][0-9]-*.sh"
phase_name() {
  name=`basename -s .sh $1`
  echo ${name/[0-9][0-9]-/}
}

# Directories
SRCROOT=${SRCROOT:-$ROOT_DIR/src}
CACHE_ROOT=${CACHE_ROOT:-$ROOT_DIR/cache}
INSTALL_ROOT=${INSTALL_ROOT:-$ANDROID_ROOT/GNUstep}
INSTALL_PREFIX=$INSTALL_ROOT/$ABI_NAME
BUILD_TXT=${BUILD_TXT:-$INSTALL_ROOT/build.txt}
BUILD_LOG=${BUILD_LOG:-$INSTALL_ROOT/build.log}

# CMake
CMAKE=${CMAKE:-cmake}
CMAKE_TOOLCHAIN_FILE=${ANDROID_NDK_ROOT}/build/cmake/android.toolchain.cmake

# GNUstep Make
case $BUILD_TYPE in
  Debug)
    GNUSTEP_MAKE_OPTIONS="$GNUSTEP_MAKE_OPTIONS debug=yes"
    ;;
esac
