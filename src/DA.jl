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
    Base.print(io::IO, da::DA)

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
