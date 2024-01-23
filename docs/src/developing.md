# Developing

## Releasing the DACE\_jll.jl package

!!! warning
    This will change once released to upstream [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil)

The DACE\_jll build recipe is currently in my fork/branch of the Yggdrasil repo
[here](https://github.com/chrisdjscott/Yggdrasil/tree/beacbce0777417d58d748729e5bc1ab73604aa93/D/DACE).

In that directory there is a *build\_tarballs.jl* file which defines the build, including the CMake command
and options to build the DACE C++ library.

To build the library and deploy it, run:

```sh
julia --color=yes build_tarballs.jl --verbose --deploy="chrisdjscott/DACE_jll.jl"
```
