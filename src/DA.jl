struct Monomial
    cc::Cdouble
    ii::Cuint
end

struct Variable
    len::Cuint
    max::Cuint
    mem::Ptr{Monomial}
end

# TODO: constructor behaviour is not matching C++, need to change eg to make C default to 1 etc...
mutable struct DA
    index::Ref{Variable}

    @doc """
        DA()

    Create an empty DA object representing the constant zero function.
    """
    function DA()
        m_index = Ref{Variable}()
        ccall((:daceAllocateDA, libdace), Cvoid, (Ref{Variable}, Cuint), m_index, 0)
        exitondaceerror("Error: DA() failed")
        y = new(m_index)

        finalizer(y) do x
            ccall((:daceFreeDA, libdace), Cvoid, (Ref{Variable},), x.index)
            exitondaceerror("Error: Failed to free DA")
        end

        return y
    end

    @doc """
        DA(da::DA)

    Create a copy of a DA object.
    """
    function DA(da::DA)
        m = DA()

        ccall((:daceCopy, libdace), Cvoid, (Ref{Variable}, Ref{Variable}), da.index, m.index)
        exitondaceerror("Error: DA(da::DA) failed to copy")

        return m
    end

    @doc """
        DA(c::Cdouble)

    Create a DA object with the constant part equal to `c`.
    """
    function DA(c::Cdouble)
        m = DA()

        ccall((:daceCreateConstant, libdace), Cvoid, (Ref{Variable}, Cdouble), m.index, c)
        exitondaceerror("Error: DA(c::Cdouble) failed")

        return m
    end

    @doc """
        DA(c)

    Create a DA object with the constant part equal to `c`.

    Note: `c` must be able to be cast to type `Cdouble`.
    """
    function DA(c)
        return DA(convert(Cdouble, c))
    end

    @doc """
        DA(i::Cuint. c::Cdouble)

    Create a DA object as `c` times the independent variable number `i`.
    """
    function DA(i::Cuint, c::Cdouble)
        m = DA()

        ccall((:daceCreateVariable, libdace), Cvoid, (Ref{Variable}, Cuint, Cdouble), m.index, i, c)
        exitondaceerror("Error: DA(i::Cuint, c::Cdouble) failed")

        return m
    end

    function DA(i, c)
        return DA(convert(Cuint, i), convert(Cdouble, c))
    end
end

"""
    tostring(da::DA)

Convert DA object to string.
"""
function tostring(da::DA)
    # initialise 2d char array
    nstr = getmaxmonomials() + 2
    nstrout = Ref{Cuint}()
    ss = Vector{UInt8}(undef, nstr * DACE_STRLEN)

    # call dacewrite
    ccall((:daceWrite, libdace), Cvoid, (Ref{Variable}, Ref{UInt8}, Ref{Cuint}), da.index, ss, nstrout)
    exitondaceerror("Error: call to daceWrite failed")

    # construct string from array
    s = ""
    for i in 1:nstrout[]
        lower = (i - 1) * DACE_STRLEN + 1
        upper = i * DACE_STRLEN
        tmps = unsafe_string(pointer(ss[lower:upper]))
        s = s * tmps * "\n"
    end

    return s
end

"""
    Base.show(io::IO, da::DA)

Print DA object.
"""
function Base.show(io::IO, da::DA)
    print(io, tostring(da))
end

# this is used to show values in the REPL / IJulia
# Base.show(io::IO, m::MIME"text/plain", x::MyString)

"""
    Base.sin(z::DA)

Compute the sine of a DA object. Returns a new DA object containing the result
of the operation.
"""
function Base.sin(z::DA)
    temp = DA()
    ccall((:daceSine, libdace), Cvoid, (Ref{Variable}, Ref{Variable}), z.index, temp.index)
    exitondaceerror("Error: daceSine call failed")

    return temp
end

"""
    Base.cos(z::DA)

Compute the cosine of a DA object. Returns a new DA object containing the result
of the operation.
"""
function Base.cos(z::DA)
    temp = DA()
    ccall((:daceCosine, libdace), Cvoid, (Ref{Variable}, Ref{Variable}), z.index, temp.index)
    exitondaceerror("Error: daceCosine call failed")

    return temp
end

"""
    Base.tan(z::DA)

Compute the tangent of a DA object. Returns a new DA object containing the result
of the operation.
"""
function Base.tan(z::DA)
    temp = DA()
    ccall((:daceTangent, libdace), Cvoid, (Ref{Variable}, Ref{Variable}), z.index, temp.index)
    exitondaceerror("Error: daceTangent call failed")

    return temp
end

"""
    Base.:+(da1::DA, da2::DA)

Compute the addition between two DA objects. The result is copied to a new DA
object.
"""
function Base.:+(da1::DA, da2::DA)
    temp = DA()
    ccall((:daceAdd, libdace), Cvoid, (Ref{Variable}, Ref{Variable}, Ref{Variable}), da1.index, da2.index, temp.index)
    exitondaceerror("Error: addition of two DA objects failed")

    return temp
end

"""
    Base.:+(da::DA, c::Float64)

Compute the addition between a DA object and a given constant. The result is
copied to a new DA object.
"""
function Base.:+(da::DA, c::Float64)
    temp = DA()
    ccall((:daceAddDouble, libdace), Cvoid, (Ref{Variable}, Cdouble, Ref{Variable}), da.index, c, temp.index)
    exitondaceerror("Error: addition of DA and a given constant failed")

    return temp
end

"""
    Base.:+(c::Float64, da::DA)

Compute the addition between a given constant and a DA object. The result is
copied to a new DA object.
"""
function Base.:+(c::Float64, da::DA)
    temp = DA()
    ccall((:daceAddDouble, libdace), Cvoid, (Ref{Variable}, Cdouble, Ref{Variable}), da.index, c, temp.index)
    exitondaceerror("Error: addition of a given constant and DA failed")

    return temp
end


"""
    Base.:-(da1::DA, da2::DA)

Compute the subtraction between two DA objects (da1-da2). The result is copied
to a new DA object.
"""
function Base.:-(da1::DA, da2::DA)
    temp = DA()
    ccall((:daceSubtract, libdace), Cvoid, (Ref{Variable}, Ref{Variable}, Ref{Variable}), da1.index, da2.index, temp.index)
    exitondaceerror("Error: subtraction between two DA objects failed")

    return temp
end

"""
    Base.:-(da::DA, c::Float64)

Compute the subtraction between a DA object and a given constant (da-c). The
result is copied to a new DA object.
"""
function Base.:-(da::DA, c::Float64)
    temp = DA()
    ccall((:daceSubtractDouble, libdace), Cvoid, (Ref{Variable}, Cdouble, Ref{Variable}), da.index, c, temp.index)
    exitondaceerror("Error: subtraction between DA and a given constant failed")

    return temp
end

"""
    Base.:-(c::Float64, da::DA)

Compute the subtraction between a given constant and a DA object (c-da). The
result is copied to a new DA object.
"""
function Base.:-(c::Float64, da::DA)
    temp = DA()
    ccall((:daceDoubleSubtract, libdace), Cvoid, (Ref{Variable}, Cdouble, Ref{Variable}), da.index, c, temp.index)
    exitondaceerror("Error: subtraction of a given constant and DA failed")

    return temp
end


"""
    Base.:*(da1::DA, da2::DA)

Compute the multiplication between two DA objects. The result is copied
to a new DA object.
"""
function Base.:*(da1::DA, da2::DA)
    temp = DA()
    ccall((:daceMultiply, libdace), Cvoid, (Ref{Variable}, Ref{Variable}, Ref{Variable}), da1.index, da2.index, temp.index)
    exitondaceerror("Error: multiplication between two DA objects failed")

    return temp
end

"""
    Base.:*(da::DA, c::Float64)

Compute the multiplication between a DA object and a given constant. The
result is copied to a new DA object.
"""
function Base.:*(da::DA, c::Float64)
    temp = DA()
    ccall((:daceMultiplyDouble, libdace), Cvoid, (Ref{Variable}, Cdouble, Ref{Variable}), da.index, c, temp.index)
    exitondaceerror("Error: multiplication between DA and a given constant failed")

    return temp
end

"""
    Base.:*(c::Float64, da::DA)

Compute the multiplication between a given constant and a DA object. The
result is copied to a new DA object.
"""
function Base.:*(c::Float64, da::DA)
    temp = DA()
    ccall((:daceMultiplyDouble, libdace), Cvoid, (Ref{Variable}, Cdouble, Ref{Variable}), da.index, c, temp.index)
    exitondaceerror("Error: multiplication between given constant and DA failed")

    return temp
end


"""
    Base.:/(da1::DA, da2::DA)

Compute the division between two DA objects (da1/da2). The result is copied
to a new DA object.
"""
function Base.:/(da1::DA, da2::DA)
    temp = DA()
    ccall((:daceDivide, libdace), Cvoid, (Ref{Variable}, Ref{Variable}, Ref{Variable}), da1.index, da2.index, temp.index)
    exitondaceerror("Error: division between two DA objects failed")

    return temp
end

"""
    Base.:/(da::DA, c::Float64)

Compute the division between a DA object and a given constant (da/c). The
result is copied to a new DA object.
"""
function Base.:/(da::DA, c::Float64)
    temp = DA()
    ccall((:daceDivideDouble, libdace), Cvoid, (Ref{Variable}, Cdouble, Ref{Variable}), da.index, c, temp.index)
    exitondaceerror("Error: division between DA and a given constant failed")

    return temp
end

"""
    Base.:/(c::Float64, da::DA)

Compute the division between a given constant and a DA object (c/da). The
result is copied to a new DA object.
"""
function Base.:/(c::Float64, da::DA)
    temp = DA()
    ccall((:daceDoubleDivide, libdace), Cvoid, (Ref{Variable}, Cdouble, Ref{Variable}), da.index, c, temp.index)
    exitondaceerror("Error: division between given constant and DA failed")

    return temp
end


"""
    Base.sqrt(da::DA)

Compute the square root of a DA object. The result is copied to a new DA
object.
"""
function Base.sqrt(da::DA)::DA
    temp = DA()
    ccall((:daceSquareRoot, libdace), Cvoid, (Ref{Variable}, Ref{Variable}), da.index, temp.index)
    exitondaceerror("Error: sqrt of DA failed")

    return temp
end

function deriv(da::DA, i::Integer)::DA
    temp = DA()
    ccall((:daceDifferentiate, libdace), Cvoid, (Cuint, Ref{Variable}, Ref{Variable}), i, da.index, temp.index)
    exitondaceerror("Error: deriv of DA failed")

    return temp
end
