@testset "DACE init" begin
    for order = 1:10
        for nvar = 1:6
            @testset "DACE init $(order), $(nvar)" begin
                DACE.init(order, nvar)
                @test order == DACE.getMaxOrder()
                @test nvar == DACE.getMaxVariables()
            end
        end
    end
end
