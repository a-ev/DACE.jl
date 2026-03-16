# Making a new release of DACE.jl

A new release of *DACE.jl* is created using [Registrator.jl](https://github.com/JuliaRegistries/Registrator.jl) by following these steps:

1. Make sure all the changes you want to be included in the new release are in the *main* branch in the [GitHub repository](https://github.com/UoA-AstroGroup/DACE.jl)
2. Make a new commit in the *main* branch that increments the version specified in *Project.toml*
3. Open the commit you just made in the GitHub web interface (the list of commits on the *main* branch can be viewed [here](https://github.com/UoA-AstroGroup/DACE.jl/commits/main/))
4. Add a comment to the commit with the following text: `@JuliaRegistrator register`
   - this will automatically open a pull request against the Julia registry to make a new release and it should be processed automatically
   - the registrator bot will add a comment after yours with any other instructions
