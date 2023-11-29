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

@doc """
    init(ord::Integer, nvar::Integer)

Initialize the DACE control arrays and set the maximum order and the maximum
number of variables.

Note: must be called before any other DA routine can be used!
""" init(ord::Integer, nvar::Integer)

@doc """
    getMaxOrder()

Return the maximum order currently set for the computation, or zero if
undefined.
""" getMaxOrder()

@doc """
    getMaxVariables()

Return the maximum number of variables set for the computations, or zero if
undefined.
""" getMaxVariables()

@doc """
    getMaxMonomials()

Return the maximum number of monomials available with the order and number of
variables specified, or zero if undefined.
""" getMaxMonomials()
