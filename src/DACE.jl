module DACE

using DACE_jll

DACE_JUL_MAJOR::Integer = 2
DACE_JUL_MINOR::Integer = 0

initialized::Bool = false

function init(ord::Integer, nvar::Integer)
    checkversion()
    ccall((:daceInitialize, libdace), Cvoid, (Cuint, Cuint), ord, nvar)
    exitondaceerror("Error: dace init failed")
    initialized = true
end

function dacegetversion()
    # void daceGetVersion(int *imaj, int *imin, int *ipat)
    imaj = Ref(Cint(0))
    imin = Ref(Cint(0))
    ipat = Ref(Cint(0))
    ccall((:daceGetVersion, libdace), Cvoid, (Ref{Cint}, Ref{Cint}, Ref{Cint}), imaj, imin, ipat)

    return imaj[], imin[], ipat[]
end

function checkversion()
    maj, min, patch = dacegetversion()
    if maj != DACE_JUL_MAJOR || min != DACE_JUL_MINOR
        println("Error: checkversion failed")
        exit(1)
    end
end

function dacegeterror()
    err = ccall((:daceGetError, libdace), Cuint, ())
    return err
end

function exitondaceerror(msg::String)
    if dacegeterror() != 0
        println(msg)
        exit(1)
    end
end

function getmaxorder()
    ord = ccall((:daceGetMaxOrder, libdace), Cuint, ())
    exitondaceerror("Error: getmaxorder failed")

    return ord
end

function getmaxmonomials()
    maxmon = ccall((:daceGetMaxMonomials, libdace), Cuint, ())
    exitondaceerror("Error: getmaxmonomials failed")

    return maxmon
end

include("DA.jl")

end  # module DACE
