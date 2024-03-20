# Developer Guide

## Location of source code

The source code for the DACE julia package is split into a couple of different repositories:

- the DACE C/C++ library, including the C++ part of the DACE julia interface: https://github.com/chrisdjscott/dace/tree/julia-interface
  - the interface is defined in the file *interfaces/julia/dace_julia.cxx*
- the Julia part of the interface: https://github.com/chrisdjscott/DACE.jl

## Releasing the DACE\_jll.jl package

!!! warning
    This will change once released to upstream [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil)

The DACE\_jll build recipe is currently in my fork/branch of the Yggdrasil repo
[here](https://github.com/chrisdjscott/Yggdrasil/blob/dace/D/DACE/build_tarballs.jl).

In that directory there is a *build\_tarballs.jl* file which defines the build, including the CMake command
and options to build the DACE C++ library.

To build the library and deploy it, run:

```sh
julia --color=yes build_tarballs.jl --verbose --deploy="chrisdjscott/DACE_jll.jl"
```
