# Making a new release of DACE.jl

A new release of *DACE.jl* is created using [Registrator.jl](https://github.com/JuliaRegistries/Registrator.jl) by following these steps:

1. Make sure all the changes you want to be included in the new release are in the *main* branch in the [GitHub repository](https://github.com/a-ev/DACE.jl)
2. Make a new commit in the *main* branch that increments the version specified in *Project.toml*
3. Open the commit you just made in the GitHub web interface (the list of commits on the *main* branch can be viewed [here](https://github.com/a-ev/DACE.jl/commits/main/))
4. Add a comment to the commit with the following text: `@JuliaRegistrator register`
   - this will automatically open a pull request against the Julia registry to make a new release and it should be processed automatically
   - the registrator bot will add a comment after yours with any other instructions
   - for example, [this](https://github.com/a-ev/DACE.jl/commit/82f0e255e6f29ceb07b70796ba332ba8d81d252e) is the commit we initially released and you can see the [comment](https://github.com/a-ev/DACE.jl/commit/82f0e255e6f29ceb07b70796ba332ba8d81d252e#commitcomment-146076832) we added there to initiate the release
