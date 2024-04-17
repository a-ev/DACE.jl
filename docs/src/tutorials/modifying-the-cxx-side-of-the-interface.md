# Modifying the C++ side of the interface

This tutorial will give a brief explanation of the C++ side of the DACE Julia interface,
which will hopefully allow you to make changes and add new functionality to the interface.

Note that there are two sides to the interface:

- the C++ side of the interface, which exists in the DACE C++ source code
- the Julia side of the interface, which exists in the DACE.jl Julia package

The Julia interface on the C++ side is created using [CxxWrap.jl](https://github.com/JuliaInterop/CxxWrap.jl), which is documented in the *README.md* file in their git repo.

!!! note
    It is assumed that you have successfully followed the tutorial to [set up your development environment](setting-up-your-development-environment.md).

## Switch to your dace directory

Switch to your *dace* directory that you set up during the [setting up your development environment tutorial](setting-up-your-development-environment.md)

```
cd /path/to/dace
```

Inside that directory you should see a sub-directory called *build* which is where we have compiled the DACE C++ library.
You should also see an *interfaces* directory. Switch into the *interfaces/julia* directory

```
cd interfaces/julia
```

Inside this directory you will see the file *dace_julia.cxx*, which contains the source code for the Julia interface.

## Defining the Julia module

In *dace_julia.cxx* you will see

```cxx
JLCXX_MODULE define_julia_module(jlcxx::module& mod) {
    // code omitted here
}
```

All the methods and types defined within the `define_julia_module` function will belong to the generated Julia module when we load it in the *DACE.jl* package.

## Adding DA static methods

In the first section of the `define_julia_module` function we add some `DA` static methods:

```cxx
// add DA static methods separately
mod.method("init", [](const unsigned int ord, const unsigned int nvar) {
        DA::init(ord, nvar);
    });
mod.method("getMaxOrder", []()->int64_t { return DA::getMaxOrder(); });
mod.method("getMaxVariables", []()->int64_t { return DA::getMaxVariables(); });
mod.method("getMaxMonomials", []()->int64_t { return DA::getMaxMonomials(); });
mod.method("setEps", [](const double eps) { return DA::setEps(eps); });
mod.method("getEps", []() { return DA::getEps(); });
mod.method("getEpsMac", []() { return DA::getEpsMac(); });
mod.method("setTO", [](const unsigned int ot) { return DA::setTO(ot); });
mod.method("getTO", []() { return DA::getTO(); });
mod.method("pushTO", [](const unsigned int ot) { DA::pushTO(ot); });
mod.method("popTO", []() { DA::popTO(); });
```

Here `mod` is the Julia module and when we call `mod.method` we are adding a new method (function) to the Julia module.

Take the `init` function for example:

```cxx
mod.method("init", [](const unsigned int ord, const unsigned int nvar) { DA::init(ord, nvar); });
```

The first argument to `mod.method` is the name of the function as it should appear in the Julia module that we are creating, in this case the new function will be named `init`.

The second argument to `mod.method` is the C++ function that should be called when some calls the `init` function in the Julia module that we are creating. In this case we are using a C++ [lambda function](https://en.cppreference.com/w/cpp/language/lambda) but you could pass a normal C++ function also. The lambda function, denoted by the `[]`, takes two arguments, `ord` and `nvar` (the order and number of variables) and runs the code within the curly braces, `DA::init(ord, nvar);`, i.e. it calls the DA static method `init` with the two arguments that were passed in from Julia.

You can return values back to Julia and CxxWrap.jl can automatically infer the type of the return value, such as:

```cxx
mod.method("getEps", []() { return DA::getEps(); });
```

is a lambda function (`[]`) that takes no arguments (`()`) and returns the epsilon value `return DA::getEps();` and automatically convert the C++ return type to a Julia type.

It is also possible to specify the return type, which we have done in some cases to avoid compiler warnings, e.g. we specify the return type of `getMaxOrder` to be of type `int64_t` here:

```cxx
mod.method("getMaxOrder", []()->int64_t { return DA::getMaxOrder(); });
```

## Adding the DA type


