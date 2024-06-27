# add some documentation
@doc """
$(TYPEDEF)

DA object representing a single polynomial.

The default constructor (with no arguments) creates an empty DA object
representing the constant zero function.

""" DA

@doc """
    DA(c::Number)

Create a DA object with the constant part equal to `c`.
""" DA(c::Number)

@doc """
    DA(i::Integer, c::Number)

Create a DA object as `c` times the independent variable number `i`.
""" DA(i::Integer, c::Number)
