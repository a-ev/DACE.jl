module DACE
    using DACE_jll
    using CxxWrap

    # load the C++ interface
    @wrapmodule(() -> libdace, :define_julia_module)
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

    # define some exports
    export DA, AlgebraicVector
    export deriv
end  # module DACE
