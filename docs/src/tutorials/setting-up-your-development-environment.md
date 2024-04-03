# Setting up your development environment

!!! warning
    This might not work as is until DACE\_jll is released as a package.

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
  git clone https://github.com/chrisdjscott/DACE.jl.git
  ```
- DACE C++ library (note specific branch required)
  ```
  git clone --branch julia-interface https://github.com/chrisdjscott/dace.git
  ```

Switch to the *DACE.jl* directory you just cloned:

```
cd DACE.jl
```

## Setup DACE\_jll.jl for development

Run `julia --project` to enter the Julia REPL and enter `]` to enter the Pkg REPL mode, then

```julia
(DACE) pkg> add https://github.com/chrisdjscott/DACE_jll.jl.git
(DACE) pkg> develop DACE_jll
```

!!! warning
    TODO: check if extra steps required here to install other dependencies, might need `(DACE) pkg> instantiate`?

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

## Build the DACE C++ library

We should still be in the *DACE.jl* directory from above. Now find the CxxWrap prefix path by entering the Julia REPL (`julia --project`) and running

```julia
julia> using CxxWrap
julia> CxxWrap.prefix_path()
```

which should return a path like

```
"/home/<username>/.julia/artifacts/fb412eee87eae845b84a799f0cabf241142406d7"
```

with a different ID at the end. We will use this path in the CMake command later.

Now switch to the *dace* directory we cloned earlier (it should be alongside the *DACE.jl* directory we are currently working in):

```
cd ../dace
```

Make a build directory and switch to it:

```
mkdir build
cd build
```

Now run the cmake command to configure DACE (make sure to replace the first two paths with the paths you found above):

```
cmake .. \
    -DCMAKE_INSTALL_PREFIX=/home/<username>/.julia/dev/DACE_jll/override \
    -DCMAKE_PREFIX_PATH=/home/<username>/.julia/artifacts/fb412eee87eae845b84a799f0cabf241142406d7 \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_PTHREAD=ON \
    -DWITH_ALGEBRAICMATRIX=ON \
    -DCMAKE_CXX_STANDARD=17 \
    -DWITH_JULIA=ON
```

and then build and install DACE with:

```
VERBOSE=ON cmake --build . --config Release --target install -- -j${nproc}
```

## Verify the DACE module is working

Switch back to the *DACE.jl* directory. If you are still in the *build* directory from above run:

```
cd ../../DACE.jl
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
cd ../dace/build
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
VERBOSE=ON cmake --build . --config Release --target install -- -j${nproc}
```

Now change back to the *DACE.jl* directory

```
cd ../../DACE.jl
```


Once again, enter the Julia REPL with `julia --project` and run the `DACE.init` function we ran above:

```julia
julia> using DACE
julia> DACE.init(10, 1)
```

This time it should print out the string we just added (*initialising local version of DACE library...*).
