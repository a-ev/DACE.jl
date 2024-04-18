# Making a new release of DACE\_jll

The *DACE\_jll* Julia package contains the prebuilt DACE library (prebuilt for all combinations of platforms, Julia versions, etc. that Julia is supported on).
[BinaryBuilder.jl](https://docs.binarybuilder.org/stable/) is used to build the libraries and publish them to the Julia registry.

The recipe for building the DACE library can be found on [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil) in the *D/DACE* directory.

To make a new release of the DACE\_jll package you can follow these steps:

1. Make your changes in the [dace](https://github.com/a-ev/dace/tree/julia-interface) repo and test them (see [setting up your development environment](setting-up-your-development-environment.md) for help getting started with this step)
2. Commit your changes into the [dace](https://github.com/a-ev/dace/tree/julia-interface) repo and make a note of the unique commit hash that identifies the commit you want to release (this can be found using `git log` or via the commits view in the GitHub interface)
3. On GitHub, make a fork of the [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil) repository, clone that locally and create a branch for your changes
   ```
   # fork in the github web interface, then...

   # clone the repo (replace with the correct URL for your fork)
   git clone git@github.com:<namespace>/Yggdrasil.git

   # change directory into the repo
   cd Yggdrasil

   # switch to a new branch
   git checkout -b update-dace

   # switch to the D/DACE directory
   cd D/DACE
   ```
4. Edit the *build_tarballs.jl* file:
   - bump the version of the release on or around line 11:
     ```
     version = v"0.1.0"
     ```

     !!! note
         It is highly recommended to follow [semantic versioning](https://semver.org/)

   - change the commit hash (on or around line 15) that the new version will be based of to the hash of the commit you identified in step 2
     ```
     GitSource("https://github.com/a-ev/dace.git", "9fe534f9b27c147a171bce1ad7dc8b4706a9457e"),
     ```
     where *9fe534f9b27c147a171bce1ad7dc8b4706a9457e* is the commit hash
5. Check the version of *libcxxwrap_julia_jll* which is linked to the version of *CxxWrap.jl*. When bumping the version of the CxxWrap dependency in the *DACE.jl* package you may also need to bump the version of *libcxxwrap_julia_jll* on or around line 55:
   ```
   Dependency("libcxxwrap_julia_jll"; compat = "~0.12.2"),
   ```
   
   !!! important
       Make sure the version of *libcxxwrap_julia_jll* is compatible with the version of *CxxWrap,jl* in your *Project.toml* for *DACE.jl*

6. Commit and push your changes into your fork of Yggdrasil:
   ```
   git add build_tarballs.jl
   git commit -m "[DACE] bump version"
   git push
   ```
   You may need to set the upstream of your repo for `git push` to work. The above commands are just examples and may need tweaking.
7. Create a pull request back to the main Yggdrasil repo. The builds will run automatically and you can view their status in the pull request. If they all succeed someone will merge them automatically (you don't need to do anything else)
