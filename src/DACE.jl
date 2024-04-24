module DACE
    using DACE_jll
    using CxxWrap
    using DiffEqBase

    mutable struct Interval
        m_lb::Float64
        m_ub::Float64
    end

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
    Base.zero(::Type{DA}) = DA(0.0)
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
        @eval Base.convert(::Type{<:DA}, x::$R) = DA(convert(Float64, x))
    end

    # overloading power operator for different input types
    @eval Base.:^(da::DA, p::Integer) = DACE.powi(da, p)
    @eval Base.:^(da::DA, p::Float64) = DACE.powd(da, p)

    # overloading comparison operators (considering only the constant part)
    for op = (:(==), :(!=), :<, :(<=), :>, :(>=))

        # both arguments are DA objects
        @eval Base.$op(a::DA, b::DA) = $op(DACE.cons(a), DACE.cons(b))

        # one argument is a number
        for R in (AbstractFloat, AbstractIrrational, Integer, Rational)
            @eval Base.$op(a::DA, b::$R) = $op(DACE.cons(a), b)
            @eval Base.$op(a::$R, b::DA) = $op(a, DACE.cons(b))
        end
    end

    @eval Base.isfinite(a::DA) = isfinite(DACE.cons(a))
    @eval Base.isinf(a::DA) = isinf(DACE.cons(a))
    @eval Base.isnan(a::DA) = isnan(DACE.cons(a))
    @eval Base.float(a::DA) = a

    # constructors for concrete DA type
    DA(x::Rational) = DA(convert(Float64,x))
    DAAllocated() = DA(0.0)
    DAAllocated(x::Real) = DA(x)

    # functions needed to interact with DifferentialEquations
    for R in (AbstractFloat, AbstractIrrational, Integer, Rational)
        @eval Base.:^(a::$R, b::DA) = a^DACE.cons(b)
    end
    @eval DiffEqBase.value(a::DA) = DACE.cons(a)

    # functions to avoid code duplicates
    for R in (AbstractFloat, AbstractIrrational, Integer, Rational)
        @eval DACE.cons(a::$R) = a
    end

    # define some exports
    export DA, AlgebraicVector
end  # module DACE
