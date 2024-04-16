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

    # addittive and multiplicative identities
    Base.zero(::Type{DA}) = DA()
    Base.one(::Type{DA}) = DA(1.0)

    # implement the similar function for AlgebraicVector
    function Base.similar(foo::AlgebraicVector{DA})
        sz = size(foo)[1]
        bar = AlgebraicVector{DA}(sz)
        return bar
    end

    # promotion of number to DA
    @inline Base.promote_rule(::Type{T}, ::Type{R}) where {T<:DA, R<:Real} = T
    @inline Base.promote_rule(::Type{R}, ::Type{T}) where {T<:DA, R<:Real} = T

    for R in (AbstractFloat, AbstractIrrational, Integer, Rational)
        @eval begin
            Base.convert(::Type{<:DA}, x::$R) = DA(convert(Float64, x))
        end
    end

    # overloading power operator for different input types
    function Base.:^(da::DA, p::Integer)
        return DACE.powi(da, p)
    end
    function Base.:^(da::DA, p::Float64)
        return DACE.powd(da, p)
    end

    # constructors for concrete DA type
    DAAllocated() = DA()
    DAAllocated(x::Number) = DA(x)

    # define some exports
    export DA, AlgebraicVector
end  # module DACE
