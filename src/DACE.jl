module DACE
    using DACE_jll
    using CxxWrap

    # load the C++ interface and initialise it
    @wrapmodule(() -> libdace, :define_julia_module)
    function __init__()
        @initcxx
    end

    # include the file that contains documentation for some of the DACE C++ wrapped functions
    include("docs.jl")

    # extend DACE functionality

    # custom show functions for DA and AlgebraicVector objects
    function Base.show(io::IO, da::DA)
        print(io, toString(da))
    end
    function Base.show(io::IO, vec::AlgebraicVector)
        print(io, toString(vec))
    end

    Base.zero(::Type{DA}) = DA()

    # implement the similar function for AlgebraicVector
    function Base.similar(foo::AlgebraicVector{DA})
        sz = size(foo)[1]
        bar = AlgebraicVector{DA}(sz)
        return bar
    end

    # promotion of number to DA
    Base.convert(::Type{DA}, x::Number) = DA(convert(Float64, x))

    # define some exports
    export DA, AlgebraicVector
end  # module DACE
