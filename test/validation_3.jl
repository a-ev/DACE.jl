@testset "3 Single-variable functions" begin
    k = 10  # order

    for n = 1:10
        @testset "3.2 Power function (n=$(n))" begin
            DACE.init(k, 1)

            x = DA(1)
            f = (1 + x)^n

            jj = Vector{UInt32}(undef, 1)
            for i in 0:k
                jj[1] = i
                a_dace = DACE.getCoefficient(f, jj)
                if i <= n
                    a_exact = binomial(n, i)
                else
                    a_exact = 0.0
                end
                @test a_dace == a_exact
            end
        end
    end

    @testset "3.3 Division" begin
        DACE.init(k, 1)

        x = DA(1)
        f = 1 / (1 - x)

        jj = Vector{UInt32}(undef, 1)
        for i in 0:k
            jj[1] = i
            a_dace = DACE.getCoefficient(f, jj)
            a_exact = 1.0
            @test a_dace == a_exact
        end
    end
end
