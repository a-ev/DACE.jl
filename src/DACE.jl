module DACE

using DACE_jll

DACE_JUL_MAJOR::Integer = 2
DACE_JUL_MINOR::Integer = 0

initialized::Bool = false

"""
    init(ord::Integer, nvar::Integer)

Initialise the DACE control arrays and set the maximum order of the Taylor
polynomials, `x`, and the maximum number of variables, `nvar`.

Note: Must be called before any other DA routine can be used

Note: This routine performs mandatory version check to compare the version of
the Julia interface to the version of the DACE library that is loaded at
runtime.
"""
function init(ord::Integer, nvar::Integer)
    checkversion()
    ccall((:daceInitialize, libdace), Cvoid, (Cuint, Cuint), ord, nvar)
    exitondaceerror("Error: dace init failed")
    global initialized = true
end

"""
    dacegetversion()

Returns a tuple containing the major, minor and patch version of the DACE
library that is loaded at runtime.
"""
function dacegetversion()
    # void daceGetVersion(int *imaj, int *imin, int *ipat)
    imaj = Ref(Cint(0))
    imin = Ref(Cint(0))
    ipat = Ref(Cint(0))
    ccall((:daceGetVersion, libdace), Cvoid, (Ref{Cint}, Ref{Cint}, Ref{Cint}), imaj, imin, ipat)

    return imaj[], imin[], ipat[]
end

"""
    checkversion()

Checks that the version of the DACE library loaded at runtime is compatible
with the Julia interface.
"""
function checkversion()
    maj, min, patch = dacegetversion()
    if maj != DACE_JUL_MAJOR || min != DACE_JUL_MINOR
        println("Error: checkversion failed")
        exit(1)
    end
end

"""
    dacegeterror()

Calls the `daceGetError` C function and returns the output.
"""
function dacegeterror()
    err = ccall((:daceGetError, libdace), Cuint, ())
    return err
end

"""
    exitondaceerror(msg::String)

Checks whether the DACE library has reported an error by calling
`dacegeterror`, if so print the error message, `msg`, and exit the program.
"""
function exitondaceerror(msg::String)
    if dacegeterror() != 0
        println(msg)
        exit(1)
    end
end

"""
    getmaxorder()

Return the maximum order currently set for the computations or zero if
undefined.
"""
function getmaxorder()
    ord = ccall((:daceGetMaxOrder, libdace), Cuint, ())
    exitondaceerror("Error: getmaxorder failed")

    return ord
end

"""
    getmaxmonomials()

Return the maximum number of monomials available with the order and number of
variables specified, or zero if undefined.
"""
function getmaxmonomials()
    maxmon = ccall((:daceGetMaxMonomials, libdace), Cuint, ())
    exitondaceerror("Error: getmaxmonomials failed")

    return maxmon
end

include("DA.jl")

end  # module DACE
