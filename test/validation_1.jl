@testset verbose = true "TEST 1: DACE initialisation" begin
    @testset "1.1 Maximum order, number of variables, and number of monomials" begin
        for order = 1:10
            for nvar = 1:6
                @testset "order=$(order), nvar=$(nvar)" begin
                    DACE.init(order, nvar)
                    @test order == DACE.getMaxOrder()
                    @test nvar == DACE.getMaxVariables()
                    @test factorial(order + nvar) / (factorial(order) * factorial(nvar)) == DACE.getMaxMonomials()
                end
            end
        end
    end

    @testset "1.2 Truncation order" begin
        for k_user = 1:10
            @testset "1.2 Trunction order (k_user=$k_user)" begin
                DACE.init(10, 6)

                DACE.setTO(k_user)
                k_dace = DACE.getTO()
                @test k_dace == k_user
            end
        end
    end

    @testset "1.3 Cutoff for the coefficients" begin
        for cutoff_user in (1e-14, 1e-15, 1e-16)
            @testset "1.3 Cutoff for the coefficients (cutoff_user=$cutoff_user)" begin
                DACE.init(10, 6)
                DACE.setEps(cutoff_user)
                cutoff_dace = DACE.getEps()
                @test cutoff_dace == cutoff_user
            end
        end
    end
end
