@testset verbose = true "2 DACE initialisation" begin
    @testset "2.1 Maximum order, number of variables, and number of monomials" begin
        for order = 1:10
            for nvar = 1:6
                @testset "DACE init $(order), $(nvar)" begin
                    DACE.init(order, nvar)
                    @test order == DACE.getMaxOrder()
                    @test nvar == DACE.getMaxVariables()
                    @test factorial(order + nvar) / (factorial(order) * factorial(nvar)) == DACE.getMaxMonomials()
                end
            end
        end
    end
end
