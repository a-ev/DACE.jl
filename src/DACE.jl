module DACE
    using DACE_jll
    using CxxWrap
    using SpecialFunctions
    using DiffEqBase
    using DocStringExtensions

    DocStringExtensions.@template DEFAULT =
        """
        $(TYPEDSIGNATURES)
        $(DOCSTRING)
        """

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

    # ========================= #
    # extend DACE functionality #
    # ========================= #

    # ------------------- #
    # custom constructors #
    # ------------------- #

    DA(b::Bool) = DA(b ? 1.0 : 0.0)
    DA(x::Rational) = DA(convert(Float64,x))

    # concrete DA types
    DAAllocated() = DA(0.0)
    DAAllocated(x::Real) = DA(x)

    # AlgebraicVector objects
    # TODO is there a better way to do this?
    AlgebraicVector(v::Vector{<:DA}) = AlgebraicVector{DA}(v)
    AlgebraicVector(v::Vector{Float64}) = AlgebraicVector{Float64}(v)
    AlgebraicVector{T}(v::Vector{<:T}) where T = begin
        res = AlgebraicVector{T}(length(v))
        for i in eachindex(v)
            res[i] = v[i]
        end
        return res
    end

    # -------------------------- #
    # overload functions in Base #
    # -------------------------- #

    # addittive and multiplicative identities
    Base.zero(::Type{DA}) = DA(0.0)
    Base.one(::Type{DA}) = DA(1.0)

    # similar function for AlgebraicVector
    function Base.similar(foo::AlgebraicVector{DA})
        sz = size(foo)[1]
        bar = AlgebraicVector{DA}(sz)
        return bar
    end

    # promotions and conversions to DA
    @inline Base.promote_rule(::Type{T}, ::Type{R}) where {T<:DA, R<:Real} = T
    @inline Base.promote_rule(::Type{R}, ::Type{T}) where {T<:DA, R<:Real} = T

    for R in (AbstractFloat, AbstractIrrational, Integer, Rational)
        @eval Base.convert(::Type{<:DA}, x::$R) = DA(convert(Float64, x))
        @eval DACE.cons(a::$R) = a
    end

    Base.float(a::DA) = a
    Base.eps(a::DA) = eps(cons(a))
    Base.eps(::Type{T}) where {T<:DA} = eps(Float64)

    # power operators
    Base.:^(da::DA, p::Integer) = DACE.powi(da, p)
    Base.:^(da::DA, p::Float64) = DACE.powd(da, p)

    for R in (AbstractFloat, AbstractIrrational, Integer, Rational)
        @eval Base.:^(a::$R, b::DA) = a^DACE.cons(b)
    end

    # comparison operators (considering only the constant part)
    for op = (:(==), :(!=), :<, :(<=), :>, :(>=))

        # both arguments are DA objects
        @eval Base.$op(a::DA, b::DA) = $op(DACE.cons(a), DACE.cons(b))

        # one argument is a number
        for R in (AbstractFloat, AbstractIrrational, Integer, Rational)
            @eval Base.$op(a::DA, b::$R) = $op(DACE.cons(a), b)
            @eval Base.$op(a::$R, b::DA) = $op(a, DACE.cons(b))
        end
    end

    Base.isfinite(a::DA) = isfinite(DACE.cons(a))
    Base.isinf(a::DA) = isinf(DACE.cons(a))
    Base.isnan(a::DA) = isnan(DACE.cons(a))

    # assignment of vector and matrix elements
    Base.setindex!(v::AlgebraicVector{<:DA}, x::Real, i::Integer) = v[i] = convert(DA, x)
    Base.setindex!(m::AlgebraicMatrix{<:DA}, x::Real, i::Integer, j::Integer) = m[i,j] = convert(DA, x)

    # custom show functions for DA and AlgebraicVector objects
    Base.show(io::IO, da::DA) = print(io, toString(da))
    Base.show(io::IO, vec::AlgebraicVector) = print(io, toString(vec))
    Base.show(io::IO, mat::AlgebraicMatrix) = print(io, toString(mat))

    # -------------------------------------- #
    # overload functions in SpecialFunctions #
    # -------------------------------------- #

    # error and complementary error functions
    SpecialFunctions.erf(a::DA) = DACE.erf(a)
    SpecialFunctions.erfc(a::DA) = DACE.erfc(a)

    # -------------------------------- #
    # overload functions in DiffEqBase #
    # -------------------------------- #

    DiffEqBase.value(a::DA) = DACE.cons(a)

    # ---------------------------------------------- #
    # wrappers to handle different subtypes of Array #
    # ---------------------------------------------- #

    # map inversion
    invert(v::Vector{<:DA}) = Vector{DA}(invert(AlgebraicVector(v)))

    # linear part, Jacobian and Hessian
    linear(v::Vector{<:DA}) = linear(AlgebraicVector(v))
    jacobian(v::Vector{<:DA}) = jacobian(AlgebraicVector(v))
    hessian(v::Vector{<:DA}) = stack(hessian(AlgebraicVector(v)), dims=3)

    # compilation and evaluation of DA objects
    compile(v::Vector{<:DA}) = compile(StdVector{DA}(v))
    for R in (DA, Float64)
        @eval eval(cda::compiledDA, v::Vector{<:$R}) = Vector{$R}(eval(cda, AlgebraicVector(v)))
        @eval eval(da::DA, v::Vector{<:$R}) = eval(da, AlgebraicVector(v))
        @eval eval(a::Vector{<:DA}, v::Vector{<:$R}) = Vector{$R}(eval(AlgebraicVector(a), AlgebraicVector(v)))
        @eval eval(a::AlgebraicVector{DA}, v::Vector{<:$R}) = Vector{$R}(eval(a, AlgebraicVector(v)))
    end

    # ------- #
    # exports #
    # ------- #

    export DA, AlgebraicVector, AlgebraicMatrix, compiledDA

end  # module DACE
