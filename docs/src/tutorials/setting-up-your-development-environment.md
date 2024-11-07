# Setting up your development environment

This tutorial will run through setting up DACE\_jll.jl, DACE.jl and the DACE C++ library for development locally.
It has been tested on Linux.

After running this tutorial, you should be able to make changes to the C++ code that defines the DACE Julia interface,
compile those changes and test them via the DACE.jl Julia package locally.

This is based on the upstream binary builder documention for how to develop locally:

- [https://docs.binarybuilder.org/stable/building/#Building-and-testing-JLL-packages-locally](https://docs.binarybuilder.org/stable/building/#Building-and-testing-JLL-packages-locally)
- [https://docs.binarybuilder.org/stable/jll/#Overriding-the-artifacts-in-JLL-packages](https://docs.binarybuilder.org/stable/jll/#Overriding-the-artifacts-in-JLL-packages)

and also CxxWrap documentation:

- [https://github.com/JuliaInterop/CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl)
- [https://github.com/JuliaInterop/libcxxwrap-julia](https://github.com/JuliaInterop/libcxxwrap-julia)

## Clone repos

Create and change to a new directory that we can clone the DACE code into. Then run the following:

- DACE.jl Julia package
  ```
  git clone https://github.com/a-ev/DACE.jl.git
  ```
- DACE C++ library (note specific branch required)
  ```
  git clone --branch julia-interface https://github.com/a-ev/dace.git
  ```

Set an environment variable with the path to the current directory, so we can refer back to it later:

```
export srcdir=$PWD
```

## Setup DACE\_jll.jl for development

Switch to the *DACE.jl* directory that you cloned above:

```
cd ${srcdir}/DACE.jl
```

Run `julia --project` to enter the Julia REPL and enter `]` to enter the Pkg REPL mode, then

```julia
(DACE) pkg> instantiate
(DACE) pkg> develop DACE_jll
```

After running the above, press backspace to return to the Julia REPL and run

```julia
julia> using DACE_jll
julia> DACE_jll.dev_jll()
```

At the end of the above command it will print a location of the override directory, e.g.

```
...
[ Info: DACE_jll dev'ed out to /home/<username>/.julia/dev/DACE_jll with pre-populated override directory
```

The directory `/home/<username>/.julia/dev/DACE_jll/override` contains the dace shared libraries and headers in *lib* and *includes* directories.
We can delete the contents of this directory and replace it with our own version that we build locally.

Don't just copy this command, make sure the path corresponds to the path in your output above.

```
rm -rf /home/<username>/.julia/dev/DACE_jll/override/*
```

Now store the path in an environment variable so that we can use it later (make sure you replace the path below with your path):

```
export dacejllpath=${HOME}/.julia/dev/DACE_jll/override
```

## On Mac OS X only: build our own version of libcxxwrap-julia

!!! note

    Skip this section and continue to the [next step](#Build-the-DACE-C-library) if you are not running on Mac OS X.

On Mac OS X it seems that currently you need to build your own version of *libcxxwrap-julia* in order
for the remaining instructions to work correctly.

First set up an override directory where we can build our own version of *libcxxwrap-julia*.
We should still be in the *DACE.jl* directory from above (`cd ${srcdir}/DACE.jl`).
Run `julia --project` to enter the Julia REPL and enter `]` to enter the Pkg REPL mode, then

```
pkg> develop libcxxwrap_julia_jll
```

At this point we should also make a note of the version of *libcxxwrap_julia_jll*:

```
pkg> status libcxxwrap_julia_jll
```

The above command should output something like:

```
Project DACE v0.1.0
Status `/path/to/DACE.jl/Project.toml`
  [3eaa8342] libcxxwrap_julia_jll v0.13.2+0 `~/.julia/dev/libcxxwrap_julia_jll`
```

We can see that the version is `v0.13.2` (ignore the "+" and anything after it).

Back in the Julia REPL, import the package and run `dev_jll`:

```
julia> import libcxxwrap_julia_jll
julia> libcxxwrap_julia_jll.dev_jll()
```

At the end of the above command it should print the path to the devved JLL, e.g. `/home/<username>/.julia/dev/libcxxwrap_julia_jll`.
Inside that directory will be an override directory, which is where we will build our local version of *libcxxwrap_julia*. Make a note of the directory that was printed.

Make sure you are still in the directory where we cloned the other git repos above, clone the *libcxxwrap_julia* repository and checkout the tag that matches the version you found above:

```
cd ${srcdir}
git clone https://github.com/JuliaInterop/libcxxwrap-julia.git
cd libcxxwrap-julia
git checkout v0.13.2
```

Now we will change to the directory where *libcxxwrap_julia_jll* was devved out to and build our own version:

```
cd /home/<username>/.julia/dev/libcxxwrap_julia_jll/override
rm -rf *
cmake -DJulia_EXECUTABLE=$(which julia) ${srcdir}/libcxxwrap-julia
cmake --build . --config Release
```

## Build the DACE C++ library

Switch to the *DACE.jl* directory from above:

```
cd ${srcdir}/DACE.jl
```

Now find the CxxWrap prefix path by entering the Julia REPL (`julia --project`) and running

```julia
julia> import CxxWrap
julia> CxxWrap.prefix_path()
```

This should return a path like:

```
"/home/<username>/.julia/artifacts/fb412eee87eae845b84a799f0cabf241142406d7"
```

with a different ID at the end (although it may look like `/Users/<username>/.julia/dev/libcxxwrap_julia_jll` on Mac OS X). We will use this path in the CMake command later so let's store it in an environment variable (make sure you replace the path below with your path):

```
export prefixpath=${HOME}/.julia/artifacts/fb412eee87eae845b84a799f0cabf241142406d7
```

Now switch to the *dace* directory we cloned earlier (it should be alongside the *DACE.jl* directory we are currently working in):

```
cd ${srcdir}/dace
```

Make a build directory and switch to it:

```
mkdir build
cd build
```

Now run the cmake command to configure DACE:

```
cmake .. \
    -DCMAKE_INSTALL_PREFIX=${dacejllpath} \
    -DCMAKE_PREFIX_PATH=${prefixpath} \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_PTHREAD=ON \
    -DWITH_ALGEBRAICMATRIX=ON \
    -DCMAKE_CXX_STANDARD=17 \
    -DWITH_JULIA=ON
```

and then build and install DACE with:

```
VERBOSE=ON cmake --build . --config Release --target install -- -j$(nproc)
```

## Verify the DACE module is working

Switch back to the *DACE.jl* directory.

```
cd ${srcdir}/DACE.jl
```

Enter the Julia REPL with `julia --project` and run

```julia
julia> using DACE
julia> DACE.init(10, 1)
julia> ?DACE.DA
```

which should show some help about the `DACE.DA` type.

## Make a change to the local DACE library

Now we will make a change to the local C++ source code and verify that the change is loaded in the Julia library.

Switch back to the *dace/build* directory

```
cd ${srcdir}/dace/build
```

Edit the interface file *../interfaces/julia/dace_julia.cxx* using an editor such as *vim* or *nano*.

Locate the `DACE.init` function, it should be near the top and look like

```cxx
mod.method("init", [](const unsigned int ord, const unsigned int nvar) {
        DA::init(ord, nvar);
    });
```

For reference,

- `mod.method` adds a function to the Julia module
- `"init"` is the name of the function that is being added
- `[](const unsigned int ord, const unsigned int nvar)` denotes a C++ lambda function that runs when the function is called from Julia and takes two unsigned integer arguments
- the lambda function body passes those two arguments to the `DA::init` routine, which is defined in the DACE C++ library

We will modify this method to add a print statement, such as

```cxx
mod.method("init", [](const unsigned int ord, const unsigned int nvar) {
        std::cout << "initialising local version of DACE library..." << std::endl;
        DA::init(ord, nvar);
    });
```

so that we can tell the local version has been loaded. Make the above change then save the file.

We should be in the *build* directory still. Execute the following command to build and install your change:

```
VERBOSE=ON cmake --build . --config Release --target install -- -j$(nproc)
```

Now change back to the *DACE.jl* directory

```
cd ${srcdir}/DACE.jl
```

Once again, enter the Julia REPL with `julia --project` and run the `DACE.init` function we ran above:

```julia
julia> using DACE
julia> DACE.init(10, 1)
```

This time it should print out the string we just added (*initialising local version of DACE library...*).
