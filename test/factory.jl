@testset verbose = true "Identity" begin

    @testset verbose = true "First N" begin

        DACE.init(4,4)
        av = DACE.identity(2)
        ae = [DA(1, 1.0), DA(2, 1.0)]

        @test length(av) == 2
        @test all(av .== ae)
    end

    @testset verbose = true "Unsorted" begin

        DACE.init(4,4)
        av = DACE.identity(Vector{UInt32}([3, 4, 1, 1, 3]), false)
        ae = [DA(3, 1.0), DA(4, 1.0), DA(1, 1.0), DA(1, 1.0), DA(3, 1.0)]

        @test length(av) == 5
        @test all(av .== ae)
    end

    @testset verbose = true "Sorted & Unique" begin

        DACE.init(4,4)
        av = DACE.identity(Vector{UInt32}([3, 1, 1, 4, 3, 3]), true)
        ae = [DA(1, 1.0), 0.0, DA(3, 1.0), DA(4, 1.0)]

        @test length(av) == 4 # max number of variables
        @test all(av .== ae)
    end

end