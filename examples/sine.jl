# # Sine example
#
# This is a simple DACE example using the sine function, which demonstrates:
#
# - How to load DACE.jl
# - How to initialise the DACE library
# - How to create a `DA` object
# - How to compute the sine of a `DA` object
# - How to print a `DA` object to screen
# - How to evaluate a `DA` object
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
# Initialise DACE for 20th-order computations in 1 variable

DACE.init(20, 1)

# Initialise `x` as a `DA` object

x = DACE.DA(1)

# Initialise `y` as the Taylor expansion of `sin(x)`

y = sin(x)

# Print `x` and `y` to screen

println("x")
print(x)
println("y = sin(x)")
print(y)

# Evaluate `y` at 1.0 and compare with the builtin `sin` function.

println("  y(1.0) = $(DACE.evalScalar(y, 1.0))")
println("sin(1.0) = $(sin(1.0))")
