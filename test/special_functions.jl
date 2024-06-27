using SpecialFunctions

@testset verbose = true "Special functions" begin
    @testset "Test erf" begin
        DACE.init(1,3)

        x = DACE.random(-1)
        @test isapprox(DACE.cons(erf(x)), erf(DACE.cons(x)), atol=1e-15, rtol=1e-15)

    end

    @testset "Test erfc" begin
        DACE.init(1,3)

        x = DACE.random(-1)
        @test isapprox(DACE.cons(erfc(x)), erfc(DACE.cons(x)), atol=1e-15, rtol=1e-15)

    end

end
