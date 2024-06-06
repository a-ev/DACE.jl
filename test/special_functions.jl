using SpecialFunctions

@testset verbose = true "Special functions" begin
    @testset "Test erf" begin
        DACE.init(1,3)

        x = DACE.random(-1)
        @test DACE.cons(erf(x)) == erf(DACE.cons(x))

    end

    @testset "Test erfc" begin
        DACE.init(1,3)
        
        x = DACE.random(-1)
        @test DACE.cons(erfc(x)) == erfc(DACE.cons(x))

    end

end