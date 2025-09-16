#!/bin/sh

echo "### Set toolchain vars"

export CC=clang
export CXX=clang++
export OBJC="${CC}"
export OBJCXX="${CXX}"
export LD=ld.lld
export AR=llvm-ar
export AS="${CC}"
export RANLIB=llvm-ranlib
export STRIP=llvm-strip
export NM=llvm-nm
export OBJDUMP=llvm-objdump
export PKG_CONFIG_PATH="${INSTALL_PREFIX}/lib/pkgconfig"

# always generate debug info and build with optimizations
if [ ! -n "${OPTFLAG+set}" ]; then
  OPTFLAG="-g -O2"
fi

# NOTE: The following compiler and linker flags mirror the NDK's CMake toolchain file
# and are recommended by the Android Build System Maintainers Guide (see link above)

# - emit stack guards to protect against security vulnerabilities caused by buffer overruns
# - enable FORTIFY to try to catch incorrect use of standard functions
# - generate position-independent code (PIC) to remove unsupported text relocations
export CFLAGS="$OPTFLAG -fstack-protector-strong -D_FORTIFY_SOURCE=2 -fPIC"

# -L library search path required for some projects to find libraries (e.g. gnustep-corebase)
# -fuse-ld=lld require to enforce LLD, which is needed e.g. for --no-rosegment flag
# --build-id=sha1 required for Android Studio to locate debug information
# --gc-sections is recommended to decrease binary size
export LDFLAGS="-L${INSTALL_PREFIX}/lib -fuse-ld=lld -Wl,--build-id=sha1 -Wl,--gc-sections"
export CXXFLAGS=$CFLAGS

# common options for CMake-based projects
CMAKE_OPTIONS=" \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -DCMAKE_SHARED_LINKER_FLAGS=$ADDITIONAL_CMAKE_FLAGS \
"
