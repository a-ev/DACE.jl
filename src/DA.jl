struct Monomial
    cc::Cdouble
    ii::Cuint
end

struct Variable
    len::Cuint
    max::Cuint
    mem::Ptr{Monomial}
end

mutable struct DA
    index::Ref{Variable}

    function DA()
        m_index = Ref{Variable}()
        ccall((:daceAllocateDA, libdace), Cvoid, (Ref{Variable}, Cuint), m_index, 0)
        exitondaceerror("Error: DA() failed")
        new(m_index)

        # TODO: add finalizer
    end

    function DA(c::Cdouble)
        m_index = Ref{Variable}()
        ccall((:daceAllocateDA, libdace), Cvoid, (Ref{Variable}, Cuint), m_index, 0)
        ccall((:daceCreateConstant, libdace), Cvoid, (Ref{Variable}, Cdouble), m_index, c)
        exitondaceerror("Error: DA(c::Cdouble) failed")
        new(m_index)

        # TODO: add finalizer
    end

    function DA(c)
        DA(convert(Cdouble, c))
    end

    function DA(i::Cuint, c::Cdouble)
        m_index = Ref{Variable}()
        ccall((:daceAllocateDA, libdace), Cvoid, (Ref{Variable}, Cuint), m_index, 0)
        ccall((:daceCreateVariable, libdace), Cvoid, (Ref{Variable}, Cuint, Cdouble), m_index, i, c)
        exitondaceerror("Error: DA(i::Cuint, c::Cdouble) failed")
        new(m_index)

        # TODO: add finalizer
    end

    function DA(i, c)
        DA(convert(Cuint, i), convert(Cdouble, c))
    end
end

function tostring(da::DA)
    println("Converting DA to string...")

    # initialise 2d char array
    nstr = getmaxmonomials() + 2
    # TODO: how to avoid hardcoding this (e.g. add function to dace that returns it)
    dace_strlen = 140
    nstrout = Ref{Cuint}()
    ss = Vector{UInt8}(undef, nstr*dace_strlen)

    # call dacewrite
    ccall((:daceWrite, libdace), Cvoid, (Ref{Variable}, Ref{UInt8}, Ref{Cuint}), da.index, ss, nstrout)
    exitondaceerror("Error: call to daceWrite failed")

    # construct string from array
    s = ""
    for i in 1:nstrout[]
        lower = (i - 1) * dace_strlen + 1
        upper = i * dace_strlen
        tmps = unsafe_string(pointer(ss[lower:upper]))
        s = s * tmps * "\n"
    end

    return s
end
