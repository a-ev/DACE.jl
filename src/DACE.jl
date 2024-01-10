module DACE
    using DACE_jll
    using CxxWrap

    # load the C++ interface
    #@wrapmodule(() -> libdace, :define_julia_module)
    @wrapmodule(() -> "/home/cdjs/DocumentsSync/work/projects/dace-julia/dace/buildjl/interfaces/cxx/libdace.so", :define_julia_module)
    function __init__()
        @initcxx
    end

    # add extra functionality
    function Base.show(io::IO, da::DA)
        print(io, toString(da))
    end

    function Base.show(io::IO, vec::AlgebraicVector)
        print(io, toString(vec))
    end

    include("docs.jl")

    Base.zero(::Type{DA}) = DA()

    function Base.similar(foo::AlgebraicVector{DA})
        sz = size(foo)[1]
        bar = AlgebraicVector{DA}(sz)
        return bar
    end

    # define some exports
    export DA, AlgebraicVector
    export deriv, integ
    #export eval, evalScalar
end  # module DACE
