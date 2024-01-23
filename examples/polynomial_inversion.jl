# # Polynomial inversion
#
# This is a simple DACE example demonstrating:
#
# - How to load DACE.jl
# - How to initialise the DACE library
# - How to create a `DA` object
# - How to create an `AlgebraicVector`
# - How to invert a Taylor polynomial
#
# ## Install dependencies
#
# Make sure the required packages are installed

# ```julia
# using Pkg
# Pkg.add("https://github.com/chrisdjscott/DACE_jll.jl.git")
# Pkg.add("https://github.com/chrisdjscott/DACE.jl.git")
# ```

# ## Using DACE
#
# Write

using DACE

# to load DACE functions and objects into our script.
#
# Initialise DACE for 10th-order computations in 1 variable

DACE.init(10, 1)

# Initialise `x` as a `DA` object

x = DACE.DA(1)

# Create `y` as `AlgebraicVector` of type `DA` and size 1

y = AlgebraicVector{DA}(1)

# Store the Taylor expansion of `sin(x)` in the first element of `y`

y[1] = sin(x)

# Invert the Taylor polynomial

inv_y = DACE.invert(y)

# Compare with asin(x)
#
# Polynomial inversion of `sin(x)`

println(inv_y)

# `asin(x)`

println(asin(x))
