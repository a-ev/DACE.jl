struct Monomial
    cc::Cdouble
    ii::Cuint
end

struct Variable
    len::Cuint
    max::Cuint
    mem::Ptr{Monomial}
end

struct DA
    index::Ref{Variable}

    function DA()
        m_index = Ref{Variable}()
        ccall((:daceAllocateDA, libdace), Cvoid, (Ref{Variable}, Cuint), m_index, 0)
        if dacegeterror() != 0
            println("Error: DA() failed")
            exit(1)
        end
        new(m_index)
    end

    function DA(c::Cdouble)
        m_index = Ref{Variable}()
        ccall((:daceAllocateDA, libdace), Cvoid, (Ref{Variable}, Cuint), m_index, 0)
        ccall((:daceCreateConstant, libdace), Cvoid, (Ref{Variable}, Cdouble), m_index, c)
        if dacegeterror() != 0
            println("Error: DA(c::Float64) failed")
            exit(1)
        end
        new(m_index)
    end

    function DA(c)
        DA(convert(Cdouble, c))
    end

    function DA(i::Cuint, c::Cdouble)
        m_index = Ref{Variable}()
        ccall((:daceAllocateDA, libdace), Cvoid, (Ref{Variable}, Cuint), m_index, 0)
        ccall((:daceCreateVariable, libdace), Cvoid, (Ref{Variable}, Cuint, Cdouble), m_index, i, c)
        if dacegeterror() != 0
            println("Error: DA(i::Cuint, c::Cdouble) failed")
            exit(1)
        end
        new(m_index)
    end

    function DA(i, c)
        DA(convert(Cuint, i), convert(Cdouble, c))
    end
end
