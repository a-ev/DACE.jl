using DelimitedFiles

@testset verbose = true "Moments" begin
    @testset verbose = true "Multi indices" begin

        file = joinpath(@__DIR__,"data/map_partial_orders_6D4.txt")
        data = readdlm(file,' ',Int64,comments=true,comment_char='#')
        @test size(data,1) == binomial(6+4,4)

        idx = DACE.getMultiIndices(6,4)
        ida = [data[k,:] for k in axes(data,1)]
        iin = indexin(idx,ida)

        for k in eachindex(idx)
            @test all(idx[k] .== ida[iin[k]])
        end
    end
    @testset verbose = true "Raw Moments" begin

        s1 = ("integer", "double")
        s2 = ("", "non")
        atol = [1e-15 1e-14; 1e-15 5e-12]
        for i in 1:2
            for j in 1:2

                file = joinpath(@__DIR__,"data/"*s1[i]*"_moments_"*s2[j]*"zero_6D4.txt")
                data = readdlm(file,' ',Float64)

                ord = convert(Int64,data[1,1])
                dim = convert(Int64,data[1,2])

                μ = data[2:dim+1,1]
                P = data[2:dim+1,2:end]

                M(t) = exp(μ'*t + 0.5*t'*P*t)

                DACE.init(ord,dim)
                Mt = M([DA(i,1.0) for i in 1:dim])
                ix, m0 = DACE.getRawMoments(Mt,ord)

                ia = [UInt32.(data[dim+1+k,1:end-1]) for k in eachindex(ix)]
                ii = indexin(ix,ia)
                ma = data[dim+2:end,end][ii]

                @test all(isapprox.(m0, ma; atol=atol[i,j], rtol=1e-15))
            end
        end
    end
    @testset verbose = true "Central Moments" begin
        for s in ("integer", "double")

            file_raw = joinpath(@__DIR__,"data/"*s*"_moments_nonzero_6D4.txt")
            file_ctr = joinpath(@__DIR__,"data/"*s*"_moments_zero_6D4.txt")
            data_raw = readdlm(file_raw,' ',Float64)
            data_ctr = readdlm(file_ctr,' ',Float64)

            ord = convert(Int64,data_raw[1,1])
            dim = convert(Int64,data_raw[1,2])

            μ_raw = data_raw[2:dim+1,1]
            P_raw = data_raw[2:dim+1,2:end]

            M(t) = exp(μ_raw'*t + 0.5*t'*P_raw*t)

            DACE.init(ord,dim)
            Mt = M([DA(i,1.0) for i in 1:dim])
            ix, m0 = DACE.getCentralMoments(Mt,ord)

            ia = [UInt32.(data_ctr[dim+1+k,1:end-1]) for k in eachindex(ix)]
            ii = indexin(ix,ia)
            ma = data_ctr[dim+2:end,end][ii]

            @test all(isapprox.(m0, ma; atol=1e-11, rtol=1e-15))
        end
    end
end
