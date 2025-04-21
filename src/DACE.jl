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

    # load the C++ interface and initialize it
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

    # AlgebraicVector and AlgebraicMatrix constructors from Julia vectors and matrices
    for R in (DA, Float64)
        @eval AlgebraicVector(v::AbstractVector{<:$R}) = AlgebraicVector{$R}(v)
        @eval AlgebraicMatrix(m::AbstractMatrix{<:$R}) = AlgebraicMatrix{$R}(m)
    end

    AlgebraicVector{T}(v::AbstractVector{<:T}) where T<:Union{DA, Float64} = begin
        res = AlgebraicVector{T}(length(v))
        res .= v
        return res
    end
    AlgebraicMatrix{T}(v::AbstractMatrix{<:T}) where T<:Union{DA, Float64} = begin
        res = AlgebraicMatrix{T}(size(v)...)
        res .= v
        return res
    end

    # -------------------------- #
    # overload functions in Base #
    # -------------------------- #

    # additive and multiplicative identities
    Base.zero(::Type{DA}) = DA(0.0)
    Base.one(::Type{DA}) = DA(1.0)

    # similar function for AlgebraicVector and AlgebraicMatrix
    for R in (DA, Float64)
        @eval Base.similar(v::AlgebraicVector{<:$R}) = AlgebraicVector{$R}(v)
        @eval Base.similar(m::AlgebraicMatrix{<:$R}) = AlgebraicMatrix{$R}(m)
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

    Base.isfinite(a::DA) = isfinite(DACE.cons(a))
    Base.isinf(a::DA) = isinf(DACE.cons(a))
    Base.isnan(a::DA) = isnan(DACE.cons(a))

    # assignment of vector and matrix elements
    Base.setindex!(v::AlgebraicVector{<:DA}, x::Real, i::Integer) = v[i] = convert(DA, x)
    Base.setindex!(m::AlgebraicMatrix{<:DA}, x::Real, i::Integer, j::Integer) = m[i,j] = convert(DA, x)

    # custom show functions for DA-related objects
    Base.show(io::IO, m::Monomial) = print(io, toString(m))
    Base.show(io::IO, da::DA) = print(io, toString(da))
    Base.show(io::IO, vec::AlgebraicVector{T}) where T<:Union{DA, Float64} = print(io, toString(vec))
    Base.show(io::IO, mat::AlgebraicMatrix{T}) where T<:Union{DA, Float64} = print(io, toString(mat))

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
    invert(v::AbstractVector{<:DA}) = invert(AlgebraicVector(v))

    # linear part, Jacobian and Hessian
    linear(v::AbstractVector{<:DA}) = linear(AlgebraicVector(v))
    jacobian(v::AbstractVector{<:DA}) = jacobian(AlgebraicVector(v))
    hessian(v::AbstractVector{<:DA}) = hessian(AlgebraicVector(v)) # vector of Hessian matrices
    hess_stack(a::AbstractVector{<:DA}) = stack(hessian(a), dims=3)

    # compilation and evaluation of DA objects
    compile(v::AbstractVector{<:DA}) = compile(AlgebraicVector(v))
    for R in (DA, Float64)
        @eval eval(cda::compiledDA, v::AbstractVector{<:$R}) = eval(cda, AlgebraicVector(v))
        @eval eval(da::DA, v::AbstractVector{<:$R}) = eval(da, AlgebraicVector(v))
        @eval eval(a::AbstractVector{<:DA}, v::AbstractVector{<:$R}) = eval(AlgebraicVector(a), AlgebraicVector(v))
        @eval eval(a::AlgebraicVector{<:DA}, v::AbstractVector{<:$R}) = eval(a, AlgebraicVector(v))
    end

    # ------- #
    # exports #
    # ------- #

    export DA, AlgebraicVector, AlgebraicMatrix, compiledDA, Monomial

end  # module DACE
