@testset "Hessian" begin

    DACE.init(4,4)

    v = [DACE.random(-1) for i in 1:4]
    a = AlgebraicVector(v)

    H1 = DACE.hessian(a)
    H2 = DACE.hessian(v)

    H3 = DACE.hess_stack(a)
    H4 = DACE.hess_stack(v)

    @test all(stack(H1,dims=3) .== stack(H2,dims=3))
    @test all(H3 .== H4)
    @test all(stack(H1,dims=3) .== H3)
end