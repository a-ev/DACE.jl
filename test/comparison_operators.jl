@testset verbose = true "Comparison operators" begin
    @testset "Test ==" begin
        DACE.init(10, 4)

        x = 1 + DA(1, 1.0)
        @test 1 == x

        y = DA(1)
        @test 1 == y

        @test x == y
    end

    @testset "Test >=" begin
        DACE.init(10, 4)
        
        x = 1 + DA(1, 1)
        y = DA(2)
        @test y >= x
        @test y >= 1
        @test y >= 2

    end

end
