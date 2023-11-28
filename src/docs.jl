# add some documentation
@doc """
    DA()

Create an empty DA object representing the constant zero function.
""" DA

@doc """
    DA(c::Float64)

Create a DA object with the constant part equal to `c`.
""" DA(c::Float64)

@doc """
    DA(i::Integer, c::Float64)

Create a DA object as `c` times the independent variable number `i`.
""" DA(i::Integer, c::Float64)

@doc """
    DA(i::Integer)

Create a DA object as 1.0 times the independent variable number `i`.
""" DA(i::Integer)
