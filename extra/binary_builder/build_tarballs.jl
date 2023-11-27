# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "DACE"
version = v"0.0.3"

# Collection of sources required to complete build
sources = [
    GitSource("https://github.com/chrisdjscott/dace.git", "0fddf8aac9f4ba583d1d0b23ce3460b3b986d8a8")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/dace
cmake -DCMAKE_INSTALL_PREFIX=$prefix \
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TARGET_TOOLCHAIN} \
      -DCMAKE_BUILD_TYPE=Release \
      -DWITH_PTHREAD=ON \
      -DWITH_ALGEBRAICMATRIX=ON \
      -DCMAKE_CXX_STANDARD=17 \
      -DWITH_JULIA=ON \
      -DJulia_PREFIX=${prefix} \
      -DCMAKE_FIND_ROOT_PATH=${prefix}
make
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Platform("i686", "linux"; libc = "glibc"),
    Platform("x86_64", "linux"; libc = "glibc"),
    Platform("aarch64", "linux"; libc = "glibc"),
    Platform("armv6l", "linux"; call_abi = "eabihf", libc = "glibc"),
    Platform("armv7l", "linux"; call_abi = "eabihf", libc = "glibc"),
    Platform("powerpc64le", "linux"; libc = "glibc"),
    #Platform("i686", "linux"; libc = "musl"),
    Platform("x86_64", "linux"; libc = "musl"),
    Platform("aarch64", "linux"; libc = "musl"),
    Platform("armv6l", "linux"; call_abi = "eabihf", libc = "musl"),
    Platform("armv7l", "linux"; call_abi = "eabihf", libc = "musl"),
    Platform("x86_64", "macOS"),
    Platform("aarch64", "macOS"),
]


# The products that we will ensure are always built
products = [
    LibraryProduct("libdace", :libdace),
]

# Dependencies that must be installed before this package can be built
dependencies = [
    BuildDependency("libjulia_jll"),
    Dependency("libcxxwrap_julia_jll"),
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6", preferred_gcc_version = v"12.1.0")
