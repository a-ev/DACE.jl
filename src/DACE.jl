module DACE

using DACE_jll

function dacelibversion()
    # void daceGetVersion(int *imaj, int *imin, int *ipat)
    imaj = Ref(Cint(0))
    imin = Ref(Cint(0))
    ipat = Ref(Cint(0))
    ccall((:daceGetVersion, libdace), Cvoid, (Ref{Cint}, Ref{Cint}, Ref{Cint}), imaj, imin, ipat)

    return imaj[], imin[], ipat[]
end

end # module DACE
